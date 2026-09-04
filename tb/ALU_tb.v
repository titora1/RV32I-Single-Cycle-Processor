`timescale 1ns/1ps

module ALU_tb;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALU_Control;

    wire [31:0] Result;
    wire Zero;

    // Instantiate your ALU module
    ALU uut (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin

        // Monitor values in Transcript
        $monitor("Time=%0t | A=%0d | B=%0d | Control=%b | Result=%0d | Zero=%b",
                  $time, A, B, ALU_Control, Result, Zero);

        // -------------------------
        // ADD
        // 10 + 5 = 15
        // -------------------------
        A = 32'd10;
        B = 32'd5;
        ALU_Control = 4'b0000;
        #10;

        // -------------------------
        // SUB
        // 10 - 5 = 5
        // -------------------------
        A = 32'd10;
        B = 32'd5;
        ALU_Control = 4'b0001;
        #10;

        // -------------------------
        // AND
        // 12 = 1100
        // 10 = 1010
        // AND = 1000 = 8
        // -------------------------
        A = 32'd12;
        B = 32'd10;
        ALU_Control = 4'b0010;
        #10;

        // -------------------------
        // OR
        // 1100 OR 1010 = 1110 = 14
        // -------------------------
        A = 32'd12;
        B = 32'd10;
        ALU_Control = 4'b0011;
        #10;

        // -------------------------
        // XOR
        // 1100 XOR 1010 = 0110 = 6
        // -------------------------
        A = 32'd12;
        B = 32'd10;
        ALU_Control = 4'b0100;
        #10;

        // -------------------------
        // SLT signed
        // 5 < 10 => 1
        // -------------------------
        A = 32'd5;
        B = 32'd10;
        ALU_Control = 4'b0101;
        #10;

        // -------------------------
        // SLTU unsigned
        // 5 < 10 => 1
        // -------------------------
        A = 32'd5;
        B = 32'd10;
        ALU_Control = 4'b0110;
        #10;

        // -------------------------
        // SLL
        // 1 << 3 = 8
        // -------------------------
        A = 32'd1;
        B = 32'd3;
        ALU_Control = 4'b0111;
        #10;

        // -------------------------
        // SRL
        // 8 >> 2 = 2
        // -------------------------
        A = 32'd8;
        B = 32'd2;
        ALU_Control = 4'b1000;
        #10;

        // -------------------------
        // SRA
        // -8 >>> 2 = -2
        // -------------------------
        A = -32'sd8;
        B = 32'd2;
        ALU_Control = 4'b1001;
        #10;

        // -------------------------
        // ZERO FLAG TEST
        // 5 - 5 = 0
        // Zero should become 1
        // -------------------------
        A = 32'd5;
        B = 32'd5;
        ALU_Control = 4'b0001;
        #10;

        $stop;

    end

endmodule
