library ieee;
use ieee.std_logic_1164.all;

entity RingBuffer_Full_Empty_tb is
end RingBuffer_Full_Empty_tb;

architecture test of RingBuffer_Full_Empty_tb is

    component RingBuffer is
        port(
            CLK   : in  std_logic;
            RESET : in  std_logic;
            DAV   : in  std_logic;
            CTS   : in  std_logic;
            Din   : in  std_logic_vector(3 downto 0);
            DAC   : out std_logic;
            Wreg  : out std_logic;
            Dout  : out std_logic_vector(3 downto 0)
        );
    end component;

    signal CLK   : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DAV   : std_logic := '0';
    signal CTS   : std_logic := '0';
    signal Din   : std_logic_vector(3 downto 0) := (others => '0');

    signal DAC   : std_logic;
    signal Wreg  : std_logic;
    signal Dout  : std_logic_vector(3 downto 0);

begin

    UUT : RingBuffer
        port map(
            CLK   => CLK,
            RESET => RESET,
            DAV   => DAV,
            CTS   => CTS,
            Din   => Din,
            DAC   => DAC,
            Wreg  => Wreg,
            Dout  => Dout
        );

    ----------------------------------------------------------------
    -- Clock do sistema
    ----------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for 10 ns;
            CLK <= '1';
            wait for 10 ns;
        end loop;
    end process;

    ----------------------------------------------------------------
    -- Estímulos
    ----------------------------------------------------------------
    stim_process : process
    begin
        ------------------------------------------------------------
        -- RESET
        ------------------------------------------------------------
        RESET <= '1';
        DAV   <= '0';
        CTS   <= '0';
        Din   <= "0000";
        wait for 40 ns;

        RESET <= '0';
        wait for 60 ns;

        ------------------------------------------------------------
        -- ENCHER O BUFFER COM 16 VALORES
        ------------------------------------------------------------
        Din <= "0000"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "0001"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "0010"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "0011"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "0100"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "0101"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "0110"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "0111"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1000"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1001"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1010"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1011"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1100"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1101"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1110"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;
        Din <= "1111"; DAV <= '1'; wait for 100 ns; DAV <= '0'; wait for 100 ns;

        ------------------------------------------------------------
        -- TENTATIVA DE ESCREVER O 17º VALOR
        ------------------------------------------------------------
        Din <= "0000";
        DAV <= '1';
        wait for 100 ns;
        DAV <= '0';
        wait for 200 ns;

        ------------------------------------------------------------
        -- ESVAZIAR O BUFFER COM 16 ATIVAÇÕES DE CTS
        ------------------------------------------------------------
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;
        CTS <= '1'; wait for 100 ns; CTS <= '0'; wait for 100 ns;

        wait for 300 ns;
        wait;
    end process;

end test;