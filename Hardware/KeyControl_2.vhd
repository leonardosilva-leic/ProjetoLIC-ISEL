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
component KeyControl is
	port(
			MClk : in std_logic;
			Rst : in std_logic; 
			Ka : in std_logic;
			Kpress: in std_logic;
			Kval: out std_logic;
			Kscan: out std_logic
		);
		
end component;


begin
	
KeyColtrol_1: KeyControl
	port map(
		MClk   	=> MClk,
		Rst    	=> Rst,
		Ka     	=> Ka,
		Kpress 	=> Kpress,
		Kval   	=> Kval,
		Kscan  	=> Kscan
	);

end structural;
		
		
		