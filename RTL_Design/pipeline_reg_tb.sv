module pipeline_reg_tb;

    // Clock & reset
    logic clk;
    logic rst_n;

    // Input interface
    logic        in_valid;
    logic        in_ready;
    logic [31:0] in_data;

    // Output interface
    logic        out_valid;
    logic        out_ready;
    logic [31:0] out_data;

    // DUT instantiation
    single_stage_pipeline_reg  dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .in_valid  (in_valid),
        .in_ready  (in_ready),
        .in_data   (in_data),
        .out_valid (out_valid),
        .out_ready (out_ready),
        .out_data  (out_data)
    );

    
    always #5 clk = ~clk;

    
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, pipeline_reg_tb);
    end

    
    initial begin
        // Initialize
        clk       = 0;
        rst_n     = 0;
        in_valid  = 0;
        in_data   = 0;
        out_ready = 0;

        $display("---- Simulation Start ----");

       
        #20;
        rst_n = 1;
        $display("[%0t] Reset deasserted", $time);

        @(posedge clk);
        in_valid = 1;
        in_data  = 32'hACCEDEDF;
        out_ready = 0;
        $display("[%0t] Sending data = %h, out_ready = 0", $time, in_data);
      
        repeat (1) begin
        @(posedge clk);
        $display("[%0t] Holding | out_valid=%b in_ready=%b",$time, out_valid, in_ready);
        end
        
        @(posedge clk);
        out_ready = 1;
        $display("[%0t] Releasing backpressure", $time);

        @(posedge clk);
        in_valid = 0;
        $display("[%0t] Output data observed = %h", $time, out_data);

        $display("---- Simulation End ----");
        $finish;
    end

endmodule
