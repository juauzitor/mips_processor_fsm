library ieee;
use ieee.std_logic_1164.all;

entity mips_processor is 
	port (
		reset: in std_logic;
		sys_clk: in std_logic;
		seg: out std_logic_vector(6 downto 0)
	);
end mips_processor;

architecture Structure of mips_processor is
	component clock_divider is
		port (
			sys_clk: in  std_logic;  -- 50 MHz (Clock do sistema)
			reset: in  std_logic;  -- Reset assíncrono (ativo alto)
			slow_clk: out std_logic   -- Saída do clock de 1 Hz
		 );
	end component;

	component counter is
		port(
			reset: in std_logic;
			clk: in std_logic;
			count: out std_logic_vector(7 downto 0)
		);
	end component;

	component display_7_segment is
		port(
			char: in std_logic_vector(7 downto 0);
			seg: out std_logic_vector(6 downto 0)
		);
	end component;

	signal slow_clk: std_logic;
	signal number: std_logic_vector(7 downto 0);
begin
	
	clock_div: clock_divider
		port map (
			sys_clk => sys_clk,
			reset => reset,
			slow_clk => slow_clk
		);

	count: counter
		port map(
			clk => slow_clk,
			reset => reset,
			count => number
		);

	display: display_7_segment
		port map (
			char => number,
			seg => seg
		);
end Structure;