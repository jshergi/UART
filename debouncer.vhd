LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

----------------------------------------------------------------------
--
--  This is the debouncer for the UART Project.
--
-----------------------------------------------------------------------

ENTITY debouncer IS
	PORT(input_key : IN STD_LOGIC; -- the input key to be debounced
		debounced_key : OUT STD_LOGIC;  -- the output debounced key
		reset : IN STD_LOGIC;
		clk : IN STD_LOGIC
	);
END debouncer;

ARCHITECTURE behavioural OF debouncer IS
	SIGNAL sig_debouced_key : std_logic;
	
	-- Given 50MHz clock, count 0.01*50,00,000 = 500,000 clock clycles to reach 10 ms. Hence, use 19-bit counter.
	CONSTANT counter_size : integer := 19;
	SIGNAL counter_output : UNSIGNED(19 DOWNTO 0) := "00000000000000000000";
	
	
BEGIN
	
	PROCESS(clk, reset, sig_debouced_key, input_key)
	BEGIN
		IF reset = '0' THEN
			counter_output <= "00000000000000000000";
			sig_debouced_key <= input_key; --reset internal signal upon reset
		
		ELSE
			IF rising_edge(clk) THEN
				IF (std_logic(counter_output(counter_size)) = '0') THEN
					counter_output <= counter_output + "1"; --increment for the 19-bit counter duration
					
				ELSIF sig_debouced_key /= input_key THEN --update internal signal if different from input_key and reset counter
					sig_debouced_key <= input_key;
					counter_output <= "00000000000000000000";
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	-- updated debounced_key with internal signal
	debounced_key <= sig_debouced_key;
END;