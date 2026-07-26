library ieee;
use ieee.std_logic_1164.all;

entity CoinAcceptor_tb is
end CoinAcceptor_tb;

architecture test of CoinAcceptor_tb is

    component CoinAcceptor is
        port(
            MClk       : in  std_logic;
            Rst        : in  std_logic;
            Insert     : in  std_logic;
            CoinId_in  : in  std_logic_vector(2 downto 0);
            accept     : in  std_logic;
            collect    : in  std_logic;
            eject      : in  std_logic;
            Coin       : out std_logic;
            CoinId     : out std_logic_vector(2 downto 0);
            EjectLed   : out std_logic;
            CollectLed : out std_logic
        );
    end component;

    signal MClk       : std_logic := '0';
    signal Rst        : std_logic := '0';
    signal Insert     : std_logic := '0';
    signal CoinId_in  : std_logic_vector(2 downto 0) := "000";
    signal accept     : std_logic := '0';
    signal collect    : std_logic := '0';
    signal eject      : std_logic := '0';

    signal Coin       : std_logic;
    signal CoinId     : std_logic_vector(2 downto 0);
    signal EjectLed   : std_logic;
    signal CollectLed : std_logic;

    constant CLK_PERIOD : time := 20 ns;

begin

    UUT : CoinAcceptor
        port map(
            MClk       => MClk,
            Rst        => Rst,
            Insert     => Insert,
            CoinId_in  => CoinId_in,
            accept     => accept,
            collect    => collect,
            eject      => eject,
            Coin       => Coin,
            CoinId     => CoinId,
            EjectLed   => EjectLed,
            CollectLed => CollectLed
        );

    clk_process : process
    begin
        while true loop
            MClk <= '0';
            wait for CLK_PERIOD/2;
            MClk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_process : process
    begin
        Rst <= '1';
        Insert <= '0';
        CoinId_in <= "000";
        accept <= '0';
        collect <= '0';
        eject <= '0';
        wait for 60 ns;

        Rst <= '0';
        wait for 40 ns;

        -- moeda 0,05 € -> 000
        CoinId_in <= "000";
        Insert <= '1';
        wait for 40 ns;
        Insert <= '0';
        wait for 100 ns;

        accept <= '1';
        wait for 40 ns;
        accept <= '0';
        wait for 100 ns;

        -- moeda 0,50 € -> 011
        CoinId_in <= "011";
        Insert <= '1';
        wait for 40 ns;
        Insert <= '0';
        wait for 100 ns;

        accept <= '1';
        wait for 40 ns;
        accept <= '0';
        wait for 100 ns;

        -- moeda 2,00 € -> 101
        CoinId_in <= "101";
        Insert <= '1';
        wait for 40 ns;
        Insert <= '0';
        wait for 100 ns;

        accept <= '1';
        wait for 40 ns;
        accept <= '0';
        wait for 100 ns;

        -- testar collect
        collect <= '1';
        wait for 100 ns;
        collect <= '0';
        wait for 100 ns;

        -- testar eject
        eject <= '1';
        wait for 100 ns;
        eject <= '0';
        wait for 100 ns;

        -- moeda 0,20 € -> 010
        CoinId_in <= "010";
        Insert <= '1';
        wait for 40 ns;
        Insert <= '0';
        wait for 100 ns;

        accept <= '1';
        wait for 40 ns;
        accept <= '0';
        wait for 100 ns;

        wait;
    end process;

end test;