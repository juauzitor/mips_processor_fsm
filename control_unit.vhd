library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        op        : in  STD_LOGIC_VECTOR(2 downto 0);  -- Opcode
        fn        : in  STD_LOGIC_VECTOR(1 downto 0);  -- Função (R-type)
        -- Sinais de controle
        MemToReg  : out STD_LOGIC;                     -- Seletor de origem do registrador
        RegDst    : out STD_LOGIC;                     -- Seletor de destino do registrador
        MemWrite  : out STD_LOGIC;                     -- Escrita na memória de dados
        MemRead   : out STD_LOGIC;                     -- Leitura da memória de dados
        ALUSrc    : out STD_LOGIC;                     -- Seletor da entrada da ALU
        RegWrite  : out STD_LOGIC;                     -- Habilita escrita no registrador
        Br        : out STD_LOGIC;                     -- Controle de branch
        NIA       : out STD_LOGIC;                     -- Controle de jump
        ALUfn     : out STD_LOGIC_VECTOR(2 downto 0)   -- Operação da ALU
    );
end control_unit;

architecture Behavioral of control_unit is
begin
    process(op, fn)
    begin
        -- Valores padrão
        MemToReg <= '0';
        RegDst   <= '0';
        MemWrite <= '0';
        MemRead  <= '0';
        ALUSrc   <= '0';
        RegWrite <= '0';
        Br       <= '0';
        NIA      <= '0';
        ALUfn    <= "000";

        case op is
            when "000" => -- R-type
                RegWrite <= '1';
                MemToReg <= '1';
                RegDst   <= '1'; -- rd é o destino
                ALUSrc   <= '0'; -- Entrada da ALU vem de registradores
                case fn is
                    when "00" => ALUfn <= "000"; -- add
                    when "01" => ALUfn <= "001"; -- sub
                    when "10" => ALUfn <= "010"; -- and
                    when "11" => ALUfn <= "011"; -- or
                    when others => null;
                end case;

            when "001" => -- addi
                RegWrite <= '1';
                MemToReg <= '1';
                RegDst   <= '0'; -- rb é o destino
                ALUSrc   <= '1'; -- Entrada da ALU vem do imediato
                ALUfn    <= "100"; -- add (cálculo de endereço)

            when "010" => -- lw
                RegWrite <= '1';
                MemToReg <= '0'; -- Dado vem da memória
                RegDst   <= '0'; -- rb é o destino
                ALUSrc   <= '1'; -- Entrada da ALU vem do imediato
                ALUfn    <= "101"; -- add (cálculo de endereço)
                MemRead  <= '1';

            when "011" => -- sw
                ALUSrc   <= '1'; -- Entrada da ALU vem do imediato
                ALUfn    <= "110"; -- add (cálculo de endereço)
                MemWrite <= '1';

            when "100" => -- beq
                ALUSrc   <= '0'; -- Entrada da ALU vem de registradores
                ALUfn    <= "111"; -- comparação
                Br       <= '1';

            when "101" => -- j
                NIA      <= '1';

            when others =>
                null;
        end case;
    end process;
end Behavioral;
