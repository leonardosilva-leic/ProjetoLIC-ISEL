library ieee;
use ieee.std_logic_1164.all;

entity KeyTransmitter is
    port(
        MClk   : in  std_logic;
        K      : in  std_logic_vector(3 downto 0);
        Load   : in  std_logic;
        TXclk  : in  std_logic;
        Rst    : in  std_logic;
        KBfree : out std_logic;
        K_out      : out  std_logic_vector(3 downto 0);
        TXD    : out std_logic
    );
end KeyTransmitter;

architecture structural of KeyTransmitter is

    component KT_Control is
        port(
            MClk     : in  std_logic;
            Rst      : in  std_logic;
            Load     : in  std_logic;
            TXclk    : in  std_logic;
            Count    : in  std_logic_vector(2 downto 0);
            KBfree   : out std_logic;
            ClrCnt   : out std_logic;
            TXEnable : out std_logic
        );
    end component;

    component KT_Datapath is
        port(
            MClk     : in  std_logic;
            TXclk    : in  std_logic;
            K        : in  std_logic_vector(3 downto 0);
				KBfree	: in  std_logic;
            Load     : in  std_logic;
            TXEnable : in  std_logic;
            ClrCnt   : in  std_logic;
            Rst      : in  std_logic;
				K_out			: out std_logic_vector(3 downto 0);
            Count    : out std_logic_vector(2 downto 0);
            TXD      : out std_logic
        );
    end component;

    signal Count_s    : std_logic_vector(2 downto 0);
    signal KBfree_s   : std_logic;
    signal TXEnable_s : std_logic;
    signal ClrCnt_s   : std_logic;
	 

begin

    Control1 : KT_Control
        port map(
            MClk     => MClk,
            Rst      => Rst,
            Load     => Load,
            TXclk    => TXclk,
            Count    => Count_s,
            KBfree   => KBfree_s,
            ClrCnt   => ClrCnt_s,
            TXEnable => TXEnable_s
        );

    Datapath1 : KT_Datapath
        port map(
            MClk     => MClk,
            TXclk    => TXclk,
            K        => K,
				KBfree	=> KBfree_s,
            Load     => Load,
            TXEnable => TXEnable_s,
            ClrCnt   => ClrCnt_s,
            Rst      => Rst,
				K_out        => K_out,
            Count    => Count_s,
            TXD      => TXD
        );

    KBfree <= KBfree_s;

end structural;