`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2024 03:06:27 PM
// Design Name: 
// Module Name: fifo_4096_tb
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


module fifo_4096_tb();
reg clk;
reg reset_n;
reg w_en;
reg r_en;
reg [7:0]input_tdata;
reg input_tvalid;
wire input_tready;
reg input_tlast;
wire [7:0]output_tdata;
reg output_tready;
wire output_tvalid;
wire output_tlast;

top dut2(
.clk(clk),
.reset_n(reset_n),
.w_en(w_en),
.r_en(r_en),
.input_tdata(input_tdata),
.input_tvalid(input_tvalid),
.input_tready(input_tready),
.input_tlast(input_tlast),
.output_tdata(output_tdata),
.output_tvalid(output_tvalid),
.output_tlast(output_tlast),
.output_tready(output_tready));

task automatic reset_task;
begin
repeat(3)@(negedge clk);
reset_n = ~reset_n;
end
endtask

task automatic fifo_write;
begin
w_en =1;
input_tdata = input_tdata + 1;
input_tvalid = 1;
repeat(1)@(negedge clk);
end
endtask

task automatic fifo_read;
begin
r_en = 1;
output_tready = 1;
repeat(1)@(posedge clk);
end
endtask


initial begin
clk = 0;
reset_n = 0;
r_en =0;
w_en = 0;
input_tdata = 0;
input_tvalid = 0;
input_tlast = 0;
output_tready = 0;
reset_task();
repeat(2)@(posedge clk);

repeat(4096) begin
fifo_write();
end
@(posedge clk);

repeat(10)@(posedge clk);

repeat (30) begin
fifo_write();
end
@(posedge clk);

w_en = 0;


repeat(4096)begin
fifo_read();
end
@(posedge clk)

r_en = 0;
repeat(10)@(posedge clk);

$finish;
end

endmodule
