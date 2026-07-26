library ieee;
use ieee.std_logic_1164.all;

entity PETD is
	port(
		SS   : in std_logic;
		SCLK : in std_logic;
		SDX  : in std_logic;
		Rst  : in std_logic;
		RT   : out std_logic;
		Prt  : out std_logic;
		O    : out std_logic_vector(8 downto 5);
		D    : out std_logic_vector(4 downto 1)
	);
	
end PETD;

architecture structural of PETD is

component SerialReceiver is
	port(
		SDX   : in std_logic;
		SCLK  : in std_logic;
		SS    : in std_logic;
		Rst   : in std_logic;
		D     : out std_logic_vector(9 downto 0)
	);
	
end component;

signal s_D_out : std_logic_vector(9 downto 0);

begin 

SerialReceiver_V: serialReceiver
	port map(
		SDX  => SDX,
		SCLK => SCLK,
		SS   => SS,
		Rst  => Rst,
		D    => s_D_out
	);
	
Prt    <= s_D_out(9);
O     <= s_D_out(4 downto 1);
D     <= s_D_out(8 downto 5); 
RT     <= s_D_out(0);
	
end structural;

		