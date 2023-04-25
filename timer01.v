//'include "x_teste.v"
module timer
(
  // Declaração das portas
  //------------
    input clock, reset, start, stop, pause,
    input [6:0] min, sec,
    input [5:0] d1, d2, d3, d4, d5, d6, d7, d8,
    output done,
    output [6:0] an, dec_cat
  //------------
);

    // Declaração dos sinais
    //------------
    wire start_ed, pause_ed, stop_ed;
    wire [6:0] min_left, sec_left;
    wire reg [1:0] EA;
    //------------
    
    // Instanciação dos edge_detectors
    //------------
    edge_detector ed1(.clock(clock), .reset(reset), .din(start), .rising(start_ed));
    edge_detector ed2(.clock(clock), .reset(reset), .din(pause), .rising(pause_ed));
    edge_detector ed3(.clock(clock), .reset(reset), .din(stop), .rising(stop_ed));
    //------------

    // Divisor de clock para gerar o ck1seg
    #(parameter 1SEC_COUNT = 50000000)
    reg ck1seg;
    reg [31:0] count;


    always @(posedge clock or posedge reset)
    begin
        if (reset == 1'b1) begin
            ck1seg   <= 1'b0;
            count <= 32'd0;
        end
        else begin
            if (count == 1SEC_COUNT-1) begin
                ck1seg   <= ~ck1seg;
                count <= 32'd0;
            end
            else begin
                count <= count + 1;
            end
        end
    end
    //


    // Máquina de estados para determinar o estado atual (EA)
    always @(posedge clock or posedge reset)
    begin
        if (reset ==  1) begin
          EA <= 2'b00;          
        end
        else  begin
          case (EA)
            2'b00: begin
              if (start_ed == 1)
                EA <= 2'b01;
            end 

            2'b01: begin
              if(stop_ed==1)
                EA <= 2'b00;
              if(pause_ed==1)
                EA <= 2'b10;
            end

            2'b10: begin
              if(pause_ed==1 || start_ed==1)
                EA <= 2'b01;
              if(stop_ed==1)
                EA <= 2'b00;
            end
            default:
                EA <= 2'b00;
          endcase
        end
    end

    // Decrementador de tempo (minutos e segundos)
    always @(posedge ck1seg or posedge reset)
    begin
        if(reset == 1) begin
            min_left <= 0;
            sec_left <= 0;
        end
        else begin
            case(EA)
                2'b00:begin
                    if(min > 7'd99)
                        min_left <= 7'd99;
                    else
                        min_left <= min;

                    if(sec > 7'd59)
                        sec_left <= 7'd59;
                    else
                        sec_left <= sec;
                end

                2'b01:begin
                    if(sec_left == 7'd0)
                        min_left <= min_left - 1;
                    

                end
                2'b10:begin
                    
                end
            
            endcase
        end
    end


    // Instanciação da display 7seg
    dspl_drv_NexysA7 dsp1( .d1(d1), .d2(d2), .d3(d3), .d4(d4), .d5(d5), .d6(d6), .d7(d7), .d8(d8),
                             .an(an), .dec_cat(dec_cat))

    
endmodule
