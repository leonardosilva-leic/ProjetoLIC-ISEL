library ieee;
use ieee.std_logic_1164.all;

entity KT_Mux8x1 is 
	port(
		Start0   : in std_logic;
		Start1   : in std_logic;
		K        : in std_logic_vector(3 downto 0);
		Stop0    : in std_logic;
		Stop1    : in std_logic;
		Selector : in std_logic_vector(2 downto 0);
		Y        : out std_logic
	);
end KT_Mux8x1;

architecture logic of KT_Mux8x1 is

component Mux4x1 is 
	port(
		A : in std_logic;
		B : in std_logic;
		C : in std_logic;
		D : in std_logic;
		S : in std_logic_vector(1 downto 0);
		Y : out std_logic
	);
end component;

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
signal Mux21_out : std_logic;

begin
Mux01 : Mux4x1
    port map(
        A => Start0,
        B => Start1,
        C => K(0),
        D => K(1),
        S => Selector(1 downto 0),
        Y => Mux01_out
    );

Mux02 : Mux4x1
    port map(
        A => K(2),
        B => K(3),
        C => Stop0,
        D => Stop1,
        S => Selector(1 downto 0),
        Y => Mux02_out
    );

Mux21 : Mux2x1
    port map(
        A => Mux01_out,
        B => Mux02_out,
        S => Selector(2),
        Y => Mux21_out
    );
	
Y <= Mux21_out;

end logic;