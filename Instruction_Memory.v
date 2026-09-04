module Instruction_Memory (
    input  [31:0] PC,
    output [31:0] Instr
);

    reg [31:0] memory [0:1023];

    initial begin
        $readmemh("program.mem", memory);
    end

    assign Instr = memory[PC[11:2]];

endmodule