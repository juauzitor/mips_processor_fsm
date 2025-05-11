library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_7_segment is 
	port (
		char: in std_logic_vector(7 downto 0);
		seg: out std_logic_vector(6 downto 0)
	);
end display_7_segment;

architecture Behavioral of display_7_segment is
	signal char_code: integer;
begin
	char_code <= to_integer(unsigned(char));

	with char_code select
		seg <=  
			"1000000" when 0,
			"1111001" when 1,
			"0100100" when 2,
			"0110000" when 3,
			"0011001" when 4,
			"0010010" when 5,
			"0000010" when 6,
			"1111000" when 7,
			"0000000" when 8,
			"0010000" when 9,
			"0001000" when 10,
			"0000011" when 11,
			"1000110" when 12,
			"0100001" when 13,
			"0000110" when 14,
			"0001110" when 15,
			"1000010" when 16,
			"0001011" when 17,
			"1001111" when 18,
			"1100001" when 19,
			"0001010" when 20,
			"1000111" when 21,
			"0101010" when 22,
			"0101011" when 23,
			"0100011" when 24,
			"0001100" when 25,
			"0011000" when 26,
			"1001110" when 27,
			"0010010" when 28,
			"0000111" when 29,
			"1100011" when 30,
			"1000001" when 31,
			"0010101" when 32,
			"0001001" when 33,
			"0010001" when 34,
			"0111000" when 35,
			"1111111" when others;
end Behavioral;