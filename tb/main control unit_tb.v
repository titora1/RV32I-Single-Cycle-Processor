`timescale 1ns/1ps

module Control_Unit_tb;
/*
reg for signals that the testbench itself changes
wire for signals that are driven by the module under test
the testbench is actively driving opcode SO WIREEE
REG I/P to uut
WIRE O/P to uut
*/

reg [6:0] opcode;

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


// Instantiate Main Control Unit
Control_Unit uut (

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


initial begin

    $monitor(
        "opcode=%b | RegWrite=%b MemRead=%b MemWrite=%b Branch=%b Jump=%b JALR=%b SrcASel=%b ALUSrc=%b ResultSrc=%b ImmSrc=%b ALUOp=%b",
        opcode,
        RegWrite,
        MemRead,
        MemWrite,
        Branch,
        Jump,
        JALR,
        SrcASel,
        ALUSrc,
        ResultSrc,
        ImmSrc,
        ALUOp
    );


    // R-Type
    opcode = 7'b0110011;
    #10;


    // I-Type ALU
    opcode = 7'b0010011;
    #10;


    // LOAD
    opcode = 7'b0000011;
    #10;


    // STORE
    opcode = 7'b0100011;
    #10;


    // BRANCH
    opcode = 7'b1100011;
    #10;


    // JAL
    opcode = 7'b1101111;
    #10;


    // JALR
    opcode = 7'b1100111;
    #10;


    // LUI
    opcode = 7'b0110111;
    #10;


    // AUIPC
    opcode = 7'b0010111;
    #10;


    // Unsupported opcode
    opcode = 7'b1111111;
    #10;


    $stop;

end

endmodule
