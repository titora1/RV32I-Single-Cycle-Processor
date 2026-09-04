`timescale 1ns/1ps

module Immediate_Generator_tb;

    reg  [31:0] Instr;
    reg  [2:0]  ImmSrc;
    wire [31:0] ImmExt;

    // Instantiate Immediate Generator
    Immediate_Generator uut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin

        $monitor("Time=%0t | ImmSrc=%b | Instr=%h | ImmExt=%h",
                  $time, ImmSrc, Instr, ImmExt);

        // --------------------------------
        // Test 1 : I-Type, immediate = 10
        // --------------------------------
        ImmSrc = 3'b000;
        Instr  = 32'h00A00000;
        #10;

        // --------------------------------
        // Test 2 : I-Type, immediate = -4
        // Instr[31:20] = FFC
        // --------------------------------
        ImmSrc = 3'b000;
        Instr  = 32'hFFC00000;
        #10;

        // --------------------------------
        // Test 3 : S-Type, immediate = 8
        // imm[11:5] = 0000000
        // imm[4:0]  = 01000
        // --------------------------------
        ImmSrc = 3'b001;
        Instr  = 32'h00000400;
        #10;

        // --------------------------------
        // Test 4 : B-Type, offset = 8
        // imm[4:1] = 0100
        // --------------------------------
        ImmSrc = 3'b010;
        Instr  = 32'h00000400;
        #10;

        // --------------------------------
        // Test 5 : U-Type
        // Expected ImmExt = 12345000
        // --------------------------------
        ImmSrc = 3'b011;
        Instr  = 32'h12345000;
        #10;

        // --------------------------------
        // Test 6 : J-Type, offset = 8
        // imm[10:1] = 0000000100
        // --------------------------------
        ImmSrc = 3'b100;
        Instr  = 32'h00800000;
        #10;

        // --------------------------------
        // Test 7 : Invalid ImmSrc
        // Expected ImmExt = 0
        // --------------------------------
        ImmSrc = 3'b111;
        Instr  = 32'hFFFFFFFF;
        #10;

        $stop;

    end

endmodule
