LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity baud_rate_generator is 

	generic(
		clk_frequency : integer := 50000000; 
		baud_rate     : integer := 9600; 
		sampling_rate : integer := 16); 
	
	port(
		clk : in std_logic; 
		rst : in std_logic; 
		baud_pulse : out std_logic; 
		sampling_pulse : out std_logic); 
end baud_rate_generator; 

architecture behaviour of baud_rate_generator is
	signal baud_pulse_sig : std_logic := '0'; 
	signal sampling_pulse_sig : std_logic := '0'; 
	
	begin 
		process (clk, rst)
			variable baud_counter : integer range 0 to clk_frequency/baud_rate - 1;
			variable sampling_counter : integer range 0 to clk_frequency/baud_rate/sampling_rate -1; 
			begin
				if (rst = '0') then 
					baud_pulse_sig <= '0'; 
					sampling_pulse_sig <= '0'; 
					baud_counter := 0; 
					sampling_counter := 0;
				elsif (rising_edge(clk)) then 
					-- generating baud rate
					if (baud_counter < clk_frequency/baud_rate-1) then
						baud_counter := baud_counter + 1;
						baud_pulse_sig <= '0'; 
					else
						baud_counter := 0; 
						baud_pulse_sig <= '1'; 
					end if;
					
					-- gnerating sampling rate
					if (sampling_counter < clk_frequency/baud_rate/sampling_rate-1) then
						sampling_counter := sampling_counter + 1;  
						sampling_pulse_sig <= '0'; 
					else
						sampling_counter := 0;
						sampling_pulse_sig <= '1'; 
					end if;
				end if;
		end process; 
		
		baud_pulse <= baud_pulse_sig; 
		sampling_pulse <= sampling_pulse_sig;
end behaviour; 
	
	
	
	