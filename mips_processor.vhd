library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mips_processor is
    port (
        reset   : in std_logic;
        sys_clk : in std_logic
    );
end mips_processor;

architecture Structure of mips_processor is
    -- Componentes necessários
    component clock_divider is
        port (
            sys_clk  : in std_logic;
            reset    : in std_logic;
            slow_clk : out std_logic
        );
    end component;

    component program_counter is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            br       : in std_logic;
            nia      : in std_logic;
            imm_in   : in std_logic_vector(7 downto 0);
            pc_out   : out std_logic_vector(7 downto 0)
        );
    end component;

    component instruction_memory is
        port (
            address : in std_logic_vector(7 downto 0);
            data    : out std_logic_vector(15 downto 0)
        );
    end component;

    component decoder is
        port (
            instr     : in std_logic_vector(15 downto 0);
            op        : out std_logic_vector(2 downto 0);
            fn        : out std_logic_vector(1 downto 0);
            imm       : out std_logic_vector(7 downto 0);
            ra        : out std_logic_vector(2 downto 0);
            rb        : out std_logic_vector(2 downto 0);
            rd        : out std_logic_vector(2 downto 0);
            is_r_type : out std_logic;
            is_i_type : out std_logic;
            is_j_type : out std_logic
        );
    end component;

    component control_unit is
        port (
            op       : in std_logic_vector(2 downto 0);
            fn       : in std_logic_vector(1 downto 0);
            MemToReg : out std_logic;
            RegDst   : out std_logic;
            MemWrite : out std_logic;
            MemRead  : out std_logic;
            ALUSrc   : out std_logic;
            RegWrite : out std_logic;
            Br       : out std_logic;
            NIA      : out std_logic;
            ALUfn    : out std_logic_vector(2 downto 0)
        );
    end component;

    component register_file is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            RegWrite : in std_logic;
            RegDst   : in std_logic;
            ra       : in std_logic_vector(2 downto 0);
            rb       : in std_logic_vector(2 downto 0);
            rd       : in std_logic_vector(2 downto 0);
            data_in  : in std_logic_vector(7 downto 0);
            data_a   : out std_logic_vector(7 downto 0);
            data_b   : out std_logic_vector(7 downto 0)
        );
    end component;

    component alu_source_mux is
        port (
            reg_b   : in std_logic_vector(7 downto 0);
            imm     : in std_logic_vector(7 downto 0);
            alusrc  : in std_logic;
            alu_b   : out std_logic_vector(7 downto 0)
        );
    end component;

    component alu is
        port (
            a      : in std_logic_vector(7 downto 0);
            b      : in std_logic_vector(7 downto 0);
            alufn  : in std_logic_vector(2 downto 0);
            result : out std_logic_vector(7 downto 0);
            zero   : out std_logic
        );
    end component;

    component data_memory is
        port (
            clk      : in std_logic;
            MemRead  : in std_logic;
            MemWrite : in std_logic;
            address  : in std_logic_vector(7 downto 0);
            data_in  : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component mem_to_reg_mux is
        port (
            alu_result : in std_logic_vector(7 downto 0);
            mem_data   : in std_logic_vector(7 downto 0);
            MemToReg   : in std_logic;
            reg_input  : out std_logic_vector(7 downto 0)
        );
    end component;

    component reg_dst_mux is
        port (
            rd      : in std_logic_vector(2 downto 0);
            rb      : in std_logic_vector(2 downto 0);
            RegDst  : in std_logic;
            reg_dst : out std_logic_vector(2 downto 0)
        );
    end component;

    -- Sinais intermediários
    signal slow_clk      : std_logic;
    signal pc_out        : std_logic_vector(7 downto 0);
    signal instruction   : std_logic_vector(15 downto 0);
    signal op, fn        : std_logic_vector(2 downto 0);
    signal imm           : std_logic_vector(7 downto 0);
    signal ra, rb, rd    : std_logic_vector(2 downto 0);
    signal is_r_type, is_i_type, is_j_type : std_logic;
    signal MemToReg, RegDst, MemWrite, MemRead, ALUSrc, RegWrite, Br, NIA : std_logic;
    signal ALUfn         : std_logic_vector(2 downto 0);
    signal data_a, data_b, alu_b : std_logic_vector(7 downto 0);
    signal alu_result    : std_logic_vector(7 downto 0);
    signal zero          : std_logic;
    signal mem_data_out  : std_logic_vector(7 downto 0);
    signal reg_input     : std_logic_vector(7 downto 0);
    signal reg_dst       : std_logic_vector(2 downto 0);

begin
    -- Instanciação do divisor de clock
    clock_div: clock_divider
        port map (
            sys_clk  => sys_clk,
            reset    => reset,
            slow_clk => slow_clk
        );

    -- Instanciação do Program Counter
    pc_inst: program_counter
        port map (
            clk      => slow_clk,
            reset    => reset,
            br       => Br,
            nia      => NIA,
            imm_in   => imm,
            pc_out   => pc_out
        );

    -- Instanciação da Memória de Instruções
    imem_inst: instruction_memory
        port map (
            address => pc_out,
            data    => instruction
        );

    -- Instanciação do Decodificador
    decoder_inst: decoder
        port map (
            instr     => instruction,
            op        => op,
            fn        => fn,
            imm       => imm,
            ra        => ra,
            rb        => rb,
            rd        => rd,
            is_r_type => is_r_type,
            is_i_type => is_i_type,
            is_j_type => is_j_type
        );

    -- Instanciação da Unidade de Controle
    cu_inst: control_unit
        port map (
            op       => op,
            fn       => fn,
            MemToReg => MemToReg,
            RegDst   => RegDst,
            MemWrite => MemWrite,
            MemRead  => MemRead,
            ALUSrc   => ALUSrc,
            RegWrite => RegWrite,
            Br       => Br,
            NIA      => NIA,
            ALUfn    => ALUfn
        );

    -- Instanciação do Banco de Registradores
    regfile_inst: register_file
        port map (
            clk      => slow_clk,
            reset    => reset,
            RegWrite => RegWrite,
            RegDst   => RegDst,
            ra       => ra,
            rb       => rb,
            rd       => rd,
            data_in  => reg_input,
            data_a   => data_a,
            data_b   => data_b
        );

    -- Instanciação do Multiplexador da Fonte da ALU
    alusrc_mux: alu_source_mux
        port map (
            reg_b   => data_b,
            imm     => imm,
            alusrc  => ALUSrc,
            alu_b   => alu_b
        );

    -- Instanciação da ALU
    alu_inst: alu
        port map (
            a      => data_a,
            b      => alu_b,
            alufn  => ALUfn,
            result => alu_result,
            zero   => zero
        );

    -- Instanciação da Memória de Dados
    dmem_inst: data_memory
        port map (
            clk      => slow_clk,
            MemRead  => MemRead,
            MemWrite => MemWrite,
            address  => alu_result,
            data_in  => data_b,
            data_out => mem_data_out
        );

    -- Instanciação do Multiplexador MemToReg
    memtoreg_mux: mem_to_reg_mux
        port map (
            alu_result => alu_result,
            mem_data   => mem_data_out,
            MemToReg   => MemToReg,
            reg_input  => reg_input
        );

    -- Instanciação do Multiplexador RegDst
    regdst_mux: reg_dst_mux
        port map (
            rd      => rd,
            rb      => rb,
            RegDst  => RegDst,
            reg_dst => reg_dst
        );

end Structure;
