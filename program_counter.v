///////////////////////////////////////////////////////////////////////////////
// Program Counter Module
///////////////////////////////////////////////////////////////////////////////
// Holds the current program counter value.
// Updates to pcnext on clock edge, resets to 0 on rst
module program_counter(clk,rst,pcnext,pc);
input [31:0]pcnext;
input clk,rst;
output reg [31:0]pc;

always@(posedge clk or posedge rst )
begin
    if(rst)
        begin
            pc <= 32'h00000000; 
        end
    else
        begin
            pc <= pcnext;   
        end
end

    
endmodule
