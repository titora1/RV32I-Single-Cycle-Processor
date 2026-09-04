`timescale 1ns / 1ps

module Data_Memory (
    input              clk,
    input              MemRead,
    input              MemWrite,
    input      [2:0]   funct3,
    input      [31:0]  Address,
    input      [31:0]  WriteData,
    output reg [31:0]  ReadData
);

    // 1 KB memory arranged as:
    // 256 words × 4 byte banks
    //
    // bank0 contains bits [7:0]
    // bank1 contains bits [15:8]
    // bank2 contains bits [23:16]
    // bank3 contains bits [31:24]

    (* ram_style = "distributed" *)
    reg [7:0] bank0 [0:255];

    (* ram_style = "distributed" *)
    reg [7:0] bank1 [0:255];

    (* ram_style = "distributed" *)
    reg [7:0] bank2 [0:255];

    (* ram_style = "distributed" *)
    reg [7:0] bank3 [0:255];


    // Address[9:2] selects one of the 256 words.
    // Address[1:0] selects a byte inside that word.

    wire [7:0] WordAddress;
    wire [1:0] ByteOffset;

    assign WordAddress = Address[9:2];
    assign ByteOffset  = Address[1:0];


    // =====================================================
    // WRITE CONTROL
    // =====================================================

    reg WriteEnable0;
    reg WriteEnable1;
    reg WriteEnable2;
    reg WriteEnable3;

    reg [7:0] WriteByte0;
    reg [7:0] WriteByte1;
    reg [7:0] WriteByte2;
    reg [7:0] WriteByte3;


    always @(*) begin

        // Default: do not write any bank
        WriteEnable0 = 1'b0;
        WriteEnable1 = 1'b0;
        WriteEnable2 = 1'b0;
        WriteEnable3 = 1'b0;

        WriteByte0 = 8'b0;
        WriteByte1 = 8'b0;
        WriteByte2 = 8'b0;
        WriteByte3 = 8'b0;


        if (MemWrite) begin

            case (funct3)

                // =========================================
                // SB - STORE BYTE
                // =========================================

                3'b000: begin

                    case (ByteOffset)

                        2'b00: begin
                            WriteEnable0 = 1'b1;
                            WriteByte0   = WriteData[7:0];
                        end

                        2'b01: begin
                            WriteEnable1 = 1'b1;
                            WriteByte1   = WriteData[7:0];
                        end

                        2'b10: begin
                            WriteEnable2 = 1'b1;
                            WriteByte2   = WriteData[7:0];
                        end

                        2'b11: begin
                            WriteEnable3 = 1'b1;
                            WriteByte3   = WriteData[7:0];
                        end

                    endcase

                end


                // =========================================
                // SH - STORE HALFWORD
                //
                // Supported aligned offsets:
                // 00 -> lower halfword
                // 10 -> upper halfword
                // =========================================

                3'b001: begin

                    if (ByteOffset == 2'b00) begin

                        WriteEnable0 = 1'b1;
                        WriteEnable1 = 1'b1;

                        WriteByte0 = WriteData[7:0];
                        WriteByte1 = WriteData[15:8];

                    end
                    else if (ByteOffset == 2'b10) begin

                        WriteEnable2 = 1'b1;
                        WriteEnable3 = 1'b1;

                        WriteByte2 = WriteData[7:0];
                        WriteByte3 = WriteData[15:8];

                    end

                end


                // =========================================
                // SW - STORE WORD
                //
                // Word must be aligned:
                // Address[1:0] must equal 00
                // =========================================

                3'b010: begin

                    if (ByteOffset == 2'b00) begin

                        WriteEnable0 = 1'b1;
                        WriteEnable1 = 1'b1;
                        WriteEnable2 = 1'b1;
                        WriteEnable3 = 1'b1;

                        WriteByte0 = WriteData[7:0];
                        WriteByte1 = WriteData[15:8];
                        WriteByte2 = WriteData[23:16];
                        WriteByte3 = WriteData[31:24];

                    end

                end


                default: begin
                    // No memory write
                end

            endcase

        end

    end


    // =====================================================
    // SYNCHRONOUS MEMORY WRITES
    // =====================================================

    always @(posedge clk) begin

        if (WriteEnable0)
            bank0[WordAddress] <= WriteByte0;

    end


    always @(posedge clk) begin

        if (WriteEnable1)
            bank1[WordAddress] <= WriteByte1;

    end


    always @(posedge clk) begin

        if (WriteEnable2)
            bank2[WordAddress] <= WriteByte2;

    end


    always @(posedge clk) begin

        if (WriteEnable3)
            bank3[WordAddress] <= WriteByte3;

    end


    // =====================================================
    // MEMORY READ
    // =====================================================

    wire [31:0] WordData;

    reg [7:0]  SelectedByte;
    reg [15:0] SelectedHalfword;


    // Little-endian word arrangement

    assign WordData = {
        bank3[WordAddress],
        bank2[WordAddress],
        bank1[WordAddress],
        bank0[WordAddress]
    };


    // Select one byte or one aligned halfword

    always @(*) begin

        case (ByteOffset)

            2'b00:
                SelectedByte = WordData[7:0];

            2'b01:
                SelectedByte = WordData[15:8];

            2'b10:
                SelectedByte = WordData[23:16];

            2'b11:
                SelectedByte = WordData[31:24];

        endcase


        if (Address[1] == 1'b0)
            SelectedHalfword = WordData[15:0];
        else
            SelectedHalfword = WordData[31:16];

    end


    // Asynchronous read keeps the existing pipeline timing unchanged.

    always @(*) begin

        ReadData = 32'b0;


        if (MemRead) begin

            case (funct3)

                // LB - signed byte
                3'b000: begin

                    ReadData = {
                        {24{SelectedByte[7]}},
                        SelectedByte
                    };

                end


                // LH - signed halfword
                3'b001: begin

                    ReadData = {
                        {16{SelectedHalfword[15]}},
                        SelectedHalfword
                    };

                end


                // LW - word
                3'b010: begin

                    ReadData = WordData;

                end


                // LBU - unsigned byte
                3'b100: begin

                    ReadData = {
                        24'b0,
                        SelectedByte
                    };

                end


                // LHU - unsigned halfword
                3'b101: begin

                    ReadData = {
                        16'b0,
                        SelectedHalfword
                    };

                end


                default: begin

                    ReadData = 32'b0;

                end

            endcase

        end

    end

endmodule