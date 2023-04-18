library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

-----------------------------------------------------------------
--
--  This is the TestBench corresponding to the BaudRateGenerator.
-- 
-----------------------------------------------------------------

entity tb_baud_rate is
end tb_baud_rate; 

architecture test of tb_baud_rate is

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

constant period: time := 10 ns; 

signal clk : std_logic := '1'; 
signal rst : std_logic; 
signal baud_pulse : std_logic; 
signal sampling_pulse : std_logic; 

begin
DUT: baud_rate_generator 

PORT MAP (clk => clk, rst => rst, baud_pulse => baud_pulse, sampling_pulse => sampling_pulse); 

	clk <= not clk after period; 

	process is 
		begin
		rst <= '1'; 
		wait; 
		
	end process; 
end test; 
	