`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2024 11:29:09 AM
// Design Name: 
// Module Name: fifo_tb
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


module fifotb();

 // Define parameters
  parameter CLK_PERIOD = 10; // Clock period in simulation time units
  
reg clk;
reg reset_n;
reg w_en, r_en;
reg [7:0]input_tdata;
reg input_tvalid;
wire input_tready;
reg input_tlast;
wire [7:0]output_tdata;
reg output_tready;
wire output_tvalid;
wire output_tlast;

integer file;

top d1 (.clk(clk),.reset_n(reset_n),.w_en(w_en),.r_en(r_en),.input_tdata(input_tdata),.input_tvalid(input_tvalid),.input_tready(input_tready),.input_tlast(input_tlast),.output_tdata(output_tdata),.output_tready(output_tready),.output_tvalid(output_tvalid),.output_tlast(output_tlast));

// Initial values
  initial begin
    clk = 0;
    reset_n = 0;
    w_en = 0;
    r_en = 0;
    input_tdata = 8'h00;
    input_tvalid = 0;
    input_tlast = 0;
    output_tready = 0;
    
    // Call test tasks
    run_test_case_1();
    run_test_case_2();
    run_test_case_3();
    run_test_case_4();
    run_test_case_5();
    
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
      $display("Running Test Case 1: Write and Read Data");
      
      // Assert reset
      reset_n = 0;
      #40;
      
      // Release reset
      reset_n = 1;
      #40;
      
      // Write data
      w_en = 1;
      input_tdata = 8'hAA;
      input_tvalid = 1;
      input_tlast = 0;
      output_tready =1;
      #20;
      
      // Read data
      r_en = 1;
      #215;
      
      // Verify output data
      assert(output_tvalid == 1 && output_tdata == 8'hAA) else $error("Test Case 1 failed: Incorrect output data");
    end
  endtask

  // Test case 2 task
  task run_test_case_2;
    begin
      $display("Running Test Case 2: Full FIFO Handling");
      
      // Assert reset
      reset_n = 0;
      #40;
      
      // Release reset
      reset_n = 1;
      #40;
      
      // Fill FIFO
      w_en = 1;
      r_en = 0;
      input_tdata = 0;
      input_tvalid = 1;
      input_tlast = 0;
      repeat(2048)
      begin
      input_tdata = input_tdata + 1;
       @(posedge clk);
       end
      
      // Attempt to write more data
      input_tdata = 8'hFF;
      input_tvalid = 1;
      input_tlast = 0;
      #20;
      
      // Verify FIFO full condition
      assert(output_tvalid == 0) else $error("Test Case 2 failed: FIFO not handling full condition");
    end
  endtask

  // Test case 3 task
  task run_test_case_3;
    begin
      $display("Running Test Case 3: Empty FIFO Handling");
      
      // Assert reset
      reset_n = 0;
      #40;
      
      // Release reset
      reset_n = 1;
      #40;
      
      // Verify FIFO empty condition
      assert(output_tvalid == 0) else $error("Test Case 3 failed: FIFO not handling empty condition");
    end
  endtask

  // Test case 4 task
  task run_test_case_4;
    begin
      $display("Running Test Case 4: Data Integrity and Packet Boundary");
      
      // Assert reset
      reset_n = 0;
      #40;
      
      // Release reset
      reset_n = 1;
      #40;
      
      // Write data
      w_en = 1;
      input_tdata = 8'hAA;
      input_tvalid = 1;
      input_tlast = 1; // End of packet
      #20;
      
      // Read data
      r_en = 1;
      #20;
      
      // Verify output data and last signal
      assert(output_tvalid == 1 && output_tdata == 8'hAA && output_tlast == 1) else $error("Test Case 4 failed: Incorrect output data or last signal");
    end
  endtask

  // Test case 5 task
  task run_test_case_5;
    begin
      $display("Running Test Case 5: Flow Control");
      
      // Assert reset
      reset_n = 0;
      #40;
      
      // Release reset
      reset_n = 1;
      #40;
      
      // Write data
      w_en = 1;
      input_tdata = 8'hAA;
      input_tvalid = 1;
      input_tlast = 0;
      #20;
      
      // Read data
      r_en = 1;
      #20;
      
      // Verify output data and flow control
      assert(output_tvalid == 1 && output_tdata == 8'hAA && input_tready == 1 && output_tready == 1) else $error("Test Case 5 failed: Incorrect flow control or output data");
    end
  endtask

  // Start clock generation task
  initial begin
    generate_clock;
  end
  
  
  
endmodule
