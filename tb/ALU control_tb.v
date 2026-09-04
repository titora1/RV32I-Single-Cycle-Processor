/*ADD/ADDI/direct ADD ? 0000
SUB/BEQ/BNE         ? 0001
AND/ANDI            ? 0010
OR/ORI              ? 0011
XOR/XORI            ? 0100
SLT/SLTI/BLT/BGE    ? 0101
SLTU/SLTIU/BLTU/BGEU? 0110
SLL/SLLI            ? 0111
SRL/SRLI            ? 1000
SRA/SRAI            ? 1001*/

`timescale 1ns/1ps

module ALU_Control_tb;

reg  [1:0] ALUOp;
reg  [2:0] funct3;
reg  [6:0] funct7;

wire [3:0] ALU_Control;


// Instantiate ALU Control
ALU_Control uut (
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .ALU_Control(ALU_Control)
);


initial begin

    $monitor(
        "ALUOp=%b funct3=%b funct7=%b | ALU_Control=%b",
        ALUOp,
        funct3,
        funct7,
        ALU_Control
    );


    // =====================================
    // ALUOp = 00
    // Direct ADD
    // =====================================

    ALUOp  = 2'b00;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;


    // =====================================
    // ALUOp = 01
    // BRANCH
    // =====================================

    // BEQ
    ALUOp  = 2'b01;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // BNE
    funct3 = 3'b001;
    #10;

    // BLT
    funct3 = 3'b100;
    #10;

    // BGE
    funct3 = 3'b101;
    #10;

    // BLTU
    funct3 = 3'b110;
    #10;

    // BGEU
    funct3 = 3'b111;
    #10;


    // =====================================
    // ALUOp = 10
    // R-TYPE
    // =====================================

    ALUOp = 2'b10;

    // ADD
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // SUB
    funct3 = 3'b000;
    funct7 = 7'b0100000;
    #10;

    // SLL
    funct3 = 3'b001;
    funct7 = 7'b0000000;
    #10;

    // SLT
    funct3 = 3'b010;
    #10;

    // SLTU
    funct3 = 3'b011;
    #10;

    // XOR
    funct3 = 3'b100;
    #10;

    // SRL
    funct3 = 3'b101;
    funct7 = 7'b0000000;
    #10;

    // SRA
    funct3 = 3'b101;
    funct7 = 7'b0100000;
    #10;

    // OR
    funct3 = 3'b110;
    funct7 = 7'b0000000;
    #10;

    // AND
    funct3 = 3'b111;
    #10;


    // =====================================
    // ALUOp = 11
    // I-TYPE ALU
    // =====================================

    ALUOp = 2'b11;

    // ADDI
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // SLLI
    funct3 = 3'b001;
    #10;

    // SLTI
    funct3 = 3'b010;
    #10;

    // SLTIU
    funct3 = 3'b011;
    #10;

    // XORI
    funct3 = 3'b100;
    #10;

    // SRLI
    funct3 = 3'b101;
    funct7 = 7'b0000000;
    #10;

    // SRAI
    funct3 = 3'b101;
    funct7 = 7'b0100000;
    #10;

    // ORI
    funct3 = 3'b110;
    funct7 = 7'b0000000;
    #10;

    // ANDI
    funct3 = 3'b111;
    #10;


    $stop;

end

endmodule