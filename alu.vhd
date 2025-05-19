library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity alu is
    Port (
        a      : in  STD_LOGIC_VECTOR(7 downto 0); -- Entrada A (registrador A)
        b      : in  STD_LOGIC_VECTOR(7 downto 0); -- Entrada B (ALU Source Mux)
        alufn  : in  STD_LOGIC_VECTOR(2 downto 0); -- Controle da operação
        result : out STD_LOGIC_VECTOR(7 downto 0); -- Resultado da ALU
        zero   : out STD_LOGIC                      -- Sinal de zero (para beq)
    );
end alu;

architecture Behavioral of alu is
    signal alu_result: STD_LOGIC_VECTOR(7 downto 0);
begin
    -- Processo principal da ALU
    process(a, b, alufn)
    begin
        case alufn is
            when "000" => -- add (R-type)
                alu_result <= a + b;
            when "001" => -- sub (R-type)
                alu_result <= a - b;
            when "010" => -- and (R-type)
                alu_result <= a and b;
            when "011" => -- or (R-type)
                alu_result <= a or b;
            when "100" => -- add (I-type: cálculo de endereço para lw/sw)
                alu_result <= a + b;
            when "101" => -- add (I-type: cálculo de endereço para lw/sw)
                alu_result <= a + b;
            when "110" => -- add (I-type: cálculo de endereço para lw/sw)
                alu_result <= a + b;
            when "111" => -- comparação (beq)
                alu_result <= a - b;
            when others =>
                alu_result <= (others => '0');
        end case;
    end process;

    -- Atualização do resultado e sinal de zero
    result <= alu_result;
    zero   <= '1' when alu_result = x"00" else '0'; -- Zero flag
end Behavioral;
