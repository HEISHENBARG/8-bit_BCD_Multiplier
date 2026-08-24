module multiplier(out, a_in, b_in, clk, start, reset, finish, bcd);

parameter N = 8;

// Outputs
output [(((N*2)/3)+1)*4-1:0] bcd;
output [(N*2)-1:0] out;
output finish;

// Inputs
input start;
input clk;
input reset;
input [N-1:0] a_in;
input [N-1:0] b_in;


// Internal registers
reg [(((N*2)/3)+1)*4-1:0] bcd_reg = 0;
reg [(N*2)-1:0] out_reg;
reg finish_reg = 0;

reg [(N*2)-1:0] a_in_reg;
reg [(N*2)-1:0] b_in_reg;

// Counter for multiplication cycles
reg [N:0] bits;


// Output assignments
assign bcd = bcd_reg;
assign out = out_reg;
assign finish = finish_reg;

integer i;


// Reset internal registers
always @(negedge reset)
begin
    out_reg = 0;
    a_in_reg = 0;
    b_in_reg = 0;
end


// Sequential multiplication process
always @(posedge clk)
begin

    if (!reset)
    begin

        case(start)

            // Load input operands
            1'b0:
            begin
                a_in_reg = a_in;
                b_in_reg = b_in;
                bits = N;

                finish_reg = 0;
                out_reg = 0;
                bcd_reg = 0;

                $display("Value loaded into the input register.");
            end


            // Shift-and-add multiplication
            1'b1:
            begin

                // Add multiplicand when LSB of multiplier is 1
                if (b_in_reg[0] == 1)
                begin
                    out_reg = out_reg + a_in_reg;
                end

                // Move to the next multiplier bit
                bits = bits - 1;
                a_in_reg = a_in_reg << 1;
                b_in_reg = b_in_reg >> 1;

            end

        endcase


        // Multiplication completed
        if (bits == 0)
        begin

            $display("Multiplication Completed");

            finish_reg = 1'b1;


            // Binary to BCD conversion
            for(i = 0; i < (N*2); i = i + 1)
            begin

                if(3 <= ((N*2)/3+1)*4-1 &&
                   bcd_reg[3:0] >= 5)
                    bcd_reg[3:0] = bcd_reg[3:0] + 3;

                if(7 <= ((N*2)/3+1)*4-1 &&
                   bcd_reg[7:4] >= 5)
                    bcd_reg[7:4] = bcd_reg[7:4] + 3;

                if(11 <= ((N*2)/3+1)*4-1 &&
                   bcd_reg[11:8] >= 5)
                    bcd_reg[11:8] = bcd_reg[11:8] + 3;

                if(15 <= ((N*2)/3+1)*4-1 &&
                   bcd_reg[15:12] >= 5)
                    bcd_reg[15:12] = bcd_reg[15:12] + 3;

                // Shift binary result into BCD register
                bcd_reg = {
                    bcd_reg[(((N*2)/3)+1)*4-2:0],
                    out_reg[(N*2)-1-i]
                };

            end

            $display("Conversion of binary to BCD Completed");

        end

    end

end

endmodule