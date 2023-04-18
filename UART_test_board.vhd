LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-----------------------------------------------------------------------
--
--  This is the top-level of the UART protocol to show the transmission
--  and reception of data between 2 UART components on the board.
-- 
-----------------------------------------------------------------------

entity UART_test_board is 
	port(CLOCK_50 : in std_logic;
		SW  : in std_logic_vector(15 downto 0);
		KEY : in std_logic_vector(3 downto 0); -- KEY0=Reset; KEY3=TX_EN1; KEY2=TX_EN2
		LEDR : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  -- red LEDs
		LEDG : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  -- green LEDs
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));   -- digit 0
end UART_test_board; 

architecture behaviour of UART_test_board is 

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
			rx_data  : out std_logic_vector(7 downto 0);
			tx_bit   : out std_logic); 
	end component;
	
	component digit7seg is
		port(
          digit : in  std_logic_vector(3 DOWNTO 0);  -- number 0 to 0xF
          seg7 : out std_logic_vector(6 DOWNTO 0)  -- one per segment
		);
	end component;
	
	component debouncer is
		port(input_key : in STD_LOGIC;
			debounced_key : out STD_LOGIC;
			reset: in STD_LOGIC;
			clk : in STD_LOGIC
		);
	end component;
	
	signal rx_error1, rx_error2 : std_logic; 
	signal rx_busy1, rx_busy2   : std_logic;  
	signal tx_bit1, tx_bit2     : std_logic; 
	signal uart1_data_out, uart2_data_out : std_logic_vector(7 downto 0);
	
	signal debouced_tx_ena1 : std_logic;
	signal debouced_tx_ena2 : std_logic;
	
	begin
	
	-- Debounce the enable keys used by the transmitter
	Obj_debouced_tx_ena1: debouncer
						PORT MAP(input_key => KEY(2),
									debounced_key => debouced_tx_ena1,
									reset => KEY(0),
									clk => CLOCK_50);
									
	Obj_debouced_tx_ena2: debouncer
						PORT MAP(input_key => KEY(3),
									debounced_key => debouced_tx_ena2,
									reset => KEY(0),
									clk => CLOCK_50);
		
   -- Display the received data in the red LEDs
	LEDR(15 downto 8) <= uart2_data_out;
	LEDR(7 downto 0) <= uart1_data_out;
	
	-- Display any errors in the green LEDs
	LEDG(0) <= rx_error1;
	LEDG(1) <= rx_error2;

	-- Transmit the data provided by SW between the UART components
	UART1 : UART port map (clk => CLOCK_50, rst => KEY(0), rx_busy_tx => rx_busy2, tx_data => SW(7 downto 0), 
								  tx_bit => tx_bit1, tx_ena => debouced_tx_ena1, rx_busy => rx_busy1, rx_error => rx_error1,
								  rx_data => uart1_data_out, rx => tx_bit2);
	UART2 : UART port map (clk => CLOCK_50, rst => KEY(0), rx_busy_tx => rx_busy1, tx_data => SW(15 downto 8),
								  tx_bit => tx_bit2, tx_ena => debouced_tx_ena2, rx_busy => rx_busy2, rx_error => rx_error2,
								  rx_data => uart2_data_out,rx => tx_bit1);
								  
								  
	-- Dipay the output from UART2 to HEX7&HEX86 and the output from UART1 to HEX5&HEX4	(in hex)
	Obj_digit7seg_HEX7: digit7seg PORT MAP (digit => (uart2_data_out(7 downto 4)), seg7 => HEX7);
	Obj_digit7seg_HEX6: digit7seg PORT MAP (digit => (uart2_data_out(3 downto 0)), seg7 => HEX6);
	Obj_digit7seg_HEX5: digit7seg PORT MAP (digit => (uart1_data_out(7 downto 4)), seg7 => HEX5);
	Obj_digit7seg_HEX4: digit7seg PORT MAP (digit => (uart1_data_out(3 downto 0)), seg7 => HEX4);
	
	-- Turn off the unused HEX display
	HEX3 <= "1111111";
	HEX2 <= "1111111";
	HEX1 <= "1111111";
	HEX0 <= "1111111";
	
end behaviour; 
								  
	