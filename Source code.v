module traffic_light_controller (
    input clk,
    input reset,
    output reg [1:0] ns_light, // 00: Red, 01: Yellow, 10: Green
    output reg [1:0] ew_light
);

    // State encoding
    typedef enum reg [1:0] {
        NS_GREEN = 2'b00,
        NS_YELLOW = 2'b01,
        EW_GREEN = 2'b10,
        EW_YELLOW = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [3:0] timer;

    localparam GREEN_TIME  = 5;
    localparam YELLOW_TIME = 2;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= NS_GREEN;
            timer <= GREEN_TIME;
        end else begin
            if (timer == 0) begin
                current_state <= next_state;
                case (next_state)
                    NS_GREEN, EW_GREEN: timer <= GREEN_TIME;
                    NS_YELLOW, EW_YELLOW: timer <= YELLOW_TIME;
                endcase
            end else begin
                timer <= timer - 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            NS_GREEN:   next_state = (timer == 0) ? NS_YELLOW : NS_GREEN;
            NS_YELLOW:  next_state = (timer == 0) ? EW_GREEN : NS_YELLOW;
            EW_GREEN:   next_state = (timer == 0) ? EW_YELLOW : EW_GREEN;
            EW_YELLOW:  next_state = (timer == 0) ? NS_GREEN : EW_YELLOW;
            default:    next_state = NS_GREEN;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            NS_GREEN:   begin ns_light = 2'b10; ew_light = 2'b00; end
            NS_YELLOW:  begin ns_light = 2'b01; ew_light = 2'b00; end
            EW_GREEN:   begin ns_light = 2'b00; ew_light = 2'b10; end
            EW_YELLOW:  begin ns_light = 2'b00; ew_light = 2'b01; end
            default:    begin ns_light = 2'b00; ew_light = 2'b00; end
        endcase
    end

endmodule
