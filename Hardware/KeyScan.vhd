library ieee;
use ieee.std_logic_1164.all;

entity KeyScan is
port(
   MClk        : in std_logic;
	Kscan       : in std_logic;
	Rst         : in std_logic;
	linhas_in   : in std_logic_vector(3 downto 0);
	colunas_out : out std_logic_vector(3 downto 0);
	K           : out std_logic_vector(3 downto 0);
	Kpress      : out std_logic
  );
end KeyScan;


architecture structural of KeyScan is

component Counter is
  port(
    Clk : in std_logic;
    CE  : in std_logic;
    Rst : in std_logic;
    Q   : out std_logic_vector(3 downto 0)
  );
end component;

component TM_Decoder is
  port(
		S0: in std_logic;
		S1: in std_logic;
		C0: out std_logic;
		C1: out std_logic;
		C2: out std_logic;
		C3: out std_logic
  );
end component;

component Mux4x1 is
  port(
      A : in std_logic;
		B : in std_logic;
		C : in std_logic;
		D : in std_logic;
		S : in std_logic_vector(1 downto 0);
		Y : out std_logic
	);

end component;

signal CE_sig : std_logic;
signal QS      : std_logic_vector(3 downto 0);
signal NotCols: std_logic_vector(3 downto 0);
signal Not_Y: std_logic;
signal clkOut: std_logic;

begin

CE_sig <= Kscan;


Cont : Counter
  port map(
    Clk => MClk,
    CE  => CE_sig,
    Rst => Rst,
    Q   => QS
  );
  
Dec : TM_Decoder
  port map(
		S0 => QS(2),
		S1 => QS(3),
		C0 => NotCols(0), 
		C1 => NotCols(1),
		C2 => NotCols(2),
		C3 => NotCols(3)  
  );
  
MUX : Mux4x1
  port map(
        S(0) => QS(0),
        S(1) => QS(1),
		  A    => linhas_in(0),
		  B    => linhas_in(1),
		  C    => linhas_in(2),
		  D    => linhas_in(3),
        Y    => Not_Y
  );
  
K <= QS;
colunas_out <= not NotCols;
Kpress <= not Not_Y;

end structural;
