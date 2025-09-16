module datapath(ld_a,ld_b,ld_p,clr_p,dec_b,eqz,data_in,clk);
    input ld_a,ld_b,ld_p,clr_p,dec_b,clk;
    input [15:0]data_in;
    output eqz;
    wire[15:0] x,y,z,b_out;
    pipoa A(.clk(clk), .in(data_in), .out(x), .ld(ld_a));
    pipop P(.clk(clk), .in(z), .out(y), .clr(clr_p), .ld(ld_p));
    comparator comp(.in(b_out), .eq(eqz));
    counter B(.clk(clk), .in(data_in), .out(b_out), .ld(ld_b), .dec(dec_b));
    adder D(.x(x), .y(y), .z(z));
endmodule
