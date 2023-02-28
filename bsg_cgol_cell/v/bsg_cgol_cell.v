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
  
	// inernal logic signals
	logic [3:0] sum;
	logic newData;

	// bsg instance
	bsg_popcount #(.width_p(8)) countBits
		(.i(data_i)
		,.o(sum)
		);

	// gate logic for newData
	assign newData = ( ((~data_o)&&(sum==3)) || ((data_o)&&((2<=sum)&&(sum<=3))) );

	// sequential logic for data_o
	always_ff @(posedge clk_i) begin
		if (update_i) 
			data_o <= update_val_i;
		else if (en_i)
			data_o <= newData;
		else
			data_o <= data_o;
	end

endmodule
