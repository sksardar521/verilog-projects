module adder(x,y,z);
    input [15:0]x,y;
    output reg[15:0]z;
    
    always@(*)
    begin
        z<=x+y;
    end
endmodule
