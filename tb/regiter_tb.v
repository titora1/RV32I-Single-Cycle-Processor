
`timescale 1ns/1ps

module Register_tb;

    reg clk;
    reg RegWrite;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate Register File
    Register uut (
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test cases
    initial begin

        RegWrite = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;

        #10;

        // Write 10 into x2
        RegWrite = 1;
        rd = 5'd2;
        write_data = 32'd10;

        #10;

        // Write 20 into x3
        rd = 5'd3;
        write_data = 32'd20;

        #10;

        // Stop writing and read x2 and x3
        RegWrite = 0;
        rs1 = 5'd2;
        rs2 = 5'd3;

        #10;

        // Try writing 50 into x0
        RegWrite = 1;
        rd = 5'd0;
        write_data = 32'd50;

        #10;

        // Read x0 and x2
        RegWrite = 0;
        rs1 = 5'd0;
        rs2 = 5'd2;

        #10;

        $stop;

    end

    initial begin
        $monitor(
            "Time=%0t | rs1=%d rs2=%d | read1=%d read2=%d | rd=%d write_data=%d RegWrite=%b",
            $time, rs1, rs2, read_data1, read_data2, rd, write_data, RegWrite
        );
    end

endmodule