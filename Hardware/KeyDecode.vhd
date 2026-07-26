library ieee;
use ieee.std_logic_1164.all;

entity KeyDecode is
	port(
		MClk        : in std_logic;
		Rst         : in std_logic;
		Tdelay      : in std_logic_vector(1 downto 0);
		Ka          : in std_logic;
		linhas_in   : in std_logic_vector(3 downto 0);
	   colunas_out : out std_logic_vector(3 downto 0);
	   K           : out std_logic_vector(3 downto 0);
		Kval        : out std_logic
   );
	
end KeyDecode;

architecture structural of KeyDecode is

component CLKDIV is
		port ( clk_in: in std_logic;
				 clk_out: out std_logic);
end component;


component KeyScan is
		port(
			MClk        : in std_logic;
			Kscan       : in std_logic;
			Rst         : in std_logic;
			linhas_in   : in std_logic_vector(3 downto 0);
			colunas_out : out std_logic_vector(3 downto 0);
			K           : out std_logic_vector(3 downto 0);
			Kpress      : out std_logic
		);
end component;


component KeyControl_2 is
 port(
			MClk   : in std_logic;
			Rst    : in std_logic; 
			Ka     : in std_logic;
			Tdelay : in std_logic_vector(1 downto 0);
			Kpress : in std_logic;
			Kval   : out std_logic;
			Kscan  : out std_logic
		);
end component;

--component KeyControl is 
--port		( 
--				MClk : in std_logic;
--				Rst : in std_logic; 
--				Ka : in std_logic;
--				Tdelay : in std_logic_vector(1 downto 0);
--				Kpress: in std_logic;
--				Kval: out std_logic;
--				Kscan: out std_logic
--				);
--end component;

signal s_Kscan  : std_logic;
signal s_Kpress : std_logic;
signal s_clk    : std_logic;
signal s_CLKDIV : std_logic;
signal s_CLKDIV_KeyScan : std_logic;
signal s_CLKDIV_KeyControl : std_logic;


begin

CLKDIV_V: CLKDIV
	port map(
		clk_in	=> MCLK,
		clk_out	=> s_CLKDIV
		);

KeyScan_V: KeyScan
	port map(
		MClk        => s_CLKDIV_KeyScan,
		Kscan       => s_Kscan,
		Rst         => Rst,
		linhas_in   => linhas_in,
		colunas_out => colunas_out,
		K           => K,
		Kpress      => s_Kpress
	);

	
KeyColtrol_V: KeyControl_2
	port map(
		MClk   => s_CLKDIV_KeyControl,
		Rst    => Rst,
		Ka     => Ka,
		Tdelay => Tdelay,
		Kpress => s_Kpress,
		Kval   => Kval,
		Kscan  => s_Kscan
	);

	
--KeyColtrol_V: KeyControl
--	port map(
--		MClk   => s_CLKDIV_KeyControl,
--		Rst    => Rst,
--		Ka     => Ka,
--		Tdelay => Tdelay,
--		Kpress => s_Kpress,
--		Kval   => Kval,
--		Kscan  => s_Kscan
--	);

	s_CLKDIV_KeyScan <= not s_CLKDIV;
	s_CLKDIV_KeyControl <= s_CLKDIV;
	

end structural;
		
		
		












