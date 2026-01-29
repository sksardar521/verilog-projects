`timescale 1ns / 1ps

module ahb_master(
    // AHB signals
    input CLK_MASTER,
    input RESET_MASTER,
    input HREADY,
    input [31:0]HRDATA,
    
    //user input signals
    input [31:0] data_top,
    input [31:0] addr_top,
    input write_top,
    input[3:0] beat_length,
    input enb,
    input wrap_enb,
    
    // AHB output signals
    output [31:0] HADDR,   // ADDRESS BUS
    output reg HWRITE,     // write control signal
    output reg [2:0]HSIZE, //transfer size
    output reg [31:0]HWDATA, // data bus
    output reg [1:0] HTRANS,
    output reg [2:0] HBURST,
    
    // user defined output signals
    output fifo_empty, fifo_full   
    );
    
    reg [2:0] p_state, n_state;
    reg [31:0] addr_internal=32'h0000_0000;
    integer i=0;
    reg [3:0] count=3'b000;
    reg hburst_internal;
    reg [31:0] internal_data;
    reg [7:0] wrap_base;
    reg [7:0] wrap_boundary;
    reg [31:0] prev_address;
    
    //fifo signals
    reg [3:0] wr_ptr,rd_ptr;
    reg [31:0] mem[14:0];
    parameter idle=3'b000, write_state_address=3'b001, read_state_address=3'b010,read_state_data=3'b011, write_state_data=3'b100;
    
    assign fifo_empty = (wr_ptr == rd_ptr);
    assign fifo_full = ((wr_ptr + 1)==rd_ptr);
    
    //fifo_reset_logic
    always@(posedge CLK_MASTER)
        begin
            if(RESET_MASTER)
            begin
                wr_ptr <= 0;
                rd_ptr <= 0;
                for(i=0;i<15;i=i+1)
                    begin
                        mem[i]<=0;
                        //wr_ptr <= 0;
                        //rd_ptr <= 0;
                    end
            end
            else if(write_top)
                begin
                    mem[wr_ptr] <= data_top;
                    wr_ptr <= wr_ptr+1'b1;
                end
        end
        
    // present state logic
    always@(posedge CLK_MASTER or RESET_MASTER)
    begin
        if(RESET_MASTER) 
            begin
                p_state = idle;
                count <= 0;
            end
        else 
            begin
                p_state <= n_state;
            end      
            // logic for INCR4
            if((p_state == write_state_data)&& beat_length == 4 && HREADY && wrap_enb == 0)
            begin
                count <= count+1'b1;
                rd_ptr <= rd_ptr + 1'b1;
                addr_internal <= addr_internal + 'h4 ;  // 4 because size of data is 4 bytes
            end
    end  
    
    //next state logic   
    always@(*)
        begin
            case(p_state)
                idle: begin
                        HSIZE = 'bx;
                        HBURST = 'bx;
                        HTRANS = 2'b00; //master is in idle state
                        HWDATA = 'bx;
                        count = 0;
                        addr_internal = addr_top;
                        
                        // LOGIC FOR WRITE OPERATION
                            // logic for incremental burst
                        if(write_top && HREADY && beat_length==1 && enb && wrap_enb == 0)
                            begin
                                n_state = write_state_address;
                                HBURST = 3'b000;
                                HWRITE = 1;                               
                            end
                            
                            // logic for INCR4 burst
                            else if (write_top && HREADY && beat_length==4 && enb && wrap_enb==0)
                                begin
                                    n_state = write_state_address;
                                    HBURST = 3'b011;
                                    HWRITE = 1'b1;
                                end 
                      end
                write_state_address : begin
                                          HSIZE = 3'b010;  // 4 byte
                                          HWRITE = 1'b1;
                                          if(HBURST == 3'b000)
                                               begin
                                                HTRANS = 2'b10;  // non seq transfer
                                                n_state = write_state_data;
                                               end
                                               
                                          //   logic for INCR4 burst    
                                          else if(HBURST == 3'b011)
                                            begin
                                                   HTRANS = 2'b10;
                                                   n_state = write_state_data; 
                                            end     
                                      end   
                                      
                                      
                write_state_data : begin
                    if(HBURST ==3'b000)
                        begin
                            if(HREADY) begin
                                n_state = idle;
                                HWDATA = data_top;
                                end
                        end 
                         //logic for INCR4 burst
                    else if(HBURST == 3'b011) // INCR4
                        begin
                            HWDATA = mem[rd_ptr];
                            HTRANS = 2'B11;  // seq transfer                   
                        
                        
                        if(count == beat_length-1)
                            begin
                                n_state = idle;
                            end  
                        else begin
                        n_state = write_state_data;
                        end
                        end
                    end
                    
                default : n_state = idle;    
            endcase
        end
        
        assign HADDR = addr_internal ;
        
endmodule











