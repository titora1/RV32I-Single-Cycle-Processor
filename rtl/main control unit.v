/*
ALU CONTROL functions   

ADD/ADDI/direct ADD ? 0000
SUB/BEQ/BNE         ? 0001
AND/ANDI            ? 0010
OR/ORI              ? 0011
XOR/XORI            ? 0100
SLT/SLTI/BLT/BGE    ? 0101
SLTU/SLTIU/BLTU/BGEU? 0110
SLL/SLLI            ? 0111
SRL/SRLI            ? 1000
SRA/SRAI            ? 1001

SrcASel 00 = rs1
        01 = PC
        10 = 0

ResultSrc 00 = ALU
          01 = Memory
          10 = PC+4

ImmSrc  000 = I
        001 = S
        010 = B
        011 = U
        100 = J

ALUOp  00 = ADD directly
       01 = Branch
       10 = R-type
       11 = I-type ALU
*/
 
module Control_Unit (
    input  [6:0] opcode,

    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,

    output reg       Branch,
    output reg       Jump,
    output reg       JALR,

    output reg [1:0] SrcASel,
    output reg       ALUSrc,

    output reg [1:0] ResultSrc,
    output reg [2:0] ImmSrc,

    output reg [1:0] ALUOp
);

always @(*) begin

    // Default values
    RegWrite = 1'b0;

    MemRead  = 1'b0;
    MemWrite = 1'b0;

    Branch = 1'b0;
    Jump   = 1'b0;
    JALR   = 1'b0;

    SrcASel = 2'b00;
    ALUSrc  = 1'b0;

    ResultSrc = 2'b00;
    ImmSrc    = 3'b000;

    ALUOp = 2'b00;


    case (opcode)

        // R-Type
        // ADD, SUB, AND, OR, XOR,
        // SLT, SLTU, SLL, SRL, SRA
        7'b0110011: begin

            RegWrite = 1'b1;

            SrcASel = 2'b00;     // rs1
            ALUSrc  = 1'b0;      // rs2

            ResultSrc = 2'b00;   // ALU result

            ALUOp = 2'b10;       // R-type decode

        end


        // I-Type ALU
        // ADDI, ANDI, ORI, XORI,
        // SLTI, SLTIU, SLLI, SRLI, SRAI
        7'b0010011: begin

            RegWrite = 1'b1;

            SrcASel = 2'b00;     // rs1
            ALUSrc  = 1'b1;      // immediate

            ResultSrc = 2'b00;   // ALU result

            ImmSrc = 3'b000;     // I-type immediate

            ALUOp = 2'b11;       // I-type ALU decode

        end


        // Load
        // LB, LH, LW, LBU, LHU
        7'b0000011: begin

            RegWrite = 1'b1;

            MemRead = 1'b1;

            SrcASel = 2'b00;     // rs1
            ALUSrc  = 1'b1;      // immediate

            ResultSrc = 2'b01;   // memory data

            ImmSrc = 3'b000;     // I-type immediate

            ALUOp = 2'b00;       // ADD address

        end


        // Store
        // SB, SH, SW
        7'b0100011: begin

            RegWrite = 1'b0;

            MemWrite = 1'b1;

            SrcASel = 2'b00;     // rs1
            ALUSrc  = 1'b1;      // immediate

            ImmSrc = 3'b001;     // S-type immediate

            ALUOp = 2'b00;       // ADD address

        end


        // Branch
        // BEQ, BNE, BLT, BGE, BLTU, BGEU
        7'b1100011: begin

            RegWrite = 1'b0;

            Branch = 1'b1;

            SrcASel = 2'b00;     // rs1
            ALUSrc  = 1'b0;      // rs2

            ImmSrc = 3'b010;     // B-type immediate

            ALUOp = 2'b01;       // branch comparison

        end


        // JAL = Jump And Link
        7'b1101111: begin

            RegWrite = 1'b1;

            Jump = 1'b1;

            SrcASel = 2'b01;     // PC
            ALUSrc  = 1'b1;      // immediate

            ResultSrc = 2'b10;   // PC + 4

            ImmSrc = 3'b100;     // J-type immediate

            ALUOp = 2'b00;       // ADD

        end


        // JALR = Jump And Link Register
        7'b1100111: begin

            RegWrite = 1'b1;

            Jump = 1'b1;
            JALR = 1'b1;

            SrcASel = 2'b00;     // rs1
            ALUSrc  = 1'b1;      // immediate

            ResultSrc = 2'b10;   // PC + 4

            ImmSrc = 3'b000;     // I-type immediate

            ALUOp = 2'b00;       // ADD

        end


        // LUI = Load Upper Immediate
        7'b0110111: begin

            RegWrite = 1'b1;

            SrcASel = 2'b10;     // constant 0
            ALUSrc  = 1'b1;      // immediate

            ResultSrc = 2'b00;   // ALU result

            ImmSrc = 3'b011;     // U-type immediate

            ALUOp = 2'b00;       // 0 + immediate

        end


        // AUIPC = Add Upper Immediate to PC
        7'b0010111: begin

            RegWrite = 1'b1;

            SrcASel = 2'b01;     // PC
            ALUSrc  = 1'b1;      // immediate

            ResultSrc = 2'b00;   // ALU result

            ImmSrc = 3'b011;     // U-type immediate

            ALUOp = 2'b00;       // PC + immediate

        end


        // Unknown / unsupported opcode
        default: begin

            RegWrite = 1'b0;

            MemRead  = 1'b0;
            MemWrite = 1'b0;

            Branch = 1'b0;
            Jump   = 1'b0;
            JALR   = 1'b0;

            SrcASel = 2'b00;
            ALUSrc  = 1'b0;

            ResultSrc = 2'b00;
            ImmSrc    = 3'b000;

            ALUOp = 2'b00;

        end

    endcase

end

endmodule
