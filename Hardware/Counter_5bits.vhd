library ieee;
use ieee.std_logic_1164.all;

entity Counter_5bits is
port(
    Clk : in std_logic;
    CE  : in std_logic;
    Rst : in std_logic;
    Q   : out std_logic_vector(4 downto 0)
);
end Counter_5bits;

architecture structural of Counter_5bits is

component Register_5bit is
  port(
    CLK   : in  std_logic;
    Rst : in  std_logic;
    EN    : in  std_logic;
    D_IN  : in  std_logic_vector(4 downto 0);
    Q_OUT : out std_logic_vector(4 downto 0)
  );
end component;

component Adder_5bits is
  port(
    A  : in  std_logic_vector(4 downto 0);
    B  : in  std_logic_vector(4 downto 0);
    Ci : in  std_logic;
    S  : out std_logic_vector(4 downto 0);
    Co : out std_logic
  );
end component;

signal B : std_logic_vector(4 downto 0);
signal EntradaReg : std_logic_vector(4 downto 0);
signal Q_OUT : std_logic_vector(4 downto 0);
signal Co_sig : std_logic;

begin

B <= "00001";

Adderr : Adder_5bits
  port map(
    A  => Q_OUT,
    B  => B,
    Ci => '0',
    S  => EntradaReg,
    Co => Co_sig
  );

Registerr : Register_5bit
  port map(
    CLK   => CLK,
    Rst => Rst,
    EN    => CE,
    D_IN  => EntradaReg,
    Q_OUT => Q_OUT
  );

Q <= Q_OUT;

end structural;
