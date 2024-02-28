`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2024 05:05:12 PM
// Design Name: 
// Module Name: fifo
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


module fifo(
input clk,
input reset_n,
input w_en,
input r_en,
input [7:0]input_tdata,
input input_tvalid,
output input_tready,
input input_tlast,
output [7:0]output_data,
input output_ready,
output output_valid,
output output_last
    );
    
    reg [7:0]rdata;
    reg rvalid;
    reg rlast;
    reg [11:0] w_ptr;
    reg [11:0]r_ptr;
    reg [11:0]count;
    reg [7:0]mem[2047:0];
    reg empty = 1;
    reg full = 0;
    reg [7:0]r_output_data;
    reg r_output_valid;
    reg r_output_last;
    reg r_output_ready;
    
 integer i;
    // mem initiliazation to 0;
    initial begin
    // Initialize mem to all zeros
    for (i = 0; i < 2048; i = i + 1) begin
        mem[i] = 8'h00; // 8'h00 represents an 8-bit value of all zeros
    end
end
    //assigning operator
    assign input_tready = (full)?0:1; 
    assign output_data = r_output_data;
    assign output_valid = r_output_valid;
    assign output_last = r_output_last; 
    // condition for empty and full
    always@(count)
    begin
    empty <= (count == 0);
    full <= (count == 12'd2048);
    end
    
    
    //block for fifo count 
    always@(posedge clk)
    begin
    if(!reset_n) count <= 0;
    else if((!full && w_en && rvalid) && (!empty && r_en && output_ready)) count <= count;
    else if(!full && w_en && rvalid) count <= count + 1;
    else if(!empty && r_en && output_ready) count <= count - 1;
    else count <= count;
    end
    
    
    // block for write pointer and read pointer
    always@(posedge clk)
    begin
    if(!reset_n)
    begin
    w_ptr <= 0;
    r_ptr <= 0;
    end
    else  begin
             if (!full && w_en && rvalid) w_ptr <= w_ptr + 1;
             else w_ptr <= w_ptr;
             if (!empty && r_en && output_ready) r_ptr <= r_ptr + 1;
             else r_ptr <= r_ptr; 
    end
    end
    
    
    //data transfer axi input
    always@(posedge clk)
    begin
    if(!reset_n)
    begin
   rdata <= 0;
   rvalid <= 0;
   rlast <= 0; 
    end
    else if(input_tvalid && input_tready)
    begin
    rdata <= input_tdata;
    rvalid <= 1;
    rlast <= input_tlast;
    end
    end
    
    //registering the output_ready
    always@(posedge clk)
    begin
    if(!reset_n) r_output_ready <= 0;
    else r_output_ready <= output_ready;
    end
    
    
    // data to output
    always@(posedge clk)
    begin
    if (!reset_n) 
    begin
    r_output_data <= 0;
    r_output_valid <= 0;
    r_output_last <= 0;
    end
    else begin
         if(r_en && !empty && r_output_ready) begin
         r_output_data <= mem[r_ptr];
         r_output_valid <= 1;
         r_output_last <= rlast;
         end
         else begin
         r_output_data <= output_data;
         r_output_valid <= 0;
         r_output_last <= output_last;
         end
    end
    end
    
    // data input 
    always@(posedge clk)
    begin
    if(w_en && !full && input_tready && rvalid) mem[w_ptr] <= rdata;
    else mem[w_ptr] <= mem[w_ptr];
    end
    
endmodule

