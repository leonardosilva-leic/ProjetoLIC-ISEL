library ieee;
use ieee.std_logic_1164.all;

entity CoinAcceptor is
port(
    MClk        : in  std_logic;
    Rst         : in  std_logic;
    Insert      : in  std_logic;
    CoinId_in   : in  std_logic_vector(2 downto 0);
    accept      : in  std_logic;
    collect     : in  std_logic;
    eject       : in  std_logic;
    Coin        : out std_logic;
    CoinId      : out std_logic_vector(2 downto 0);
    CollectLed  : out std_logic;
    EjectLed    : out std_logic
);
end CoinAcceptor;

architecture behavioral of CoinAcceptor is

    type State_Type is (Idle, Delivery, WaitAcceptLow);
    signal CurrentState, NextState : State_Type;

    signal CoinId_reg : std_logic_vector(2 downto 0);

begin

    CurrentState <= Idle when Rst = '1' else NextState when rising_edge(MClk);

    process(CurrentState, Insert, accept)
    begin
        case CurrentState is

            when Idle =>
                if (Insert = '1') then
                    NextState <= Delivery;
                else
                    NextState <= Idle;
                end if;

            when Delivery =>
                if (accept = '1') then
                    NextState <= WaitAcceptLow;
                else
                    NextState <= Delivery;
                end if;

            when WaitAcceptLow =>
                if (accept = '0') then
                    NextState <= Idle;
                else
                    NextState <= WaitAcceptLow;
                end if;

        end case;
    end process;

    process(MClk, Rst)
    begin
        if (Rst = '1') then
            CoinId_reg <= "000";
        elsif rising_edge(MClk) then
            if (CurrentState = Idle and Insert = '1') then
                CoinId_reg <= CoinId_in;
            end if;
        end if;
    end process;

    Coin       <= '1' when (CurrentState = Delivery) else '0';
    CoinId     <= CoinId_reg;
    CollectLed <= collect;
    EjectLed   <= eject;

end behavioral;