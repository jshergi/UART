library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

----------------------------------------------------------
--
--  This is the TestBench corresponding to the transmitter.
-- 
----------------------------------------------------------

entity tb_tx is
end tb_tx; 

architecture test of tb_tx is

	component transmitter is
		generic(
			w : integer := 8);
		
		port(
			clk : in std_logic;
			rst : in std_logic;
			tx_data  : in std_logic_vector(w-1 downto 0); 
			tx_ena  : in std_logic; 
			rx_busy : in std_logic;
			tx_bit  : out std_logic); 
	end component;
	
	constant period: time := 10 ns;

	signal clk : std_logic := '1'; 
	signal rst, rx_busy : std_logic; 
	signal tx_data : std_logic_vector (7 downto 0);
	signal tx_ena, tx_bit : std_logic; 

	begin
		DUT: transmitter

		PORT MAP (clk => clk, rst => rst, tx_ena => tx_ena, rx_busy => rx_busy, tx_data => tx_data, tx_bit => tx_bit); 

		clk <= not clk after period;
		
		process is
			begin
			
				--Test Case #1: Reset unset but receiver buffer not empty (do not transmit)
				rst <= '1';
				rx_busy <= '1';
				tx_ena <= '0'; 
				tx_data <= "00000111";
				wait for 416000 ns;
				
				--Test Case #2: Receiver buffer empty (start transmission). Send data with odd parity.
				rx_busy <= '0'; 
				wait for 1040000 ns;
				
				--Test Case #3: Receiver buffer not empty (remain in idle state until buffer empties)
				rx_busy <= '1'; 
				wait for 416000 ns;
				
				rx_busy <= '0'; 
				wait for 104000 ns;
				
				--Test Case #4: Send data with even parity.
				tx_data <= "10011100";
				wait for 1040000 ns;
				
				--Test Case #5: Asynchronous reset 
				rst <= '0';
				wait for 208000 ns;
				
				rst <= '1';
				wait for 104000 ns;
				
				tx_data <= "01000101";
				wait for 1040000 ns;
				
				--Test Case #6: disabling tx_ena
				tx_ena <= '1'; 
				wait for 416000 ns; 
				
				tx_ena <= '0'; 
				wait for 1040000 ns; 
				
				wait;
		end process;
end test; 