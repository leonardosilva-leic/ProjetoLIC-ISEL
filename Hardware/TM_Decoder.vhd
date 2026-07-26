library ieee;
use ieee.std_logic_1164.all;
entity TM_Decoder is
	port
	(
		S0: in std_logic;
		S1: in std_logic;
		C0: out std_logic;
		C1: out std_logic;
		C2: out std_logic;
		C3: out std_logic
		);
end TM_Decoder;
architecture arch_tmdecoder of TM_Decoder is
begin
 C0 <= (not S1 and not S0) ;
 C1 <= (not S1 and S0);
 C2 <= (S1 and not S0);
 C3 <= (S1 and S0);
end arch_tmdecoder;

