 `timescale 1ns / 1ps

module Instruction_Memory_tb;

    reg  [31:0] PC;
    wire [31:0] Instr;

    Instruction_Memory uut (
        .PC(PC),
        .Instr(Instr)
    );

    initial begin

        // Put some values into memory only for simulation
        uut.memory[0] = 32'h00500093;  // addi x1, x0, 5
        uut.memory[1] = 32'h00A00113;  // addi x2, x0, 10
        uut.memory[2] = 32'h002081B3;  // add x3, x1, x2

        PC = 32'd0;
        #10;

        PC = 32'd4;
        #10;

        PC = 32'd8;
        #10;

        $finish;

    end

endmodule