LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity UART_test is 

	generic(
		w : integer := 8); 
	
	port(
		clk : in std_logic;
		rst : in std_logic;
		uart1_data_in  : in std_logic_vector(w-1 downto 0);
		uart2_data_in  : in std_logic_vector(w-1 downto 0);
		tx_ena1        : in std_logic; 
		tx_ena2        : in std_logic; 
		uart1_data_out : out std_logic_vector(w-1 downto 0); 
		uart2_data_out : out std_logic_vector(w-1 downto 0)); 
end UART_test; 

architecture behaviour of UART_test is 

	component UART is
		generic(
			w : integer := 8;
			parity_even : std_logic := '0'); 
	
		port(
			clk : in std_logic; 
			rst : in std_logic; 
			rx  : in std_logic; 
			tx_data  : in std_logic_vector(w-1 downto 0);
			tx_ena   : in std_logic;
			rx_busy_tx : in std_logic; 
			rx_busy  : out std_logic; 
			rx_error : out std_logic; 
			rx_data  : out std_logic_vector(w-1 downto 0);
			tx_bit   : out std_logic); 
	end component;
	
	signal rx_error1, rx_error2 : std_logic; 
	signal rx_busy1, rx_busy2   : std_logic;  
	signal tx_bit1, tx_bit2     : std_logic; 
	
	begin
	

	
	UART1 : UART port map (clk => clk, rst => rst, rx_busy_tx => rx_busy2, tx_data => uart1_data_in, 
								  tx_bit => tx_bit1, tx_ena => tx_ena1, rx_busy => rx_busy1, rx_error => rx_error1,
								  rx_data => uart1_data_out, rx => tx_bit2);
	UART2 : UART port map (clk => clk, rst => rst, rx_busy_tx => rx_busy1, tx_data => uart2_data_in,
								  tx_bit => tx_bit2, tx_ena => tx_ena2, rx_busy => rx_busy2, rx_error => rx_error2,
								  rx_data => uart2_data_out, rx => tx_bit1);
end behaviour; 
								  
	