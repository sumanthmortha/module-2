`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2024 11:00:38 AM
// Design Name: 
// Module Name: reset_check
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


module reset_check();
 reg clk;
      reg reset_n;
      reg [7:0]input_tdata;
      reg input_tvalid;
      reg input_tlast;
      wire input_tready;
      wire [7:0]output_data;
      wire output_valid;
      wire output_last;
      reg  output_ready;
      
      axi_reg DUT(.clk(clk),.reset_n(reset_n),.input_tdata(input_tdata),.input_tvalid(input_tvalid),.input_tlast(input_tlast),.input_tready(input_tready),.output_data(output_data),.output_valid(output_valid),.output_last(output_last),.output_ready(output_ready)); 
      
      
      // Clock generation
  always #5 clk = ~clk;


  initial begin
    clk = 0;
    reset_n = 0; 
    input_tdata = 0;   
    input_tvalid = 0;
    input_tlast = 0;
    output_ready = 0;   // initial values
    
    repeat(2) @(posedge clk);  // time to settle for the initial data for 2 clock cycles
    
    reset_n = 1;             
  
    // Test scenario 1: Basic Functionality Test
     $display("Test Scenario 1: Basic Functionality Test");
    // Provide valid input data
    input_tdata = 8'hFF;
    input_tvalid = 1;
    input_tlast = 0;
    // Ensure output_ready is asserted
    output_ready = 1;
    // Wait for output valid
    repeat(10) @(posedge clk);
    // Check output
    if (output_valid && output_ready) begin
      if (output_data !== input_tdata)
        $display("ERROR: Output data mismatch!");
      else
        $display("Test Passed: Basic functionality test");
    end else
      $display("ERROR: Output not valid or ready!");
      
      // Test scenario 2: Reset Handling Test
    $display("Test Scenario 2: Reset Handling Test");
    // Reset the module
    reset_n = 1;
    repeat(3) @(posedge clk);
    reset_n = 0;
    // Provide valid input data
    input_tdata = 8'hAA;
    input_tvalid = 1;
    input_tlast = 1;
    // Ensure output_ready is asserted
    output_ready = 1;
    // Wait for output valid
    repeat(10) @(posedge clk);
    // Check output
    if (output_valid && output_ready) begin
      if (output_data !== 8'h00 || output_last !== 1'b0)
        $display("ERROR: Reset not handled properly!");
      else
        $display("Test Passed: Reset handling test");
    end else
      $display("ERROR: Output not valid or ready!");
   
    // test scenario : 3
    // changing the tvalid condition after each handshake of the output 
    repeat (5) begin
      reset_n =1;
      input_tvalid = 1;
      input_tdata = input_tdata + 1;
      output_ready = 1;
      repeat(1) @(posedge clk);
      input_tvalid = 0;
        // Check output
      @(posedge clk);
      end
     
      
     // changing the tready condition after handshake between input and output 
      repeat (5) begin
      reset_n =1;
      input_tvalid = 1;
      input_tdata = input_tdata + 1;
      output_ready = 1;
      repeat(1) @(posedge clk);
      output_ready = 0;
      @(posedge clk);
      end
      
      
      // making tvalid high before making tready as high
      repeat (5) begin
      reset_n =1;
      input_tvalid = 1;
      input_tdata = input_tdata + 1;
      output_ready = 0;
      @(posedge clk);
      end
      output_ready =1;
      repeat (2) @(posedge clk);
     
      
      
   /*  // making tvalid and tready opposite all the time
      repeat (5) begin
      reset_n =1;
      input_tvalid = 0;
      input_tdata = input_tdata + 1;
      output_ready = 1;
      repeat(2) @(posedge clk);
      input_tvalid =1;
      output_ready = 0;
      @(posedge clk);
      end
      
      reset_n = 0;
       repeat(2) @(posedge clk); // giving some idles
      
      */
      // tvalid is changing before data transmission is getting completed.
       repeat(5) begin
       input_tvalid =0;
       input_tdata = input_tdata + 1;
       output_ready = 0;
      repeat(1) @(posedge clk);
      input_tvalid =1;
      output_ready = 0;
       @(posedge clk);
       end
      
      
     
      
    $finish;
end


  

endmodule
