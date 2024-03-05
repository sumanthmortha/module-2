`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 11:09:40 AM
// Design Name: 
// Module Name: axi_reg
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


module axi_reg(
      input clk,
      input reset_n,
      
      input [7:0]input_tdata,
      input input_tvalid,
      input input_tlast,
      output input_tready,
      
      output [7:0]output_data,
      output output_valid,
      output output_last,
      input  output_ready 
    );
   
    reg [7:0]r_output_data;
    reg r_output_valid;
    reg r_output_last;
    
    reg [7:0]r_input_tdata;
    reg r_input_tlast;
    reg r_output_ready;
    
    
    assign input_tready = output_ready;
    assign output_data = r_output_data;
    assign output_valid = r_output_valid;
    assign output_last = r_output_last;
    
 
 //registering the inputs
 
    always@(posedge clk)
    begin
    if(!reset_n)
    begin
    r_input_tdata<=0;
    r_input_tlast<=0;
    end
    else if(input_tvalid && input_tready)
    begin
    r_input_tdata <= input_tdata;
    r_input_tlast <= input_tlast;
    end
    else begin 
    end
   end
   
   always@(posedge clk)
   begin
   if(!reset_n) r_output_ready <=0;
   else r_output_ready <= output_ready;
   end
    // output ports
    always@(posedge clk)
    begin
    if(!reset_n)
    begin
    r_output_data <= 0;
    r_output_last <= 0;
    r_output_valid <= 0;
    end
    else if(r_output_ready)
    begin
    r_output_data <= r_input_tdata;
    r_output_valid <= 1;
    r_output_last <= r_input_tlast;
    end
    else begin
     r_output_valid <= r_output_valid;
     r_output_data <= r_output_data ;
     r_output_last <= r_output_last;
     end
    end
    
    
endmodule
