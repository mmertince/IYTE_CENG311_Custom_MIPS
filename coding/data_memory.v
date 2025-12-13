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
    //loop variable for initialization
    integer i;

    //READ OPERATION (COMBINATIONAL)
    //CONCATINATE 4 BYTES TO FORM 32-BIT DATA(BIG-ENDIAN)
    //IF mem_read_enable IS 0, OUTPUT ZERO
    assign read_data = (mem_read_enable) ? {memory[address], memory[address + 1], memory[address + 2], memory[address + 3]} : 32'b0

    //WRITE OPERATION (SYNCHRONOUS)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            //INITIALIZE MEMORY TO ZERO ON RESET
            for (i = 0; i < 64; i = i + 1) begin
                memory[i] <= 8'b0;
            end

            //TABLE 3 INITIAL VALUES
            //EACH LINE 4 BYTES (32 BITS)
            //16 LINES TOTAL
            
            {memory[0], memory[1], memory[2], memory[3]} <= 32'd1;
            
            {memory[4], memory[5], memory[6], memory[7]} <= 32'd2;
            
            {memory[8], memory[9], memory[10], memory[11]} <= 32'd2;
            
            {memory[12], memory[13], memory[14], memory[15]} <= 32'd5;
            
            {memory[16], memory[17], memory[18], memory[19]} <= 32'd3;
            
            {memory[20], memory[21], memory[22], memory[23]} <= 32'd3;
            
            {memory[24], memory[25], memory[26], memory[27]} <= 32'd56;
            
            {memory[28], memory[29], memory[30], memory[31]} <= 32'd5;

            
            //START OF OUR STACK AREA
            
            {memory[32], memory[33], memory[34], memory[35]} <= 32'd34;
            
            {memory[36], memory[37], memory[38], memory[39]} <= 32'd0;
            
            //END OF OUR STACK AREA
            
            {memory[40], memory[41], memory[42], memory[43]} <= 32'd0;

            {memory[44], memory[45], memory[46], memory[47]} <= 32'd0;

            {memory[48], memory[49], memory[50], memory[51]} <= 32'd0;
            
            {memory[52], memory[53], memory[54], memory[55]} <= 32'd0;

            {memory[56], memory[57], memory[58], memory[59]} <= 32'd0;

            {memory[60], memory[61], memory[62], memory[63]} <= 32'd0;

        end
        
        else if (mem_write_enable) begin
            //WRITE 32-BIT DATA AS 4 X 8-bits (BIG-ENDIAN)
            memory[address] <= write_data[31:24]; //most significant byte
            memory[address + 1] <= write_data[23:16];
            memory[address + 2] <= write_data[15:8];
            memory[address + 3] <= write_data[7:0];//least significant byte
        end
    end
endmodule