`timescale 1ns / 1ps

module ahb_slave(
     input HCLK,
     input HRESET,
     input [31:0] HADDR,
     input HWRITE,
     input [2:0] HSIZE,
     input [2:0] HBURST,
     input [1:0] HTRANS,
     input [31:0] HWDATA,
     output reg HREADY,
     output HRESP,
     output reg [31:0] HRDATA
    );
    
    parameter idle = 2'b00, sample_state = 2'b01, write_state = 2'b10, write_state_ready = 2'b11;
    
    reg [1:0] p_state,n_state;
    reg [1:0] htrans_internal;
    reg hwrite_internal;
    reg [31:0] addr_internal;
    
    
    // present state logic
    always@(posedge HCLK)
        begin
            if(HRESET)
                begin
                p_state <= idle;
                end
            else begin
            p_state <= n_state;
            end
        end 
        
        // next state logic
        always@(*)
            begin
                case(p_state)
                    idle: begin
                              HREADY =1;
                              n_state = sample_state;
                          end
                    sample_state: begin
                                    htrans_internal = HTRANS;
                                    hwrite_internal = HWRITE;
                                    addr_internal = HADDR;
                                    if(htrans_internal == 2'b10 || htrans_internal == 2'b11)
                                        begin
                                            if(hwrite_internal)
                                                begin n_state = write_state; end
                                        end
                                        
                                  end      
                    write_state: begin
                    
                        HRDATA = HWDATA;
                        if(htrans_internal == 2'b00)
                             n_state = idle;
                    end      
                endcase          
            end
           
endmodule











