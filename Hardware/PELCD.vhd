library ieee;
use ieee.std_logic_1164.all;

entity PELCD is
	port(
		SS   : in std_logic;
		SCLK : in std_logic;
		SDX  : in std_logic;
		Rst  : in std_logic;
		D    : out std_logic_vector(9 downto 0)
	);
	
end PELCD;

architecture structural of PELCD is

component SerialReceiver is
	port(
		SDX   : in std_logic;
		SCLK  : in std_logic;
		SS    : in std_logic;
		Rst   : in std_logic;
		D     : out std_logic_vector(9 downto 0)
	);
	
end component;

begin 

SerialReceiver_V: serialReceiver
	port map(
		SDX  => SDX,
		SCLK => SCLK,
		SS   => SS,
		Rst  => Rst,
		D    => D
	);
	
end structural;

		