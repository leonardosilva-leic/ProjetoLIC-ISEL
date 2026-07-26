library ieee;
use ieee.std_logic_1164.all;

entity RingBuffer_tb is
end RingBuffer_tb;

architecture sim of RingBuffer_tb is

    component RingBuffer is
        port(
            CLK   : in  std_logic;
            RESET : in  std_logic;
            DAV   : in  std_logic;
            CTS   : in  std_logic;
            Din   : in  std_logic_vector(3 downto 0);

            DAC   : out std_logic;
            Wreg  : out std_logic;
            Dout  : out std_logic_vector(3 downto 0)
        );
    end component;

    signal CLK   : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DAV   : std_logic := '0';
    signal CTS   : std_logic := '0';
    signal Din   : std_logic_vector(3 downto 0) := "0000";

    signal DAC   : std_logic;
    signal Wreg  : std_logic;
    signal Dout  : std_logic_vector(3 downto 0);

begin

    CLK <= not CLK after 10 ns;

    DUT : RingBuffer
        port map(
            CLK   => CLK,
            RESET => RESET,
            DAV   => DAV,
            CTS   => CTS,
            Din   => Din,
            DAC   => DAC,
            Wreg  => Wreg,
            Dout  => Dout
        );

    stim : process
    begin
        --------------------------------------------------------------------
        -- RESET
        --------------------------------------------------------------------
        RESET <= '1';
        DAV   <= '0';
        CTS   <= '0';
        Din   <= "0000";

        wait for 30 ns;
        RESET <= '0';
        wait for 30 ns;

        --------------------------------------------------------------------
        -- TESTE 1: escrever 1010 e depois ler 1010
        --------------------------------------------------------------------
        Din <= "1010";
        DAV <= '1';

        -- Espera o RingBuffer aceitar o dado
        wait until DAC = '1';
        wait for 1 ns;

        assert DAC = '1'
            report "FALHOU: RingBuffer nao ativou DAC ao escrever 1010"
            severity error;

        -- Produtor baixa DAV depois de DAC
        wait until falling_edge(CLK);
        DAV <= '0';

        -- Espera DAC baixar
        wait until DAC = '0';
        wait for 20 ns;

        -- Consumidor fica livre
        CTS <= '1';

        -- Quando Wreg subir, Dout tem de ter o valor escrito
        wait until Wreg = '1';
        wait for 1 ns;

        assert Dout = "1010"
            report "FALHOU: RingBuffer devia entregar 1010 no Dout"
            severity error;

        -- Consumidor deixa de estar livre, para terminar a leitura
        wait until falling_edge(CLK);
        CTS <= '0';

        wait until Wreg = '0';
        wait for 30 ns;

        --------------------------------------------------------------------
        -- TESTE 2: escrever varios valores e confirmar ordem FIFO
        -- Valores: 0001, 0110, 1111
        --------------------------------------------------------------------

        -- Escreve 0001
        Din <= "0001";
        DAV <= '1';
        wait until DAC = '1';
        wait until falling_edge(CLK);
        DAV <= '0';
        wait until DAC = '0';
        wait for 20 ns;

        -- Escreve 0110
        Din <= "0110";
        DAV <= '1';
        wait until DAC = '1';
        wait until falling_edge(CLK);
        DAV <= '0';
        wait until DAC = '0';
        wait for 20 ns;

        -- Escreve 1111
        Din <= "1111";
        DAV <= '1';
        wait until DAC = '1';
        wait until falling_edge(CLK);
        DAV <= '0';
        wait until DAC = '0';
        wait for 20 ns;

        --------------------------------------------------------------------
        -- Lê primeiro valor: 0001
        --------------------------------------------------------------------
        CTS <= '1';
        wait until Wreg = '1';
        wait for 1 ns;

        assert Dout = "0001"
            report "FALHOU: primeiro valor FIFO devia ser 0001"
            severity error;

        wait until falling_edge(CLK);
        CTS <= '0';
        wait until Wreg = '0';
        wait for 30 ns;

        --------------------------------------------------------------------
        -- Lê segundo valor: 0110
        --------------------------------------------------------------------
        CTS <= '1';
        wait until Wreg = '1';
        wait for 1 ns;

        assert Dout = "0110"
            report "FALHOU: segundo valor FIFO devia ser 0110"
            severity error;

        wait until falling_edge(CLK);
        CTS <= '0';
        wait until Wreg = '0';
        wait for 30 ns;

        --------------------------------------------------------------------
        -- Lê terceiro valor: 1111
        --------------------------------------------------------------------
        CTS <= '1';
        wait until Wreg = '1';
        wait for 1 ns;

        assert Dout = "1111"
            report "FALHOU: terceiro valor FIFO devia ser 1111"
            severity error;

        wait until falling_edge(CLK);
        CTS <= '0';
        wait until Wreg = '0';
        wait for 30 ns;

        --------------------------------------------------------------------
        -- FIM
        --------------------------------------------------------------------
        assert false
            report "TESTE TERMINADO: RingBuffer passou."
            severity note;

        wait;
    end process;

end sim;