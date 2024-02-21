`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 03:24:47 PM
// Design Name: 
// Module Name: axi_mux
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


module axi_mux(
input clk,
input reset_n,
input sel_tdata,
output sel_tready,
input sel_tvalid,
input [7:0]input_tdata_0,
input input_tvalid_0,
output input_tready_0,
input input_tlast_0,
input [7:0]input_tdata_1,
input input_tvalid_1,
output input_tready_1,
input input_tlast_1,
output [7:0]output_data,
output output_valid,
output output_last,
input output_ready
    );
    
     //reg
    reg [7:0]rdata;
    reg rvalid;
    reg rlast;
    reg rseldata;
    reg rselvalid;
    reg [7:0]r_output_data;
    reg r_output_valid;
    reg r_output_last;
    
    // assignment
    assign sel_tready = (!reset_n) ? 0 : 1;
    assign input_tready_0 = sel_tready;
    assign input_tready_1 = sel_tready;
    assign output_data = r_output_data;
    assign output_valid = r_output_valid;
    assign output_last = r_output_last;
    
    //select line
    always@(posedge clk)
    begin
    if(!reset_n)
    begin
    rseldata <= 0;
    rselvalid <= 0;
    end
    else if (sel_tvalid)
    begin
    rseldata <= sel_tdata;
    rselvalid <= 1;
    end
    end
    
    //input port
   always@(posedge clk)
   begin
   if(!reset_n) begin
   rdata <= 0;
   rvalid <= 0;
   rlast <= 0;
   end
   else   
   begin
           if (rseldata && input_tvalid_1 && sel_tready)    
           begin
           rdata <= input_tdata_1;
           rlast <= input_tlast_1;
           rvalid <= 1;
           end
           else if(input_tvalid_0 && sel_tready)
           begin
           rdata <= input_tdata_0;
           rlast <= input_tlast_0;
           rvalid <= 1;
           end
           else begin
           rdata <= rdata;
           rlast <= rlast;
           rvalid <= 0;
           end
           end
   end
   
   //output port
   
   always@(posedge clk)
   begin
   if(!reset_n) begin
   r_output_data <= 0;
   r_output_last <= 0;
   r_output_valid <= 0;
   end
   else if(output_ready && rvalid)
   begin
   r_output_data <= rdata;
   r_output_last <= rlast;
   r_output_valid <= 1;
   end
   else r_output_valid <= 0;
   end
   
   
endmodule
