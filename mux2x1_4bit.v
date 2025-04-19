module mux2x1_4bit(x,z,sel,rst,y );
input [3:0]x,z;
input sel,rst;
output [3:0]y;
 
assign y = ( rst )? 0 : 
            (sel == 0)? x : z;
endmodule



