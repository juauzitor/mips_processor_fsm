library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity data_memory is
    Port (
        clk        : in  STD_LOGIC;                     -- Clock
        MemRead    : in  STD_LOGIC;                     -- Leitura habilitada
        MemWrite   : in  STD_LOGIC;                     -- Escrita habilitada
        address    : in  STD_LOGIC_VECTOR(7 downto 0);  -- Endereço de 8 bits
        data_in    : in  STD_LOGIC_VECTOR(7 downto 0);  -- Dado a ser escrito
        data_out   : out STD_LOGIC_VECTOR(7 downto 0)   -- Dado lido
    );
end data_memory;

architecture Behavioral of data_memory is
    -- Tipo para a memória de dados
    type mem_array is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
    signal memory : mem_array := (others => (others => '0')); -- Inicializa com zeros
begin
    -- Leitura assíncrona
    data_out <= memory(conv_integer(address)) when MemRead = '1' else (others => 'Z');

    -- Escrita síncrona
    process(clk)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                memory(conv_integer(address)) <= data_in;
            end if;
        end if;
    end process;
end Behavioral;
