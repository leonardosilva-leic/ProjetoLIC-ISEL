library ieee;
use ieee.std_logic_1164.all;

entity Mux4x1 is 
	port(
		A : in std_logic;
		B : in std_logic;
		C : in std_logic;
		D : in std_logic;
		S : in std_logic_vector(1 downto 0);
		Y : out std_logic
	);
end Mux4x1;

architecture logic of Mux4x1 is

component Mux2x1 is
	port(
		A : in std_logic;
		B : in std_logic;
		S : in std_logic;
		Y : out std_logic
	);
end component;

signal Mux01_out : std_logic;
signal Mux02_out : std_logic;
signal Mux11_out : std_logic;

begin

Mux01 : Mux2x1
	port map(
		A => A,
		B => B,
		S => S(0),
		Y => Mux01_out
	);
	
Mux02 : Mux2x1
	port map(
		A => C,
		B => D,
		S => S(0),
		Y => Mux02_out
	);
	
Mux11 : Mux2x1
	port map(
		A => Mux01_out,
		B => Mux02_out,
		S => S(1),
		Y => Mux11_out
	);

Y <= Mux11_out;
	 
end logic;
