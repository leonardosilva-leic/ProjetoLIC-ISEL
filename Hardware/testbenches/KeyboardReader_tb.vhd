library ieee;
use ieee.std_logic_1164.all;

entity KeyboardReader_tb is
end KeyboardReader_tb;

architecture test of KeyboardReader_tb is

    ---------------------------------------------------------------
    -- Entradas do KeyboardReader
    ---------------------------------------------------------------
    signal MClk      : std_logic := '0';
    signal Rst       : std_logic := '0';
    signal Tdelay    : std_logic_vector(1 downto 0) := "00";
    signal linhas_in : std_logic_vector(3 downto 0) := "1111";
    signal Txclk     : std_logic := '0';

    ---------------------------------------------------------------
    -- Saídas do KeyboardReader
    ---------------------------------------------------------------
    signal K           : std_logic_vector(3 downto 0);
    signal colunas_out : std_logic_vector(3 downto 0);
    signal TxD         : std_logic;

    ---------------------------------------------------------------
    -- Sinais para simular uma tecla física
    ---------------------------------------------------------------
    signal key_pressed : std_logic := '0';
    signal pressed_row : integer range 0 to 3 := 1;
    signal pressed_col : integer range 0 to 3 := 0;

    -- Clock de 50 MHz
    constant MClk_period : time := 20 ns;

begin

    ---------------------------------------------------------------
    -- Unidade em teste
    ---------------------------------------------------------------
    UUT : entity work.KeyboardReader
        port map(
            MClk        => MClk,
            Rst         => Rst,
            Tdelay      => Tdelay,
            linhas_in   => linhas_in,
            Txclk       => Txclk,
            K           => K,
            colunas_out => colunas_out,
            TxD         => TxD
        );

    ---------------------------------------------------------------
    -- Clock principal de 50 MHz
    ---------------------------------------------------------------
    MClk_process : process
    begin
        while true loop
            MClk <= '0';
            wait for MClk_period / 2;

            MClk <= '1';
            wait for MClk_period / 2;
        end loop;
    end process;

    ---------------------------------------------------------------
    -- Modelo do teclado matricial
    --
    -- Sem tecla:
    --     linhas_in = "1111"
    --
    -- Quando a coluna da tecla estiver ativa a '0',
    -- a linha correspondente também passa para '0'.
    ---------------------------------------------------------------
    keyboard_model : process(
        key_pressed,
        pressed_row,
        pressed_col,
        colunas_out
    )
        variable linhas_aux : std_logic_vector(3 downto 0);
    begin
        linhas_aux := "1111";

        if key_pressed = '1' then
            if colunas_out(pressed_col) = '0' then
                linhas_aux(pressed_row) := '0';
            end if;
        end if;

        linhas_in <= linhas_aux;
    end process;

    ---------------------------------------------------------------
    -- Simulação do software que recebe a tecla
    --
    -- Quando TxD desce para zero, são gerados seis pulsos
    -- lentos de Txclk para serem visíveis na waveform.
    ---------------------------------------------------------------
    Txclk_process : process
    begin
        Txclk <= '0';

        while true loop

            -- Início da transmissão
            wait until falling_edge(TxD);

            wait for 5 us;

            -- 1 pulso para Start,
            -- 4 pulsos para os bits,
            -- 1 pulso para terminar
            for i in 1 to 6 loop
                Txclk <= '1';
                wait for 5 us;

                Txclk <= '0';
                wait for 5 us;
            end loop;

            wait for 20 us;

        end loop;
    end process;

    ---------------------------------------------------------------
    -- Estímulos
    ---------------------------------------------------------------
    stimulus_process : process
    begin

        -----------------------------------------------------------
        -- Reset
        -----------------------------------------------------------
        Rst         <= '1';
        key_pressed <= '0';

        wait for 200 ns;

        Rst <= '0';

        -- Tempo para iniciar o varrimento do teclado
        wait for 1 ms;

        -----------------------------------------------------------
        -- Pressionar uma tecla
        --
        -- Linha 1 e coluna 0.
        -- Num teclado convencional, deverá corresponder à tecla 4.
        -----------------------------------------------------------
        pressed_row <= 1;
        pressed_col <= 0;
        key_pressed <= '1';

        -- Mantém a tecla pressionada durante tempo suficiente
        -- para permitir a sua deteção.
        wait for 20 ms;

        -----------------------------------------------------------
        -- Libertar a tecla
        -----------------------------------------------------------
        key_pressed <= '0';

        -- Tempo para concluir a transmissão
        wait for 5 ms;

        -----------------------------------------------------------
        -- Fim
        -----------------------------------------------------------
        wait;

    end process;

end test;