//Mustafa Mert İnce
//STUDENT ID: 310201102
//DATA MEMORY MODULE

module data_memory(
    input clk, //clock signal
    input rst, //reset signal
    input mem_write_enable, //memory write enable signal
    input mem_read_enable, //memory read enable signal
    input [31:0] address, //memory address input
    input [31:0] write_data, //data to write into memory
    output [31:0] read_data //data read from memory
);

    //64 x 8-bit data memory
    reg [7:0] memory [0:63];
    integer i;

    // Load memory from .dat file at simulation start and on reset
    initial begin
        $readmemb("data_memory.dat", memory);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            $readmemb("simulation/data_memory.dat", memory);
        end
        else if (mem_write_enable) begin
            //WRITE 32-BIT DATA AS 4 X 8-bits (BIG-ENDIAN)
            memory[address]     <= write_data[31:24]; //most significant byte
            memory[address + 1] <= write_data[23:16];
            memory[address + 2] <= write_data[15:8];
            memory[address + 3] <= write_data[7:0];   //least significant byte
        end
    end

    //READ OPERATION (COMBINATIONAL)
    assign read_data = (mem_read_enable) ? {memory[address], memory[address + 1], memory[address + 2], memory[address + 3]} : 32'b0;

endmodule