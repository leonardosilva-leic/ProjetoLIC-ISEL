library ieee;
use ieee.std_logic_1164.all;

entity KT_Register is
    port(
        MClk     : in std_logic;
        Rst      : in std_logic;
        K        : in std_logic_vector(3 downto 0);
        Load     : in std_logic;
        KBfree   : in std_logic;
        K_reg    : out std_logic_vector(3 downto 0)
   );
end KT_Register;

architecture structural of KT_Register is

    component FFD is
        port(
            CLK : in  std_logic;
            Rst : in  std_logic;
            SET : in  std_logic;
            D   : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;

    signal EN_reg : std_logic;

begin

    EN_reg <= Load and KBfree;

    FF0 : FFD
        port map (
            CLK => MClk,
            Rst => Rst,
            SET => '0',
            EN  => EN_reg,
            D   => K(0),
            Q   => K_reg(0)
        );

    FF1 : FFD
        port map (
            CLK => MClk,
            Rst => Rst,
            SET => '0',
            EN  => EN_reg,
            D   => K(1),
            Q   => K_reg(1)
        );

    FF2 : FFD
        port map (
            CLK => MClk,
            Rst => Rst,
            SET => '0',
            EN  => EN_reg,
            D   => K(2),
            Q   => K_reg(2)
        );

    FF3 : FFD
        port map (
            CLK => MClk,
            Rst => Rst,
            SET => '0',
            EN  => EN_reg,
            D   => K(3),
            Q   => K_reg(3)
        );

end structural;