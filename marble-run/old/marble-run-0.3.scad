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

// track (col=0, row=0, up=0, length=2, width=2, closure=3,height=FULL);

doblo   (2,   0,   0,   1,   4,   THIRD,  true, false, scale=SCALE );
doblo   (3,   0,   0,   1,   4,   2*THIRD,  true, false, scale=SCALE );
doblo   (4,   0,   0,   1,   4,   FULL,  true, false, scale=SCALE );
doblo   (5,   0,   0,   1,   4,   FULL+THIRD,  true, false, scale=SCALE );
doblo   (6,   0,   0,   1,   4,   FULL+2*THIRD,  true, false, scale=SCALE );
// pipe (up=2*THIRD,closure=3);
// pipe (col=-2);
// doblo (col=5, row=5, up=0, width=2, length=8, height=FULL, nibbles_on_off=false,diamonds_on_off=false,scale=LUGO,orientation=45) ;

track (col=-4, row=0, up=0, length=6,  width=2, closure=5, orientation=0);

doblo   (-8,   0,   0,   2,   6,    THIRD,  true, false, orientation=0 );
// color ("green") doblo   (-4,   -4,   0,   2,   6,    THIRD,  true, false, orientation=45 );
// color ("blue") doblo   (-4,   -4,   0,   2,   6,    THIRD,  true, false, orientation=60 );
// color ("grey") doblo   (-4,   -4,   0,   2,   6,    THIRD,  true, false, orientation=90 );
// color ("red") block   (col=-4, row=-4, up=0, width=2, length=6, height=THIRD, orientation=270 );

// --- simple 4x2 lego brick
module calibration (scale=SCALE)
{
     //     (col, row, up, width,length,height,nibbles_on_off) 
     doblo   (0,   0,   0,   2,   4,    THIRD,  true, false, scale );
}

/* -----------------------------------------flat track --------------------------------- */

module track (col=0, row=0, up=0, length=4, width=2, closure=5, orientation=0, scale=LUGO) {
     /* The track element will be placed along the y axis (back/forth)
	In the doblo system: width= left/right length, length= forth/back length
	The tube is embedded in block that sits on a doblo block without nibbles.
	Orientation is a bit messy since it has to happen within the doblo components
	closure is a value between 2 and 12 and it defines the height of block that will shave off the tube
	*/

     // doblo + block block heights
     upper_block_h = closure-1;
     bottom_doblo_h = 2*THIRD;

     // prepare the bed
     difference () {
	  union () {
	       doblo (col=col, row=row, up=up, width=width, length=length, height=bottom_doblo_h,
		      nibbles_on_off=false,diamonds_on_off=false,scale=LUGO,orientation=orientation) ;
	       color("grey") block (col=col, row=row, up=bottom_doblo_h, width=width, length=length, height=upper_block_h,
		      nibbles_on_off=false, diamonds_on_off=false, scale=LUGO,orientation=orientation) ;
	  }
	  // dig
	  pipe_rod (col=col, row=row, up=up+bottom_doblo_h, width=width, length=length, height_start=0, height=FULL, closure=closure, orientation=orientation, scale=LUGO);
     }
     // lay the pipe
     pipe (col=col, row=row, up=up+HALF, width=width, length=length, height_start=0, height=FULL, closure=closure, orientation=orientation, scale=LUGO);
}

/* -----------------------------------------slope track --------------------------------- */

// has extra params. Could be combined with flat track

// test slope
// slope (col=0, row=0, up=0, length=6,  width=2, closure=5, height_start=FULL,orientation=0);

pipe_sloped_0 ();


module slope (col=0, row=0, up=0, width=2, length=4, height_start=FULL, closure=3, orientation=0, scale=LUGO) {
     // The slope element will be placed along the y axis (back/forth), higher end in back
     // In the doblo system: width= left/right length, length= forth/back length
     // height_start should use Lego scale values, i.e. THIRD, FULL (aka 2,6)
     // closure is a value between 2 and 6

     // doblo + block block heights
     upper_block_h = closure-1;
     bottom_doblo_h = 2*THIRD;

