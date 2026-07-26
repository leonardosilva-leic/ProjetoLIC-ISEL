library ieee;
use ieee.std_logic_1164.all;

entity TicketMachine is
	port(
		MClk         : in std_logic;
		Rst          : in std_logic;
		Tdelay       : in std_logic_vector(1 downto 0);
		linhas_in    : in std_logic_vector(3 downto 0);
		CollectTicket: in std_logic;
		Ca_Coin		 : in std_logic;
		Ca_CoinID	 : in std_logic_vector(2 downto 0);
		M				 : in std_logic;
		D            : out std_logic_vector(9 downto 0);
	   colunas_out  : out std_logic_vector(3 downto 0);
		Ca_Collect	 : out std_logic;
		Ca_Accept	 : out std_logic;
		Ca_Eject		 : out std_logic;
		K	  		    : out std_logic_vector(3 downto 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out STD_LOGIC_VECTOR(7 downto 0)
   );
	
end TicketMachine;

architecture structural of TicketMachine is

component KeyboardReader is
port(
		MClk        : in std_logic;
		Rst         : in std_logic;
		Tdelay      : in std_logic_vector(1 downto 0);
		linhas_in   : in std_logic_vector(3 downto 0);
	   Txclk       : in std_logic;
		K				: out std_logic_vector(3 downto 0);
	   colunas_out : out std_logic_vector(3 downto 0);
		TxD         : out std_logic
	);
	
end component;

component UsbPort is
	port( 
		inputPort  :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPort :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	
end component;

component PELCD is
	port(
		SS   : in std_logic;
		SCLK : in std_logic;
		SDX  : in std_logic;
		Rst  : in std_logic;
		D    : out std_logic_vector(9 downto 0)
	);
	
end component;

component PETD is
	port(
		SS   : in std_logic;
		SCLK : in std_logic;
		SDX  : in std_logic;
		Rst  : in std_logic;
		RT   : out std_logic;
		Prt  : out std_logic;
		O    : out std_logic_vector(8 downto 5);
		D    : out std_logic_vector(4 downto 1)
	);
	
end component;

component TICKET_DISPENSER is
	port ( 
			RT, Prt, CollectTicket: in STD_LOGIC;
			O, D: in STD_LOGIC_VECTOR(3 downto 0);
			Fn: out STD_LOGIC;
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out STD_LOGIC_VECTOR(7 downto 0) 
		 );
			
end component;

signal UsbPort_in    : std_logic_vector(7 downto 0);
signal UsbPort_out   : std_logic_vector(7 downto 0);
signal RT_out			: std_logic;
signal Prt_out			: std_logic;
signal O_out			: std_logic_vector(3 downto 0);
signal D_out			: std_logic_vector(3 downto 0);
signal K_out			: std_logic_vector(3 downto 0);


begin

UsbPort_in(0)   <= Ca_CoinID(0) ; 
UsbPort_in(1)   <= Ca_CoinID(1) ; 
UsbPort_in(2)   <= Ca_CoinID(2) ; 
UsbPort_in(3)   <= Ca_Coin ; 
--UsbPort_in(4)   <= s_Kval ;
UsbPort_in(5)   <= '0' ;
UsbPort_in(6)   <= M ;
--UsbPort_in(7)   <= '0' ;
--UsbPort_out(0)  <= s_Ka ;
--UsbPort_out(1)  <= '0' ;
--UsbPort_out(2)  <= '0' ;
--UsbPort_out(3)  <= '0' ;
--UsbPort_out(4)  <= Ca_Accept ;
--UsbPort_out(5)  <= Ca_Eject ;
--UsbPort_out(6)  <= Ca_Collect ;
--UsbPort_out(7)  <= '0' ;

KeyboardReader_V: KeyboardReader
	port map(
		MClk        => MClk,
		K 				=> K_out,
		Rst         => Rst,
		Tdelay      => Tdelay, 
		linhas_in   => linhas_in,
	   Txclk       => UsbPort_out(7),
	   colunas_out => colunas_out, 
		TxD         => UsbPort_in(7)
	);

UsbPort_V: UsbPort
		port map(
			inputPort  => UsbPort_in,  
			outputPort => Usbport_out
	);
	
PETD_V: PETD
	port map(
		SS   => UsbPort_out(3),
		SCLK => Usbport_out(1), 
		SDX  => UsbPort_out(0),
		Rst  => Rst,
		RT   => RT_out,
		Prt  => Prt_out,
		O    => O_out,
		D    => D_out
		);
		
PELCD_V: PELCD
	port map(
		SS   => UsbPort_out(2),
		SCLK => Usbport_out(1), 
		SDX  => UsbPort_out(0),
		Rst  => Rst,
		D    => D
		);
		
TicketDispencer_V: TICKET_DISPENSER
    port map(
		RT   			  => RT_out,
		Prt  		  	  => Prt_out,
		CollectTicket => CollectTicket,
		Fn 			  => Usbport_in(4),
		O    			  => O_out,
		D    			  => D_out,
		HEX0 			  => HEX0, 
		HEX1 			  => HEX1, 
		HEX2 			  => HEX2, 
		HEX3 			  => HEX3, 
		HEX4 			  => HEX4, 
		HEX5 			  => HEX5
    );
	 
Ca_Accept  <= UsbPort_out(4);
Ca_Eject   <= UsbPort_out(5);
Ca_Collect <= UsbPort_out(6);
K <= K_out;
		
end structural;