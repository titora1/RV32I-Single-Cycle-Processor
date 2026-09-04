//easyy shit hai bhai
 module Branch_Unit (
    input        Branch,
    input  [2:0] funct3,
    input  [31:0] ReadData1,
    input  [31:0] ReadData2,

    output reg   BranchTaken
);

always @(*) begin

    BranchTaken = 1'b0;

    if (Branch) begin
        case (funct3)

            3'b000: // BEQ
                BranchTaken = (ReadData1 == ReadData2);

            3'b001: // BNE
                BranchTaken = (ReadData1 != ReadData2);

            3'b100: // BLT signed
                BranchTaken = ($signed(ReadData1) < $signed(ReadData2));

            3'b101: // BGE signed
                BranchTaken = ($signed(ReadData1) >= $signed(ReadData2));

            3'b110: // BLTU unsigned
                BranchTaken = (ReadData1 < ReadData2);

            3'b111: // BGEU unsigned
                BranchTaken = (ReadData1 >= ReadData2);

            default:
                BranchTaken = 1'b0;

        endcase
    end

end

endmodule
