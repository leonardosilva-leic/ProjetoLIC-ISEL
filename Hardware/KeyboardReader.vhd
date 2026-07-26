library ieee;
use ieee.std_logic_1164.all;

entity KeyboardReader is
port(
    MClk        : in std_logic;
    Rst         : in std_logic;
    Tdelay      : in std_logic_vector(1 downto 0);
    linhas_in   : in std_logic_vector(3 downto 0);
    Txclk       : in std_logic;
	 K				 : out std_logic_vector(3 downto 0);
    colunas_out : out std_logic_vector(3 downto 0);
    TxD         : out std_logic
);
end KeyboardReader;

architecture structural of KeyboardReader is

component KeyDecode is
    port(
        MClk        : in std_logic;
        Rst         : in std_logic;
        Tdelay      : in std_logic_vector(1 downto 0);
        Ka          : in std_logic;
        linhas_in   : in std_logic_vector(3 downto 0);
        colunas_out : out std_logic_vector(3 downto 0);
        K           : out std_logic_vector(3 downto 0);
        Kval        : out std_logic
    );
end component;

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

component KeyTransmitter is
    port(
        MClk   : in  std_logic;
        K      : in  std_logic_vector(3 downto 0);
        Load   : in  std_logic;
        TXclk  : in  std_logic;
        Rst    : in  std_logic;
        K_out      : out  std_logic_vector(3 downto 0);
        KBfree : out std_logic;
        TXD    : out std_logic
    );
end component;

signal Kval_out : std_logic;
signal KRB_out, dataTx    : std_logic_vector(3 downto 0);
signal Ka_in    : std_logic;
signal Q_out    : std_logic_vector(3 downto 0);
signal Kf_out   : std_logic;
signal W_out    : std_logic;

begin

KeyDecode_V : KeyDecode
    port map(
        MClk        => MClk,   
        Rst         => Rst,    
        Tdelay      => Tdelay,    
        Ka          => Ka_in,    
        linhas_in   => linhas_in,  
        colunas_out => colunas_out,
        K           => KRB_out,
        Kval        => Kval_out
    );
    
RingBuffer_V : RingBuffer
    port map(
        CLK   => MClk,
        RESET => Rst,
        DAV   => Kval_out,
        CTS   => Kf_out,
        Din   => KRB_out,
        DAC   => Ka_in,
        Wreg  => W_out,
        Dout  => Q_out
    );

KeyTransmitter_V : KeyTransmitter
    port map(
        MClk   => MClk,
        K      => Q_out,
        Load   => W_out,
        TXclk  => TxClk,
		  K_out      => DataTx,
        Rst    => Rst,
        KBfree => Kf_out,
        TXD    => TxD
    );
	 
	 K <= DataTX;
     
end structural;