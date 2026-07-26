library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity CLKDIV_T is
port(
    Clk       : in  std_logic;
    Tclear	  : in  std_logic;
    Tdelay    : in  std_logic_vector(1 downto 0);
    Texpired  : out std_logic
);
end CLKDIV_T;

architecture behavioral of CLKDIV_T is

signal count : integer := 0;
signal limit : integer;

begin

process(Tdelay)
begin
     if Tdelay = "00" then
        limit <= 25000000;    -- 500 ms
		  end if;

			if Tdelay = "01" then
            limit <= 50000000;    -- 1000 ms
			end if;

			if Tdelay = "10" then
            limit <= 75000000;    -- 1500 ms
			end if;
			
			if Tdelay = "11" then
				limit <= 100000000;   -- 2000 ms
			end if;

end process;

process(clk)
begin
    if rising_edge(clk) then

        if Tclear = '1' then
            count <= 0;
            Texpired <= '0';

        else
				if count < limit then
            count <= count + 1;
            Texpired <= '0';

        else
				count <= limit;
            Texpired <= '1';

        end if;

    end if;
	end if;
end process;

end behavioral;