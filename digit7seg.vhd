LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

-----------------------------------------------------
--
--  This block will contain a decoder to decode a 4-bit number
--  to a 7-bit vector suitable to drive a HEX dispaly
--
--  It is a purely combinational block (think Pattern 1)
--
--------------------------------------------------------

ENTITY digit7seg IS
	PORT(
          digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
          seg7 : OUT std_logic_vector(6 DOWNTO 0)  -- one per segment
	);
END;


ARCHITECTURE behavioral OF digit7seg IS
BEGIN

	PROCESS(digit)
	BEGIN
		CASE digit IS
			WHEN "0000" =>
				seg7 <= "1000000"; --'0'
			WHEN "0001" =>
				seg7 <= "1111001"; --'1'
			WHEN "0010" =>
				seg7 <= "0100100"; --'2'
			WHEN "0011" =>
				seg7 <= "0110000"; --'3'
			WHEN "0100" =>
				seg7 <= "0011001"; --'4'
			WHEN "0101" =>
				seg7 <= "0010010"; --'5'
			WHEN "0110" =>
				seg7 <= "0000010"; --'6'
			WHEN "0111" =>
				seg7 <= "1111000"; --'7'
			WHEN "1000" =>
				seg7 <= "0000000"; --'8'
			WHEN "1001" =>
				seg7 <= "0010000"; --'9'
			WHEN "1010" =>
				seg7 <= "0001000"; --'A'
			WHEN "1011" =>
				seg7 <= "0000011"; --'b'
			WHEN "1100" =>
				seg7 <= "1000110"; --'C'
			WHEN "1101" =>
				seg7 <= "0100001"; --'d'
			WHEN "1110" =>
				seg7 <= "0000110"; --'E'
			WHEN "1111" =>
				seg7 <= "0001110"; --'F'
			WHEN others =>
				seg7 <= "1111111"; --default
		END CASE;
	END PROCESS;
END;