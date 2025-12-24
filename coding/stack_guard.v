//Mustafa Mert İnce
//STUDENT ID: 310201102
//STACK GUARD MODULE
//OVERFLOW AND UNDERFLOW PROTECTION FOR STACK OPERATIONS

`include "defines.v"

module stack_guard(
    input [31:0] next_sp, //ALU result (effective address for SW/LW, new SP for ADDI)
    input [3:0] write_reg, //destination register number
    input [7:0] opcode, //instruction opcode to identify ADDI
    input mem_write, //memory write enable (SW)
    input mem_read, //memory read enable (LW)
    output reg stack_overflow, //stack overflow flag
    output reg stack_underflow //stack underflow flag
);
    //STACK PARAMETERS (per PDF requirements)
    parameter SP_BASE_ADDR = 32'd40;  // $spba = 40 (base address for physical memory)
    parameter SP_LIMIT = 32'd2;       // $spl = 2 words capacity
    parameter SP_REG = 4'd14;         // $sp register number (R14)

    //STACK GUARD LOGIC 
    //Empty Stack: SP = 0
    //Push 1 word: SP = -4 (stack address = 40 + (-4) = 36)
    //Push 2 words: SP = -8 (stack address = 40 + (-8) = 32, FULL)
    //Memory range: [32-39] for 2 words capacity
    //SP > 0: UNDERFLOW (pop from empty stack)
    //SP < -8: OVERFLOW (push beyond 2-word capacity)

    always @(*) begin
        //DEFAULT FLAGS
        stack_overflow = 1'b0;
        stack_underflow = 1'b0;

        //CHECK FOR SW OPERATIONS WITH SP AS DESTINATION
        //ALU already calculated effective address in next_sp for SW+SP
        if ((mem_write) && (write_reg == SP_REG)) begin
            //next_sp contains effective address from ALU
            //Valid range for stack memory: [32, 39]
            if ($signed(next_sp) < $signed(32'd32)) begin
                stack_underflow = 1'b1;
            end else if ($signed(next_sp) > $signed(32'd39)) begin
                stack_overflow = 1'b1;
            end
        end

        //CHECK FOR LW OPERATIONS FROM SP AS BASE
        //ALU already calculated effective address in next_sp for LW+SP
        if ((mem_read) && (write_reg == SP_REG)) begin
            //next_sp contains effective address from ALU
            //Valid range for stack memory: [32, 39]
            if ($signed(next_sp) < $signed(32'd32)) begin
                stack_underflow = 1'b1;
            end else if ($signed(next_sp) > $signed(32'd39)) begin
                stack_overflow = 1'b1;
            end
        end

        //CHECK FOR ADDI TO SP
        if ((write_reg == SP_REG) && (opcode == `OP_ADDI)) begin
            //ADDI modifies SP directly (not memory address)
            
            //CHECK FOR STACK OVERFLOW
            //SP < -(spl * 4) means pushing beyond capacity
            //With spl=2, limit is -8
            if ($signed(next_sp) < $signed(-32'd8)) begin
                stack_overflow = 1'b1;
            end

            //CHECK FOR STACK UNDERFLOW
            //SP > 0 means attempting to set SP to an invalid positive state
            if ($signed(next_sp) > $signed(32'd0)) begin
                stack_underflow = 1'b1;
            end
        end
    end
endmodule


