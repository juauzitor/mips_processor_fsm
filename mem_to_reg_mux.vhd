library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mem_to_reg_mux is
    Port (
        alu_result : in  STD_LOGIC_VECTOR(7 downto 0); -- Saída da ALU
        mem_data   : in  STD_LOGIC_VECTOR(7 downto 0); -- Dado da memória de dados
        MemToReg   : in  STD_LOGIC;                    -- Controle: '0' = ALU, '1' = memória
        reg_input  : out STD_LOGIC_VECTOR(7 downto 0)  -- Dado para o registrador
    );
end mem_to_reg_mux;

architecture Behavioral of mem_to_reg_mux is
begin
    -- Multiplexador 2×1
    reg_input <= alu_result when MemToReg = '0' else
                 mem_data;
end Behavioral;
