library ieee; 
use ieee.std_logic_1164.all;

entity Adder is
	port(
			A  : in std_logic_vector(3 downto 0);
			B  : in std_logic_vector(3 downto 0);
			Ci : in std_logic;
			S  : out std_logic_vector(3 downto 0);
			Co : out std_logic
			);
	
end Adder;

architecture structural of  Adder is 

component FA is 
     port(
				A  : in std_logic;
				B  : in std_logic;
				Ci : in std_logic;
				S  : out std_logic;
				Co : out std_logic
				);
	  
end component;		

signal carry : std_logic_vector(2 downto 0);

begin

U1 : FA port map (A => A(0), B => B(0), Ci => Ci, S => S(0), Co => carry(0));

U2 : FA port map (A => A(1), B => B(1), Ci => carry(0), S => S(1), Co => carry(1));

U3 : FA port map (A => A(2), B => B(2), Ci => carry(1), S => S(2), Co => carry(2));

U4 : FA port map (A => A(3), B => B(3), Ci => carry(2), S => S(3), Co => Co);

end structural;