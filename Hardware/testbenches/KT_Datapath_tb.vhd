-- KT_Datapath_tb.vhd
library ieee;
use ieee.std_logic_1164.all;

entity KT_Datapath_tb is
end KT_Datapath_tb;

architecture sim of KT_Datapath_tb is

    component KT_Datapath is
        port(
            MClk     : in std_logic;
            TXclk    : in std_logic;
            K        : in std_logic_vector(3 downto 0);
            KBfree   : in std_logic;
            Load     : in std_logic;
            TXEnable : in std_logic;
            ClrCnt   : in std_logic;
            Rst      : in std_logic;
            K_out    : out std_logic_vector(3 downto 0);
            Count    : out std_logic_vector(2 downto 0);
            TXD      : out std_logic
        );
    end component;

    signal MClk     : std_logic := '0';
    signal TXclk    : std_logic := '0';
    signal K        : std_logic_vector(3 downto 0) := "0000";
    signal KBfree   : std_logic := '1';
    signal Load     : std_logic := '0';
    signal TXEnable : std_logic := '0';
    signal ClrCnt   : std_logic := '1';
    signal Rst      : std_logic := '0';
    signal K_out    : std_logic_vector(3 downto 0);
    signal Count    : std_logic_vector(2 downto 0);
    signal TXD      : std_logic;

begin

    MClk <= not MClk after 10 ns;

    DUT : KT_Datapath
        port map(
            MClk     => MClk,
            TXclk    => TXclk,
            K        => K,
            KBfree   => KBfree,
            Load     => Load,
            TXEnable => TXEnable,
            ClrCnt   => ClrCnt,
            Rst      => Rst,
            K_out    => K_out,
            Count    => Count,
            TXD      => TXD
        );

    stim : process
    begin
        Rst <= '1';
        wait for 25 ns;
        Rst <= '0';

        wait until falling_edge(MClk);

        ----------------------------------------------------------------
        -- Situação parecida com a placa:
        -- Load sobe primeiro, K muda logo depois.
        ----------------------------------------------------------------
        Load <= '1';
        wait for 1 ns;

        K <= "1010";

        wait until rising_edge(MClk);
        wait for 1 ns;

        assert K_out = "1010"
            report "FALHOU: KT_Datapath nao guardou 1010 no K_out"
            severity error;

        Load <= '0';
        wait for 20 ns;

        assert false
            report "TESTE TERMINADO: KT_Datapath passou."
            severity note;

        wait;
    end process;

end sim;