library ieee;
use ieee.std_logic_1164.all;

entity KT_Counter is
port(
    TXclk    : in std_logic;
    TXEnable : in std_logic;
    ClrCnt   : in std_logic;
    Rst      : in std_logic;
    Q        : out std_logic_vector(2 downto 0)
);
end KT_Counter;

architecture structural of KT_Counter is

component Register_3bit is
  port(
    CLK   : in  std_logic;
    Rst   : in  std_logic;
    EN    : in  std_logic;
    D_IN  : in  std_logic_vector(2 downto 0);
    Q_OUT : out std_logic_vector(2 downto 0)
  );
end component;

component Adder_3bit is
  port(
    A  : in  std_logic_vector(2 downto 0);
    B  : in  std_logic_vector(2 downto 0);
    Ci : in  std_logic;
    S  : out std_logic_vector(2 downto 0);
    Co : out std_logic
  );
end component;

signal B          : std_logic_vector(2 downto 0);
signal Soma       : std_logic_vector(2 downto 0);
signal Q_OUT      : std_logic_vector(2 downto 0);
signal Co_sig     : std_logic;
signal CounterRst : std_logic;

begin

    CounterRst <= Rst or ClrCnt;
    B <= "001";

    Adderr : Adder_3bit
      port map(
        A  => Q_OUT,
        B  => B,
        Ci => '0',
        S  => Soma,
        Co => Co_sig
      );

    Registerr : Register_3bit
      port map(
        CLK   => TXclk,
        Rst   => CounterRst,
        EN    => TXEnable,
        D_IN  => Soma,
        Q_OUT => Q_OUT
      );

    Q <= Q_OUT;

end structural;