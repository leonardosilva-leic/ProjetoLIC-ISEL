library ieee;
use ieee.std_logic_1164.all;

entity KeyControl_2 is
	port(
			MClk : in std_logic;
			Rst : in std_logic; 
			Ka : in std_logic;
			Tdelay : in std_logic_vector(1 downto 0);
			Kpress: in std_logic;
			Kval: out std_logic;
			Kscan: out std_logic
   );
	
end KeyControl_2;

architecture structural of KeyControl_2 is

component CLKDIV_T is
port(
    Clk       : in  std_logic;
    Tclear	  : in  std_logic;
    Tdelay    : in  std_logic_vector(1 downto 0);
    Texpired  : out std_logic
);
end component;

component KeyControl is
	port(
			MClk : in std_logic;
			Rst : in std_logic; 
			Ka : in std_logic;
			Kpress: in std_logic;
			Texpired: in std_logic;
			Kval: out std_logic;
			Kscan: out std_logic;
			Tclear: out std_logic
		);
		
end component;

signal Texpired_out : std_logic;
signal Tclear_out : std_logic;


begin

Timer: CLKDIV_T
port map(
    Clk       =>MClk,
    Tclear	  =>Tclear_out,
    Tdelay    =>Tdelay,
    Texpired  =>Texpired_out
);

	
KeyColtrol_1: KeyControl
	port map(
		MClk   	=> MClk,
		Rst    	=> Rst,
		Ka     	=> Ka,
		Kpress 	=> Kpress,
		Texpired => Texpired_out,
		Kval   	=> Kval,
		Kscan  	=> Kscan,
		Tclear 	=> Tclear_out
	);

end structural;
		
		
		