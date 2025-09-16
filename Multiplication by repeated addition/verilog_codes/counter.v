module counter(clk,in,out,ld,dec);
    input [15:0] in;
    output reg [15:0]out;
    input clk,dec,ld;
    always@(posedge clk)
    begin 
        if(ld) begin
            out<=in;
            end
        else if(dec)begin
            out<=out-1;
            end
    end

endmodule
