library ieee;
use ieee.std_logic_1164.all;

entity KT_Control is
port(
    MClk     : in std_logic;
    TXclk    : in std_logic;
    Rst      : in std_logic;
    Load     : in std_logic;
    Count    : in std_logic_vector(2 downto 0);

    KBfree   : out std_logic;
    ClrCnt   : out std_logic;
    TXEnable : out std_logic
);
end KT_Control;

architecture behavioral of KT_Control is

type State_Type is (
    Free,
    Transmit
);

signal CurrentState, NextState : State_Type;

begin

CurrentState <= Free when Rst = '1' else NextState when rising_edge(MClk);


GenerateNextState:
process(CurrentState, Load, TXclk, Count)
begin

    case CurrentState is

        when Free =>
            if Load = '1' then
                NextState <= Transmit;
            else
                NextState <= Free;
            end if;

        when Transmit =>
            if Count = "111" and TXclk = '0' then
                NextState <= Free;
            else
                NextState <= Transmit;
            end if;

    end case;

end process;


KBfree <= '1' when CurrentState = Free else '0';

ClrCnt <= '1' when CurrentState = Free else '0';

TXEnable <= '1' when CurrentState = Transmit else '0';

end behavioral;