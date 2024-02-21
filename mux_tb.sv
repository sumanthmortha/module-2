`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2024 07:23:16 PM
// Design Name: 
// Module Name: mux_tb
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


module mux_tb( );// Define parameters

  parameter CLK_PERIOD = 10; // Clock period in simulation time units
  
  // Define signals
  reg clk;
  reg reset_n;
  reg sel_tdata;
  reg sel_tvalid;
  reg [7:0] input_tdata_0;
  reg input_tvalid_0;
  reg input_tlast_0;
  reg [7:0] input_tdata_1;
  reg input_tvalid_1;
  reg input_tlast_1;
  wire input_tready_0;
  wire input_tready_1;
  reg output_ready;
  wire sel_tready;
  wire [7:0] output_data;
  wire output_valid;
  wire output_last;
  
  // Instantiate the axi_mux module
  axi_mux mux_inst (
    .clk(clk),
    .reset_n(reset_n),
    .sel_tdata(sel_tdata),
    .sel_tready(sel_tready),
    .sel_tvalid(sel_tvalid),
    .input_tdata_0(input_tdata_0),
    .input_tvalid_0(input_tvalid_0),
    .input_tready_0(input_tready_0),
    .input_tlast_0(input_tlast_0),
    .input_tdata_1(input_tdata_1),
    .input_tvalid_1(input_tvalid_1),
    .input_tready_1(input_tready_1),
    .input_tlast_1(input_tlast_1),
    .output_data(output_data),
    .output_valid(output_valid),
    .output_last(output_last),
    .output_ready(output_ready)
  );
  
  // Initial values
  initial begin
    clk = 0;
    reset_n = 0;
    sel_tdata = 0;
    sel_tvalid = 0;
    input_tdata_0 = 0;
    input_tvalid_0 = 0;
    input_tlast_0 = 0;
    input_tdata_1 = 0;
    input_tvalid_1 = 0;
    input_tlast_1 = 0;
    output_ready = 0;
    
    // Call test tasks
    run_test_case_1();
    run_test_case_2();
    run_test_case_3();
    run_test_case_4();
    
    $finish;
  end
  
  // Clock generation task
  task generate_clock;
    begin
      forever #((CLK_PERIOD)/2) clk = ~clk;
    end
  endtask
  
  // Test case 1 task
  task run_test_case_1;
    begin
      $display("Running Test Case 1: Verify Mux Operation");
      
      // Apply data to input streams
      input_tdata_0 = 8'haa;
      input_tvalid_0 = 1;
      input_tlast_0 = 0;
      input_tdata_1 = 8'h55;
      input_tvalid_1 = 1;
      input_tlast_1 = 0;
      output_ready = 1;
      reset_n = 1;
      
      // Select input stream 0
      sel_tdata = 0;
      sel_tvalid = 1;
      #20;
      
      // Verify output data
      assert(output_data == 8'haa) else $error("Test Case 1 failed: Incorrect output data for input stream 0");
      
      // Select input stream 1
      sel_tdata = 1;
      #30;
      
      // Verify output data
      assert(output_data == 8'h55) else $error("Test Case 1 failed: Incorrect output data for input stream 1");
      # 5 output_ready = 0;
      reset_n = 0;
    end
  endtask

  // Test case 2 task
  task run_test_case_2;
    begin
      $display("Running Test Case 2: Verify Reset Behavior");
      
      // Assert reset
      reset_n = 0;
      #40;
      
      // Release reset
      reset_n = 1;
      #40;
      
      // Verify output data
      assert(output_data == 8'h00) else $error("Test Case 2 failed: Incorrect output data after reset");
    end
  endtask

 
  // Test case 3 task
  task run_test_case_3;
    begin
      $display("Running Test Case 3: Verify End-of-Packet Detection");
      
      // Apply valid data to input stream 0
      input_tdata_0 = 8'hAA;
      input_tvalid_0 = 1;
      input_tlast_0 = 0;
      sel_tdata = 0;
      output_ready = 1;
      #30;
      input_tlast_0 = 1; // Assert last signal
      #20;
      
      // Verify output last signal
      assert(output_last == 1) else $error("Test Case 3 failed: Output last signal not asserted at end of packet");
      #20 output_ready = 0;
      
    end
  endtask

  // Test case 4 task
  task run_test_case_4;
    begin
      $display("Running Test Case 4: Verify Flow Control");
      
      // Apply valid data to input stream 0
      input_tdata_0 = 8'hAA;
      input_tvalid_0 = 1;
      input_tlast_0 = 0;
      
      // Assert output ready signal intermittently
      output_ready = 0;
      #10;
      output_ready = 1;
      #10;
      output_ready = 0;
      #10;
      
      // Verify output data
      #20;
      assert(output_data == 8'hAA) else $error("Test Case 4 failed: Incorrect output data when output is ready");
      
      // Apply valid data to input stream 1
      input_tdata_1 = 8'h55;
      input_tvalid_1 = 1;
      input_tlast_1 = 0;
      sel_tdata = 1;
      
      // Assert output ready signal intermittently
      output_ready = 1;
      #10;
      output_ready = 0;
      #10;
      output_ready = 1;
      #10;
      
      // Verify output data
      #20;
      assert(output_data == 8'h55) else $error("Test Case 4 failed: Incorrect output data when output is ready");
    end
  endtask

  // Start clock generation task
  initial begin
    generate_clock;
  end
  
endmodule
