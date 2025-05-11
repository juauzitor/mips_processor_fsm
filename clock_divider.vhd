library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    port (
        sys_clk : in  std_logic;  -- 50 MHz (Clock do sistema)
        reset     : in  std_logic;  -- Reset assíncrono (ativo alto)
        slow_clk: out std_logic   -- Saída do clock de 1 Hz
	 );
end entity;

architecture Behavioral of clock_divider is
    constant COUNT: integer := 25000000;  -- Contagem para 1 Hz (50 MHz / 2)
    signal counter: integer range 0 to COUNT := 0;
    signal clk_int: std_logic := '0';
begin
    process(sys_clk, reset)
    begin
        if reset = '0' then
            counter <= 0;
            clk_int <= '0';
        elsif rising_edge(sys_clk) then
            if counter = COUNT then
                clk_int <= not clk_int;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    slow_clk <= clk_int;
	 
end architecture;