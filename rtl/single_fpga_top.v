module single_fpga_top (
    input clk,
    input reset,
    output [3:0] led
);

    wire [15:0] debug_out;
    wire cpu_clk;
    wire locked;
    wire cpu_reset;

    assign cpu_reset = reset | ~locked;

    clk_wiz_0 clk_gen (
        .clk_out1(cpu_clk),
        .reset(reset),
        .locked(locked),
        .clk_in1(clk)
    );

    riscv_processor cpu (
        .clk(cpu_clk),
        .reset(cpu_reset),
        .debug_out(debug_out)
    );

    assign led = debug_out[3:0];

endmodule