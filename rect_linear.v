//this module is a RELU 
module rect_linear(
     clk,
     rst_n,
     function_in,
     function_out
    );

input clk;
input rst_n;
input [8:0]function_in;
output [8:0]function_out;    
    
reg [8:0]function_out;

always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            function_out <= 9'b0;
        else if(function_in[8] == 1'b1)
            function_out <= 9'b0;
        else 
            function_out <=  function_in;
    end
endmodule
