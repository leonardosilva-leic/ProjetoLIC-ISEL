library ieee;
use ieee.std_logic_1164.all;

entity KT_Mux6x1 is 
	port(
		Start    : in std_logic;
		K        : in std_logic_vector(3 downto 0);
		Stop     : in std_logic;
		Selector : in std_logic_vector(2 downto 0);
		Y        : out std_logic
	);
end KT_Mux6x1;

architecture logic of KT_Mux6x1 is
begin

    -- Nova sequência durante Sending:
    -- 000 -> 1
    -- 001 -> K0
    -- 010 -> K1
    -- 011 -> K2
    -- 100 -> K3
    -- 101 -> 0
    -- 110 -> 1
    -- 111 -> 1 (segurança)
    with Selector select
        Y <= Start when "000",   -- aqui Start vai receber '1'
             K(0)  when "001",
             K(1)  when "010",
             K(2)  when "011",
             K(3)  when "100",
             Stop  when "101",   -- aqui Stop vai receber '0'
             '1'   when "110",
             '1'   when "111",
             '1'   when others;

end logic;