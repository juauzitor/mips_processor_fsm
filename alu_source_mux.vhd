library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_source_mux is
    Port (
        reg_b   : in  STD_LOGIC_VECTOR(7 downto 0); -- Dado do registrador B
        imm     : in  STD_LOGIC_VECTOR(7 downto 0); -- Valor imediato
        alusrc  : in  STD_LOGIC;                    -- Controle: '0' = reg_b, '1' = imm
        alu_b   : out STD_LOGIC_VECTOR(7 downto 0)  -- Saída para ALU
    );
end alu_source_mux;

architecture Behavioral of alu_source_mux is
begin
    -- Multiplexador 2x1
    alu_b <= reg_b when alusrc = '0' else
              imm;
end Behavioral;
