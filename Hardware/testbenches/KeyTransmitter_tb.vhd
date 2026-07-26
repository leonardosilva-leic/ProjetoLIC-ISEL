-- KeyTransmitter_tb.vhd
library ieee;
use ieee.std_logic_1164.all;

entity KeyTransmitter_tb is
end KeyTransmitter_tb;

architecture sim of KeyTransmitter_tb is

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
    signal TXclk  : std_logic := '0';
    signal K      : std_logic_vector(3 downto 0) := "0000";
    signal Load   : std_logic := '0';
    signal Rst    : std_logic := '0';
    signal KBfree : std_logic;
    signal K_out  : std_logic_vector(3 downto 0);
    signal TXD    : std_logic;

begin

    MClk <= not MClk after 10 ns;

    DUT : KeyTransmitter
        port map(
            MClk   => MClk,
            K      => K,
            Load   => Load,
            TXclk  => TXclk,
            Rst    => Rst,
            KBfree => KBfree,
            K_out  => K_out,
            TXD    => TXD
        );

    stim : process
    begin
        Rst <= '1';
        wait for 25 ns;
        Rst <= '0';

        wait until falling_edge(MClk);

        ----------------------------------------------------------------
        -- Simula o RingBuffer a entregar uma tecla:
        -- Load sobe, e K estabiliza logo depois.
        ----------------------------------------------------------------
        Load <= '1';
        wait for 1 ns;

        K <= "1010";

        wait until rising_edge(MClk);
        wait for 1 ns;

        assert K_out = "1010"
            report "FALHOU: KeyTransmitter nao carregou 1010 no K_out"
            severity error;

        Load <= '0';
        wait for 30 ns;

        assert false
            report "TESTE TERMINADO: KeyTransmitter passou."
            severity note;

        wait;
    end process;

end sim;