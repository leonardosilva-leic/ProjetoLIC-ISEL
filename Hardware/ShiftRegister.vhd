library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister is
	port(
		Serial_in : in std_logic;
		EN_shift  : in std_logic;
		SCLK      : in std_logic;
		Rst       : in std_logic;
		Q_OUT     : out std_logic_vector(9 downto 0)
	);
	
end ShiftRegister;

architecture structural of ShiftRegister is

component FFD is 
	port(
		CLK   : in  STD_LOGIC;
      Rst   : in  STD_LOGIC;
      SET   : in  STD_LOGIC;
      D     : in  STD_LOGIC;
      EN    : in  STD_LOGIC;
      Q     : out STD_LOGIC
     );
	  
	  
end component;

signal Q_s : std_logic_vector(9 downto 0);


begin

FF0 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Serial_in,
            Q     => Q_s(0)
        );

    FF1 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst  => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(0),
            Q     => Q_s(1)
        );

    FF2 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst  => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(1),
            Q     => Q_s(2)
        );

    FF3 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst   => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(2),
            Q     => Q_s(3)
        );

    FF4 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst   => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(3),
            Q     => Q_s(4)
        );

    FF5 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst   => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(4),
            Q     => Q_s(5)
        );

    FF6 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst   => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(5),
            Q     => Q_s(6)
        );

    FF7 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst   => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(6),
            Q     => Q_s(7)
        );

    FF8 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst   => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(7),
            Q     => Q_s(8)
        );

    FF9 : FFD
        PORT MAP (
            CLK   => SCLK,
            Rst    => Rst,
            SET   => '0',
            EN    => EN_shift,
            D     => Q_s(8),
            Q     => Q_s(9)
        );
		  
Q_OUT(0) <= Q_s(9);
Q_OUT(1) <= Q_s(8);
Q_OUT(2) <= Q_s(7);
Q_OUT(3) <= Q_s(6);
Q_OUT(4) <= Q_s(5);
Q_OUT(5) <= Q_s(4);
Q_OUT(6) <= Q_s(3);
Q_OUT(7) <= Q_s(2);
Q_OUT(8) <= Q_s(1);
Q_OUT(9) <= Q_s(0);


end structural;
	
