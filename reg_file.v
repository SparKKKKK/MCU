module my_reg_file(
input wire clk,
input wire rst_n,
input wire [7:0] int_wr_addr,
input wire [9:0] int_wr_data,

input wire [7:0] int_rd_addr,
input reg [9:0] int_rd_data
    );
reg [9:0] r1;
reg [9:0] r2;
reg [9:0] r3;
reg [9:0] r4;
reg [9:0] r5;
//read data
always@(*)begin
    case(int_rd_addr)
        8'h81:int_rd_data = r1;
        8'h82:int_rd_data = r2;
        8'h83:int_rd_data = r3;
        8'h84:int_rd_data = r4;
        8'h85:int_rd_data = r5;
        default:int_rd_data = 8'h0;
    endcase
end

//write data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        r1 <= 8'h0;
    end
    else if (int_wr_addr == `R1) begin
        r1 <= int_wr_data;
    end else begin
        r1 <= r1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        r2 <= 8'h0;
    end
    else if (int_wr_addr == `R2) begin
        r2 <= int_wr_data;
    end else begin
        r2 <= r2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        r3 <= 8'h0;
    end
    else if (int_wr_addr == `R3) begin
        r3 <= int_wr_data;
    end else begin
        r3 <= r3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        r4 <= 8'h0;
    end
    else if (int_wr_addr == `R4) begin
        r4 <= int_wr_data;
    end else begin
        r4 <= r4;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        r5 <= 8'h0;
    end
    else if (int_wr_addr == `R5) begin
        r5 <= int_wr_data;
    end else begin
        r5 <= r5;
    end
end
endmodule