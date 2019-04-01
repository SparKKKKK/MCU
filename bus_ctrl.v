module my_bus_ctrl(
input wire clk,
input wire rst_n,
input wire [9:0]bus_wr_data,
input wire [7:0]bus_wr_addr,
input wire bus_rd_en,
input wire bus_wr_en,
input wire [7:0]bus_rd_addr,

output reg [9:0]bus_rd_data
    );
reg [9:0] bus_memory [0:255];

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        bus_rd_data <= #12 10'd0;
    else if(bus_rd_en)
        bus_rd_data <= #12 bus_memory[bus_rd_addr];
    else
        bus_rd_data <= #12 10'd0;
end

always @(posedge clk ) begin
    if(bus_wr_en)
        bus_memory[bus_wr_addr] <= #15 bus_wr_data;
end

endmodule