     // prepare the bed
     difference () {
	  union () {
	       doblo (col=col, row=row, up=up, width=width,length=length,height=bottom_doblo_h,
		      nibbles_on_off=false,diamonds_on_off=false,scale=LUGO,orientation=orientation) ;
	       color ("grey") block (col=col, row=row, up=up+bottom_doblo_h, width=width, length=length, height=upper_block_h,
		      nibbles_on_off=false, diamonds_on_off=false, scale=LUGO, orientation=orientation) ;
	       triangle_block (col=col, row=row, up=up+bottom_doblo_h+upper_block_h, width=width, length=length, height_start = height_start,
		      scale=LUGO,orientation=orientation) ;
	  }
	  // dig
	  pipe_rod (col=col, row=row, up=up+bottom_doblo_h, width=width, length=length, height_start = height_start, closure=closure, orientation=orientation, scale=LUGO);
     }
     // lay the pipe
     pipe (col=col, row=row, up=up+HALF, width=width, length=length, height_start=height_start, closure=closure, orientation=orientation, scale=LUGO);
}

module triangle_block (col=0, row=0, up=4*THIRD, width=2, length=4, height_start = THIRD, 
		       nibbles_on_off=false, diamonds_on_off=false, scale=LUGO, orientation=0) {
     /* Computes a sloping block that will sit on top of the block and hold the pipe */ 
     corners = [[0,0], [length*PART_WIDTH(scale),0], [length*PART_WIDTH(scale),height_start*PART_HEIGHT(scale)]];
     x_0 = col    * PART_WIDTH(scale);
     y_0 = -row * PART_WIDTH(scale) ;
     z_0 = up     * PART_HEIGHT(scale);
     // rotation (optional)
     rotate_about_z (angle=orientation, point=[col*PART_WIDTH(scale),-row*PART_WIDTH(scale)]) // row is inverted
	  // doblo position
	  translate ([x_0, y_0, z_0]) {
	  // translation to fix after rotation
	  translate ([0,-length*PART_WIDTH(scale),0])
	       rotate ([90,0,90])
	       linear_extrude (height=width*PART_WIDTH(scale))  polygon (corners);
     }
}

/* -------------------------------------- flat or sloped pipe -------------------------------------------- */


module pipe (col=0, row=0, up=0, width=2, length=4, height_start=0, closure=5, scale=LUGO, orientation=0) {
     /* The pipe sits on Z=0 along the y-axis (in rotation position = 0)
	To position it with respect to a doblo block, use the up parameter (thirds)
	If used to embed, use the pipe_rod module to dig a nice hole for the pipe (same pos. params)
	Cannot be rotated. Use tracks or slopes for high-level pipes.
     */
     echo ("DEBUG: Pipe, length=", length, "height_start=", height_start);
     x_0 = col    * PART_WIDTH(scale);
     y_0 = -row * PART_WIDTH(scale) ;
     z_0 = up     * PART_HEIGHT(scale);

     // horizontal orientation (rotation). 90degs makes sense.
     rotate_about_z (angle=orientation, point=[col*PART_WIDTH(scale),-row*PART_WIDTH(scale)])

	  if (height_start == 0) {
	       translate ([x_0, y_0, z_0]) {
		    pipe_0 (length=length, width=width, closure=closure, scale=scale, height_start=0);
	       }
	  }
	  else {
	       translate ([x_0, y_0, z_0]) {
		    pipe_sloped_0 (col=col, row=row, up=up, length=length, width=width, closure=closure, height_start=height_start);
	       }
	  }
}

/* ------------------------------------ primitive pipe ------------------------------------------
   and aux modules
 */

module pipe_0 (length=4, width=2, closure=5, scale=LUGO, height_start=0) {
/* Aux function
   Creates a pipe with a given length and form, aka closure
   The pipe sits at origin X,Y,Z=0 along the y-axis in horizontal rotation position = 0
   it should be re-positioned with the pipe() module
   The outer width of the pipe is two Lego width = 16mm. That is height=5 (out of 6)
   width = 2. Do not change for now
*/
     radius = width * PART_WIDTH(scale) / 2.0;
     y_0 = - length * PART_WIDTH(scale) / 2.0 ;
     // pipe is pushed up its radius
     z_0 = radius;
     // echo ("DEBUG: Radius pipe =", radius, "length=", length);
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
	  top_block_shave (col=0, row=-0.5, width=width, length=length+1, up=closure, height=length*4);
	  if (closure > 6) echo ("WARNING: Meaningless value pour closure=", closure, "Should be between 2 and 10");
     }
}

