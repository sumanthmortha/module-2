`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2024 09:50:29 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
input clk,
input reset_n,
input w_en,
input  r_en,
input [7:0]input_tdata,
input input_tvalid,
output input_tready,
input input_tlast,
output [7:0]output_tdata,
input output_tready,
output output_tvalid,
output output_tlast
    );
   
wire [7:0]input_tdata_2;
wire input_tvalid_2;
wire input_tready_2;
wire input_tlast_2;
wire [7:0]output_data_1;
wire output_ready_1;
wire output_valid_1;
wire output_last_1; 

fifo f1 (
.clk(clk),
.reset_n(reset_n),
.w_en(w_en),
.r_en(r_en),
.input_tdata(input_tdata),
.input_tvalid(input_tvalid),
.input_tready(input_tready),
.input_tlast(input_tlast),
.output_data(output_data_1),
.output_ready(output_ready_1),
.output_valid(output_valid_1),
.output_last(output_last_1)
);
    assign input_tdata_2 = output_data_1;
    assign input_tvalid_2 = output_valid_1;
    assign input_tlast_2 = output_last_1;
    assign output_ready_1 = input_tready_2;
    
fifo f2 (
.clk(clk),
.reset_n(reset_n),
.w_en(w_en),
.r_en(r_en),
.input_tdata(input_tdata_2),
.input_tvalid(input_tvalid_2),
.input_tready(input_tready_2),
.input_tlast(input_tlast_2),
.output_data(output_tdata),
.output_ready(output_tready),
.output_valid(output_tvalid),
.output_last(output_tlast)
);
    
endmodule
