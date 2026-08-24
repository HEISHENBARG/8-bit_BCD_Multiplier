module multiplier_tb;

parameter n_bits = 5;

// Inputs
reg [n_bits-1:0] a_in;
reg [n_bits-1:0] b_in;
reg clk;
reg start;
reg reset;

// Outputs
wire [(n_bits*2)-1:0] out;
wire finish;
wire [(((n_bits*2)/3)+1)*4-1:0] bcd;


// Instantiate the multiplier
multiplier uut(
    .out(out),
    .a_in(a_in),
    .b_in(b_in),
    .clk(clk),
    .start(start),
    .reset(reset),
    .finish(finish),
    .bcd(bcd)
);

defparam uut.N = n_bits;


// Clock generation
initial
begin
    forever
        #50 clk = ~clk;
end


// Test sequence
initial
begin

    // Initialize inputs
    a_in = 0;
    b_in = 0;
    clk = 0;
    start = 0;
    reset = 0;

    // Wait for reset
    #100;

    // First multiplication: 26 x 30
    a_in = 'd26;
    b_in = 'd30;
    start = 0;

    #200;
    start = 1;

    // Second multiplication: 13 x 13
    #1000;
    a_in = 'd13;
    b_in = 'd13;
    start = 0;

    #200;
    start = 1;

end


// End simulation
initial
begin
    #3000;
    $finish;
end


// VCD waveform generation
initial
begin
    $dumpfile("multiplier.vcd");
    $dumpvars(0, multiplier_tb);
end

endmodule