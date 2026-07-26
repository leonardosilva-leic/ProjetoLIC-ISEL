library ieee;
use ieee.std_logic_1164.all;

entity Mux2x1 is 
	port(
		A : in std_logic;
		B : in std_logic;
		S : in std_logic;
		Y : out std_logic
	);
end Mux2x1;

architecture logic of Mux2x1 is
begin

Y <= (A and not S) or (B and S);
	 
end logic;