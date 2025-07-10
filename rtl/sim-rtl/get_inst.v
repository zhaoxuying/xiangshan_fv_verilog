module get_inst (
    // Clock and reset
    input  wire   clk,
    input  wire   rst_n,
    output        r_enable,
    output [63:0] r_index,
    input [63:0]  r_data_0,
    input [63:0]  r_data_1,
    input [63:0]  r_data_2,
    input [63:0]  r_data_3,


    // TileLink Interface - Channel A (READ 2 burst Request)
    output             a_ready,
    input              a_valid,
    input [3:0]        a_bits_source,
    input [47:0]       a_bits_address,

    // TileLink Interface - Channel D (Response)
    output reg            d_valid,
    output reg [3:0]      d_bits_opcode,
    output reg [3:0]      d_bits_source,
    output     [255:0]    d_bits_data,
    output reg            d_bits_corrupt
    
);

    // Internal state machine definitions
    localparam IDLE     = 2'b00;
    localparam RESP1    = 2'b01;
    localparam RESP2    = 2'b10;
    
    // Internal signals
    reg [1:0]  state, next_state;
    
    // Address range check - Ensure the address is within SRAM's mapped range
    wire sram_addr_hit;
    wire [63:0] sram_raddr;
    wire [47:0] sram_raddr_temp;
    reg [63:0] r_index_d;
   
    //a_bits_address>= 0x8000_0000 
    assign sram_addr_hit = (|a_bits_address[47:31]);
    assign sram_raddr_temp = a_bits_address>>5;
    assign sram_raddr = {38'b0,sram_raddr_temp[25:0]};
    // State machine sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // State machine combinational logic
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (a_valid && sram_addr_hit) begin
                    next_state = RESP1;
                end
            end
            
            RESP1: begin
                next_state = RESP2;
            end
            
            RESP2: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end
   
    assign r_enable = (next_state==RESP1)|(next_state==RESP2);
    assign r_index = (next_state==RESP1) ? sram_raddr : ((next_state==RESP2)?r_index_d:64'b0);
    assign d_bits_data = (state==RESP1 | state==RESP2) ? {r_data_3,r_data_2,r_data_1,r_data_0} : 256'b0;
    assign a_ready = (state == IDLE);
    
    // Generate TileLink Channel D response
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d_valid   <= 1'b0;
            d_bits_opcode  <= 4'h0;
            d_bits_source  <= 4'h0;
            d_bits_corrupt <= 1'h0;
            r_index_d <= 64'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (a_valid && sram_addr_hit) begin
                        d_valid  <= 1'b1;  // Start reading, next cycle get the data
                        d_bits_opcode  <= 4'h1; //AccessAckData
                        d_bits_source  <= a_bits_source;
                        r_index_d <= sram_raddr + 1;
                        d_bits_corrupt <= 1'h0;
                    end
                end
                
                RESP1: begin
                    d_valid  <= 1'b1;  //need read 2 cycles
                end
                
                RESP2: begin
                    d_valid  <= 1'b0;  
                end
                
                default: begin
                    d_valid  <= 1'b0;  
                end
            endcase
        end
    end
    
 endmodule    

  

