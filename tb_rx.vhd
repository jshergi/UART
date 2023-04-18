library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity tb_rx is
end tb_rx; 

architecture test of tb_rx is

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

constant period: time := 10 ns; 

signal clk : std_logic := '1'; 
signal rst, rx : std_logic; 
signal rx_busy, rx_error : std_logic; 
signal rx_data : std_logic_vector (7 downto 0); 

begin
DUT: receiver 

PORT MAP (clk => clk, rst => rst, rx => rx, rx_busy => rx_busy, rx_error => rx_error, rx_data => rx_data); 

	clk <= not clk after period; 

	process is 
		begin
		
		-- Test case #1: Error case - stop bit incorrect (low instead of high). Expected data: "00000111".
		rst <= '1';
		rx <= '0'; -- Start bit
		wait for 104000 ns; 
		
		rx <= '1'; 
		wait for 104000 ns; 
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '1'; -- Parity bit: 1 because of odd number of ones for "00000111"
		wait for 104000 ns;
		
		rx <= '0'; --1 -- Stop bit: incorrect (should be high)
		wait for 104000 ns;
		
		rx <= '0'; --1 
		wait for 104000 ns;
		
		
		-- Test case #2: Error case - parity bit incorrect (low instead of high).  Expected data: "00000111".
		rx <= '0'; --1 -- Start bit
		wait for 104000 ns;
		
		rx <= '1'; --1
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; -- Parity bit: 1 because of odd number of ones for "00000111"
		wait for 104000 ns;
		
		rx <= '1'; -- Stop bit: correct
		wait for 104000 ns;
		
		
		-- Test case #3: Successfully received data (correct odd parity and stop bits). Expected data: "00000111".
		rx <= '0'; --1 -- Start bit
		wait for 104000 ns;
		
		rx <= '1'; --1
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '1'; -- Parity bit: 1 because of odd number of ones for "00000111"
		wait for 104000 ns;
		
		rx <= '1'; -- Stop bit: correct
		wait for 1040000 ns;
		
		-- Test case #4: Successfully received data (correct even parity and stop bits). Expected data: "00110110".
		rx <= '0'; --1 -- Start bit
		wait for 104000 ns;
		
		rx <= '0';
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; -- Parity bit: 0 because of even number of ones for "00110110"
		wait for 104000 ns;
		
		rx <= '1'; -- Stop bit: correct
		wait for 1040000 ns;
		
		-- Test case #5: Asynchronous reset. Expected data: "11011001".
		rst <= '0';
		wait for 208000 ns;
				
		rst <= '1';
		wait for 104000 ns;
		
		rx <= '0'; --1 -- Start bit
		wait for 104000 ns;
		
		rx <= '1';
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '0'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; -- Parity bit: 1 because of odd number of ones for "11011001"
		wait for 104000 ns;
		
		rx <= '1'; -- Stop bit: correct
		wait for 1040000 ns;
		
		
		wait; 
	end process; 
end test; 