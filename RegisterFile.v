module RegisterFile(
    input clk,
    input RegWrite,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);
    reg [31:0] registers [0:31];
    
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'h00000000;
        end
    end
    
    assign ReadData1 = (ReadReg1 != 0) ? registers[ReadReg1] : 32'b0;
    assign ReadData2 = (ReadReg2 != 0) ? registers[ReadReg2] : 32'b0;
    
    always @(posedge clk) begin
        if (RegWrite && WriteReg != 0)
            registers[WriteReg] <= WriteData;
    end
    // زمانی نوشتن انجام میشود که سیگنال نوشتن فعال باشه و ادرس ریسجتر صفر نباشه
endmodule