`timescale 1ns / 1ps

module pipeline_4(zout,rs1,rs2,rd,addr,func,clk1,clk2);
        input [3:0] rs1,rs2,rd,func;
        input [7:0] addr;
        input clk1,clk2;
        output [15:0] zout;
        
        // intermediate latches decleration
        reg [15:0] l12_a,l12_b,l23_z,l34_z;
        reg [3:0] l12_func,l12_rd,l23_rd;
        reg [7:0] l12_addr,l23_addr,l34_addr;
        
        //storage elements
        reg [15:0] regbank [0:15];
        reg [15:0] mem [0:255];
        assign zout = l23_z;
        always@(posedge clk1)
        begin
            l12_a<=#2regbank[rs1];
            l12_b<=#2regbank[rs2];
            l12_func<=#2func;
            l12_addr<=#2addr;
            l12_rd<=#2rd;                              
        end
        always@(posedge clk2)
        begin
            case(func)
                4'b0000: l23_z<=#2 l12_a+l12_b;
                4'b0001: l23_z<=#2 l12_a-l12_b;
                4'b0010: l23_z<=#2 l12_a*l12_b;
                4'b0011: l23_z<=#2 l12_a;
                4'b0100: l23_z<=#2 l12_b;
                4'b0101: l23_z<=#2 l12_a&l12_b;
                4'b0110: l23_z<=#2 l12_a|l12_b;
                4'b0111: l23_z<=#2 l12_a^l12_b;
                4'b1000: l23_z<=#2 ~l12_a;
                4'b1001: l23_z<=#2 ~l12_b;
                4'b1010: l23_z<=#2 l12_a>>1;
                4'b1011: l23_z<=#2 l12_a<<1;
                default: l23_z<=#2 16'hxxxx;              
            endcase
            
            l23_rd<=#2 l12_rd;
            l23_addr<=#2 l12_addr;
        end
        
        // stage 3
        
        always@(posedge clk1)
        begin
            regbank[l23_rd]<=#2 l23_z;
            l34_addr<=#2 l23_addr;
            l34_z<=#2 l23_z;
        end
        
        //stage 4
        always@(posedge clk2)
        begin
        mem[l34_addr]<=#2 l34_z;
        end
        
        
endmodule




