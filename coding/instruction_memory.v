//Mustafa Mert İnce
//STUDENT ID: 310201102
//INSTRUCTION MEMORY MODULE

module instruction_memory(
    input [31:0] pc, //program counter(address) input  
    output [31:0] instruction //32-bit retrieved instruction output
);

    //64 x 8-bit instruction memory
    reg [7:0] memory [0:63];

    //download instructions from external file into instruction memory
    initial begin
        $readmemb("simulation/instruction_memory3.dat", memory);
    end

    //big endian instruction fetch
    //concatenate 4 consecutive bytes to form 32-bit instruction
    assign instruction = {memory[pc], memory[pc + 1], memory[pc + 2], memory[pc + 3]};

endmodule