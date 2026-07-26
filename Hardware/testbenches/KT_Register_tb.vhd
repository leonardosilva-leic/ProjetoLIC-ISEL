library ieee;
use ieee.std_logic_1164.all;

entity KT_Register_tb is
end KT_Register_tb;

architecture sim of KT_Register_tb is

    component KT_Register is
        port(
            MClk   : in std_logic;
            Rst    : in std_logic;
            K      : in std_logic_vector(3 downto 0);
            Load   : in std_logic;
            KBfree : in std_logic;
            K_reg  : out std_logic_vector(3 downto 0)
        );
    end component;

    signal MClk   : std_logic := '0';
    signal Rst    : std_logic := '0';
    signal K      : std_logic_vector(3 downto 0) := "0000";
    signal Load   : std_logic := '0';
    signal KBfree : std_logic := '1';
    signal K_reg  : std_logic_vector(3 downto 0);

begin

    -- Clock principal
    MClk <= not MClk after 10 ns;

    DUT : KT_Register
        port map(
            MClk   => MClk,
            Rst    => Rst,
            K      => K,
            Load   => Load,
            KBfree => KBfree,
            K_reg  => K_reg
        );

    stim : process
    begin
        -- reset inicial
        Rst <= '1';
        wait for 25 ns;
        Rst <= '0';
        wait for 20 ns;

        --------------------------------------------------------------------
        -- Caso parecido com RingBuffer/RAM:
        -- Load sobe primeiro, K muda logo depois.
        -- Agora deve funcionar, porque o registo só guarda no próximo MClk.
        --------------------------------------------------------------------
        Load <= '1';
        wait for 1 ns;

        K <= "1010";

        -- espera o próximo flanco de subida de MClk
        wait until rising_edge(MClk);
        wait for 1 ns;

        assert K_reg = "1010"
            report "FALHOU: KT_Register corrigido nao capturou 1010"
            severity error;

        Load <= '0';
        wait for 30 ns;

        --------------------------------------------------------------------
        -- Segundo valor, para garantir que não ficou preso
        --------------------------------------------------------------------
        Load <= '1';
        wait for 1 ns;

        K <= "0111";

        wait until rising_edge(MClk);
        wait for 1 ns;

        assert K_reg = "0111"
            report "FALHOU: KT_Register corrigido nao capturou 0111"
            severity error;

        Load <= '0';
        wait for 30 ns;

        assert false
            report "TESTE TERMINADO: KT_Register corrigido passou."
            severity note;

        wait;
    end process;

end sim;