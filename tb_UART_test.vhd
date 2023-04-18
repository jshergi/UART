library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

----------------------------------------------------------
--
--  This is the TestBench corresponding to UART_test.
-- 
----------------------------------------------------------

entity tb_UART_test is
end tb_UART_test;

architecture test of tb_UART_test is
	component UART_test is
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
	end component;

	constant period: time := 10 ns;

	signal clk : std_logic := '1';
	signal rst : std_logic; 
	signal uart1_data_in, uart2_data_in: std_logic_vector(7 downto 0); 
	signal uart1_data_out, uart2_data_out : std_logic_vector(7 downto 0); 
	signal tx_ena1, tx_ena2 : std_logic; 
	
	begin
	
		DUT : UART_test port map (clk => clk, rst => rst, uart1_data_in => uart1_data_in,  uart1_data_out => uart1_data_out, tx_ena1 => tx_ena1,
										  uart2_data_in => uart2_data_in,  uart2_data_out => uart2_data_out, tx_ena2 => tx_ena2);

		clk <= not clk after period;

	process is
	begin
		-- Test case #1: Start tranmission without reset
		rst <= '1';
		uart1_data_in <= "00100100";
		uart2_data_in <= "01001001"; 
		tx_ena1 <= '0';
		tx_ena2 <= '0'; 
		wait for 1560000 ns;

		-- Test case #2: Reset - transmission stops
		rst <= '0';
		tx_ena1 <= '1'; 
		tx_ena2 <= '1';
		wait for 104000 ns;

		rst <= '1';
		wait for 1040000 ns;

		-- Test case #3: Transmission with even parity
		uart1_data_in <= "00111100";
		uart2_data_in <= "11101101"; 
		tx_ena1 <= '0';
		tx_ena2 <= '0';
		wait for 1040000 ns;

		uart1_data_in <= "11000011";
		uart2_data_in <= "01100110"; 
		wait for 1040000 ns;

		-- Test case #4: Transmission with odd parity
		uart1_data_in <= "01011000";
		uart2_data_in <= "01100111";
		wait for 1040000 ns;

		-- Test case #5: Transmission with even parity (extra)
		uart1_data_in <= "10100101";
		uart2_data_in <= "01010101"; 
		wait for 1560000 ns; -- to about overlap of data received the tranmitted

		-- Test case #6: Base case - transmit 0
		uart1_data_in <= "00000000";
		uart2_data_in <= "00000000"; 
		wait for 1560000 ns;

		-- Test case #7: Base case - transmit 1
		uart1_data_in <= "00000001";
		uart2_data_in <= "00000001"; 
		wait for 1040000 ns;

		-- Test case #8: Base case - transmit 255
		uart1_data_in <= "11111111";
		uart2_data_in <= "11111111"; 
		wait for 1040000 ns;
		
		-- Test case #9: Base case - transmit 2, only uart2 transmission should be successful
		uart1_data_in <= "00000010";
		uart2_data_in <= "00000010"; 
		tx_ena1 <= '1';
		tx_ena2 <= '0';
		wait for 2080000 ns;
		
		-- Test case #10: Base case - transmit 64, only no transmission should be successful
		uart1_data_in <= "01000000";
		uart2_data_in <= "01000000"; 
		tx_ena1 <= '1';
		tx_ena2 <= '1';
		wait for 2080000 ns;
		
		-- Test case #11: Base case - transmit 64
		uart1_data_in <= "01000000";
		uart2_data_in <= "01000000"; 
		tx_ena1 <= '0';
		tx_ena2 <= '0';
		
		
		wait for 1040000 ns;

		wait;
	end process;

end test;