`include "network_params.vh"
/*
   this module contains two function: 
    1.buffer the 4rows of input image date 
    2.make a matrix_buffer to do convolution operation 
   in this module,the size of input image is 28*28 and the kernel size is 5 * 5
*/

module image_buffer(clk,rst_n,image_in,image_out);
input clk;
input rst_n;
input image_in;
output image_out;

genvar i;
genvar j;

wire [`IMAGE_IN_BIT_WIDTH-1:0] image_in;
wire [7:0] matrix_buffer_wire[4:0][4:0];
wire [7:0] buffer_wire[112:0];
wire [25*8-1:0] image_out;

generate
    for(j=1;j<113;j=j+1) begin:image_in_buffer
        buffer_unit my_buffer_unit(clk,rst_n,buffer_wire[j-1],buffer_wire[j]);
    end
endgenerate

generate
    for(i=0;i<5;i=i+1) begin:matrix_buffer_1
        for(j=1;j<5;j=j+1) begin:matrix_buffer_2
            buffer_unit my_matrix_buffer1(clk,rst_n,matrix_buffer_wire[i][j-1],matrix_buffer_wire[i][j]);
        end
    end  
endgenerate


generate 
    for(i=1;i<5;i=i+1) begin:matrix_buffer_0
       buffer_unit my_matrix_buffer2(clk,rst_n,buffer_wire[28*i],matrix_buffer_wire[i][0]);
    end
endgenerate
buffer_unit my_matrix_buffer3(clk,rst_n,buffer_wire[0],matrix_buffer_wire[0][0]);


assign buffer_wire[0] = image_in;
//assign image_out = matrix_buffer_wire[4][4];

generate
    for(i=0;i<5;i=i+1) begin:image_out_1
        for(j=0;j<5;j=j+1) begin:image_out_2
           assign image_out[(i*5+j+1)*8-1:(i*5+j)*8]=matrix_buffer_wire[i][j];
        end
    end

endgenerate
endmodule

 
module buffer_unit(clk,rst_n,in,out);
input clk;
input rst_n;
input in;
output out;
wire [7:0] in;
reg [7:0] out;
 
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            out <= 8'b0;
        else
            out <= in;
    end   
endmodule