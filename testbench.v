module tb_traffic_light_controller;

    reg clk;
    reg reset;
    wire [1:0] ns_light;
    wire [1:0] ew_light;

    // Instantiate DUT
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .ns_light(ns_light),
        .ew_light(ew_light)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Starting Traffic Light Controller Simulation");
        $monitor("Time=%0t | NS=%b | EW=%b", $time, ns_light, ew_light);

        // Initialize
        clk = 0;
        reset = 1;
        #10;

        reset = 0;

        // Run simulation for a full cycle
        #100;

        $display("Simulation Finished");
        $stop;
    end

endmodule
