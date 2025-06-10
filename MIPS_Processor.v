module MIPS_Processor(
    input clk,
    input reset
);
    wire [31:0] PC, NextPC, Instruction;
    wire [31:0] ReadData1, ReadData2, ALUResult, MemReadData;
    wire [31:0] SignImm, SrcB, PCPlus4, PCBranch, HI_LO_Result;
    wire [4:0] WriteReg;
    wire [31:0] WriteData;
    wire PCSrc, Zero;
    wire [63:0] MultResult;
    
    wire RegWrite, MemWrite, MemRead, ALUSrc, RegDst, Branch, Jump;
    wire [1:0] MemtoReg;
    wire [2:0] ALUControl;

    reg [31:0] HI, LO;
    
    // ماژول شمارنده
    ProgramCounter PC_Reg(
        .clk(clk),
        .reset(reset),
        .next_PC(NextPC),
        .PC(PC)
    );
    
    // حافظه دستورات
    InstructionMemory IM(
        .Address(PC),
        .Instruction(Instruction)
    );
    
    // واحد کنترل اصلی
    ControlUnit CU(
        .Opcode(Instruction[31:26]),
        .Funct(Instruction[5:0]),
        .RegDst(RegDst),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );
    
    // فایل ثبات ها
    RegisterFile RF(
        .clk(clk),
        .RegWrite(RegWrite),
        .ReadReg1(Instruction[25:21]),
        .ReadReg2(Instruction[20:16]),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    
    // واحد گسترش علامت برای مقادیر
    SignExtend SE(
        .data_in(Instruction[15:0]),
        .data_out(SignImm)
    );
    
    // مالتی
    MUX_2x1 ALU_Src_MUX(
        .input0(ReadData2),
        .input1(SignImm),
        .select(ALUSrc),
        .out(SrcB)
    );
    
    // واحد محاسباتی و منطقی
    ALU ALU(
        .SrcA(ReadData1),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .MultResult(MultResult)
    );
    
    DataMemory DM(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(MemReadData)
    );
    
    wire [4:0] WriteReg_temp;

    MUX_3x1 RegDst_MUX(
        .input0(Instruction[20:16]), 
        .input1(Instruction[15:11]), 
        .input2(5'b11111),           
        .select({Jump, RegDst}),
        .out(WriteReg)               
    );   
    
    MUX_4x1 MemtoReg_MUX(
        .input0(ALUResult),
        .input1(MemReadData),
        .input2(PCPlus4),
        .input3(HI_LO_Result),
        .select(MemtoReg),
        .out(WriteData)
    );

    // جمع کننده برای محاسبه PC+4
    Adder PC_Adder(
        .a(PC),
        .b(32'd4),
        .out(PCPlus4)
    );
    
    // مع کننده برای محاسبه آدرس برنچ
    Adder Branch_Adder(
        .a(PCPlus4),
        .b(SignImm << 2),
        .out(PCBranch)
    );
    
    assign PCSrc = Branch & Zero;
    

    wire [31:0] JumpAddr = {PCPlus4[31:28], Instruction[25:0], 2'b00};


    MUX_2x1 PC_Src_MUX(
        .input0(Jump ? JumpAddr : PCPlus4), 
        .input1(PCBranch),
        .select(PCSrc),
        .out(NextPC)
    );


    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            HI <= 32'b0;
            LO <= 32'b0;
        end
        else if (ALUControl == 3'b110 || ALUControl == 3'b111) begin 
            HI <= MultResult[63:32];
            LO <= MultResult[31:0]; 
        end
    end

    
    assign HI_LO_Result = (Instruction[5:0] == 6'b010000) ? HI : LO; 
endmodule