library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_memory is
    Port (
        address : in  STD_LOGIC_VECTOR(7 downto 0); -- Endereço de 8 bits (PC)
        data    : out STD_LOGIC_VECTOR(15 downto 0)  -- Instrução de 16 bits
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    -- Tipo para a memória de instruções
    type mem_array is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0);

    -- Memória inicializada com zeros (pode ser carregada com instruções durante simulação/síntese)
    signal memory : mem_array := (
        -- Exemplo: Inicialize com instruções específicas se necessário
        others => x"0000" -- Todos os endereços iniciam com instrução nula
    );
begin
    -- Leitura assíncrona da instrução com base no endereço
    data <= memory(conv_integer(address));
end Behavioral;
