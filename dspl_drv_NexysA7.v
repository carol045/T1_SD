`timescale 1ns / 1ps

module dspl_drv_NexysA7(
    input reset,
    input clock,
    input [5:0] d1,
    input [5:0] d2,
    input [5:0] d3,
    input [5:0] d4,
    input [5:0] d5,
    input [5:0] d6,
    input [5:0] d7,
    input [5:0] d8,
    output [7:0] dec_cat,
    output reg [7:0] an
    );    
    
    reg clock_1KHz;
    reg [15:0] counter;
    reg [2:0] dig_sel;
    reg [4:0] digito;
    
    // 1KHz clock generation
    always @(posedge clock, posedge reset) begin
        if(reset) begin
            clock_1KHz <= 0;
            counter <= 16'd0;
        end
        else begin
            if (counter == 16'd49999) begin
                clock_1KHz <= ~clock_1KHz;
                counter <= 16'd0; 
            end
            else
                counter <= counter + 16'd1;
        end
    end
    
    // 1KHz counter to select digit and register output
    always @(posedge clock_1KHz, posedge reset) begin
        if (reset) begin
            dig_sel <= 3'd0;
            an <= 8'hFF;
            digito <= 5'd0;
        end
        else begin
            // contador de 0 até 7 para alternar os displays
            if (dig_sel == 3'd7)
                dig_sel <= 3'd0;
            else
                dig_sel <= dig_sel + 3'd1;
            
            // atribuição do digito selecionado
            case(dig_sel)
                3'd0: begin
                    digito <= d1[4:0];
                    an     <= {7'b1111111,~d1[5]};
                end
                3'd1: begin
                    digito <= d2[4:0];
                    an     <= {6'b111111,~d2[5],1'b1};
                end
                3'd2: begin
                    digito <= d3[4:0];
                    an     <= {5'b11111,~d3[5],2'b11};
                end
                3'd3: begin
                    digito <= d4[4:0];
                    an     <= {4'b1111,~d4[5],3'b111};
                end
                3'd4: begin
                    digito <= d5[4:0];
                    an     <= {3'b111,~d5[5],4'b1111};
                end
                3'd5: begin
                    digito <= d6[4:0];
                    an     <= {2'b11,~d6[5],5'b11111};
                end
                3'd6: begin
                    digito <= d7[4:0];
                    an     <= {1'b1,~d7[5],6'b111111};
                end
                default: begin //3'd7:
                    digito <= d8[4:0];
                    an     <= {~d8[5],7'b1111111};
                end                
            endcase
        end
    end
    
    // atribuição do dígito para a saída
    assign dec_cat = (digito[4:1] == 4'h0) ? {7'b0000001,~digito[0]} : 
                     (digito[4:1] == 4'h1) ? {7'b1001111,~digito[0]} :
                     (digito[4:1] == 4'h2) ? {7'b0010010,~digito[0]} :
                     (digito[4:1] == 4'h3) ? {7'b0000110,~digito[0]} :
                     (digito[4:1] == 4'h4) ? {7'b1001100,~digito[0]} :
                     (digito[4:1] == 4'h5) ? {7'b0100100,~digito[0]} :
                     (digito[4:1] == 4'h6) ? {7'b0100000,~digito[0]} :
                     (digito[4:1] == 4'h7) ? {7'b0001111,~digito[0]} :
                     (digito[4:1] == 4'h8) ? {7'b0000000,~digito[0]} :
                     (digito[4:1] == 4'h9) ? {7'b0000100,~digito[0]} :
                     (digito[4:1] == 4'ha) ? {7'b0001000,~digito[0]} :
                     (digito[4:1] == 4'hb) ? {7'b1100000,~digito[0]} :
                     (digito[4:1] == 4'hc) ? {7'b0110001,~digito[0]} :
                     (digito[4:1] == 4'hd) ? {7'b1000010,~digito[0]} :
                     (digito[4:1] == 4'he) ? {7'b0110000,~digito[0]} : {7'b0111000,~digito[0]};
                     //(digito[4:1] == 4'hf) ? {8'b1001111,digito[0]} :    
    
endmodule
