//Mustafa Mert İnce
//STUDENT ID: 310201102
//CONTROL UNIT MODULE

`include "defines.v"

module control_unit(
    input [7:0] opcode, //Instruction[31:24] 8-bit opcode
    input [5:0] funct, //Instruction[5:0] 6-bit function code for R-type
    input overflow, //overflow flag from stack guard
    input underflow, //underflow flag from stack guard
    output reg reg_dst, //Register Destination select (rt or rd)
    output reg alu_src, //ALU Source select (register or immediate)
    output reg mem_to_reg, //Memory to Register select (ALU result or Memory data)
    output reg reg_write_enable, //Register Write Enable
    output reg mem_read, //Memory Read Enable
    output reg mem_write, //Memory Write Enable
    output reg branch_eq, //Branch if Equal Enable
    output reg branch_neq, //Branch if Not Equal Enable
    output reg branch_lt, //Branch if Less Than Enable
    output reg  branch_eqi, //Branch if Equal Immediate Enable
    output reg jump, //Jump Enable
    output reg [3:0] alu_control //ALU Control Signals
);

    //raw signasl before overflow/underflow check
    reg raw_reg_write_enable;
    reg raw_mem_write;

    //CONTROL UNIT LOGIC
    always @(*) begin
        //DEFAULT SIGNALS
        reg_dst = 1'b0;
        alu_src = 1'b0;
        mem_to_reg = 1'b0;
        raw_reg_write_enable = 1'b0;
        raw_mem_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch_eq = 1'b0;
        branch_neq = 1'b0;
        branch_lt = 1'b0;
        branch_eqi = 1'b0;
        jump = 1'b0;
        alu_control = `ALU_ADD; //default safe ADD operation

        //SWITCH CASE FOR OPCODE
        case (opcode)

            //R-TYPE instructions OPCODE: 102
            `OP_R_TYPE: begin
                reg_dst = 1'b1; //rd is destination
                alu_src = 1'b0; //second ALU operand from register
                mem_to_reg = 1'b0; //write ALU result to register
                raw_reg_write_enable = 1'b1; //enable register write

                //FUNCTION CODE DECODING
                case (funct)
                    `FUNCT_SLL: alu_control = `ALU_SLL; //sll
                    `FUNCT_MOVE: alu_control = `ALU_MOVE; //move
                    `FUNCT_NAND: alu_control = `ALU_NAND; //nand
                    `FUNCT_OR: alu_control = `ALU_OR; //or
                    `FUNCT_ADD: alu_control = `ALU_ADD; //add
                    default: alu_control = 'ALU_ADD; //default case
                endcase
            end


            //I-TYPE instructions 
            `OP_LW: begin
                alu_src = 1'b1; //address from immediate rs + offset
                mem_to_reg = 1'b1; //write Memory data to register
                raw_reg_write_enable = 1'b1; //enable register write
                mem_read = 1'b1; //enable memory read
                alu_control = `ALU_ADD; //add for address calculation
            end

            `OP_SW: begin
                alu_src = 1'b1; //address from immediate rs + offset
                raw_mem_write = 1'b1; //enable memory write
                alu_control = `ALU_ADD; //add for address calculation
            end

            `OP_BEQ: begin
                alu_src = 1'b0; //register vs register comparison
                branch_eq = 1'b1; //enable branch if equal
                alu_control = `ALU_SUB; //subtract for comparison
            end

            `OP_BLT: begin
                alu_src = 1'b0; //register vs register comparison
                branch_lt = 1'b1; //enable branch if less than
                alu_control = `ALU_SUB; //subtract for comparison
            end

            `OP_SUBI: begin
                alu_src = 1'b1; //second ALU operand from immediate
                raw_reg_write_enable = 1'b1; //enable register write
                alu_control = `ALU_SUB; //subtract
            end

            `OP_ADDI: begin
                alu_src = 1'b1; //second ALU operand from immediate
                raw_reg_write_enable = 1'b1; //enable register write
                alu_control = `ALU_ADD; //add
            end


            //B-I TYPE and J-TYPE
            `OP_BEQI: begin
                alu_src = 1'b1; //register vs immediate comparison
                branch_eqi = 1'b1; //enable branch if equal immediate
                alu_control = `ALU_SUB; //subtract for comparison
            end

            `OP_J: begin
                jump = 1'b1; //enable jump
            end

            //DEFAULT CASE FOR SAFETY
            default: begin
                //all control signals are already set to default safe values
            end
        endcase

        //SAFETY CHECKS FOR STACK OVERFLOW AND UNDERFLOW
        //HW INSTRUCTION: IF OVERFLOW OR UNDERFLOW OCCURS PREVENT THE EXECUTION OF THE INSTRUCTION
        /MAKE WRITE SIGNALS ZERO IF OVERFLOW OR UNDERFLOW OCCURS
        if (overflow || underflow) begin
            reg_write_enable = 1'b0; //prevent register write
            mem_write = 1'b0; //prevent memory write
        end
        //NO OVERFLOW OR UNDERFLOW OCCURRED SO PASS RAW SIGNALS
        else begin
            reg_write_enable = raw_reg_write_enable;
            mem_write = raw_mem_write;
        end
    end
endmodule



    