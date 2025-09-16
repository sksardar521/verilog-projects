module controlpath(ld_a,ld_b,ld_p,clr_p,dec_b,eqz,start,done,clk);
    input start,clk,eqz;
    output reg ld_a,ld_b,ld_p,clr_p,dec_b,done;
    reg [2:0]state;
    parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100;
    always@(posedge clk)
        begin
            case(state)
                s0:begin 
                    if(start)
                        state<=s1;
                   end
                s1:begin 
                    
                        state<=s2;
                   end
                s2:begin 
                    
                        state<=s3;
                   end
                s3:begin 
                    
                       #2 if(eqz) state<=s4;
                   end 
                s4:begin 
                    
                        state<=s4;
                   end  
                default: state<=s0;   
            endcase
        end
        always@(state)
        begin
            case(state)
            s0:begin 
                    #1 ld_a=0;ld_b=0;ld_p=0;clr_p=0;dec_b=0;
                   end
            s1:begin 
                    #1 ld_a=1;
                   end
            s2:begin 
                    #1 ld_a=0;ld_b=1;clr_p=1;
                   end
            s3:begin 
                    #1 ld_b=0;ld_p=1;clr_p=0;dec_b=1;
                   end
            s4:begin 
                    #1 done=1;ld_b=0;ld_p=0;dec_b=0;
                   end
            default: begin 
                    #1 ld_a=0;ld_b=0;ld_p=0;clr_p=0;dec_b=0;
                   end      
            endcase
        end
    

endmodule
