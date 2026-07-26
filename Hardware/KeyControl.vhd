library ieee;
use ieee.std_logic_1164.all;

entity KeyControl is 
port		( 
				MClk : in std_logic;
				Rst : in std_logic; 
				Ka : in std_logic;
				Kpress: in std_logic;
				Texpired: in std_logic;
				Kval: out std_logic;
				Kscan: out std_logic;
				Tclear: out std_logic
				);
end KeyControl;

architecture behavioral of KeyControl is

type State_Type is ( Scan, Delievery, NotAcknoledge, KeyRelease);

signal CurrentState, NextState: State_Type;

begin 

CurrentState <= Scan when Rst = '1' else NextState when rising_edge(MClk);

GenerateNextState:
process ( CurrentState, Ka, Kpress, Texpired)
	begin
		case CurrentState is 
			when Scan 				=> 	if (Kpress = '1') 
													then 
														NextState <= Delievery;
													else 
														NextState <= Scan; 
													end if;
													
			when Delievery 		=> 	if (Ka = '1')
													then 
														NextState <= NotAcknoledge;
													else 
														NextState <= Delievery;
													end if;
													
			when NotAcknoledge 	=> 	if (KA = '0')
													then 
														NextState <= KeyRelease;
													else 
														NextState <= NotAcknoledge;
													end if;
													
			when KeyRelease 		=> 	if (Kpress = '0')
													then 
														NextState <= Scan;
													elsif (Kpress = '1' and Texpired = '0')
														then
														NextState <= KeyRelease;
													else
														NextState <= Delievery;
													end if;
			
		end case;
	end process;	
	
Kval <= '1' when ( (CurrentState = Delievery) ) else '0';

Kscan <= '1' when ( (CurrentState = Scan) ) else '0';

Tclear <= '1' when ( (CurrentState = Delievery) ) else '0';

end behavioral;