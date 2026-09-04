module Immediate_Generator (
    input  [31:0] Instr,
    input  [2:0]  ImmSrc,
    output reg [31:0] ImmExt
);

always @(*) begin

    case (ImmSrc)

        // I-Type: ADDI, LW, JALR, etc.
        3'b000: begin
            ImmExt = {{20{Instr[31]}}, Instr[31:20]};
        end

        // S-Type: SW
        3'b001: begin
            ImmExt = {{20{Instr[31]}},
                      Instr[31:25],
                      Instr[11:7]};
        end

        // B-Type: BEQ, BNE, BLT, BGE, etc.
        3'b010: begin
            ImmExt = {{19{Instr[31]}},
                      Instr[31],
                      Instr[7],
                      Instr[30:25],
                      Instr[11:8],
                      1'b0};
        end

        // U-Type: LUI, AUIPC
        3'b011: begin
            ImmExt = {Instr[31:12], 12'b0};
        end

        // J-Type: JAL
        3'b100: begin
            ImmExt = {{11{Instr[31]}},
                      Instr[31],
                      Instr[19:12],
                      Instr[20],
                      Instr[30:21],
                      1'b0};
        end

        default: begin
            ImmExt = 32'b0;
        end

    endcase

end

endmodule