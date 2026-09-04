
`timescale 1ns/1ps

module PC_tb;

reg clk;
reg reset;

reg BranchTaken;
reg Jump;
reg JALR;

reg [31:0] ImmExt;
reg [31:0] ReadData1;

wire [31:0] PC;


Program_Counter uut (
    .clk(clk),
    .reset(reset),
    .BranchTaken(BranchTaken),
    .Jump(Jump),
    .JALR(JALR),
    .ImmExt(ImmExt),
    .ReadData1(ReadData1),
    .PC(PC)
);


// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// Test cases
initial begin

    reset       = 1;
    BranchTaken = 0;
    Jump        = 0;
    JALR        = 0;
    ImmExt      = 0;
    ReadData1   = 0;

    #10;
    reset = 0;


    // Normal execution: PC + 4
    #30;


    // Branch test
    BranchTaken = 1;
    ImmExt      = 32'd16;

    #10;

    BranchTaken = 0;


    // Normal again
    #20;


    // JAL test
    Jump   = 1;
    ImmExt = 32'd20;

    #10;

    Jump = 0;


    // Normal again
    #20;


    // JALR test
    JALR      = 1;
    ReadData1 = 32'd100;
    ImmExt    = 32'd8;

    #10;

    JALR = 0;


    #20;

    $stop;

end


initial begin
    $monitor(
        "Time=%0t | reset=%b BranchTaken=%b Jump=%b JALR=%b | ImmExt=%d ReadData1=%d | PC=%d",
        $time,
        reset,
        BranchTaken,
        Jump,
        JALR,
        ImmExt,
        ReadData1,
        PC
    );
end

endmodule