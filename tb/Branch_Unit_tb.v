`timescale 1ns/1ps

module Branch_Unit_tb;

    reg         Branch;
    reg  [2:0]  funct3;
    reg  [31:0] ReadData1;
    reg  [31:0] ReadData2;

    wire        BranchTaken;

    // Instantiate Branch Unit
    Branch_Unit uut (
        .Branch(Branch),
        .funct3(funct3),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .BranchTaken(BranchTaken)
    );

    initial begin

        $monitor("Time=%0t | Branch=%b funct3=%b | RD1=%d RD2=%d | BranchTaken=%b",
                 $time, Branch, funct3, ReadData1, ReadData2, BranchTaken);

        // ------------------------------------------------
        // Test 1: Branch disabled
        // ------------------------------------------------
        Branch = 0;
        funct3 = 3'b000;
        ReadData1 = 10;
        ReadData2 = 10;
        #10;

        // ------------------------------------------------
        // Test 2: BEQ - Equal
        // ------------------------------------------------
        Branch = 1;
        funct3 = 3'b000;
        ReadData1 = 10;
        ReadData2 = 10;
        #10;

        // ------------------------------------------------
        // Test 3: BEQ - Not Equal
        // ------------------------------------------------
        ReadData1 = 10;
        ReadData2 = 20;
        #10;

        // ------------------------------------------------
        // Test 4: BNE - Not Equal
        // ------------------------------------------------
        funct3 = 3'b001;
        ReadData1 = 10;
        ReadData2 = 20;
        #10;

        // ------------------------------------------------
        // Test 5: BNE - Equal
        // ------------------------------------------------
        ReadData1 = 10;
        ReadData2 = 10;
        #10;

        // ------------------------------------------------
        // Test 6: BLT - Signed
        // -5 < 10
        // ------------------------------------------------
        funct3 = 3'b100;
        ReadData1 = -5;
        ReadData2 = 10;
        #10;

        // ------------------------------------------------
        // Test 7: BGE - Signed
        // 20 >= 10
        // ------------------------------------------------
        funct3 = 3'b101;
        ReadData1 = 20;
        ReadData2 = 10;
        #10;

        // ------------------------------------------------
        // Test 8: BLTU - Unsigned
        // 5 < 10
        // ------------------------------------------------
        funct3 = 3'b110;
        ReadData1 = 5;
        ReadData2 = 10;
        #10;

        // ------------------------------------------------
        // Test 9: BGEU - Unsigned
        // 20 >= 10
        // ------------------------------------------------
        funct3 = 3'b111;
        ReadData1 = 20;
        ReadData2 = 10;
        #10;

        // ------------------------------------------------
        // Test 10: Signed vs Unsigned special test
        // Same bit pattern of -1
        // ------------------------------------------------

        // BLT signed: -1 < 5 ? TRUE
        funct3 = 3'b100;
        ReadData1 = 32'hFFFFFFFF;
        ReadData2 = 5;
        #10;

        // BLTU unsigned:
        // 4294967295 < 5 ? FALSE
        funct3 = 3'b110;
        ReadData1 = 32'hFFFFFFFF;
        ReadData2 = 5;
        #10;

        $stop;

    end

endmodule
