library ieee;
use ieee.std_logic_1164.all;

entity KT_Datapath is
    port(
        MClk     : in std_logic;
        TXclk    : in std_logic;
        K        : in std_logic_vector(3 downto 0);
		  KBfree	  : in std_logic;
        Load     : in std_logic;
        TXEnable : in std_logic;
        ClrCnt   : in std_logic;
        Rst      : in std_logic;
		  K_out		  : out std_logic_vector(3 downto 0);
        Count    : out std_logic_vector(2 downto 0);
        TXD      : out std_logic
    );
end KT_Datapath;

architecture structural of KT_Datapath is

		component KT_Register is
			 port(
				  MClk   : in std_logic;
				  Rst    : in std_logic;
				  K      : in std_logic_vector(3 downto 0);
				  KBfree : in std_logic;
				  Load   : in std_logic;
				  K_reg  : out std_logic_vector(3 downto 0)
			 );
		end component;

    component KT_Counter is
        port(
            TXclk    : in std_logic;
            TXEnable : in std_logic;
            ClrCnt   : in std_logic;
            Rst      : in std_logic;
            Q        : out std_logic_vector(2 downto 0)
        );
    end component;

    component KT_Mux8x1 is  
        port(
            Start0   : in std_logic;
            Start1   : in std_logic;
            K        : in std_logic_vector(3 downto 0);
            Stop0    : in std_logic;
            Stop1    : in std_logic;
            Selector : in std_logic_vector(2 downto 0);
            Y        : out std_logic
        );
    end component;

    signal K_reg_s : std_logic_vector(3 downto 0);
    signal Count_s : std_logic_vector(2 downto 0);
    signal TXD_mux : std_logic;


begin

		Reg1 : KT_Register
			 port map(
				  MClk   => MClk,
				  Rst    => Rst,
				  K      => K,
				  KBfree => KBfree,
				  Load   => Load,
				  K_reg  => K_reg_s
			 );

    Counter1 : KT_Counter
        port map(
            TXclk    => TXclk,
            TXEnable => TXEnable,
            ClrCnt   => ClrCnt,
            Rst      => Rst,
            Q        => Count_s
        );

    DataMux : KT_Mux8x1
        port map(
            Start0   => '0',
            Start1   => '1',
            K        => K_reg_s,
            Stop0    => '0',
            Stop1    => '1',
            Selector => Count_s,
            Y        => TXD_mux
        );	  

    Count <= Count_s;

    TXD <= TXD_mux when TXEnable = '1' else '1';
	 
	 K_out <= K_reg_s;

end structural;