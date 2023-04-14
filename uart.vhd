LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity uart is
	generic(w : integer := 8);
	
	port(
		clk : in std_logic;
		rst : in std_logic;
		uart_data_in: in std_logic_vector(w-1 downto 0);
		uart_data_out : out std_logic_vector(w-1 downto 0));
end uart;

architecture behaviour of uart is
	-- component intantiation
	component transmitter is
		generic(
			w : integer := 8);
		
		port(
			clk : in std_logic;
			rst : in std_logic;
			tx_data  : in std_logic_vector(w-1 downto 0); 
			rx_busy  : in std_logic;
			tx_bit  : out std_logic); 
	end component;
	
	component receiver is 
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
	end component;

	-- signals declaration
	signal rx_busy_u : std_logic; 
	signal rx_error_u : std_logic; -- not need, just for testing
	signal tx_bit_u : std_logic;
	

begin
	
	transmitter_u : transmitter port map (
			clk => clk, rst => rst, rx_busy => rx_busy_u, tx_data => uart_data_in, tx_bit => tx_bit_u);
	
	receiver_u : receiver port map (
			clk => clk, rst => rst, rx => tx_bit_u, rx_busy => rx_busy_u, rx_error => rx_error_u, rx_data => uart_data_out);

end behaviour;