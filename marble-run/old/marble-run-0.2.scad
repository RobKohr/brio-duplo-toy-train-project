/* Marble run kit, Lego and duplo compatible
Daniel.schneider@unige.ch
dec. 2018

Version 0.1
- a bit of playing

Instructions:
- print calibration first. If the piece doesn't fit, then act, i.e. cope with it or adjust the doblo-factory-x-y parameters in the lib directory.
- print a chosen module by uncommenting (see below)

You will have to find 1cm marbles. I recommend 10mm steel balls (about 1$/€ per ball). Marble balls are usually bigger, e.g. 16mm and will not fit.

Basic parameters are below. If you change these, most elements will adjust correctly, but some won't, i.e. need some manual adjustment. Parameters are different for Lego and Duplo compatibles. Legos work in "third" sizes and Duplos in "half". Length below are not absolute heights, but just length as defined in our Lego conventions. Therefore, they must be multiplied with either PART_WIDTH or PART_HEIGHT if you do some openscad coding.
*/

// SCALE MUST BE set
SCALE =0.5;   // Lego size, print tested

// LOAD doblo factory
include <../doblo-factory.scad>;

// Overrides
LATTICE_TYPE    = 3; 

// Local
UNIT = (SCALE < 0.6) ? THIRD : HALF; // Lego vs. Duplo small height units
BASE_HEIGHT  = (SCALE < 0.6) ? 2*THIRD : HALF;  // Height of the base plaform.
FLOOR_TOP    = 8*FULL;  // Height of the first floor, e.g. nibbles go here
FLOOR_BOTTOM = FLOOR_TOP-UNIT;  // bottom of a floor
WALL_TOP     = 10*FULL;            // e.g. nibbles go here
WALL_BOTTOM  = WALL_TOP-BASE_HEIGHT; // this is wall_top - the base plate height
INNER_WALL_TOP = FLOOR_BOTTOM-BASE_HEIGHT;  // e.g. inside of walls, needs a BASE_HEIGHT on top

NUDGE = 0.001;

TUBE_WALL_WIDTH = 2;

echo (str ("LATTICE-WIDTH = ", LATTICE_WIDTH(SCALE)));	
echo (str ("SCALE = ", SCALE));

// ----------------  Execute models. Uncomment only one

// calibration ();
// block (col=0, row=0, up=0, width=2,length=4,height=THIRD,nibbles_on_off=false, scale=LUGO) 
// half_pipe (col=0, row=0, up=0, width=4, length=2,height=FULL);

// track (col=0, row=0, up=0, length=2, width=2, closure="high",height=FULL);

doblo   (2,   0,   0,   1,   4,   THIRD,  true, false, scale=SCALE );
doblo   (3,   0,   0,   1,   4,   2*THIRD,  true, false, scale=SCALE );
doblo   (4,   0,   0,   1,   4,   FULL,  true, false, scale=SCALE );
doblo   (5,   0,   0,   1,   4,   FULL+THIRD,  true, false, scale=SCALE );
doblo   (6,   0,   0,   1,   4,   FULL+2*THIRD,  true, false, scale=SCALE );
// pipe (up=2*THIRD,closure="half");
pipe (col=-2);

// --- simple 4x2 lego brick
module calibration (scale=SCALE)
{
    //     (col, row, up, width,length,height,nibbles_on_off) 
    doblo   (0,   0,   0,   2,   4,    THIRD,  true, false, scale );
}

// TODO: implement ROTATION

track (col=0, row=0, up=0, length=4,  width=2, closure="high", height=FULL);

module track (col=0, row=0, up=0, width=2, length=4, height=FULL, closure="half", orientation=0, scale=LUGO) {
     // The track element will be placed along the y axis (back/forth)
     // In the doblo system: width= left/right length, length= forth/back length

     height_upper_block = (closure=="low") ? THIRD : 2*THIRD; // depends on closure
     // prepare the bed
     
