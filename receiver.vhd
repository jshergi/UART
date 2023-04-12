LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity receiver is 

	generic(
		w : integer := 8;
		parity_even : std_logic := '0'; 
		parity : integer := 1); 
	
	port(
		clk : in std_logic;
		rst : in std_logic;
		rx  : in std_logic; 
		rx_busy  : out std_logic;
		rx_error : out std_logic; 
		rx_data  : out std_logic_vector(w-1 downto 0)); 
 
end receiver; 

architecture behaviour of receiver is 

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
	signal rx_state : state_type;
	signal parity_error : std_logic;
	signal rx_loaded : std_logic_Vector(10 downto 0) := (others => '0'); --parity + w
	signal data_parity : std_logic_vector(w downto 0); 
	
	signal clk_b, rst_b, baud_pulse_b, sampling_pulse_b : std_logic; 
	
	begin
		baud_r : baud_rate_generator port map ( 
			clk => clk_b, rst => rst_b, baud_pulse => baud_pulse_b, sampling_pulse => sampling_pulse_b); 
			clk_b <= clk; 
			rst_b <= rst; 
		process (rst, sampling_pulse_b) --clk, 
			variable n : integer := 0; 
			variable over_s_counter : integer := 0; 
		
			begin
				if (rst = '0') then
					over_s_counter := 0;
					n := 0;
					rx_busy <= '0';
					rx_error <= '0';
					rx_data <= (others => '0'); 
					rx_state <= idle; 
				elsif (rising_edge(clk) and sampling_pulse_b = '1') then --rising_edge(sampling_pulse_b)
					case rx_state is 
						when idle =>
							rx_busy <= '0';
							if (rx = '0') then
								over_s_counter := 0; 
								rx_busy <= '1'; 
								rx_state <= start; 
							else
								rx_busy <= '0'; 
								rx_state <= idle; 
							end if;
							
						when start =>
							if (over_s_counter < 7) then
								over_s_counter := over_s_counter + 1;
								rx_state <= start; 
							else
								over_s_counter := 0;
								n := 0; 
								rx_loaded <= rx & rx_loaded(10 downto 1); --parity + w
								rx_state <= data; 
							end if;
							
						when data =>
							if (over_s_counter < 15) then
								over_s_counter := over_s_counter + 1;
								rx_state <= data; 
							elsif (n < 10) then --parity + w
								over_s_counter := 0;
								n := n + 1; 
								rx_loaded <= rx & rx_loaded(10 downto 1); --parity + w
								rx_state <= data;
							else
								--rx_data <= rx_loaded(w downto 1); 
								--rx_error <= rx_loaded(0) or parity_error or not rx; 
								--rx_busy <= '0'; 
								--rx_state <= idle; 
								rx_state <= stop;
							end if;
							
						when stop => 
							if (over_s_counter < 15) then
								over_s_counter := over_s_counter +1; 
								rx_state <= stop; 
							else
								rx_data <= rx_loaded(w downto 1);
								rx_error <= rx_loaded(0) or parity_error or not rx;
								rx_busy <= '0';
								rx_state <= idle; 
							end if; 
								
					end case;
				end if;
		end process; 
		
		data_parity(0) <= parity_even;
		data_parity_logic: FOR i in 0 to w-1 generate
			data_parity(i+1) <= data_parity(i) xor rx_loaded(i + 1); 
		end generate; 
		
		parity_error <= data_parity(w) xor rx_loaded(9); --parity + w - 1
	end behaviour; 
							
								
			
								
			
			
		
			
 
		