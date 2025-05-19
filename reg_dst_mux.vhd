library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_dst_mux is
    Port (
        rd         : in  STD_LOGIC_VECTOR(2 downto 0); -- Registrador destino (R-type)
        rb         : in  STD_LOGIC_VECTOR(2 downto 0); -- Registrador destino (I-type)
        RegDst     : in  STD_LOGIC;                     -- Controle: '0' = rb, '1' = rd
        reg_dst    : out STD_LOGIC_VECTOR(2 downto 0)  -- Endereço do registrador de destino
    );
end reg_dst_mux;

architecture Behavioral of reg_dst_mux is
begin
    -- Multiplexador 2×1
    reg_dst <= rd when RegDst = '1' else
                rb;
end Behavioral;
