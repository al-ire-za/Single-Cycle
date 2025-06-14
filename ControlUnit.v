module ControlUnit(
    input [5:0] Opcode,
    input [5:0] Funct,
    output reg RegDst,     // انتخاب ریجستر مقصد rt یا rd
    output reg Jump,
    output reg Branch,
    output reg MemRead,    // خواندن از حافظه
    output reg [1:0] MemtoReg,  // انتخاب داده ای که باید در فایل ریجستر نوشته شود
    output reg [2:0] ALUControl,  // نوع عملیات
    output reg MemWrite,   // نوتشن در حافظه 
    output reg ALUSrc,     // انتخاب ورودی دوم alu
    output reg RegWrite    // اجازه نوشتن در ریسجتر 
);
    always @(*) begin  // با هر تغییر در ورودی ها
        RegDst = 0;
        ALUSrc = 0;
        MemtoReg = 2'b00;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        Jump = 0;
        ALUControl = 3'b000;

        case (Opcode)

            6'b000000: begin         // R-Type
                RegDst = 1;
                RegWrite = 1;
                case (Funct)
                    6'b100000: ALUControl = 3'b000;
                    6'b100010: ALUControl = 3'b001;
                    6'b100100: ALUControl = 3'b010; 
                    6'b100101: ALUControl = 3'b011; 
                    6'b100111: ALUControl = 3'b100; 
                    6'b101010: ALUControl = 3'b101; 
                    6'b011000: ALUControl = 3'b110; 
                    6'b011010: ALUControl = 3'b111; 
                    6'b010000: begin 
                        RegWrite = 1;
                        MemtoReg = 2'b11;
                    end
                    6'b010010: begin 
                        RegWrite = 1;
                        MemtoReg = 2'b11;
                    end
                    default: ALUControl = 3'b000;
                endcase
            end

            6'b001000: begin   //I-type
                ALUSrc = 1;
                RegWrite = 1;
                ALUControl = 3'b000;
            end
            6'b100011: begin  // Load
                ALUSrc = 1;
                MemtoReg = 2'b01;
                RegWrite = 1;
                MemRead = 1;
                ALUControl = 3'b000;
            end
            6'b101011: begin // Sw
                ALUSrc = 1;
                MemWrite = 1;
                ALUControl = 3'b000;
            end
            6'b000100: begin  //beq
                Branch = 1;
                ALUControl = 3'b001; 
            end

            6'b000010: begin  // j
                Jump = 1;
            end

            6'b000011: begin // jal
                Jump = 1;
                RegWrite = 1;
                MemtoReg = 2'b10; 
            end

            default: begin
                
            end
        endcase
    end
endmodule