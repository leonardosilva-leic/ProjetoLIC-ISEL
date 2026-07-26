LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RingBufferControl IS
  PORT(
			CLK    : in std_logic;
        RESET  : in std_logic;
        DAV    : in std_logic;
        CTS    : in std_logic;
        full   : in std_logic;
        empty  : in std_logic;

        Wr     : out std_logic;
        PnG : out std_logic;
        incPut : out std_logic;
        incGet : out std_logic;
        Wreg   : out std_logic;
        DAC    : out std_logic
  );
END RingBufferControl;

architecture Behavioral of RingBufferControl is
--    type state_type is (Idle, prev_Write, Writing, pos_Write, Reading, pos_Read, ack_producer);
    type state_type is (Idle, prev_Write, Writing, pos_Write, Reading, pos_Read, ack_producer);	 
    signal current_state, next_state : STATE_TYPE;
    
begin

    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= Idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    

    process(current_state, DAV, CTS, Full, Empty)
    begin
--
--        Wr <= '0';
--        incPut <= '0';
--        incGet <= '0';
--        PnG <= '0';
--        DAC <= '0';
--        Wreg <= '0';
        
        case current_state is
		  
            when Idle =>
					
					if DAV = '1' and Full = '0' then
                    next_state <= prev_Write;
					 
					 elsif DAV = '1' and Full = '1' and CTS = '1' then
						  next_state <= Reading;
                
					 elsif DAV = '0'and CTS = '1' and Empty = '0' then
                    next_state <= Reading;
						  
                else
                    next_state <= Idle;
                end if;
                
				when prev_Write => 
									 
					 
					next_state <= Writing;
			   
				
            when Writing =>
               
                next_state <= pos_Write;
                
					 
            when pos_Write =>
                next_state <= ack_producer;
					 
			   when ack_producer =>
					 
					 if DAV = '1' then
					     next_state <= ack_producer;
					 else
					      next_state <= Idle;
                end if;
 
				  when Reading =>
				  
                if CTS = '1' then
					     next_state <= Reading;
					 else
					      next_state <= pos_Read;
                end if;
                
            when pos_Read =>
                
                
					 next_state <= Idle; 
           
			  
        end case;
    end process;
	 
	 Wr <= '1' when (current_state = Writing) else '0' ;
	 
    incPut <= '1' when (current_state = pos_Write) else '0' ;
	 
    incGet <= '1' when (current_state = pos_Read) else '0' ;
	 
    PnG <= '1' when (current_state = prev_Write) or (current_state = Writing) or (current_state = pos_Write) else '0' ;
	 
    DAC <= '1' when (current_state = ack_producer) else '0' ;
	 
    Wreg <= '1' when (current_state = Reading) else '0';
	 

end Behavioral;