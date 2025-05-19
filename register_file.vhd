library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity register_file is
    Port (
        clk      : in  STD_LOGIC;                     -- Clock
        reset    : in  STD_LOGIC;                     -- Reset assíncrono
        RegWrite : in  STD_LOGIC;                     -- Habilita escrita
        RegDst   : in  STD_LOGIC;                     -- Seleciona destino: rd (R-type) ou rb (I-type)
        ra       : in  STD_LOGIC_VECTOR(2 downto 0);  -- Endereço de leitura A
        rb       : in  STD_LOGIC_VECTOR(2 downto 0);  -- Endereço de leitura B
        rd       : in  STD_LOGIC_VECTOR(2 downto 0);  -- Endereço de destino (R-type)
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0);  -- Dado a ser escrito
        data_a   : out STD_LOGIC_VECTOR(7 downto 0);  -- Saída de dados A
        data_b   : out STD_LOGIC_VECTOR(7 downto 0)    -- Saída de dados B
    );
end register_file;

architecture Behavioral of register_file is
    -- Tipo para o array de registradores
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(7 downto 0);
    signal registers : reg_array := (others => (others => '0')); -- Inicializa todos como zero
begin
    -- Leitura dos registradores (combinacional)
    data_a <= registers(conv_integer(ra)) when ra /= "000" else x"00";
    data_b <= registers(conv_integer(rb)) when rb /= "000" else x"00";

    -- Escrita nos registradores (sincronizada)
    process(clk, reset)
    begin
        if reset = '1' then
            registers <= (others => (others => '0')); -- Reseta todos os registradores
        elsif rising_edge(clk) then
            if RegWrite = '1' then
                -- Seleciona o destino com base em RegDst
                if RegDst = '1' then -- R-type: escreve em rd
                    if rd /= "000" then -- Ignora r0
                        registers(conv_integer(rd)) <= data_in;
                    end if;
                else -- I-type: escreve em rb
                    if rb /= "000" then -- Ignora r0
                        registers(conv_integer(rb)) <= data_in;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
