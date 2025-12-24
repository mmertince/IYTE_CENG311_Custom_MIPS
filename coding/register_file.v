//Mustafa Mert İnce
//STUDENT ID: 310201102
//REGISTER FILE MODULE 16 x 32-bit registers

module register_file(
    input clk, //clock signal
    input rst, //reset signal
    input reg_write_enable, //register write enable signal
    input [3:0] read_reg1, //rs register number
    input [3:0] read_reg2, //rt register number
    input [3:0] write_reg, //rd or rt register number based on reg_dst
    input [31:0] write_data, //data to write into register
    output [31:0] read_data1, //data from rs register
    output [31:0] read_data2 //data from rt register
);

    //16 x 32-bit register array
    reg [31:0] registers [15:0];

    //Pre-initialize registers from file at time 0
    initial begin
        $readmemb("./simulation/register_file.dat", registers);
    end

    //ASYNCHRONOUS READ OPERATION
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

    //INITIALIZE FROM .dat FILE ON RESET
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            //TABLE 2 INITIAL VALUES - reload from file on reset
            $readmemb("./simulation/register_file.dat", registers);
        end 
        else if (reg_write_enable) begin
            if (write_reg != 0) begin //prevent writing to $0 register
                registers[write_reg] <= write_data; //write data to register 
            end
        end
    end
endmodule
