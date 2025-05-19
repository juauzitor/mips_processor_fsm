library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        br       : in  STD_LOGIC;  -- Controle de branch
        nia      : in  STD_LOGIC;  -- Controle de jump
        imm_in   : in  STD_LOGIC_VECTOR(7 downto 0);  -- Valor imediato (8 bits)
        pc_out   : out STD_LOGIC_VECTOR(7 downto 0)   -- Saída do PC
    );
end program_counter;

architecture Behavioral of program_counter is
    signal pc_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');  -- Registrador do PC
    signal next_pc: STD_LOGIC_VECTOR(7 downto 0);  -- Próximo valor do PC
    signal pc_plus_1: STD_LOGIC_VECTOR(7 downto 0); -- PC + 1
    signal pc_plus_imm: STD_LOGIC_VECTOR(7 downto 0); -- PC + imediato
begin
    -- Cálculo de PC + 1
    pc_plus_1 <= pc_reg + 1;

    -- Cálculo de PC + imediato (para branch)
    pc_plus_imm <= pc_reg + imm_in;

    -- Lógica de seleção do próximo PC (multiplexador 4×1)
    with br & nia select
        next_pc <=
            imm_in         when "00",  -- Jump incondicional (j)
            pc_plus_1      when "01",  -- Execução sequencial
            pc_plus_imm    when "11",  -- Branch condicional (beq)
            pc_plus_1      when others; -- Caso inválido (10), padrão para PC+1

    -- Atualização do PC no clock
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');  -- Reset para endereço inicial 0
        elsif rising_edge(clk) then
            pc_reg <= next_pc;  -- Atualiza PC com o próximo valor
        end if;
    end process;

    pc_out <= pc_reg;  -- Saída do PC
end Behavioral;
