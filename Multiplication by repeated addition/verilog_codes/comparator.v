module comparator(in,eq);
    input[15:0] in;   
    output  eq;  
    assign eq = (in==0);        
endmodule
