/*

ALU CONTROL functions 

ADD/ADDI/direct ADD ? 0000
SUB/BEQ/BNE         ? 0001
AND/ANDI            ? 0010
OR/ORI              ? 0011
XOR/XORI            ? 0100
SLT/SLTI/BLT/BGE    ? 0101
SLTU/SLTIU/BLTU/BGEU? 0110
SLL/SLLI            ? 0111
SRL/SRLI            ? 1000
SRA/SRAI            ? 1001


ALUOp	funct3	funct7	Instruction / Meaning	ALU_Control	ALU does
00	X	X	Load/Store/JAL/JALR/LUI/AUIPC type work	0000	ADD
01	000	X	BEQ	0001	SUB
01	001	X	BNE	0001	SUB
01	100	X	BLT	0101	SLT
01	101	X	BGE	0101	SLT
01	110	X	BLTU	0110	SLTU
01	111	X	BGEU	0110	SLTU
10	000	0000000	ADD	0000	ADD
10	000	0100000	SUB	0001	SUB
10	001	0000000	SLL	0111	Shift Left Logical
10	010	0000000	SLT	0101	Set Less Than
10	011	0000000	SLTU	0110	Set Less Than Unsigned
10	100	0000000	XOR	0100	XOR
10	101	0000000	SRL	1000	Shift Right Logical
10	101	0100000	SRA	1001	Shift Right Arithmetic
10	110	0000000	OR	0011	OR
10	111	0000000	AND	0010	AND
11	000	X	ADDI	0000	ADD
11	001	usually 0000000	SLLI	0111	SLL
11	010	X	SLTI	0101	SLT
11	011	X	SLTIU	0110	SLTU
11	100	X	XORI	0100	XOR
11	101	0000000	SRLI	1000	SRL
11	101	0100000	SRAI	1001	SRA
11	110	X	ORI	0011	OR
11	111	X	ANDI	0010	AND
*/
module ALU_Control (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output reg [3:0] ALU_Control
);

always @(*) begin

    // Default operation = ADD
    ALU_Control = 4'b0000;

    case (ALUOp)

        // -------------------------------------------------
        // 00 = Direct ADD
        // Used for:
        // Load, Store, JAL, JALR, LUI, AUIPC
        // -------------------------------------------------
        2'b00: begin
            ALU_Control = 4'b0000;   // ADD
        end


        // -------------------------------------------------
        // 01 = Branch comparison
        // -------------------------------------------------
        2'b01: begin

            case (funct3)

                3'b000:
                    ALU_Control = 4'b0001;   // BEQ -> SUB

                3'b001:
                    ALU_Control = 4'b0001;   // BNE -> SUB

                3'b100:
                    ALU_Control = 4'b0101;   // BLT -> SLT

                3'b101:
                    ALU_Control = 4'b0101;   // BGE -> SLT

                3'b110:
                    ALU_Control = 4'b0110;   // BLTU -> SLTU

                3'b111:
                    ALU_Control = 4'b0110;   // BGEU -> SLTU

                default:
                    ALU_Control = 4'b0001;

            endcase

        end


        // -------------------------------------------------
        // 10 = R-Type
        // ADD, SUB, SLL, SLT, SLTU,
        // XOR, SRL, SRA, OR, AND
        // -------------------------------------------------
        2'b10: begin

            case (funct3)

                // ADD / SUB
                3'b000: begin
                    if (funct7 == 7'b0100000)
                        ALU_Control = 4'b0001;   // SUB
                    else
                        ALU_Control = 4'b0000;   // ADD
                end


                // SLL
                3'b001:
                    ALU_Control = 4'b0111;


                // SLT
                3'b010:
                    ALU_Control = 4'b0101;


                // SLTU
                3'b011:
                    ALU_Control = 4'b0110;


                // XOR
                3'b100:
                    ALU_Control = 4'b0100;


                // SRL / SRA
                3'b101: begin

                    if (funct7 == 7'b0100000)
                        ALU_Control = 4'b1001;   // SRA
                    else
                        ALU_Control = 4'b1000;   // SRL

                end


                // OR
                3'b110:
                    ALU_Control = 4'b0011;


                // AND
                3'b111:
                    ALU_Control = 4'b0010;


                default:
                    ALU_Control = 4'b0000;

            endcase

        end


        // -------------------------------------------------
        // 11 = I-Type ALU
        // ADDI, SLLI, SLTI, SLTIU,
        // XORI, SRLI, SRAI, ORI, ANDI
        // -------------------------------------------------
        2'b11: begin

            case (funct3)

                // ADDI
                3'b000:
                    ALU_Control = 4'b0000;


                // SLLI
                3'b001:
                    ALU_Control = 4'b0111;


                // SLTI
                3'b010:
                    ALU_Control = 4'b0101;


                // SLTIU
                3'b011:
                    ALU_Control = 4'b0110;


                // XORI
                3'b100:
                    ALU_Control = 4'b0100;


                // SRLI / SRAI
                3'b101: begin

                    if (funct7 == 7'b0100000)
                        ALU_Control = 4'b1001;   // SRAI
                    else
                        ALU_Control = 4'b1000;   // SRLI

                end


                // ORI
                3'b110:
                    ALU_Control = 4'b0011;


                // ANDI
                3'b111:
                    ALU_Control = 4'b0010;


                default:
                    ALU_Control = 4'b0000;

            endcase

        end


        default:
            ALU_Control = 4'b0000;

    endcase

end

endmodule