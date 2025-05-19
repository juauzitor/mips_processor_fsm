library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL; -- Para sign extension

entity decoder is
    Port (
        instr     : in  STD_LOGIC_VECTOR(15 downto 0); -- Instrução de 16 bits
        op        : out STD_LOGIC_VECTOR(2 downto 0);  -- Opcode (3 bits)
        fn        : out STD_LOGIC_VECTOR(1 downto 0);  -- Função (2 bits para R-type)
        imm       : out STD_LOGIC_VECTOR(7 downto 0);  -- Valor imediato (7 bits + 1 bit de sinal)
        ra        : out STD_LOGIC_VECTOR(2 downto 0);  -- Registrador de origem A (3 bits)
        rb        : out STD_LOGIC_VECTOR(2 downto 0);  -- Registrador de origem B (3 bits)
        rd        : out STD_LOGIC_VECTOR(2 downto 0);  -- Registrador de destino (3 bits)
        is_r_type : out STD_LOGIC;                     -- Sinaliza se é R-type
        is_i_type : out STD_LOGIC;                     -- Sinaliza se é I-type
        is_j_type : out STD_LOGIC                      -- Sinaliza se é J-type
    );
end decoder;

architecture Behavioral of decoder is
begin
    -- Extrai campos da instrução
    op <= instr(15 downto 13); -- Bits 15-13: Opcode
    ra <= instr(5 downto 3);   -- Bits 5-3: Registrador A
    rb <= instr(2 downto 0);   -- Bits 2-0: Registrador B

    -- Identifica o tipo de instrução
    process(op)
    begin
        case op is
            when "000" => -- R-type
                is_r_type <= '1';
                is_i_type <= '0';
                is_j_type <= '0';
                fn <= instr(12 downto 11); -- Bits 12-11: Função (add, sub, etc.)
                rd <= instr(8 downto 6);   -- Bits 8-6: Registrador destino
                imm <= (others => '0');    -- Não usado em R-type
            when "001" | "010" | "011" | "100" => -- I-type
                is_r_type <= '0';
                is_i_type <= '1';
                is_j_type <= '0';
                fn <= (others => '0');     -- Não usado em I-type
                rd <= rb;                   -- Registrador destino = rb (para lw/addi)
                imm <= instr(12 downto 6); -- Bits 12-6: Valor imediato (7 bits)
                -- Sign extension (estende 7 bits para 8 bits)
                if instr(12) = '1' then
                    imm(7) <= '1';
                else
                    imm(7) <= '0';
                end if;
            when "101" => -- J-type
                is_r_type <= '0';
                is_i_type <= '0';
                is_j_type <= '1';
                fn <= (others => '0');     -- Não usado em J-type
                rd <= (others => '0');     -- Não usado em J-type
                imm <= instr(7 downto 0);  -- Bits 7-0: Endereço imediato
            when others =>
                is_r_type <= '0';
                is_i_type <= '0';
                is_j_type <= '0';
                fn <= (others => '0');
                rd <= (others => '0');
                imm <= (others => '0');
        end case;
    end process;
end Behavioral;
