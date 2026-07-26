library ieee;
use ieee.std_logic_1164.all;

entity Counter is
port(
    Clk : in std_logic;
    CE  : in std_logic;
    Rst : in std_logic;
    Q   : out std_logic_vector(3 downto 0)
);
end Counter;

architecture structural of Counter is

component Register_4bit is
  port(
    CLK   : in  std_logic;
    Rst : in  std_logic;
    EN    : in  std_logic;
    D_IN  : in  std_logic_vector(3 downto 0);
    Q_OUT : out std_logic_vector(3 downto 0)
  );
end component;

component Adder is
  port(
    A  : in  std_logic_vector(3 downto 0);
    B  : in  std_logic_vector(3 downto 0);
    Ci : in  std_logic;
    S  : out std_logic_vector(3 downto 0);
    Co : out std_logic
  );
end component;

signal B : std_logic_vector(3 downto 0);
signal EntradaReg : std_logic_vector(3 downto 0);
signal Q_OUT : std_logic_vector(3 downto 0);
signal Co_sig : std_logic;

begin

B <= "0001";

Adderr : Adder
  port map(
    A  => Q_OUT,
    B  => B,
    Ci => '0',
    S  => EntradaReg,
    Co => Co_sig
  );

Registerr : Register_4bit
  port map(
    CLK   => CLK,
    Rst => Rst,
    EN    => CE,
    D_IN  => EntradaReg,
    Q_OUT => Q_OUT
  );

Q <= Q_OUT;

end structural;
