module riscv_processor (
    input clk,
    input reset,
    output [15:0] debug_out
);

    wire [31:0] PC;
    wire [31:0] instruction;

    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;

    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire Jump;
    wire JALR;

    wire [1:0] SrcASel;
    wire ALUSrc;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [1:0] ALUOp;

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] debug_x26;

    wire [31:0] ImmExt;
    wire [3:0] ALU_Control;

    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] ALU_Result;
    wire Zero;

    wire [31:0] Memory_Read_Data;
    wire BranchTaken;

    wire [31:0] PC_Plus_4;
    wire [31:0] WriteBack_Data;

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    assign PC_Plus_4 = PC + 32'd4;
    assign debug_out = debug_x26[15:0];

    Program_Counter pc_unit (
        .clk(clk),
        .reset(reset),
        .BranchTaken(BranchTaken),
        .Jump(Jump),
        .JALR(JALR),
        .ImmExt(ImmExt),
        .ReadData1(read_data1),
        .PC(PC)
    );

    Instruction_Memory instr_mem (
        .PC(PC),
        .Instr(instruction)
    );

    Control_Unit control_unit (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .JALR(JALR),
        .SrcASel(SrcASel),
        .ALUSrc(ALUSrc),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );

    Register reg_file (
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(WriteBack_Data),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .debug_x26(debug_x26)
    );

    Immediate_Generator imm_gen (
        .Instr(instruction),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    ALU_Control alu_control_unit (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALU_Control(ALU_Control)
    );

    assign ALU_A = (SrcASel == 2'b00) ? read_data1 :
                   (SrcASel == 2'b01) ? PC :
                   (SrcASel == 2'b10) ? 32'b0 :
                                         read_data1;

    assign ALU_B = (ALUSrc == 1'b1) ? ImmExt : read_data2;

    ALU alu_unit (
        .A(ALU_A),
        .B(ALU_B),
        .ALU_Control(ALU_Control),
        .Result(ALU_Result),
        .Zero(Zero)
    );

    Branch_Unit branch_unit (
        .Branch(Branch),
        .funct3(funct3),
        .ReadData1(read_data1),
        .ReadData2(read_data2),
        .BranchTaken(BranchTaken)
    );

    Data_Memory data_mem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .funct3(funct3),
        .Address(ALU_Result),
        .WriteData(read_data2),
        .ReadData(Memory_Read_Data)
    );

    assign WriteBack_Data = (ResultSrc == 2'b00) ? ALU_Result :
                            (ResultSrc == 2'b01) ? Memory_Read_Data :
                            (ResultSrc == 2'b10) ? PC_Plus_4 :
                                                    ALU_Result;

endmodule