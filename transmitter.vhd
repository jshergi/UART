LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity transmitter is
	generic(
		w : integer := 8);
	
	port(
		clk : in std_logic;
		rst : in std_logic;
		tx_data  : in std_logic_vector(w-1 downto 0);
		tx_ena   : in std_logic; 
		rx_busy  : in std_logic;
		tx_busy  : out std_logic;
		tx_bit   : out std_logic); 
end transmitter;

architecture behaviour of transmitter is

	component baud_rate_generator is
		generic(
			clk_frequency : integer := 50000000; 
			baud_rate     : integer := 9600; 
			sampling_rate : integer := 16); 
	
		port(
			clk : in std_logic; 
			rst : in std_logic; 
			baud_pulse : out std_logic; 
			sampling_pulse : out std_logic); 
	end component;
	
	type state_type is (idle, start, data, stop); 
	signal tx_state : state_type;
	
	signal parity_bit : std_logic := '0';
	signal tx_loaded : std_logic_Vector(7 downto 0) := (others => '0');
	
	signal clk_b, rst_b, baud_pulse_b, sampling_pulse_b : std_logic;
	
	
	begin
		baud_r : baud_rate_generator port map ( 
					clk => clk_b, rst => rst_b, sampling_pulse => sampling_pulse_b); 
		clk_b <= clk; 
		rst_b <= rst; 
				
		process (rst, clk, sampling_pulse_b)
			variable n : integer := 0; 
			variable over_s_counter : integer := 0; 
			
			begin
				if (rst = '0') then
					over_s_counter := 0;
					n := 0;
					parity_bit <= '0';
					tx_busy <= '0'; -- adding
					tx_bit <= '0';
					tx_state <= idle;
				
				elsif (rising_edge(clk) and sampling_pulse_b = '1') then
					case tx_state is
						when idle =>
							tx_bit <= '1';
							over_s_counter := 0;
							if (rx_busy = '0' and tx_ena = '1') then -- changing
								tx_state <= start;
								tx_busy <= '1'; -- adding
							else
								tx_state <= idle;
								tx_busy <= '0'; -- adding
							end if;
						
						when start =>
							if (over_s_counter < 15) then
								over_s_counter := over_s_counter + 1;
								tx_state <= start;
							else
								over_s_counter := 0;
								n := 0; 
								tx_bit <= '0';
								tx_loaded <= tx_data;
								tx_state <= data;
							end if;
						
						when data =>
							if (over_s_counter < 15) then
								over_s_counter := over_s_counter + 1;
								tx_state <= data;
							
							elsif (n < 8) then
								tx_bit <= tx_loaded(0); -- send LSB first and MSB last
								tx_loaded <= '0' & tx_loaded(7 downto 1);
								parity_bit <= tx_loaded(0) xor parity_bit; 
								n := n + 1;
								over_s_counter := 0;
								tx_state <= data;
								
							else
								over_s_counter := 0;
								n := 0; 
								tx_bit <= parity_bit;
								tx_state <= stop;
							end if;
							
						when stop =>
							if (over_s_counter < 15) then
								over_s_counter := over_s_counter + 1;
								tx_state <= stop; 
							else
								tx_bit <= '1';
								parity_bit <= '0';
								tx_state <= idle;
								tx_busy <= '0'; -- adding
							end if;
					end case;
				end if;
		end process;
end behaviour;