module pipe_sloped_0 (length=4, width=2, closure=5, scale=LUGO, height_start=FULL) {
     angle = atan2(height_start * PART_HEIGHT(scale), length * PART_WIDTH(scale)) ;
     rotate ([angle,0,0])
     // add an extra length because we will have to shave off horizontally
     translate ([0,0,height_start])
     pipe_0 (length=length+1, width=width, closure=closure, scale=scale, height_start=height_start);
     }


module pipe_sloped_0_alt (length=4, width=2, closure=3, scale=LUGO, height_start) {
     /* Sloped pipes are bit more difficult because the ends need to shaved off
	Could be merged with pipe_0 some day ...
     */
		   
     if (closure > 6) echo ("WARNING: Meaningless value pour closure=", closure, "Should be between 2 and 10");
     radius = width * PART_WIDTH(scale) / 2.0;
     angle = atan2(height_start * PART_HEIGHT(scale), length * PART_WIDTH(scale)) ;
     extra_length = PART_WIDTH(scale)/2;
     cyl_height = length*PART_WIDTH(scale) + 2 * extra_length;
     cut_cube_w = width*PART_WIDTH(scale)*2;
     x_0 = radius;
     y_0 = - cyl_height/2+PART_WIDTH(scale)/4;
     // z_0 = height_start*PART_HEIGHT(scale);
     z_0 = radius;
     
     echo (str ("pipe height_start=", height_start, ", length=", length, ", angle=", angle));
     

	  
  // position the hollow tube
//      translate ([radius,-length*PART_WIDTH(scale)/2+extra_length,0])
	  // The tube is rotated 90 degs + the slope angle
	  
     rotate ([90,0,0])
     // h will be rotated, so it is left/right length, aka width in DOBLO
     difference() {
	  cylinder(h= cyl_height, r = radius, center = true, $fs = CYL_FS);
	  translate ([0,0,-2*NUDGE]) {
	       cylinder(h= cyl_height+6*NUDGE, r = radius-TUBE_WALL_WIDTH, center = true, $fs = CYL_FS);
	  }
	  // position of the cutting the block for the tube according to closure.
	  translate ([0, cut_cube_w/2 -radius+closure*PART_HEIGHT(scale),0]) {
	       cube ([cut_cube_w, cut_cube_w, cyl_height+1],center=true);
	  }
     }

}


module top_block_shave (col=-1, row=-1, width=2, length=4, up=FULL, height=3*FULL) {
     /* Aux function that will draw a block that can be used to shave off stuff on top.
      */
     // echo ("PART_WIDTH(SCALE) =", PART_WIDTH(SCALE) );
     block (col=col, row=row, width=width, length=length, up=up, height=height);
}

module pipe_rod (col=0, row=0, up=0, width=2, length=4, height_start = 0, closure=180, orientation=0, scale=LUGO, rotation=0) {
     /* This is an aux function to dig the bed of a pipe
	It is just a well positioned cylinder that should have same width as the pipe.
	It can slope if height_start > 0
     */
     x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
     y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
     z_0 = up     * PART_HEIGHT(scale) + up * PART_HEIGHT(scale); 
     
     rotate_about_z (angle=orientation, point=[col*PART_WIDTH(scale),-row*PART_WIDTH(scale)]) {
	  // row is inverted
	  if (height_start == 0) {
	       // the rod is flat
	       translate ([x_0, y_0, z_0]) {
		    rotate ([90,0,0])
			 translate ([0, 0, 1*NUDGE])
			 cylinder(h= length*PART_WIDTH(scale)+4*NUDGE, r = PART_WIDTH(scale), center = true, $fs = CYL_FS);
			 }
	  }
	  // else it slopes
	  else {
	       angle = atan2(height_start * PART_HEIGHT(scale), length * PART_WIDTH(scale)) ;
	       echo (str ("height_start=", height_start, ", length=", length, ", angle=", angle));
	       rotate ([angle,0,0])
		    translate ([x_0, y_0, z_0+height_start*PART_HEIGHT(scale)]) {
		    rotate ([90,0,0])
			 translate ([0, 0, 1*NUDGE])
			 cylinder(h= 2*length*PART_WIDTH(scale), r = PART_WIDTH(scale), center = true, $fs = CYL_FS);
			 }
	  }
     }
}

