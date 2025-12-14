//Mustafa Mert İnce
//STUDENT ID: 310201102
//PROCESSOR MODULE

`include "defines.v"

module processor(
    input clk, //clock signal
    input reset, //reset signal
    
    //DEBUG OUTPUTS FOR MODELSIM WAVEFORM VIEWER
    output [31:0] debug_pc, //program counter for waveform
    output [31:0] debug_instruction, //instruction for waveform
    output [31:0] debug_alu_result, //ALU result for waveform
    output debug_overflow, //overflow flag for waveform
    output debug_underflow //underflow flag for waveform
);

    //DECLARATION OF WIRES AND REGISTERS
    reg [31:0] pc; //program counter register
    wire [31:0] pc_next; //next program counter value
    wire [31:0] pc_plus_4; //pc + 4 value
    wire [31:0] branch_target; //branch target address
    wire [31:0] branch_target_eqi; //branch target address for beqi
    wire [31:0] jump_target; //jump target address

    wire [31:0] instruction; //current instruction

    wire reg_dst; //register destination select (0: rt, 1: rd)
    wire alu_src; //ALU source select (0: register, 1: immediate)
    wire mem_to_reg; //memory to register select (0: ALU result, 1: memory data)
    wire reg_write_enable; //register write enable
    wire mem_read; //memory read enable
    wire mem_write; //memory write enable
    wire branch_eq; //branch if equal enable
    wire branch_lt; //branch if less than enable
    wire branch_eqi; //branch if equal immediate enable
    wire branch_neq; //branch if not equal enable
    wire jump; //jump enable
    wire [3:0] alu_control; //ALU control signals

    wire stack_overflow; //overflow flag from stack guard
    wire stack_underflow; //underflow flag from stack guard

    wire [31:0] read_data1; //data from rs register
    wire [31:0] read_data2; //data from rt register
    wire [31:0] write_data; //data to write into register
    wire [3:0] write_reg; //destination register number

    wire [31:0] alu_operand_b; //second ALU operand
    wire [31:0] alu_result; //ALU result
    wire alu_zero; //ALU zero flag
    wire neg_flag; //ALU negative flag

    wire [31:0] memory_read_data; //data read from data memory

    wire [31:0] sign_ext_imm; //16-bits to 32-bits (for normal I-Type)
    wire [31:0] sign_ext_imm_8;  //8-bits to 32-bits (for BEQI)

    //DEBUG OUTPUT ASSIGNMENTS
    assign debug_pc = pc; //expose pc for waveform viewer
    assign debug_instruction = instruction; //expose instruction for waveform viewer
    assign debug_alu_result = alu_result; //expose ALU result for waveform viewer
    assign debug_overflow = stack_overflow; //expose overflow flag for waveform viewer
    assign debug_underflow = stack_underflow; //expose underflow flag for waveform viewer

    //MODULE INSTANTIATIONS

    //PROGRAM COUNTER LOGIC
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'd0; //reset pc to 0
        end else begin
            pc <= pc_next; //update pc to next value
        end
    end 

    assign pc_plus_4 = pc + 32'd4; //pc + 4 calculation for next instruction

    //INSTRUCTION MEMORY
    instruction_memory im (
        .pc(pc),
        .instruction(instruction)
    );

    //CONTROL UNIT
    control_unit cu (
        .opcode(instruction[31:24]),
        .funct(instruction[5:0]),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write_enable(reg_write_enable),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch_eq(branch_eq),
        .branch_lt(branch_lt),
        .branch_eqi(branch_eqi),
        .branch_neq(branch_neq),
        .jump(jump),
        .alu_control(alu_control),

        .overflow(stack_overflow),
        .underflow(stack_underflow)
    );

    //REGISTER FILE

    assign write_reg = reg_dst ? instruction[15:12] : instruction[19:16]; //rd or rt based on reg_dst

    assign write_data = mem_to_reg ? memory_read_data : alu_result; //data to write based on mem_to_reg memory or ALU result

    register_file rf (
        .clk(clk),
        .rst(reset),
        .reg_write_enable(reg_write_enable),
        .read_reg1(instruction[23:20]), //rs
        .read_reg2(instruction[19:16]), //rt
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1), //data from rs
        .read_data2(read_data2) //data from rt
    );

    //DATA MEMORY
    data_memory dm (
        .clk(clk),
        .rst(reset),
        .mem_write_enable(mem_write),
        .mem_read_enable(mem_read),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(memory_read_data)
    );

    assign sign_ext_imm = {{16{instruction[15]}}, instruction[15:0]}; //16-bits to 32-bits sign extension
    assign sign_ext_imm_8 = {{24{instruction[15]}}, instruction[15:8]}; //8-bits to 32-bits sign extension

    assign alu_operand_b = alu_src ? sign_ext_imm : read_data2; //second ALU operand based on alu_src immediate or register

    //ALU
    alu alu_unit (
        .a(read_data1), //rs data
        .b(alu_operand_b), //rt data or immediate
        .shamt(instruction[10:6]), //shift amount for shift operations
        .alu_control(alu_control), //ALU control signals from control unit
        .result(alu_result), //ALU result
        .zero(alu_zero) //zero flag
    );

    assign neg_flag = alu_result[31]; //negative flag from ALU result MSB

    
    //STACK GUARD UNIT
    stack_guard sg (
        .next_sp(alu_result),
        .reg_write_enable(reg_write_enable),
        .write_reg(write_reg),
        .stack_overflow(stack_overflow),
        .stack_underflow(stack_underflow)
    );

    //NEXT PC LOGIC
    assign branch_target = pc_plus_4 + (sign_ext_imm << 2); //branch target address calculation
    assign branch_target_eqi = pc_plus_4 + (sign_ext_imm_8 << 2); //branch target address for beqi calculation
    assign jump_target = {pc_plus_4[31:28], instruction[23:0], 2'b00}; //jump target address calculation

    wire branch_taken_eq = branch_eq & alu_zero; //branch if equal taken
    wire branch_taken_lt = branch_lt & neg_flag; //branch if less than taken
    wire branch_taken_eqi = branch_eqi & alu_zero; //branch if equal immediate taken

    //priority: jump > branch > pc + 4
    assign pc_next = (jump) ? jump_target :
                     (branch_taken_eq || branch_taken_lt) ? branch_target :
                     (branch_taken_eqi) ? branch_target_eqi :
                     pc_plus_4;
endmodule