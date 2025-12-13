//Mustafa Mert İnce
//STUDENT ID: 310201102
//REGISTER FILE MODULE 16 x 32-bit registers

module register_file(
    input clk, //clock signal
    input rst //reset signal
    reg_write_enable, //register write enable signal
    input [3:0] read_reg1, //rs register number
    input [3:0] read_reg2, //rt register number
    input [3:0] write_reg, //rd or rt register number based on reg_dst
    input [31:0] write_data, //data to write into register
    output [31:0] read_data1, //data from rs register
    output [31:0] read_data2 //data from rt register
);

    //16 x 32-bit register array
    reg [31:0] registers [15:0];

    //SYNCHRONOUS WRITE OPERATION ON POSITIVE EDGE OF CLOCK
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            //TABLE 2 INITIAL VALUES
            registers[0] <= 32'd0; //$0
            registers[1] <= 32'd2; //$s0
            registers[2] <= 32'd3; //$s1
            registers[3] <= 32'd4; //$s2
            registers[4] <= 32'd2; //$s3
            registers[5] <= 32'd3; //$s4
            registers[6] <= 32'd6; //$t0
            registers[7] <= 32'd9; //$t1
            registers[8] <= 32'd4; //$t2
            registers[9] <= 32'd0; //$a0
            registers[10] <= 32'd0; //$a1
            registers[11] <= 32'd0; //$v0

            //STACK PARAMETERS
            registers[12] <= 32'd40; //$spba stack pointer base address 
            registers[13] <= 32'd2; //$spl stack pointer limit
            registers[14] <= 32'd0; //$sp stack pointer
            registers[15] <= 32'd0; //$ra return address
        end 
        else if (reg_write_enable) begin
            if (write_reg != 0) begin //prevent writing to $0 register
                registers[write_reg] <= write_data; //write data to register 
            end
