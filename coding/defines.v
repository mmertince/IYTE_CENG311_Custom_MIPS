//Mustafa Mert İnce
//STUDENT ID: 310201102

//OPCODE DEFINITIONS
//8-bit opcodes are defined here
`define OP_R_TYPE 8'h66  // Decimal: 102
`define OP_LW 8'h67  // Decimal: 103
`define OP_SW 8'h68  // Decimal: 104
`define OP_BEQ 8'h69  // Decimal: 105
`define OP_BLT 8'h6A  // Decimal: 106 
`define OP_SUBI 8'h6B  // Decimal: 107
`define OP_ADDI 8'h6C  // Decimal: 108
`define OP_BEQI 8'h6D  // Decimal: 109 
`define OP_J 8'h6E  // Decimal: 110

//FUNCTION CODE DEFINITIONS
//6-bit function codes for R-type instructions are defined here
`define FUNCT_SLL      6'b000001 // 1
`define FUNCT_MOVE     6'b000010 // 2
`define FUNCT_NAND     6'b000011 // 3
`define FUNCT_OR       6'b000100 // 4
`define FUNCT_ADD      6'b000101 // 5

/DEFINE ALU CONTROL LINES
//4-bit Custom ALU control lines are defined here
`define ALU_AND 4'b0000
`define ALU_OR 4'b0001
`define ALU_ADD 4'b0010 //used for add, addi, lw, sw
`define ALU_SUB 4'b0110 //used for subi, beq, blt
`define ALU_NAND4'b1100 
`define ALU_SLL 4'b1101 
`define ALU_MOVE 4'b1110

//DEFINE STACK PARAMETERS
`define SP_BASE_ADDR 32'd40 //Stack Pointer Base Address ($spba) = 40
`define SP_LIMIT_SIZE 32'd8 //Stack Pointer Limit ($spl) = 2 words (8 bytes)
`define STACK_TOP_LIMIT (`SP_BASE_ADDR - `SP_LIMIT_SIZE) //Stack Top Limit Address = 32, Valid Stack Range: [32, 40]
