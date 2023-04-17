LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity UART is 

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
 
end UART; 

architecture behaviour of UART is 

	component transmitter is
		generic(
			w : integer := 8);
	
		port(
			clk : in std_logic;
			rst : in std_logic;
			tx_data  : in std_logic_vector(w-1 downto 0);
			tx_ena   : in std_logic; 
			rx_busy  : in std_logic;
			tx_bit   : out std_logic); 
	end component;
	
	component receiver is 
		generic(
			w : integer := 8;
			parity_even : std_logic := '0'); 
	
		port(
			clk : in std_logic;
			rst : in std_logic;
			rx  : in std_logic; 
			rx_busy  : out std_logic;
			rx_error : out std_logic; 
			rx_data  : out std_logic_vector(w-1 downto 0)); 
	end component; 
	
	begin
	
	tx_unit : transmitter port map ( 
					clk => clk, rst => rst, tx_data => tx_data, tx_ena => tx_ena, rx_busy => rx_busy_tx,
					tx_bit => tx_bit);
	rx_unit : receiver port map (
					clk => clk, rst => rst, rx => rx, rx_busy => rx_busy, rx_error => rx_error, rx_data => rx_data); 
end behaviour; 