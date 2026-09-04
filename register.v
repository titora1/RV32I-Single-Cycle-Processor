 module Register (
    input clk,
    input RegWrite,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output [31:0] debug_x26
);

    reg [31:0] registers [0:31];
    integer i;

  // Initialize all architectural registers to zero
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end


    // Two asynchronous register-file read ports
    // Reading x0 always produces zero
    assign read_data1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];
      
    assign read_data2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];
   // Stable FPGA debug output
    assign debug_x26 = registers[26];

   
    // Synchronous register-file write port
    always @(posedge clk)
    begin
        if (RegWrite && (rd != 5'b00000))
            registers[rd] <= write_data;
    end

endmodule


/*
rd         ? WHERE to write
write_data ? WHAT to write
RegWrite   ? WHETHER to write
clk        ? WHEN to write */