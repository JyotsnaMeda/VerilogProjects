`timescale 1ns / 1ps

module lfsr_1#(parameter N=8)
(input i_clk,
input i_ena,
input[N-1:0] i_seed_din,
input i_seed_valid,
output [N-1:0] o_lfsr_dout,
output o_lfsr_one_cycle);
  reg xnorout;
  reg[N:1] lfsr_shift_reg=0;

  always @ (posedge i_clk)
      begin
      if(i_ena==1'b1)
          if(i_seed_valid==1'b1)
              lfsr_shift_reg <= i_seed_din;
          else
              lfsr_shift_reg <= {lfsr_shift_reg[N-1:1],xnorout};
      end

  always @(*)
      begin
      case(N)
      3: xnorout <= lfsr_shift_reg[3] ^~ lfsr_shift_reg[2];
      4: xnorout <= lfsr_shift_reg[4] ^~ lfsr_shift_reg[3];  
      5: xnorout <= lfsr_shift_reg[5] ^~ lfsr_shift_reg[3];
      6: xnorout <= lfsr_shift_reg[6] ^~ lfsr_shift_reg[5];
      7: xnorout <= lfsr_shift_reg[7] ^~ lfsr_shift_reg[6];
      8: xnorout <= lfsr_shift_reg[8] ^~ lfsr_shift_reg[6] ^~ lfsr_shift_reg[5] ^~ lfsr_shift_reg[4];
      9: xnorout <= lfsr_shift_reg[9] ^~ lfsr_shift_reg[5];
      10:xnorout <= lfsr_shift_reg[10] ^~ lfsr_shift_reg[7];
      endcase
      end

  assign o_lfsr_dout=lfsr_shift_reg[N:1];
  assign o_lfsr_one_cycle= (lfsr_shift_reg[N:1] == i_seed_din)? 1'b1:1'b0;

        
endmodule


//for a 3-bit LFSR the output pattern should be 7 units long.

module lfsr_1_tb;
  parameter N=3;
  reg i_clk,i_ena=1'b1,i_seed_valid=1'b0;
  reg [N-1:0] i_seed_din={N{1'b0}};
  wire [N-1:0] o_lfsr_dout;
  wire o_lfsr_one_cycle;

  initial
  begin
    i_clk=0;

    forever #5 i_clk =~ i_clk;
  end

  lfsr_1#(N) DUT(i_clk,i_ena,i_seed_din,i_seed_valid,o_lfsr_dout,o_lfsr_one_cycle);


endmodule
