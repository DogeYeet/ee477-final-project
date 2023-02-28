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
	logic [3:0] count, sum, newSum;
	logic dff_en, newData;

 	// FSM control logic
	typedef enum logic {eWAIT, eBUSY} state_e;
  	state_e  ps, ns;

	// gate logic for newData
	assign newData = (((~data_o) && (sum==3)) || ((data_o) && ((sum<=3) && (2<=sum))));

	// define next states
	always_comb begin
  		case (ps)
			eWAIT: begin
				if (en_i)				ns = eBUSY;
				else					ns = eWAIT;
			end
			eBUSY: begin
				if (count==4'b1000)		ns = eWAIT;
				else					ns = eBUSY;
			end
			default: 					ns = eWAIT;
		endcase
	end

	// define state actions
	always_comb begin
  		case (ps)
			eWAIT: begin
				dff_en = 0;
			end
			eBUSY: begin
				dff_en = (newSum!=sum);
			end
			default: begin
				dff_en = 0;
			end
		endcase
	end

	// sequential logic for dffs
	always_ff @(posedge clk_i) begin
		// update FSM
		if (update_i)  // reset
			ps <= eWAIT;
			data_o <= update_val_i;
			count <= 4'b0;
			sum <= 4'b0;
		else
			ps <= ns;  // update state
			if (ps == eBUSY) begin
				if (dff_en) begin
					count <= count + 1;
					sum <= newSum;
				end else begin
					count <= count;
					sum <= sum;
				end
				data_o <= data_o;
			end else begin
				count <= 4'b0;
				sum <= 4'b0;
				data_o <= newData;
			end
	end

	// bsg logic blocks
	bsg_adder_cin #(.width_p(4)) adder_sum
		(.a_i({3'b0, data_i[count]})
		,.b_i(sum)
		,.cin_i(0)
		,.o(newSum)
		);

endmodule
