library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Necessário para simular o incremento do contador

entity KT_Control_tb is
-- Entidade de Testbench não tem portas
end KT_Control_tb;

architecture sim of KT_Control_tb is

    -- 1. Declaração do Componente a testar (UUT)
    component KT_Control is
        port(
            TXclk    : in std_logic;
            Rst      : in std_logic;
            Load     : in std_logic;
            Count    : in std_logic_vector(2 downto 0);
            KBfree   : out std_logic;
            TXEnable : out std_logic;
            StartTX  : out std_logic
        );
    end component;

    -- 2. Sinais para ligar à UUT
    signal TXclk_tb    : std_logic := '0';
    signal Rst_tb      : std_logic := '0';
    signal Load_tb     : std_logic := '0';
    signal Count_tb    : std_logic_vector(2 downto 0) := "000";
    signal KBfree_tb   : std_logic;
    signal TXEnable_tb : std_logic;
    signal StartTX_tb  : std_logic;

    -- Período do clock de transmissão
    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instanciação da Unidade Sob Teste (UUT)
    UUT: KT_Control
        port map (
            TXclk    => TXclk_tb,
            Rst      => Rst_tb,
            Load     => Load_tb,
            Count    => Count_tb,
            KBfree   => KBfree_tb,
            TXEnable => TXEnable_tb,
            StartTX  => StartTX_tb
        );

    -- Gerador de Relógio (TXclk)
    clk_process : process
    begin
        while true loop
            TXclk_tb <= '0';
            wait for CLK_PERIOD / 2;
            TXclk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- =================================================================
    -- EMULADOR DO CONTADOR DO DATAPATH
    -- Este processo imita o contador real, respondendo ao sinal TXEnable
    -- =================================================================
    datapath_counter_sim : process(TXclk_tb, Rst_tb)
        variable internal_count : integer := 0;
    begin
        if Rst_tb = '1' then
            internal_count := 0;
            Count_tb <= "000";
        elsif rising_edge(TXclk_tb) then
            -- Se o sistema está livre e recebe ordem de Load, zera o contador
            if KBfree_tb = '1' and Load_tb = '1' then
                internal_count := 0;
                Count_tb <= "000";
            -- Se a FSM está a enviar dados, incrementa o contador
            elsif TXEnable_tb = '1' then
                internal_count := internal_count + 1;
                Count_tb <= std_logic_vector(to_unsigned(internal_count, 3));
            else
                -- Garante que limpa/congela quando sai do estado Sending
                internal_count := 0;
                Count_tb <= "000";
            end if;
        end if;
    end process;

    -- =================================================================
    -- PROCESSO DE ESTÍMULOS
    -- =================================================================
    stim_process : process
    begin
        ---------------------------------------------------------
        -- Passo 1: Inicialização com Reset ativo
        ---------------------------------------------------------
        Rst_tb  <= '1';
        Load_tb <= '0';
        wait for CLK_PERIOD * 2;
        
        Rst_tb  <= '0'; -- Desativa o reset
        wait for CLK_PERIOD; -- Espera a FSM estabilizar em 'Free'

        ---------------------------------------------------------
        -- Passo 2: Ordem de início de transmissão (Load)
        ---------------------------------------------------------
        -- Verifica se a máquina diz que a linha está livre (KBfree = '1')
        assert (KBfree_tb = '1') report "Erro: Máquina devia estar Free!" severity error;
        
        Load_tb <= '1';      -- Dá a ordem de Load
        wait for CLK_PERIOD; -- Mantém por 1 ciclo
        Load_tb <= '0';

        ---------------------------------------------------------
        -- Passo 3: Monitorização dos estados e do tempo
        ---------------------------------------------------------
        -- 1º Ciclo após Load: Deve ser o StartBit
        wait for CLK_PERIOD; 
        
        -- 2º ao 5º Ciclo: Deve ser o estado Sending (onde o contador simula de 0 a 3)
        wait for CLK_PERIOD * 4; 
        
        -- 6º Ciclo: Deve ser o StopBit (onde Count atingiu "011" e a FSM mudou)
        wait for CLK_PERIOD;

        -- 7º Ciclo: Deve voltar ao estado Free (KBfree volta a '1')
        wait for CLK_PERIOD;

        ---------------------------------------------------------
        -- Passo 4: Terminar a simulação
        ---------------------------------------------------------
        assert false report "Simulação do KT_Control Concluída com Sucesso!" severity failure;
        wait;
    end process;

end sim;