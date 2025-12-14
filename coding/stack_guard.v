//Mustafa Mert İnce
//STUDENT ID: 310201102
//STACK GUARD MODULE
//OVERFLOW AND UNDERFLOW PROTECTION FOR STACK OPERATIONS

`include "defines.v"

module stack_guard(
    input [31:0] next_sp, //new candidate stack pointer from ALU
    input reg_write_enable, //register write enable signal
    input [3:0] write_reg, //destination register number
    output reg stack_overflow, //stack overflow flag
    output reg stack_underflow //stack underflow flag
);
    //STACK PARAMETERS
    parameter SP_BASE  = 32'd40;  
    parameter SP_LIMIT = 32'd32; 
    parameter SP_REG = 4'd14;
    

    //STACK GUARD LOGIC
    //SP IS 0 IF STACK IS EMPTY
    //SP IS -4 IF ONE WORD IS PUSHED
    //SP IS -8 IF TWO WORDS ARE PUSHED(STACK FULL)
    //SP > 0 INDICATES UNDERFLOW
    //SP < -8 INDICATES OVERFLOW

    always @(*) begin
        //DEFAULT FLAGS
        stack_overflow = 1'b0;
        stack_underflow = 1'b0;

        //CONTROL IF ONLY SP IS BEING WRITTEN
        if (reg_write_enable && (write_reg == SP_REG)) begin

            //CHECK FOR STACK UNDERFLOW
            //SP > 0 INDICATES UNDERFLOW
            if ($signed(next_sp) > $signed(32'd0)) begin
                stack_underflow = 1'b1;
            end

            //CHECK FOR STACK OVERFLOW
            //SP < -8 INDICATES OVERFLOW
            else if ($signed(next_sp) < $signed(-32'd8)) begin
                stack_overflow = 1'b1;
            end
        end
    end
endmodule


