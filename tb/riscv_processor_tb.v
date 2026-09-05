module riscv_processor_tb;

    reg clk;
    reg reset;
    wire [15:0] debug_out;

    riscv_processor dut (
        .clk(clk),
        .reset(reset),
        .debug_out(debug_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Main test
    initial begin
        reset = 1;
        #10;
        reset = 0;

        // 42 instructions need enough time
        #500;

        $display("x1  = %0d", $signed(dut.reg_file.registers[1]));
        $display("x2  = %0d", $signed(dut.reg_file.registers[2]));
        $display("x3  = %0d", $signed(dut.reg_file.registers[3]));
        $display("x4  = %0d", $signed(dut.reg_file.registers[4]));
        $display("x5  = %0d", $signed(dut.reg_file.registers[5]));
        $display("x6  = %0d", $signed(dut.reg_file.registers[6]));
        $display("x7  = %0d", $signed(dut.reg_file.registers[7]));
        $display("x8  = %0d", $signed(dut.reg_file.registers[8]));
        $display("x9  = %0d", $signed(dut.reg_file.registers[9]));
        $display("x10 = %0d", $signed(dut.reg_file.registers[10]));
        $display("x11 = %0d", $signed(dut.reg_file.registers[11]));
        $display("x12 = %0d", $signed(dut.reg_file.registers[12]));
        $display("x13 = %0d", $signed(dut.reg_file.registers[13]));
        $display("x14 = %0d", $signed(dut.reg_file.registers[14]));
        $display("x15 = %0d", $signed(dut.reg_file.registers[15]));
        $display("x16 = %0d", $signed(dut.reg_file.registers[16]));
        $display("x17 = %0d", $signed(dut.reg_file.registers[17]));
        $display("x18 = %0d", $signed(dut.reg_file.registers[18]));
        $display("x19 = %0d", $signed(dut.reg_file.registers[19]));
        $display("x20 = %0d", $signed(dut.reg_file.registers[20]));
        $display("x21 = %0d", $signed(dut.reg_file.registers[21]));
        $display("x22 = %0d", $signed(dut.reg_file.registers[22]));
        $display("x23 = %0d", $signed(dut.reg_file.registers[23]));
        $display("x24 = %0d", $signed(dut.reg_file.registers[24]));
        $display("x25 = %0d", $signed(dut.reg_file.registers[25]));
        $display("x26 = %0d", $signed(dut.reg_file.registers[26]));
        $display("x27 = %0d", $signed(dut.reg_file.registers[27]));
        $display("x28 = %0d", $signed(dut.reg_file.registers[28]));
        $display("x29 = %0d", $signed(dut.reg_file.registers[29]));
        $display("x30 = %0d", $signed(dut.reg_file.registers[30]));
        $display("x31 = %0d", $signed(dut.reg_file.registers[31]));
        $display("debug_out = %0d", $signed(debug_out));
        $display("mem[0] word = %0d", $signed({
            dut.data_mem.memory[3],
            dut.data_mem.memory[2],
            dut.data_mem.memory[1],
            dut.data_mem.memory[0]
        }));

        $display("mem[4] half = %0d", $signed({
            dut.data_mem.memory[5],
            dut.data_mem.memory[4]
        }));

        $display("mem[8] byte = %0d", $signed(dut.data_mem.memory[8]));

        $finish;
    end

endmodule