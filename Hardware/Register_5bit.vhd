LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Register_5bit IS
    PORT(
        CLK   : in  STD_LOGIC;
        Rst : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        D_IN  : in  STD_LOGIC_VECTOR(4 downto 0);
        Q_OUT : out STD_LOGIC_VECTOR(4 downto 0)
    );
END Register_5bit;

ARCHITECTURE structural OF Register_5bit IS

    COMPONENT FFD IS
        PORT(
            CLK   : in  STD_LOGIC;
            Rst : in  STD_LOGIC;
            SET   : in  STD_LOGIC;
            D     : in  STD_LOGIC;
            EN    : in  STD_LOGIC;
            Q     : out STD_LOGIC
        );
    END COMPONENT;

BEGIN

    FF0 : FFD
        PORT MAP (
            CLK   => CLK,
            Rst => Rst,
            SET   => '0',
            EN    => EN,
            D     => D_IN(0),
            Q     => Q_OUT(0)
        );

    FF1 : FFD
        PORT MAP (
            CLK   => CLK,
            Rst => Rst,
            SET   => '0',
            EN    => EN,
            D     => D_IN(1),
            Q     => Q_OUT(1)
        );

    FF2 : FFD
        PORT MAP (
            CLK   => CLK,
            Rst => Rst,
            SET   => '0',
            EN    => EN,
            D     => D_IN(2),
            Q     => Q_OUT(2)
        );

    FF3 : FFD
        PORT MAP (
            CLK   => CLK,
            Rst => Rst,
            SET   => '0',
            EN    => EN,
            D     => D_IN(3),
            Q     => Q_OUT(3)
        );

	 FF4 : FFD
        PORT MAP (
            CLK   => CLK,
            Rst => Rst,
            SET   => '0',
            EN    => EN,
            D     => D_IN(4),
            Q     => Q_OUT(4)
        );
END structural;