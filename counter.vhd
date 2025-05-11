library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 
	port (
		reset: in std_logic;
		clk: in std_logic;
		count: out std_logic_vector(7 downto 0)
	);
end counter;

architecture Behavioral of counter is
	signal counter: unsigned(7 downto 0) := (others => '0');
begin
	process(clk, reset)
    begin
        if reset = '0' then
            counter <= (others => '0'); -- Reset assíncrono
        elsif rising_edge(clk) then
            if counter = "11111111" then
                counter <= (others => '0'); -- Volta para 0 ao atingir 255
            else
                counter <= counter + 1; -- Incrementa o contador
            end if;
        end if;
    end process;

    count <= std_logic_vector(counter);
end Behavioral;