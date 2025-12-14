//Mustafa Mert İnce
//STUDENT ID: 310201102

//OPCODE DEFINITIONS
//8-bit opcodes are defined here
`define OP_R_TYPE 8'd102  // Decimal: 102
`define OP_LW 8'd103 // Decimal: 103
`define OP_SW 8'd104 // Decimal: 104
`define OP_BEQ 8'd105  // Decimal: 105
`define OP_BLT 8'd106  // Decimal: 106 
`define OP_SUBI 8'd107  // Decimal: 107
`define OP_ADDI 8'd108  // Decimal: 108
`define OP_BEQI 8'd109  // Decimal: 109 
`define OP_J 8'd110  // Decimal: 110

//FUNCTION CODE DEFINITIONS
//6-bit function codes for R-type instructions are defined here
`define FUNCT_SLL      6'd1 // 1
`define FUNCT_MOVE     6'd2 // 2
`define FUNCT_NAND     6'd3 // 3
`define FUNCT_OR       6'd4 // 4
`define FUNCT_ADD      6'd5 // 5

//DEFINE ALU CONTROL LINES
//4-bit Custom ALU control lines are defined here
`define ALU_AND 4'b0000
`define ALU_OR 4'b0001
`define ALU_ADD 4'b0010 //used for add, addi, lw, sw
`define ALU_SUB 4'b0110 //used for subi, beq, blt
`define ALU_NAND 4'b1100 
`define ALU_SLL 4'b1000
`define ALU_MOVE 4'b1010
`define ALU_SLT 4'b0111

//DEFINE STACK PARAMETERS
`define SP_BASE_ADDR 32'd40 //Stack Pointer Base Address ($spba) = 40
`define SP_LIMIT_SIZE 32'd8 //Stack Pointer Limit ($spl) = 2 words (8 bytes)
`define STACK_TOP_LIMIT (`SP_BASE_ADDR - `SP_LIMIT_SIZE) //Stack Top Limit Address = 32, Valid Stack Range: [32, 40]
