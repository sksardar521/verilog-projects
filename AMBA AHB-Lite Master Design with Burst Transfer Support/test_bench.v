`timescale 1ns / 1ps

module ahb_tb();
    
    reg clk,rst;
    reg [31:0] data_top;
    reg write_top;
    reg wrap_enb;
    wire hready, hresp;
    wire [31:0] hrdata;
    reg enb;
    reg [31:0] addr_top;
    wire [31:0] HADDR;
    wire HWRITE;
    wire [2:0] HSIZE;
    wire [2:0] HBURST;
    wire [1:0] HTRANS;
    wire [31:0] HWDATA;
    
    reg [3:0] beat_length;
    wire fifo_empty,fifo_full;
    
    
    ahb_master dut1 (.CLK_MASTER(clk), .RESET_MASTER(rst), .HREADY(hready), .HRDATA(hrdata),
                    .data_top(data_top), .addr_top(addr_top), .write_top(write_top), .beat_length(beat_lenght),
                    .enb(enb), .wrap_enb(wrap_enb), .HADDR(HADDR), .HWRITE(HWRITE), .HSIZE(HSIZE),
                    .HWDATA(HWDATA), .HTRANS(HTRANS), .HBURST(HBURST) );
    
    ahb_slave dut2 (.HCLK(clk), .HRESET(rst), .HADDR(HADDR), .HWRITE(HWRITE), .HSIZE(HSIZE),
                    .HBURST(HBURST), .HTRANS(HTRANS), .HWDATA(HWDATA), .HREADY(HREADY), .HRESP(HRESP),
                    .HRDATA(HRDATA));
    
    
    
     initial {clk,rst,beat_length}=0;
     always #5 clk=~clk;
     
     initial 
        begin
            rst =1;
            #10 rst = 0;
            //if(!fifo_full)
             //begin
                write_top=1;
                addr_top=32'h00000000;
                data_top = 32'h00000001;
                #10 data_top = 32'h12341234;
                #10 data_top=32'h00000000;
                #10 data_top=32'h00000002;
                #10 data_top=32'h00000003;
                
                beat_length = 4;
                enb=1;
                wrap_enb = 0;
                #20 enb=0;
                
             //end
             #30 $finish;
         end    
          
    
endmodule













