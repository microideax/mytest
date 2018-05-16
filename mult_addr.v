//this module should have a state bit to show if the final addder value is ready
//but it is not designed !!!

module mult_addr(clk,rst_n,feature_in,kernel,feature_out);

input clk;
input rst_n;
input[25*9-1:0] feature_in;
input[25*2-1:0] kernel;
output[8:0] feature_out;

wire[8:0] mult_out[24:0];
wire[8:0] adder_tree_wire[48:0];
wire[48:0]carry_wire;


assign feature_out = adder_tree_wire[0];

genvar i;
generate
for(i=0;i<25;i=i+1) begin:conv_mult
    select_unit my_select_unit(
        .clk(clk),
        .rst_n(rst_n),
        .feature_in(feature_in[i*9+8:i*9]),
        .kernel(kernel[i*2+1:i*2]),
        .mult_out(mult_out[i])
    );
end
endgenerate


generate
    for(i=0;i<25;i=i+1) begin:mult_out_shift
        assign adder_tree_wire[i+24] = mult_out[i];
    end
endgenerate


assign carry_wire[48:24] =25'd0;


generate 
    for(i=48;i>=1;i=i-2) begin:conv_add
    adder_unit my_adder_unit(
        .clk(clk),
        .rst_n(rst_n),
        .adder_a(adder_tree_wire[i-1]),
        .adder_b(adder_tree_wire[i]),
        .carry_a(carry_wire[i-1]),
        .carry_b(carry_wire[i]),
        .adder_out(adder_tree_wire[(i/2)-1]),
        .carry_out(carry_wire[(i/2)-1])
        //.carry_out(carry_wire[0])
    );
    end
endgenerate




endmodule



module select_unit(clk,rst_n,feature_in,kernel,mult_out);

input clk;
input rst_n;
input signed [8:0] feature_in;
input signed [1:0] kernel;
output [8:0]mult_out;

reg signed [8:0]product;

always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            product <= 9'b0;
        else
            if(kernel == 0)
                product <= 0;
            else if(kernel == -1)
                product <= -feature_in;
            else if(kernel == 1)
                product <= feature_in;
    end
assign mult_out = product;
endmodule


module adder_unit(clk,rst_n,adder_a,adder_b,carry_a,carry_b,adder_out,carry_out);
input clk;
input rst_n;
input [8:0] adder_a;
input [8:0] adder_b;
input carry_a;
input carry_b;
output [8:0]adder_out;
output carry_out;

reg [8+1:0]sum;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sum <= 10'b0;
    else
        sum <= adder_a + adder_b;
end
assign adder_out = sum[8:0];

assign carry_out = sum[9];// | carry_a |carry_b;
endmodule