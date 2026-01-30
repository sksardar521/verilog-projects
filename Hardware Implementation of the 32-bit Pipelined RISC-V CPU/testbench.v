`timescale 1ns / 1ps
module test_mips32;

    reg clk1,clk2;
    integer k;
    pipe_mips32 mips(clk1,clk2);
    initial
        begin
            clk1 =0; clk2=0;
            repeat(20)
                begin
                    #5 clk1=1; #5 clk1=0;
                    #5 clk2=1; #5 clk2=0;
                end
        end
    initial
        begin
            for(k=0;k<31;k=k+1)
                mips.regbank[k]=k; 
            mips.memory[0] = 32'h2801000a;  
            mips.memory[1] = 32'h28020014;
            mips.memory[2] = 32'h28030019; 
            mips.memory[3] = 32'h0ce77800; 
            mips.memory[4] = 32'h0ce77800; 
            mips.memory[5] = 32'h00222000; 
            mips.memory[6] = 32'h0ce77800; 
            mips.memory[7] = 32'h00832800; 
            mips.memory[8] = 32'hfc000000; 
            mips.HALTED = 0;
            mips.pc = 0;
            mips.TAKEN_BRANCH = 0;
            #220 $finish;
              
        end   
endmodule
