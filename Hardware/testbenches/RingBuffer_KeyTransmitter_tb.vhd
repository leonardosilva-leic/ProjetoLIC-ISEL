library ieee;
use ieee.std_logic_1164.all;

entity RingBuffer_KeyTransmitter_tb is
end RingBuffer_KeyTransmitter_tb;

architecture sim of RingBuffer_KeyTransmitter_tb is

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

    component KeyTransmitter is
        port(
            MClk   : in  std_logic;
            K      : in  std_logic_vector(3 downto 0);
            Load   : in  std_logic;
            TXclk  : in  std_logic;
            Rst    : in  std_logic;
            KBfree : out std_logic;
            K_out  : out std_logic_vector(3 downto 0);
            TXD    : out std_logic
        );
    end component;

    signal MClk   : std_logic := '0';
    signal Rst    : std_logic := '0';

    -- lado produtor, como se fosse o KeyDecode
    signal DAV    : std_logic := '0';
    signal Din    : std_logic_vector(3 downto 0) := "0000";
    signal DAC    : std_logic;

    -- ligação RingBuffer -> KeyTransmitter
    signal Dout   : std_logic_vector(3 downto 0);
    signal Wreg   : std_logic;
    signal KBfree : std_logic;

    -- transmissão
    signal TXclk  : std_logic := '0';
    signal TXD    : std_logic;
    signal K_out  : std_logic_vector(3 downto 0);

begin

    MClk <= not MClk after 10 ns;

    RB : RingBuffer
        port map(
            CLK   => MClk,
            RESET => Rst,
            DAV   => DAV,
            CTS   => KBfree,
            Din   => Din,
            DAC   => DAC,
            Wreg  => Wreg,
            Dout  => Dout
        );

    KT : KeyTransmitter
        port map(
            MClk   => MClk,
            K      => Dout,
            Load   => Wreg,
            TXclk  => TXclk,
            Rst    => Rst,
            KBfree => KBfree,
            K_out  => K_out,
            TXD    => TXD
        );

    stim : process
    begin
        --------------------------------------------------------------------
        -- Reset
        --------------------------------------------------------------------
        Rst <= '1';
        DAV <= '0';
        Din <= "0000";
        TXclk <= '0';

        wait for 40 ns;
        Rst <= '0';
        wait for 40 ns;

        --------------------------------------------------------------------
        -- TESTE 1: mandar a tecla 1010
        --------------------------------------------------------------------
        Din <= "1010";
        DAV <= '1';

        -- espera o RingBuffer aceitar
        wait until DAC = '1';
        wait until falling_edge(MClk);
        DAV <= '0';

        -- espera o RingBuffer entregar ao KT
        wait until Wreg = '1';
        wait until rising_edge(MClk);
        wait for 1 ns;

        assert K_out = "1010"
            report "FALHOU: RingBuffer + KT nao carregou 1010 no K_out"
            severity error;

        --------------------------------------------------------------------
        -- Simular alguns pulsos de TXclk para terminar transmissão
        --------------------------------------------------------------------
        wait for 20 ns;

        for i in 0 to 7 loop
            TXclk <= '1';
            wait for 20 ns;
            TXclk <= '0';
            wait for 20 ns;
        end loop;

        wait for 80 ns;

        --------------------------------------------------------------------
        -- TESTE 2: mandar a tecla 0111
        --------------------------------------------------------------------
        Din <= "0111";
        DAV <= '1';

        wait until DAC = '1';
        wait until falling_edge(MClk);
        DAV <= '0';

        wait until Wreg = '1';
        wait until rising_edge(MClk);
        wait for 1 ns;

        assert K_out = "0111"
            report "FALHOU: RingBuffer + KT nao carregou 0111 no K_out"
            severity error;

        wait for 20 ns;

        for i in 0 to 7 loop
            TXclk <= '1';
            wait for 20 ns;
            TXclk <= '0';
            wait for 20 ns;
        end loop;

        wait for 80 ns;

        --------------------------------------------------------------------
        -- Fim
        --------------------------------------------------------------------
        assert false
            report "TESTE TERMINADO: RingBuffer + KeyTransmitter passou."
            severity note;

        wait;
    end process;

end sim;