library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity tb_rx is
end tb_rx; 

architecture test of tb_rx is

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
		rst <= '1';
		rx <= '0'; 
		wait for 104000 ns; 
		
		--rst <= '1';
		rx <= '1'; 
		wait for 104000 ns; 
		
		--rst <= '1';
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
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '0'; --1
		wait for 104000 ns;
		
		rx <= '0'; --1
		wait for 104000 ns;
		-- next case
		
		rx <= '0'; --1
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
		
		rx <= '1'; 
		wait for 104000 ns;
		
		rx <= '1'; 
		wait for 104000 ns;
		
		wait; 
	end process; 
end test; 