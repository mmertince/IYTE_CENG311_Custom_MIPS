//Mustafa Mert İnce
//STUDENT ID: 310201102
//TESTBENCH FOR PROCESSOR MODULE

`timescale 1ns / 1ps //time unit / time precision

module tb_processor;

    //CLOCK AND RESET SIGNALS
    reg clk;
    reg reset;
    
    //DEBUG SIGNALS FROM PROCESSOR
    wire [31:0] debug_pc;
    wire [31:0] debug_instruction;
    wire [31:0] debug_alu_result;
    wire debug_overflow;
    wire debug_underflow;

    //INSTANTIATE PROCESSOR MODULE(Unit Under Test)
    processor uut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_alu_result(debug_alu_result),
        .debug_overflow(debug_overflow),
        .debug_underflow(debug_underflow)
    );

    //CLOCK GENERATION
    initial begin
        clk = 0;
        forever #5 clk = ~clk; //every 5 ns toggle clock
    end

    //SIGNAL DUMP FOR WAVEFORM VIEWER
    initial begin
        $dumpfile("processor_sim.vcd");
        $dumpvars(0, tb_processor);
    end

    //TEST SEQUENCE
    initial begin
        //DISPLAY SIMULATION START MESSAGE
        $display("--------------------------------------------------");
        $display("Simulation is Starting...");
        $display("--------------------------------------------------");

        //INITIALIZE RESET
        reset = 1; //push reset button
        #10; //wait for 10 ns
        reset = 0; //release reset button

        $display("[%0t ns] Reset Released. Processor is Working.", $time);

        //RUN SIMULATION FOR 2000 ns
        #2000; 

        //FINISH SIMULATION
        $display("--------------------------------------------------");
        $display("Simulation is Completed.");
        $display("--------------------------------------------------");
        $finish; //finish and exit simulation
    end
endmodule