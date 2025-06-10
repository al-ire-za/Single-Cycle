module InstructionMemory(
    input [31:0] Address,      
    output [31:0] Instruction 
);
    reg [31:0] memory [0:255];  
    integer i;


    initial begin
        memory[0]  = 32'h20080005;  // addi $t0, $0, 5       | $t0 = 5
        memory[1]  = 32'h2009000A;  // addi $t1, $0, 10      | $t1 = 10
        
        memory[2]  = 32'h01285024;  // and $t2, $t1, $t0     | $t2 = $t1 & $t0 (AND)
        memory[3]  = 32'h01285825;  // or $t3, $t1, $t0      | $t3 = $t1 | $t0 (OR)
        memory[4]  = 32'h0128602A;  // slt $t4, $t1, $t0     | $t4 = ($t1 < $t0)?1:0 (SLT)
        
        memory[5]  = 32'h01095020;  // add $t2, $t0, $t1     | $t2 = $t0 + $t1
        memory[6]  = 32'hAC0A0000;  // sw $t2, 0($0)         | Mem[0] = $t2
        memory[7]  = 32'h8C0B0000;  // lw $t3, 0($0)         | $t3 = Mem[0]
        memory[8]  = 32'h08000009;  // j 0x00000009          | Jump to address 9
        memory[9]  = 32'h20080001;  // addi $t0, $0, 1       | $t0 = 1
        memory[10] = 32'h21080001;  // addi $t0, $t0, 1      | $t0 = $t0 + 1
        memory[11] = 32'h01090018;  // mult $t0, $t1         | HI/LO = $t0 * $t1
        memory[12] = 32'h00004812;  // mflo $t1              | $t1 = LO
        memory[13] = 32'hAC090000;  // sw $t1, 0($0)         | Mem[0] = $t1
        memory[14] = 32'h8C0A0000;  // lw $t2, 0($0)         | $t2 = Mem[0]
        memory[15] = 32'h0128001A;  // div $t1, $t0          | LO = $t1/$t0, HI = $t1%$t0
        memory[16] = 32'h00004810;  // mfhi $t1              | $t1 = HI (remainder)
        memory[17] = 32'h00004012;  // mflo $t0              | $t0 = LO (quotient)
        memory[18] = 32'h0800000B;  // j 0x0000000B          | Jump to address 11 (infinite loop)

        for (i = 19; i < 256; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end

    assign Instruction = memory[Address[9:2]];  
    // حافظه به صورت بایت به بایت ادرس دهی شده اما دستور ها 4 بایتی هستند
    // بخاطر همین 0و1 رو نادیده گرفتیم که یعنی تقسیم بر 4
endmodule