     difference () {
         union () {
	      doblo (col=col, row=row, up=up, width=width,length=length,height=2*THIRD,
		     nibbles_on_off=false,diamonds_on_off=false,scale=LUGO) ;
	      block (col=0, row=0, up=2*THIRD, width=width, length=length, height=height_upper_block,
		     nibbles_on_off=false, diamonds_on_off=false, scale=LUGO) ;
	 }
	 // dig
	 pipe_rod (col=0, row=0, up=2*THIRD, width=width, length=length,height=FULL, closure=closure, orientation=orientation, scale=LUGO);
     }
     // lay the pipe
     pipe (col=0, row=0, up=3, width=width, length=length,height=FULL, closure=closure, orientation=orientation, scale=LUGO);
}

module pipe (col=0, row=0, up=0, width=2, length=4,height=FULL, closure="half", orientation=0, scale=LUGO) {
  /* The pipe sits on Z=0 along the y-axis in rotation position = 0
     To position it with respect to a doblo block, use the up parameter (thirds)
     If used to embed, use the pipe_rod module to dig a nice hole for the pipe (same pos. params)
  */
     x_0 = col    * PART_WIDTH(scale);
     y_0 = -row * PART_WIDTH(scale) ;
     z_0 = up     * PART_HEIGHT(scale);

     translate ([x_0, y_0, z_0]) {
	  rotate ([0,0,orientation]) {
	       pipe_0 (length=length, closure=closure);
	  }
     }
     }

module pipe_0 (length=4, width=2, closure="half", scale=LUGO) {
/* Aux function
   Creates a pipe with a given length and form, aka closure
   The pipe sits at origine X,Y,Z=0 along the y-axis in rotation position = 0
   it should be positioned with the pipe() module
   The outer width of the pipe is two Lego width = 16mm. That is height=5 (out of 6)
   width = 2. Do not change for now
  */
     radius = width * PART_WIDTH(scale) / 2.0;
     y_0 = - length * PART_WIDTH(scale) / 2.0 ;
     // pipe is pushed up its radius
     z_0 = width/2 * PART_WIDTH(scale);
     color ("red") difference () {
	  // position the hollow tube
	  translate ([radius, y_0, z_0]) {
	       // The tube
	       rotate ([90,0,0])
		    difference () {
		    // h will be rotated, so its left/right length, aka width in DOBLO
		    cylinder(h= length*PART_WIDTH(scale), r = radius, center = true, $fs = CYL_FS);
		    translate ([0,0,-2*NUDGE]) cylinder(h= length*PART_WIDTH(scale)+6*NUDGE, r = radius -TUBE_WALL_WIDTH, center = true, $fs = CYL_FS);
	       }
	  }
	       
	  // position of the cutting the block for the tube according to closure.
	  if (closure == "half")  { 
	       top_block_shave (col=0, row=0, width=width, length=length, up=width/2*5, height=width*2);
	  }
	  else if (closure == "full") {
	       // no shaving
	  }
	  else if (closure == "high") {
	       top_block_shave (col=0, row=0, width=width, length=length, up=width/2*7, height=width*2);
	  }
	  else if (closure == "low") {
	       top_block_shave (col=0, row=0, width=width, length=length, up=width/2*3, height=width*2);
	  }
	  else {
	       echo ("WARNING: Unknown closure value = ", closure, "(pick among: 'low', 'half', 'high', 'full')" );
	  }
     }
}

module top_block_shave (col=-1, row=-1, width=2, length=4, up=FULL, height=3*FULL) {
     /* Aux function that will draw a block that can be used to shave off stuff on top.
	*/
     // echo ("PART_WIDTH(SCALE) =", PART_WIDTH(SCALE) );
     block (col=-1, row=-1, width=width*2, length=length*2, up=up, height=height*2);
}

module pipe_rod (col=0, row=0, up=0, width=2, length=4,height=FULL, closure=180, orientation=0, scale=LUGO) {
  /* This is an aux function to dig the bed of a pipe
     It is just a well positioned cylinder that should have same length and width as the pipe
  */
     x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
     y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
     z_0 = up     * PART_HEIGHT(scale) + 2*THIRD * PART_HEIGHT(scale);

     translate ([x_0, y_0, z_0]) {
	  rotate ([90,0,0])
	       translate ([0, 0, 1*NUDGE])
	       cylinder(h= length*PART_WIDTH(scale)+4*NUDGE, r = PART_WIDTH(scale), center = true, $fs = CYL_FS);
     }
}


