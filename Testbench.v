`include "MIPS_Processor.v"
`include "InstructionMemory.v"
`include "DataMemory.v"
`include "ControlUnit.v"
`include "ALU.v"
`include "Adder.v"
`include "MUX_2x1.v"
`include "MUX_3x1.v"
`include "MUX_4x1.v"
`include "ProgramCounter.v"
`include "RegisterFile.v"
`include "SignExtend.v"

module MIPS_Testbench;
    // Internal signal declarations
    reg clk;
    reg reset;
    integer cycle_count;
    
    // Instantiate the MIPS processor
    MIPS_Processor processor(.clk(clk), .reset(reset));

    // Clock generator (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulation control
    initial begin
        reset = 1;
        cycle_count = 0;
        #10 reset = 0;
        
        $display("\n====================================");
        $display(" MIPS Simulation Started");
        $display(" Now with AND, OR, SLT support");
        $display("====================================\n");
    end

    // Main simulation loop
    always @(posedge clk) begin
        if (!reset) begin
            cycle_count <= cycle_count + 1;
            print_cycle_info();
            
            if (cycle_count >= 20) begin
                $display("\nSimulation stopped after 100 cycles");
                $finish;
            end
        end
    end

    // Enhanced display task
    task print_cycle_info;
        begin
            $display("\n=== Cycle %0d ===", cycle_count);
            $display("PC: %h (%0d)", processor.PC, processor.PC);
            
            // Decode and display instruction type
            case (processor.Instruction[31:26])
                6'b000000: begin // R-type
                    case (processor.Instruction[5:0])
                        6'b100000: $display("Instruction: ADD");
                        6'b100010: $display("Instruction: SUB");
                        6'b100100: $display("Instruction: AND");
                        6'b100101: $display("Instruction: OR");
                        6'b101010: $display("Instruction: SLT");
                        6'b011000: $display("Instruction: MULT");
                        6'b011010: $display("Instruction: DIV");
                        default: $display("Instruction: Unknown R-type");
                    endcase
                end
                6'b001000: $display("Instruction: ADDI");
                6'b100011: $display("Instruction: LW");
                6'b101011: $display("Instruction: SW");
                6'b000100: $display("Instruction: BEQ");
                6'b000010: $display("Instruction: J");
                default: $display("Instruction: Unknown");
            endcase
            
            $display("Hex: %h", processor.Instruction);
            
            // ALU status
            $display("ALU Result: %h (%0d)", processor.ALUResult, processor.ALUResult);
            $display("Zero Flag: %b", processor.Zero);

            // Register write operations
            if (processor.RegWrite) begin
                $display("REG WRITE: R%0d <= %h (%0d)", 
                        processor.WriteReg, 
                        processor.WriteData,
                        processor.WriteData);
            end

            // Memory operations
            if (processor.MemWrite) begin
                $display("MEM WRITE: [%h] <= %h (%0d)", 
                        processor.ALUResult,
                        processor.ReadData2,
                        processor.ReadData2);
            end
            else if (processor.MemRead) begin
                $display("MEM READ: [%h] => %h (%0d)", 
                        processor.ALUResult,
                        processor.MemReadData,
                        processor.MemReadData);
            end
            
            // HI/LO registers for MULT/DIV
            if (processor.Instruction[31:26] == 6'b000000 && 
                (processor.Instruction[5:0] == 6'b011000 || 
                 processor.Instruction[5:0] == 6'b011010)) begin
                $display("HI: %h (%0d)", processor.HI, processor.HI);
                $display("LO: %h (%0d)", processor.LO, processor.LO);
            end
        end
    endtask

    // Enhanced register dump
    always @(posedge clk) begin
        if (!reset && cycle_count != 0 && cycle_count % 5 == 0) begin
            print_register_status();
        end
    end

    task print_register_status;
        begin
            $display("\n--- Register Dump (Cycle %0d) ---", cycle_count);
            $display("$zero (R0): %h (%0d)", processor.RF.registers[0], processor.RF.registers[0]);
            $display("$t0 (R8): %h (%0d)", processor.RF.registers[8], processor.RF.registers[8]);
            $display("$t1 (R9): %h (%0d)", processor.RF.registers[9], processor.RF.registers[9]);
            $display("$t2 (R10): %h (%0d)", processor.RF.registers[10], processor.RF.registers[10]);
            $display("$t3 (R11): %h (%0d)", processor.RF.registers[11], processor.RF.registers[11]);
            $display("$t4 (R12): %h (%0d)", processor.RF.registers[12], processor.RF.registers[12]);
            $display("$sp (R29): %h (%0d)", processor.RF.registers[29], processor.RF.registers[29]);
            $display("$ra (R31): %h (%0d)", processor.RF.registers[31], processor.RF.registers[31]);
        end
    endtask
endmodule