library ieee;
use ieee.std_logic_1164.all;

entity mips_processor is 
	port (
		reset: in std_logic;
		a, b: in std_logic;
		c: out std_logic
	);
end mips_processor;

architecture Structure of mips_processor is
begin
	c <= a and b;
end Structure;