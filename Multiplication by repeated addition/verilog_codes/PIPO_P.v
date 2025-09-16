module pipop(clk,in,out,clr,ld);
    input [15:0] in;
    output reg [15:0]out;
    input clk,clr,ld;
    always@(posedge clk)
    begin
    if(clr)
        begin
            out<=16'b0;
        end
    else if(ld) begin
        out<=in;
        end
            
    
    end

endmodule
