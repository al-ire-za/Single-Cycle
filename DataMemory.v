module DataMemory(
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] Address,
    input [31:0] WriteData,  // داده 32 بیتی برای نوشتن در حافظه
    output [31:0] ReadData
);
    reg [31:0] memory [0:255]; 
    
    
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end
    
    assign ReadData = MemRead ? memory[Address[9:2]] : 32'b0;
    
    always @(posedge clk) begin
        if (MemWrite)
            memory[Address[9:2]] <= WriteData;  // نوشتن داده در آدرس مشخص
    end
endmodule