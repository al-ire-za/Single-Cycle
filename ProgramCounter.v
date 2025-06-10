module ProgramCounter(
    input clk,
    input reset,
    input [31:0] next_PC,
    output reg [31:0] PC
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'h00000000;
        else
            PC <= next_PC;
    end
endmodule