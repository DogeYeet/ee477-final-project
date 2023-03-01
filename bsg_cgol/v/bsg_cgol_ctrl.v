module bsg_cgol_ctrl #(
   parameter `BSG_INV_PARAM(max_game_length_p)
  ,localparam game_len_width_lp=`BSG_SAFE_CLOG2(max_game_length_p)
) (
   input  logic clk_i
  ,input  logic reset_i

  ,input en_i

  // Input Data Channel
  ,input  logic [game_len_width_lp-1:0] frames_i
  ,input  logic v_i
  ,output logic ready_o

  // Output Data Channel
  ,input  logic yumi_i
  ,output logic v_o

  // Cell Array
  ,output logic update_o
  ,output logic en_o
);

  wire unused = en_i; // for clock gating, unused
  
  	// Design your control logic

	logic [game_len_width_lp-1:0] count, frames_val;

	assign update_o = v_i;

	// FSM control logic
	typedef enum logic [1:0] {eWAIT, eBUSY, eDONE} state_e;
  	state_e  ps, ns;
	
	// define next states
	always_comb begin
  		case (ps)
			eWAIT: begin
				if (v_i)				ns = eBUSY;
				else					ns = eWAIT;
			end
			eBUSY: begin
				if (count==frames_val)	ns = eDONE;
				else					ns = eBUSY;
			end
			eDONE: begin
				if (yumi_i)				ns = eWAIT;
				else					ns = eDONE;
			end
			default: 					ns = eWAIT;
		endcase
	end
  
	// define state actions
	always_comb begin
  		case (ps)
			eWAIT: begin
				ready_o 	= 1;
				v_o 		= 0;
				en_o		= 0;
			end
			eBUSY: begin
				ready_o 	= 0;
				v_o			= 0;
				en_o		= 1;
			end
			eDONE: begin
				ready_o 	= 0;
				v_o			= 1;
				en_o		= 0;
			end
			default: begin
				ready_o 	= 0;
				v_o 		= 0;
				en_o		= 0;
			end
		endcase
	end

	// sequential logic for states based on input clock
	always_ff @(posedge clk_i) begin
		if (reset_i)
		  	ps <= eWAIT;
	  	else
		  	ps <= ns;
		// set intial conditions in WAIT
		if (ps==eWAIT) begin
			count <= 1;
			frames_val <= frames_i;
		end else if (ps==eBUSY) begin
			count <= count + 1;
			frames_val <= frames_val;
		end else begin
			count <= 1;
			frames_val <= frames_val;
		end
	end

endmodule
