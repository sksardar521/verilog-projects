`timescale 1ns / 1ps

module testbench;
    wire [15:0]z;
    reg[3:0] func,rs1,rs2,rd;
    reg[7:0] addr;
    reg clk1,clk2;
    integer k;
    pipeline_4 dut(.rs1(rs1), .rs2(rs2), .rd(rd), .addr(addr), .func(func), .clk1(clk1), .clk2(clk2));
    initial 
    begin
        clk1=1'b0;clk2=1'b0;
        
        repeat(20)
        begin
            #5 clk1 = 1'b1; 
            #5 clk1 = 1'b0;
            #5 clk2 = 1'b1;
            #5 clk2 = 1'b0;
        end     
    end
    
    initial
    begin
        for(k=0;k<=15;k=k+1) dut.regbank[k]=k;       
    end
    
    initial 
    begin
        #5 rs1=3; rs2=5; rd=10;func=0;addr=155;
        #20 rs1=3; rs2=8; rd=12;func=2;addr=156;
        #20 rs1=10; rs2=5; rd=14;func=1;addr=157;
        #20 rs1=7; rs2=3; rd=13;func=11;addr=158;
        
        #60 for(k=155;k<=158;k=k+1) $display("mem[%3d]=%3d",k,dut.mem[k]);
        
    end
    
    initial 
    begin
        //$dumpfile(pipeline_4.vcd);
        //$dumpvars(0,testbench);
        $monitor("Time: %3d, F=%3d", $time, z);
        #250 $finish;
    end
    
endmodule
