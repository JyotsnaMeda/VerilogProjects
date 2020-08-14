
`timescale 1ns / 1ps

//this is an 8-bit signed multiplier implemented in Booth's Architecture

module booth_multiplier(multiplier,multiplicand,result,clk,start,done);
  input [7:0] multiplier,multiplicand;
  output [15:0] result;
  input clk,start;
  output done;
  
  
  reg [7:0] Acc,Mcand,Q;
  reg Q_1;
  reg [3:0] count;
  
  wire [7:0] sum, difference;
  
  
  always @ (posedge clk)
    begin
      if(start == 1)//when start is high, initialize all the registers with the new values.
        begin
          Acc<=8'b00000000;
          Mcand<=multiplicand;
          Q<=multiplier;
          Q_1<=0;
          count<=4'b0000;
        end
      if(done != 1)//when the multiplication is done, do not execute the algorithm any further 
        begin
          case({Q[0],Q_1})
            2'b01: {Acc,Q,Q_1} <= {sum[7],sum,Q};
            2'b10: {Acc,Q,Q_1} <= {difference[7],difference,Q};
            default:{Acc,Q,Q_1}<= {Acc[7],Acc,Q};
          endcase
          count <= count + 1'b1;
        end
    end
    
  
  alu adder(sum,Acc,Mcand,0);
  alu subtractor(difference,Acc,~Mcand,1);
  
  assign done=(count==8)?1:0;
  assign result = (done==1)? {Acc,Q}:0;
  
endmodule



//build a alu to do the addition and subtraction as and when required in the algorithm

module alu (output[7:0] result, input[7:0] in1,in2, input cin);
  assign result = in1 + in2 + cin;
endmodule



//Here is a sample test bench, that tests 8-bit signed multiplication implemented in the above module

module booth_multiplier_tb();
  reg[7:0] multiplier, multiplicand;
  wire [15:0] result;
  reg clk=0, start;
  wire done;

  always #5 clk =~ clk;


  booth_multiplier DUT(multiplier,multiplicand,result,clk,start,done);

  initial begin
    start=1;
    multiplier =8'b00000011;multiplicand=8'b00000010;//3*2=6
    #10
    start=0;
    #100
    
    start=1;
    multiplier =8'b10000101;multiplicand=8'b11111100;//-123*-4=492
    #10
    start=0;
    #100
    
    start=1;
    multiplier =8'b01000100;multiplicand=8'b00000010;//68*2=136
    #10
    start=0;
    #100
    
    start=1;
    multiplier =8'b00001011;multiplicand=8'b11111111;//11*-1=-11
    #10
    start=0;
    #100
    $finish;
    
  end
    

endmodule

