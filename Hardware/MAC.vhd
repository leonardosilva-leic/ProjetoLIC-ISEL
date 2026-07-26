library ieee;
use ieee.std_logic_1164.all;

entity MAC is
    port(
        CLK    : in  std_logic;
        Rst    : in  std_logic;
        PnG : in  std_logic;
        incPut : in  std_logic;
        incGet : in  std_logic;
        S      : out std_logic_vector(3 downto 0);
        full   : out std_logic;
        empty  : out std_logic
    );
end MAC;

architecture structural of MAC is

    component Counter_5bits is 
        port(
            Clk : in std_logic;
            CE  : in std_logic;
            Rst : in std_logic;
            Q   : out std_logic_vector(4 downto 0)
        );
    end component;

    signal Q_out_CPut : std_logic_vector(4 downto 0);
    signal Q_out_CGet : std_logic_vector(4 downto 0);

begin

    CPut : Counter_5bits
        port map(
            Clk => CLK,
            CE  => incPut,
            Rst => Rst,
            Q   => Q_out_CPut
        );

    CGet : Counter_5bits
        port map(
            Clk => CLK,
            CE  => incGet,
            Rst => Rst,
            Q   => Q_out_CGet
        );

    S <= Q_out_CGet(3 downto 0) when PnG = '0' else
         Q_out_CPut(3 downto 0);

    full <= '1' when (Q_out_CPut(3 downto 0) = Q_out_CGet(3 downto 0)) and
                     (Q_out_CPut(4) /= Q_out_CGet(4))
            else '0';

    empty <= '1' when (Q_out_CPut(3 downto 0) = Q_out_CGet(3 downto 0)) and
                      (Q_out_CPut(4) = Q_out_CGet(4))
             else '0';

end structural;
