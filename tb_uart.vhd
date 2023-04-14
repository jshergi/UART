library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity tb_uart is
end tb_uart;

architecture test of tb_uart is
	component uart is
		generic(w : integer := 8);
		
		port(
			clk : in std_logic;
			rst : in std_logic;
			uart_data_in: in std_logic_vector(7 downto 0);
			uart_data_out : out std_logic_vector(7 downto 0));
	end component;
	
	constant period: time := 10 ns;

	signal clk : std_logic := '1'; 
	signal rst : std_logic; 
	signal uart_data_in: std_logic_vector(7 downto 0);
	signal uart_data_out : std_logic_vector(7 downto 0);
	
begin
	
	DUT : uart port map (clk => clk, rst => rst, uart_data_in => uart_data_in,  uart_data_out => uart_data_out);
	
	clk <= not clk after period;
	
	process is
	begin
		-- Test case #1: Start tranmission without reset
		rst <= '1';
		uart_data_in <= "00100100";
		wait for 1040000 ns;
		
		-- Test case #2: Reset - transmission stops
		rst <= '0';
		wait for 104000 ns;
		
		rst <= '1';
		wait for 1040000 ns;
		
		-- Test case #3: Transmission with even parity
		uart_data_in <= "00111100";
		wait for 1040000 ns;
		
		uart_data_in <= "11000011";
		wait for 1040000 ns;
		
		-- Test case #4: Transmission with odd parity
		uart_data_in <= "01011000";
		wait for 1040000 ns;
		
		-- Test case #5: Transmission with even parity (extra)
		uart_data_in <= "10100101";
		wait for 1560000 ns; -- to about overlap of data received the tranmitted
		
		-- Test case #6: Base case - transmit 0
		uart_data_in <= "00000000";
		wait for 1560000 ns;
		
		-- Test case #7: Base case - transmit 1
		uart_data_in <= "00000001";
		wait for 1040000 ns;
		
		-- Test case #8: Base case - transmit 255
		uart_data_in <= "11111111";
		wait for 1040000 ns;
		
		wait;
	end process;

end test;