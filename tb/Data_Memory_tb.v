`timescale 1ns / 1ps

module Data_Memory_tb;

    reg clk;
    reg MemRead;
    reg MemWrite;
    reg [2:0] funct3;
    reg [31:0] Address;
    reg [31:0] WriteData;

    wire [31:0] ReadData;

    // Instantiate Data Memory
    Data_Memory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .funct3(funct3),
        .Address(Address),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk = 0;
        MemRead = 0;
        MemWrite = 0;
        funct3 = 3'b000;
        Address = 32'd0;
        WriteData = 32'd0;

        // --------------------------------
        // TEST 1 : SW
        // Store 12345678 at address 100
        // --------------------------------
        #10;

        MemWrite = 1;
        MemRead = 0;
        funct3 = 3'b010;       // SW
        Address = 32'd100;
        WriteData = 32'h12345678;

        #10;

        MemWrite = 0;

        // --------------------------------
        // TEST 2 : LW
        // Read word from address 100
        // Expected = 12345678
        // --------------------------------
        MemRead = 1;
        funct3 = 3'b010;       // LW
        Address = 32'd100;

        #10;

        // --------------------------------
        // TEST 3 : SB
        // Store AB at address 200
        // --------------------------------
        MemRead = 0;
        MemWrite = 1;
        funct3 = 3'b000;       // SB
        Address = 32'd200;
        WriteData = 32'h000000AB;

        #10;

        MemWrite = 0;

        // --------------------------------
        // TEST 4 : LBU
        // Expected = 000000AB
        // --------------------------------
        MemRead = 1;
        funct3 = 3'b100;       // LBU
        Address = 32'd200;

        #10;

        // --------------------------------
        // TEST 5 : LB
        // AB has sign bit = 1
        // Expected = FFFFFFAB
        // --------------------------------
        funct3 = 3'b000;       // LB

        #10;

        // --------------------------------
        // TEST 6 : SH
        // Store ABCD at address 300
        // --------------------------------
        MemRead = 0;
        MemWrite = 1;
        funct3 = 3'b001;       // SH
        Address = 32'd300;
        WriteData = 32'h0000ABCD;

        #10;

        MemWrite = 0;

        // --------------------------------
        // TEST 7 : LHU
        // Expected = 0000ABCD
        // --------------------------------
        MemRead = 1;
        funct3 = 3'b101;       // LHU
        Address = 32'd300;

        #10;

        // --------------------------------
        // TEST 8 : LH
        // ABCD has sign bit = 1
        // Expected = FFFFABCD
        // --------------------------------
        funct3 = 3'b001;       // LH

        #10;

        // End simulation
        MemRead = 0;
        MemWrite = 0;

        #10;

        $finish;

    end

    // Display values in transcript
    initial begin

        $monitor(
            "Time=%0t | MemRead=%b MemWrite=%b funct3=%b | Address=%0d | WriteData=%h | ReadData=%h",
            $time,
            MemRead,
            MemWrite,
            funct3,
            Address,
            WriteData,
            ReadData
        );

    end

endmodule