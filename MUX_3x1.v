// مدیریت مسیرهای داده

module MUX_3x1(
    input [4:0] input0, 
    input [4:0] input1, 
    input [4:0] input2,  
    input [1:0] select,
    output [4:0] out     
);
    assign out = (select == 2'b00) ? input0 :
                 (select == 2'b01) ? input1 :
                 input2;
endmodule