module ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero,
    output reg [63:0] MultResult
);
    always @(*) begin
        case (ALUControl)
            3'b000: begin  // add
                ALUResult = SrcA + SrcB;
                MultResult = 64'b0;
            end
            3'b001: begin // sub
                ALUResult = SrcA - SrcB;
                MultResult = 64'b0;
            end
            3'b010: begin  //and
                ALUResult = SrcA & SrcB;
                MultResult = 64'b0;
            end
            3'b011: begin // or
                ALUResult = SrcA | SrcB;
                MultResult = 64'b0;
            end
            3'b100: begin //nor 
                ALUResult = ~(SrcA | SrcB);
                MultResult = 64'b0;
            end
            3'b101: begin // slt
                ALUResult = (SrcA < SrcB) ? 1 : 0;
                MultResult = 64'b0;
            end
            3'b110: begin // mult
                MultResult = SrcA * SrcB;
                ALUResult = 32'b0; 
            end
            3'b111: begin 
                if (SrcB != 0) begin
                    MultResult[31:0] = SrcA / SrcB;   // LO
                    MultResult[63:32] = SrcA % SrcB;   // HI
                end else begin
                    MultResult = 64'b0; 
                end
                ALUResult = 32'b0; 
            end

            default: begin
                ALUResult = 32'b0;
                MultResult = 64'b0;
            end
        endcase
        Zero = (ALUResult == 32'b0); // اگر صفر باشه نتیجه ریجستر زیرو فعال میشه
    end
endmodule