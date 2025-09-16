module pipoa(clk,in,out,ld);
    input clk,ld;
    output reg [15:0]out;
    input[15:0]in;
    always@(posedge clk)
        begin
            if(ld)
            begin
            out<=in;
            end
        end

endmodule
