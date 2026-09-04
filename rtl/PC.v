
module Program_Counter (
    input         clk,
    input         reset,

    input         BranchTaken,
    input         Jump,
    input         JALR,

    input  [31:0] ImmExt,
    input  [31:0] ReadData1,

    output reg [31:0] PC
);

reg [31:0] PC_next;  /*it is outside the parenthesis bc 
                   it is not communicating with the outside world and it has reg bc 
                   it is used in always block and it is outside of parenthis bc it 
                    is used in always block*/


// Decide the next PC value
always @(*) begin

    if (JALR)
        PC_next = (ReadData1 + ImmExt) & 32'hFFFFFFFE;

    else if (Jump)
        PC_next = PC + ImmExt;

    else if (BranchTaken)
        PC_next = PC + ImmExt;

    else
        PC_next = PC + 32'd4;

end


// Store the new PC value
always @(posedge clk or posedge reset) begin

    if (reset)
        PC <= 32'b0;

    else
        PC <= PC_next;

end

endmodule