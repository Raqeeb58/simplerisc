
module simplerisc_TB;
reg clk,rst;  // Clock and reset signals for the testbench

top_module uut(.clk(clk),.rst(rst)); // Instantiate the top_module as the Unit Under Test (UUT)

initial
begin
    clk=0;
    forever #5 clk = ~clk; // Generate a clock signal with a period of 10ns
end
initial
begin
    rst=1;
    #6 rst=0;
    #1000 $finish;
end

    
endmodule
