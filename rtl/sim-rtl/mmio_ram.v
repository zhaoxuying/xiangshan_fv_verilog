module mmio_ram (
    // Clock and reset
    input  wire        clk,
    input  wire        rst_n,
    
    // TileLink Interface - Channel A (Request)
    input  wire        auto_L2_to_L3_peripheral_buffer_1_in_a_valid,
    output wire        auto_L2_to_L3_peripheral_buffer_1_in_a_ready,
    input  wire [3:0]  auto_L2_to_L3_peripheral_buffer_1_in_a_bits_opcode,
    input  wire [2:0]  auto_L2_to_L3_peripheral_buffer_1_in_a_bits_param,
    input  wire [2:0]  auto_L2_to_L3_peripheral_buffer_1_in_a_bits_size,
    input  wire [2:0]  auto_L2_to_L3_peripheral_buffer_1_in_a_bits_source,
    input  wire [47:0] auto_L2_to_L3_peripheral_buffer_1_in_a_bits_address,
    input  wire [7:0]  auto_L2_to_L3_peripheral_buffer_1_in_a_bits_mask,
    input  wire [63:0] auto_L2_to_L3_peripheral_buffer_1_in_a_bits_data,
    input  wire        auto_L2_to_L3_peripheral_buffer_1_in_a_bits_corrupt,
    
    // TileLink Interface - Channel D (Response)
    input  wire        auto_L2_to_L3_peripheral_buffer_1_in_d_ready,
    output wire        auto_L2_to_L3_peripheral_buffer_1_in_d_valid,
    output wire [3:0]  auto_L2_to_L3_peripheral_buffer_1_in_d_bits_opcode,
    output wire [1:0]  auto_L2_to_L3_peripheral_buffer_1_in_d_bits_param,
    output wire [2:0]  auto_L2_to_L3_peripheral_buffer_1_in_d_bits_size,
    output wire [2:0]  auto_L2_to_L3_peripheral_buffer_1_in_d_bits_source,
    output wire        auto_L2_to_L3_peripheral_buffer_1_in_d_bits_sink,
    output wire        auto_L2_to_L3_peripheral_buffer_1_in_d_bits_denied,
    output wire [63:0] auto_L2_to_L3_peripheral_buffer_1_in_d_bits_data,
    output wire        auto_L2_to_L3_peripheral_buffer_1_in_d_bits_corrupt
);

    // Internal state machine definitions
    localparam IDLE     = 2'b00;
    localparam READ     = 2'b01;
    localparam WRITE    = 2'b10;
    localparam RESPONSE = 2'b11;
    
    // Internal signals
    reg [1:0]  state, next_state;
    reg [6:0]  sram_addr_reg;
    reg [63:0] sram_data_reg;
    reg [7:0]  sram_wmask_reg;
    reg        sram_ce_reg;
    reg        sram_we_reg;
    reg [63:0] sram_Q;
    reg        d_valid_reg;
    reg [3:0]  d_opcode_reg;
    reg [1:0]  d_param_reg;
    reg [2:0]  d_size_reg;
    reg [2:0]  d_source_reg;
    reg        d_sink_reg;
    reg        d_denied_reg;
    reg        d_corrupt_reg;
    
    // Address range check - Ensure the address is within SRAM's mapped range
    wire sram_addr_hit;
    parameter SRAM_BASE_ADDR = 48'h0000000000;  // SRAM base address
    parameter SRAM_ADDR_MASK = 48'hFFFFFFFF80;  // Address mask for 128 locations
    
    assign sram_addr_hit = ((auto_L2_to_L3_peripheral_buffer_1_in_a_bits_address & SRAM_ADDR_MASK) == SRAM_BASE_ADDR);
    
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
                if (auto_L2_to_L3_peripheral_buffer_1_in_a_valid && sram_addr_hit) begin
                    case (auto_L2_to_L3_peripheral_buffer_1_in_a_bits_opcode)
                        4'b0100: next_state = READ;    // Get operation (read), opcode 4
                        4'b0000: next_state = WRITE;   // PutFullData operation (write), opcode 0
                        4'b0001: next_state = WRITE;   // PutPartialData operation (write), opcode 1
                        default: next_state = IDLE;    // Unsupported opcode, stay in IDLE
                    endcase
                end
            end
            
            READ: begin
                next_state = RESPONSE;
            end
            
            WRITE: begin
                next_state = RESPONSE;
            end
            
            RESPONSE: begin
                if (auto_L2_to_L3_peripheral_buffer_1_in_d_ready && d_valid_reg) begin
                    next_state = IDLE;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // SRAM control signal generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sram_addr_reg <= 7'h0;
            sram_data_reg <= 64'h0;
            sram_wmask_reg <= 8'h0;
            sram_ce_reg   <= 1'b1;  // Default: chip disabled
            sram_we_reg   <= 1'b1;  // Default: write disabled
        end else begin
            case (state)
                IDLE: begin
                    if (auto_L2_to_L3_peripheral_buffer_1_in_a_valid && sram_addr_hit) begin
                        sram_addr_reg <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_address[6:0];  // Extract lower 7 bits as SRAM address
                        sram_ce_reg   <= 1'b0;  // Enable chip
                        
                        case (auto_L2_to_L3_peripheral_buffer_1_in_a_bits_opcode)
                            4'b0100: begin  // Read operation (opcode 4)
                                sram_we_reg <= 1'b1;  // Disable write
                                sram_wmask_reg <= 8'h0;  // Mask unused for reads
                            end
                            
                            4'b0000, 4'b0001: begin  // Write operations (opcode 0 and 1)
                                sram_we_reg <= 1'b0;  // Enable write
                                sram_data_reg <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_data;
                                
                                // Set mask based on operation type
                                if (auto_L2_to_L3_peripheral_buffer_1_in_a_bits_opcode == 4'b0001) begin  // PutPartialData (opcode 1)
                                    sram_wmask_reg <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_mask;
                                end else begin  // PutFullData (opcode 0)
                                    sram_wmask_reg <= 8'hFF;  // All bytes enabled
                                end
                            end
                            
                            default: begin
                                sram_we_reg <= 1'b1;
                                sram_wmask_reg <= 8'h0;
                            end
                        endcase
                    end else begin
                        sram_ce_reg <= 1'b1;
                        sram_we_reg <= 1'b1;
                        sram_wmask_reg <= 8'h0;
                    end
                end
                
                READ: begin
                    // Maintain SRAM control signals for read operation
                    sram_ce_reg   <= 1'b1;  // Keep chip enabled
                    sram_we_reg   <= 1'b1;  // Keep write disabled
                    sram_wmask_reg <= 8'h0; // Keep mask disabled
                    // Maintain address to ensure stable read operation
                end
                
                WRITE: begin
                    // Maintain SRAM control signals for write operation
                    sram_ce_reg   <= 1'b1;  // Keep chip enabled
                    sram_we_reg   <= 1'b1;  // Keep write enabled
                    // Maintain write data, mask, and address for the duration of the write
                    sram_data_reg <= 64'b0;
                    sram_wmask_reg <= 8'b0;
                    sram_addr_reg <= 7'b0;
                end
                
                RESPONSE: begin
                    if (auto_L2_to_L3_peripheral_buffer_1_in_d_ready && d_valid_reg) begin
                        sram_ce_reg <= 1'b1;  // Disable chip
                        sram_we_reg <= 1'b1;  // Disable write
                        sram_wmask_reg <= 8'h0;
                    end
                end
                
                default: begin
                    sram_ce_reg <= 1'b1;
                    sram_we_reg <= 1'b1;
                    sram_wmask_reg <= 8'h0;
                end
            endcase
        end
    end
    
    // Generate TileLink Channel D response
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d_valid_reg   <= 1'b0;
            d_opcode_reg  <= 4'h0;
            d_param_reg   <= 2'h0;
            d_size_reg    <= 3'h0;
            d_source_reg  <= 3'h0;
            d_sink_reg    <= 1'b0;
            d_denied_reg  <= 1'b0;
            d_corrupt_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (auto_L2_to_L3_peripheral_buffer_1_in_a_valid && sram_addr_hit) begin
                        d_valid_reg  <= 1'b0;  // Start processing, clear previous response
                        
                        case (auto_L2_to_L3_peripheral_buffer_1_in_a_bits_opcode)
                            4'b0100: begin  // Read operation (opcode 4)
                                d_opcode_reg <= 4'b0001;  // AccessAck (opcode 1)
                                d_param_reg  <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_param[1:0];
                                d_size_reg   <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_size;
                                d_source_reg <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_source;
                                d_sink_reg   <= 1'b0;
                                d_denied_reg <= 1'b0;
                            end
                            
                            4'b0000, 4'b0001: begin  // Write operations (opcode 0 and 1)
                                d_opcode_reg <= 4'b0000;  // AccessAckData (opcode 0)
                                d_param_reg  <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_param[1:0];
                                d_size_reg   <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_size;
                                d_source_reg <= auto_L2_to_L3_peripheral_buffer_1_in_a_bits_source;
                                d_sink_reg   <= 1'b0;
                                d_denied_reg <= 1'b0;
                            end
                            
                            default: begin
                                d_opcode_reg <= 4'b0111;  // AccessAck (unsupported opcode)
                                d_denied_reg <= 1'b1;     // Mark as denied
                            end
                        endcase
                    end
                end
                
                READ: begin
                    d_valid_reg  <= 1'b1;  // Response is ready
                    d_corrupt_reg <= 1'b0;  // Assume data is valid
                end
                
                WRITE: begin
                    d_valid_reg  <= 1'b1;  // Response is ready
                    d_corrupt_reg <= 1'b0;
                end
                
                RESPONSE: begin
                    if (auto_L2_to_L3_peripheral_buffer_1_in_d_ready && d_valid_reg) begin
                        d_valid_reg <= 1'b0;  // Response consumed, clear valid flag
                    end
                end
                
                default: begin
                    d_valid_reg <= 1'b0;
                end
            endcase
        end
    end
    
    // Connect output signals
    assign auto_L2_to_L3_peripheral_buffer_1_in_a_ready = (state == IDLE) && sram_addr_hit;
    
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_valid       = d_valid_reg;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_opcode  = d_opcode_reg;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_param   = d_param_reg;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_size    = d_size_reg;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_source  = d_source_reg;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_sink    = d_sink_reg;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_denied  = d_denied_reg;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_data    = sram_Q;
    assign auto_L2_to_L3_peripheral_buffer_1_in_d_bits_corrupt = d_corrupt_reg;
    

    reg [63:0] mem_array [0:127];

    // Write operation: On rising clock edge, when sram_ce_reg is low (enabled) and sram_we_reg is low (write mode),
    // perform byte-wise write based on WMASK
    always @(posedge clk) begin
        if (!sram_ce_reg && !sram_we_reg) begin
            integer i;
            for (i = 0; i < 8; i = i + 1) begin  // Iterate over 8 bytes (64 bits)
                if (sram_wmask_reg[i]) begin  // Update byte if corresponding sram_wmask_reg bit is 1
                    mem_array[sram_addr_reg][i*8 +: 8] <= sram_data_reg[i*8 +: 8];
                end
            end
        end
    end

    // Read operation: On rising clock edge, when sram_ce_reg is low (enabled) and sram_we_reg is high (read mode),
    // output data from addressed location
    always @(posedge clk) begin
        if (!sram_ce_reg && sram_we_reg) begin
            sram_Q <= mem_array[sram_addr_reg];
        end
    end


endmodule    

  

