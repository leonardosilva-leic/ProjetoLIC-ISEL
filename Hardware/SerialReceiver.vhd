library ieee;
use ieee.std_logic_1164.all;

entity SerialReceiver is
	port(
		SDX   : in std_logic;
		SCLK  : in std_logic;
		SS    : in std_logic;
		Rst   : in std_logic;
		D     : out std_logic_vector(9 downto 0)
	);
	
end SerialReceiver;

architecture structural of SerialReceiver is

component ShiftRegister is
	port(
		Serial_in : in std_logic;
		EN_shift  : in std_logic;
		SCLK      : in std_logic;
		Rst     : in std_logic;
		Q_OUT     : out std_logic_vector(9 downto 0)
			);
			
end component;

component HoldRegister10bits is
	port(
		  CLK   : in  STD_LOGIC;
        Rst   : in  STD_LOGIC;
        SET   : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        D_IN  : in  STD_LOGIC_VECTOR(9 downto 0);
        Q_OUT : out STD_LOGIC_VECTOR(9 downto 0)
    );
	 
end component; 

signal s_D_in   : std_logic_vector(9 downto 0);
signal s_not_ss : std_logic;

begin 	 

ShiftRegister_V : ShiftRegister
	port map(
		Serial_in => SDX, 
		EN_shift  => s_not_ss,
		SCLK      => SCLK,     
		Rst       => Rst,   
		Q_OUT     => s_D_in
			);
			

HoldRegister_V : HoldRegister10bits
	port map(
		  CLK   => SS,    
        Rst   => Rst, 
        SET   => '0',  
        EN    => '1',    
        D_IN  => s_D_in,  
        Q_OUT => D 
    );
	 

s_not_ss <= not SS;	 

	 
end structural;
