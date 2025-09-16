`timescale 1ns / 1ps
module testbench;
    reg[15:0] data_in;
    reg clk,start;
    wire done;
    datapath dut1(ld_a,ld_b,ld_p,clr_p,dec_b,eqz,data_in,clk);
    controlpath dut2(ld_a,ld_b,ld_p,clr_p,dec_b,eqz,start,done,clk);
    initial 
    begin 
        clk=1'b0;
        #3 start = 1'b1;
        #100 $finish;
    end
    always #5 clk=~clk;
    initial 
    begin
        #17 data_in=17;
        #10 data_in=5;
    end
    
endmodule
