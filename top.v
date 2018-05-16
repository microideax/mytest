`include "network_params.vh"

module top(clk,rst_n,image_in);
input clk;
input rst_n;
input[`IMAGE_IN_BIT_WIDTH-1:0] image_in;

wire [(`KERNEL_SIZE * `KERNEL_SIZE)* `IMAGE_IN_BIT_WIDTH - 1:0] image_out;

//wire [(`KERNEL_SIZE * `KERNEL_SIZE)*`KERNEL_WIDTH-1:0] kernel;

image_buffer my_image_buffer(.clk(clk),.rst_n(rst_n),.image_in(image_in),.image_out(image_out));







endmodule
