/**
* Conway's Game of Life Cell
*
* data_i[7:0] is status of 8 neighbor cells
* data_o is status this cell
* 1: alive, 0: death
*
* when en_i==1:
*   simulate the cell transition with 8 given neighors
* else when update_i==1:
*   update the cell status to update_val_i
* else:
*   cell status remains unchanged
**/

module bsg_cgol_cell 
	( input  logic clk_i

    , input  logic en_i          
    , input  logic [7:0] data_i

    , input  logic update_i     
    , input  logic update_val_i

    , output logic data_o
  	);

	// Design your bsg_cgl_cell
	// Hint: Find the module to count the number of neighbors from basejump
  
	// internal signals
	logic [3:0] count;

 	// FSM control logic
	typedef enum logic [1:0] {eWAIT, eBUSY, eDONE} state_e;
  	state_e  ps, ns;

	// define next states
	always_comb begin
  		case (ps)
			eWAIT: begin
				if (en_i)				ns = eBUSY;
				else					ns = eWAIT;
			end
			eBUSY1: begin
				if (count==4'b1000)		ns = eDONE;
				else					ns = eBUSY;
			end
			eDONE: begin
				if (update_i)			ns = eWAIT;
				else					ns = eDONE;
			end
			default: 					ns = eWAIT;
		endcase
	end

	// define state actions
	always_comb begin
  		case (ps)
			eWAIT: begin

			end
			eBUSY: begin

			end
			eDONE: begin

			end
			default: begin

			end
		endcase
	end

	// sequential logic for dffs
	always_ff @(posedge clk_i) begin
		// update FSM
		if (reset_i)
		  	ps <= eWAIT;
	  	else
		  	ps <= ns;
		// dff_en implemented here
	end

	// bsg logic blocks
	bsg_adder_cin #(.width_p(4)) adder_sum
		(.a_i(/**/)
		,.b_i(/**/)
		,.cin_i(0)
		,.o(/**/)
		);

endmodule
