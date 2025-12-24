//Mustafa Mert İnce
//STUDENT ID: 310201102
//ALU MODULE

`include "defines.v"

module alu(
    input [31:0] a, //operand a
    input [31:0] b, //operand b
    input [4:0] shamt, //shift amount 
    input [3:0] alu_control, //ALU control signals 4 bits industry standard
    input is_sw_to_sp, //flag: SW instruction writing to SP
    input is_lw_from_sp, //flag: LW instruction reading from SP
    input [31:0] sp_base_addr, //stack base address (40)
    output reg [31:0] result, //ALU result
    output zero //zero flag single bit
);

    //Zero flag logic if result is zero zero flag is set to 1
    //else it is set to 0, used for branch instructions
    assign zero = (result == 32'd0);

    //ALU operation
    //always @(*) FOR COMBINATIONAL LOGIC
    always @(*) begin
        //SPECIAL CASE: SW instruction with SP as destination
        //Calculate effective address: SP_BASE_ADDR + current_sp + offset
        if (is_sw_to_sp) begin
            result = $signed(sp_base_addr) + $signed(a) + $signed(b);
        end 
        //SPECIAL CASE: LW instruction reading from SP
        //Calculate effective address: SP_BASE_ADDR + current_sp + offset
        else if (is_lw_from_sp) begin
            result = $signed(sp_base_addr) + $signed(a) + $signed(b);
        end 
        else begin
            //SWITCH CASE FOR ALU CONTROL SIGNALS
            case (alu_control)
                //ARITHMETIC OPERATIONS
                `ALU_ADD: result = a + b; //add, addi, lw, sw
                `ALU_SUB: result = a - b; //subi, beq, beqi, blt

                //LOGICAL OPERATIONS
                `ALU_AND: result = a & b; //and
                `ALU_OR: result = a | b; //or
                `ALU_NAND: result = ~(a & b); //nand

                //SHIFT OPERATIONS
                //shift rs as stated in homework instructions
                `ALU_SLL: result = a << shamt; //sll
                
                //MOVE OPERATION
                `ALU_MOVE: result = a; //move

                //HELPER FOR BLT => SLT
                //set result to 1 if a < b else set to 0
                `ALU_SLT: begin
                    if ($signed(a) < $signed(b))
                        result = 32'd1;
                    else
                        result = 32'd0;
                end

                //DEFAULT CASE FOR SAFETY
                default: result = 32'b0; //Default case
            endcase
        end
    end
endmodule