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

// SCALE MUST BE set, although one can override it using the LUGO (0.5) and DOBLO (1) constants.
SCALE =0.5;   // Lego size, print tested
// SCALE =1;   // Duplo size, less tested

// LOAD doblo factory
include <../doblo-factory.scad>;

// Overrides
LATTICE_TYPE    = 3; 

// Castle kit constants, some could be reused here
UNIT = (SCALE < 0.6) ? THIRD : HALF; // Lego vs. Duplo small height units
BASE_HEIGHT  = (SCALE < 0.6) ? 2*THIRD : HALF;  // Height of the base plaform.
FLOOR_TOP    = 8*FULL;  // Height of the first floor, e.g. nibbles go here
FLOOR_BOTTOM = FLOOR_TOP-UNIT;  // bottom of a floor
WALL_TOP     = 10*FULL;            // e.g. nibbles go here
WALL_BOTTOM  = WALL_TOP-BASE_HEIGHT; // this is wall_top - the base plate height
INNER_WALL_TOP = FLOOR_BOTTOM - BASE_HEIGHT;  // e.g. inside of walls, needs a BASE_HEIGHT on top

NUDGE = 0.001;

// marble run specific constants
// TUBE_WALL_WIDTH is 2mm for Lego compatible and 2.4 mm for duplo compatible.
function TUBE_WALL_RATIO(SCALE) = (SCALE < 0.6) ? 0.25 : 0.15 ; // use with doblo(), block() etc.
function TUBE_WALL_WIDTH(SCALE) = PART_WIDTH(SCALE) * TUBE_WALL_RATIO(SCALE) ; // in mm

// Height of the stackable base plate. 1*THIRD can be difficult to print for lego compatibles
// Turn into a function for more flexibility ?
BOTTOM_HEIGHT = (SCALE < 0.6) ? 2*THIRD : HALF; // Lego vs. Duplo, same as base height in castle kit.

echo (str ("SCALE = ", SCALE));
echo (str ("BOTTOM_HEIGHT = ", BOTTOM_HEIGHT));
echo (str ("LATTICE-WIDTH = ", LATTICE_WIDTH(SCALE)));	
echo (str ("TUBE_WALL_WIDTH = ", TUBE_WALL_WIDTH(SCALE)));
echo (str ("TUBE_WALL_RATIO = ", TUBE_WALL_RATIO(SCALE)));


// ----------------  Execute models. Uncomment only one

// calibration ();
module calibration (scale=SCALE) {
     /* --- simple 4x2 lego brick sitting in the center */
     //     (col, row, up, width,length,height,nibbles_on_off) 
     doblo   (0,   0,   0,   2,   4,   2*THIRD,  true, false, scale );
}

// This is a kind of scale
// stairways_scale ();
module stairways_scale () {
     doblo   (4,   7,   0,   2,   1,   0,  true, false, scale=SCALE );
     doblo   (4,   6,   0,   2,   1,   THIRD,  true, false, scale=SCALE );
     doblo   (4,   5,   0,   2,   1,   2*THIRD,  true, false, scale=SCALE );
     color ("red") doblo   (4,   4,   0,   2,   1,   FULL,  true, false, scale=SCALE );
     doblo   (4,   3,   0,   2,   1,   FULL+THIRD,  true, false, scale=SCALE );
     doblo   (4,   2,   0,   2,   1,   FULL+2*THIRD,  true, false, scale=SCALE );
     color ("red") doblo   (4,   1,   0,   2,   1,   2*FULL,  true, false, scale=SCALE );
     doblo   (4,   0,   0,   2,   1,   2*FULL+THIRD,  true, false, scale=SCALE );
}

// curve (col=3, angle=180, closure=7, support_height=7, up=0);
// track (col=-3, row=0, up=0, length=8,  width=2, closure=5, orientation=0);

block_ex1();
module block_ex1 () {
// test tracks
myScale = DOBLO;
// track (col=-6, row=0, up=0, length=2,  width=2, closure=5, support_height=2, orientation=0, scale = myScale);
// track (col=-6, row=0, up=0, length=2,  width=2, closure=10, orientation=0,  scale = myScale);
track (col=-6, row=3, up=0, length=2,  width=2, closure=8, orientation=0,  scale = myScale);
track (col=-6, row=6, up=0, length=2,  width=2, closure=4, support_height=2, orientation=0,  scale = myScale);
track (col=-3, row=0, up=0, length=6,  width=2, closure=5, orientation=0,  scale = myScale);
track (col=-3, row=7, up=0, length=2,  width=2, closure=5, orientation=0,  scale = myScale);
slope (col=0, row=0, up=0, length=4,  width=2, closure=5, height_start=FULL,orientation=0,  scale = myScale);
curve (col=3, angle=180, closure=7, support_height=7, up=0,  scale = myScale);
curve_wide (col=6, angle=180, closure= 7, scale = myScale);
hole (col=3, row=5, closure=7, width=2, length=6, id="hole A", scale = myScale, nibbles_on_off=true);
slope (col=0, row=6, up=0, length=4,  width=2, support_height=2, closure=5, height_start=THIRD,orientation=0, scale=myScale);
}

// combination
module combi_ex1 () {
     doblo           (col=-12, row=-2, height=THIRD, length=2,  width=2, nibbles_on_off=false, scale = DOBLO);
     doblo           (col=-12, row=-2, up=THIRD, height=4*THIRD, length=2,  width=2, nibbles_on_off=false );
     track_component (col=-12, row=-2, up=5*THIRD, length=2,  width=2, closure=10, orientation=0);
     slope (col=-12, row=0, up=0, length=6,  width=2, closure=5, height_start=FULL, support_height=1, orientation=0);
     track (col=-12, row=6, up=0, length=2,  width=2, closure=5, orientation=0);
     track (col=-12, row=8, up=0, length=2,  width=2, closure=5, support_height=1, orientation=0);
}


// test with other heights
// slope (col=-8, row=0, up=0, length=6,  width=2, closure=5, bottom_height=THIRD, height_start=2*FULL,orientation=0);
// test raw slope
// slope_component (col=-12, row=0, up=0, length=6, width=2, closure=5, height_start=FULL,orientation=0);

// raw pipe
// pipe_sloped_0 ();
// pipe_0 ();

// doblo   (-8,   0,   0,   2,   6,    THIRD,  true, false, orientation=0 );
// color ("green") doblo   (-4,   -4,   0,   2,   6,    THIRD,  true, false, orientation=45 );
// color ("blue") doblo   (-4,   -4,   0,   2,   6,    THIRD,  true, false, orientation=60 );
// color ("grey") doblo   (-4,   -4,   0,   2,   6,    THIRD,  true, false, orientation=90 );
// color ("red") block   (col=-4, row=-4, up=0, width=2, length=6, height=THIRD, orientation=270 );


/* ----------------------------------------- Tracing 
 */

MARBLE_TRACE = true;
MARBLE_DEBUG = true;

module trace_msg (type="marble run block", text="created", id="some id") {
     /* Trace block creation with a console message, works best when you give each element an id.
	*/

     if ((MARBLE_TRACE == true) || (TRACE == true)) {
	  echo (str ("<font color='blue'>MARBLE RUN element</font> ", type, ", id= ", id, " : ", text));
     }
}

module debug_msg (stri) {
     if (MARBLE_DEBUG || DEBUG) { echo (str( " - ", stri)) ;}
}


/* ----------------------------------------- track ---------------------------------
This element includes:
- a lego/duplo compatible bottom element
- a block on top of that
- a straight track embedded into this block
 */

// track (scale=LUGO);
// track (col=4,scale=DOBLO);
module track (col=0, row=0, up=0, length=4, width=2, closure=5, orientation=0, bottom_height=BOTTOM_HEIGHT, support_height=0, scale=LUGO, id="some track") {
     /* The track element will be placed along the y axis (back/forth)
	In the doblo system: width= left/right length, length= forth/back length
	The tube is embedded in block that sits on a doblo block without nibbles.
	Instead of just digging a hole into a block we create a real tube, allowing for some subtler support structures some day
	Orientation is a bit messy since it has to happen within the doblo components
	Params
	- closure is a value between 2 and 12 and it defines the height of block that will shave off the tube
	- bottom_height is the height of the block underneath the tube, e.g. the lego/duplo compatible
	*/
     trace_msg (type="track", id= id);
     // position a lego/duplo compatible block
     color ("Aqua") doblo (col=col, row=row, up=up, width=width, length=length, height=bottom_height, nibbles_on_off=false,diamonds_on_off=false,scale=scale,orientation=orientation) ;
     // Add an tube embedded in a block on top
     track_component (col=col, row=row, up=up+bottom_height, length=length, width=width, closure=closure, orientation=orientation, support_height=support_height, scale=scale);

     // add nibbles on top if closure is big
     if (closure > 9) nibbles (col=col, row=row, up=bottom_height+closure, width=2, length=2, scale=scale);

}

module track_component (col=0, row=0, up=0, length=4, width=2, closure=5, orientation=0, support_height=0, scale=LUGO) {
     /* The track element will be placed along the y axis (back/forth)
	In the doblo system: width= left/right length, length= forth/back length
	The tube is embedded in a block that allows creating playmobile like structures, or just printing it.
	Params
	- closure is a value between 2 and 12 and it defines the height of block that will shave off the tube
	*/

     // the block that supports the tube has the same size unless support_height is set.
     upper_block_h = (support_height > 0) ? support_height : closure;

     // prepare the bed
     difference () {
	  color("Aquamarine") block (col=col, row=row, up=up, width=width, length=length, height=upper_block_h,
			       nibbles_on_off=false, diamonds_on_off=false, scale=scale, orientation=orientation) ;
	  // dig
	  pipe_rod (col=col, row=row-0.5, up=up, width=width, length=length+1, height_start=0, orientation=orientation, scale=scale);
     }
     // lay the pipe
     pipe (col=col, row=row, up=up, width=width, length=length, height_start=0, closure=closure, orientation=orientation, scale=scale);
}


/* -----------------------------------------slope track --------------------------------- */

// has extra params. Could be combined with flat track


// slope (scale=LUGO);
// slope (col=- 4, row=6, height_start=0, scale=DOBLO);
// slope (col=2, row=4, up=0, length=4,  width=2, closure=5, height_start=FULL, orientation=0, scale=DOBLO);
// track (scale=DOBLO);
// slope (col=0, row=0, up=0, length=4,  width=2, closure=5, height_start=FULL,orientation=0, scale = DOBLO);

module slope (col=0, row=0, up=0, width=2, length=4, bottom_height=BOTTOM_HEIGHT, height_start=FULL, support_height=0, closure=5, orientation=0, scale=LUGO,  id="some slope") {
     // The slope element will be placed along the y axis (back/forth), higher end in back
     // In the doblo system: width= left/right length, length= forth/back length
     // height_start should use Lego scale values, i.e. THIRD, FULL (aka 2,6)
     // closure is a value between 2 and 6

     trace_msg (type="slope", id= id);
     // position a doblo block
     color ("Magenta") doblo (col=col, row=row, up=up, width=width,length=length,height=bottom_height,
	    nibbles_on_off=false,diamonds_on_off=false,scale=scale,orientation=orientation) ;
     // add the slope component, move it up to sit on the bottom_height block
     slope_component (col=col, row=row, up=up+bottom_height, length=length, width=width, height_start=height_start, support_height=support_height, closure=closure, orientation=orientation, scale=scale);
}


module slope_component (col=0, row=0, up=0, width=2, length=4, height_start=FULL, support_height=0, closure=5, orientation=0, scale=LUGO) {
     // The slope element will be placed along the y axis (back/forth), higher end in back
     // In the doblo system: width= left/right length, length= forth/back length
     // height_start should use Lego scale values, i.e. THIRD, FULL (aka 2,6)
     // closure is a value between 2 and 6
     
     // doblo + block block heights
     upper_block_h = (support_height > 0) ? support_height : closure;
     
     // prepare the bed
     difference () {
	  union () {
	       color ("pink") block (col=col, row=row, up=up, width=width, length=length, height=upper_block_h, 
				     nibbles_on_off=false, diamonds_on_off=false, scale=scale, orientation=orientation) ;
	       color ("hotpink") triangle_block (col=col, row=row, up=up+upper_block_h, width=width, length=length,
						 height_start = height_start, scale=scale,orientation=orientation) ;
	  }
          // dig a hole.
	  pipe_rod (col=col, row=row, up=up, width=width, length=length, height_start = height_start, orientation=orientation, scale=scale);
     }
     // lay the pipe     
     pipe (col=col, row=row, up=up, width=width, length=length, height_start=height_start, closure=closure, orientation=orientation, scale=scale);
}


/* ------- triangle for slope  ------ */

module triangle_block (col=0, row=0, up=2*BOTTOM_HEIGHT, width=2, length=4, height_start = THIRD, 
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


/* -----------------------------------low level flat or sloped pipe -------------------------------------------- */


module pipe (col=0, row=0, up=0, width=2, length=4, height_start=0, closure=5, scale=LUGO, orientation=0,  id="some pipe") {
     /* The pipe sits on Z=0 along the y-axis (in rotation position = 0)
	To position it with respect to a doblo block, use the up parameter (thirds)
	If used to embed, use the pipe_rod module to dig a nice hole for the pipe (same pos. params)
	Cannot be rotated. Use tracks or slopes for high-level pipes.
     */
     debug_msg (str("Pipe, length=", length, "height_start=", height_start));
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
		    pipe_sloped_0 (col=col, row=row, up=up, length=length, width=width, closure=closure, height_start=height_start, scale=scale);
	       }
	  }
}

/* ------------------------------------ primitive pipes ------------------------------------------
   and aux modules
 */

module pipe_0 (length=4, width=2, closure=5, scale=LUGO, height_start=0, scale=SCALE) {
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
     debug_msg (str ("pipe_0: Radius pipe =", radius, "length=", length));
     difference () {
	  // position the hollow tube
	  translate ([radius, y_0, z_0]) {
	       // The tube
	       rotate ([90,0,0])
		    difference () {
		    // h will be rotated, so its left/right length, aka width in DOBLO
		    cylinder(h= length*PART_WIDTH(scale), r = radius, center = true, $fs = CYL_FS);
		    translate ([0,0,2*NUDGE]) cylinder(h= length*PART_WIDTH(scale)+30*NUDGE, r = radius -TUBE_WALL_WIDTH(scale), center = true, $fs = CYL_FS);
	       }
	  }
	       
	  // position of the cutting the block for the tube according to closure.
	  top_block_shave (col=0, row=-0.5, width=width, length=length+1, up=closure+NUDGE, height=FULL*4, scale=scale);
     }
}

module pipe_sloped_0 (length=4, width=2, closure=5, up=0, scale=LUGO, height_start=FULL, scale=SCALE) {
     /* We first create a normal straight pipe that sits flat on the y axis, going forward from point 0
	The pipe must be longer than length because if rotated it will not fit.
	rotation is about point 0, i.e. after initial rotation the tube sits minus one unit on x axis and will be cut on y=0 and length.
	*/
     angle = atan2(height_start * PART_HEIGHT(scale), length * PART_WIDTH(scale)) ;
     point = [0,0,0];
     // add an extra length because we will have to shave off horizontally
     extra_length = length + 2; // we add 2 PART_WIDTH
     // move it so that the lower tip is z=0
     translate ([0,0,height_start * PART_HEIGHT(scale)])
     // Shave off extra elements in front and back
     difference () {
	  // This will position and rotate the tube (down) and it only will have to be lifted up from z=0
	  rotate_about_x (angle, point)
	       translate ([0,PART_WIDTH(scale),0]) // move it backwards on y axis one unit
	       pipe_0 (length=extra_length, width=width, closure=closure, scale=scale, height_start=height_start);
	  block (col=-1+NUDGE, up=-FULL*2+NUDGE, row=-2+NUDGE, width=width*2, length=2,  height=6*FULL, scale=scale); // bit of overkill
	  block (col=-1+NUDGE, up=-FULL*3+NUDGE, row=length+NUDGE, width=width*2, length=2, height=6*FULL, scale=scale);
     }
}


module top_block_shave (col=-1, row=-1, width=2, length=4, up=FULL, height=3*FULL, scale=SCALE) {
     /* Aux function that will draw a block that can be used to shave off stuff on top.
	We add some nudging preventing share edges in principle
      */
     // echo ("PART_WIDTH(SCALE) =", PART_WIDTH(SCALE) );
     block (col=col+NUDGE, row=row+NUDGE, width=width+NUDGE, length=length+NUDGE, up=up-NUDGE, height=height+NUDGE, scale=scale);
}

// pipe_rod (height_start=0,row=0, length=8);
// pipe_rod (height_start=3,col=2, row=2);
// pipe_rod (height_start=6,row=2);
// pipe_rod (scale=DOBLO, height_start=FULL);
// pipe_rod (scale=DOBLO);

module pipe_rod (col=0, row=0, up=0, width=2, length=4, height_start = 0, orientation=0, scale=SCALE, rotation=0) {
     /* This is an aux function to dig the bed of a pipe
	It is just a cylinder that is positioned flat, by default at x=0/y=0. It is used for subtraction.
	It can slope if height_start > 0
     */
     x_0 = col*PART_WIDTH(scale) + width * PART_WIDTH(scale) / 2.0;
     radius = PART_WIDTH(scale); // tubes always fill a 2*width
     debug_msg ("pipe_rod: ", "row =", row, "length=", length);

     rotate_about_z (angle=orientation, point=[col*PART_WIDTH(scale),-row*PART_WIDTH(scale)]) {
	  // row is inverted
	  if (height_start == 0) {
	       // the rod is flat
	       y_0 = - row * PART_WIDTH(scale)-length*PART_WIDTH(scale)/2.0;
	       z_0 = up * PART_HEIGHT(scale) + PART_WIDTH(scale); 
	       translate ([x_0, y_0, z_0]) {
		    rotate ([90,0,0])
			 translate ([0, 0, 1*NUDGE])
			 cylinder(h= length*PART_WIDTH(scale)+4*NUDGE, r = radius, center = true, $fs = CYL_FS);
			 }
	  }
	  // else it slopes
	  else {
	       // if row is not 0 then move it forth or back (inverted)
	       y_0 = -(row * PART_WIDTH(scale));
	       // the back originally sits on z=0.
	       z_0 = up  * PART_HEIGHT(scale) + height_start * PART_HEIGHT(scale);
	       tube_length = (length+2)*PART_WIDTH(scale); // must be longer because it rotates
	       angle = atan2(height_start * PART_HEIGHT(scale), length * PART_WIDTH(scale)) ;
	       debug_msg (str ("PIPE_ROD, height_start=", height_start, ", length=", length, ", angle=", angle));

	       // final x/y/z position
	       translate ([x_0, y_0, z_0]) {
		    // rotate around x=0 with angle = slope. bottom of part to but should sit at z=0 
		    rotate_about_x (angle,  [0,0,0]) {
			 // first rotate around x=0, then move it so that top is x=0 and y=0 + 1 part width
			 translate ([0, - tube_length/2 + 1*PART_WIDTH(scale) , radius])
			      rotate ([90,0,0])
			      cylinder(h=tube_length , r = radius, center = true, $fs = CYL_FS);
			      }
		    }
	  }
     }
}


/* ------------------------------------- SHARP CURVES -------------------------------------------------- */

/*
For now we plan to support

- sharp 90deg curves sitting on a single 2x2  block
- 90 deg curves sitting on a 4x4 block

*/

// The openscad angle parameter requires an openscad version (2016.xx) that is not installed in Ubuntu 18 :( Workaround: Use blocks to cut.

// To do: Add rotation

// curve (up=0, closure=7, angle=180);
// curve (up=0, closure=7, angle=180, scale=DOBLO, row=3);
// curve (up=0, closure=5, angle=90);

module curve (col=0, row=0, up=0, closure=5, orientation=0, bottom_height=BOTTOM_HEIGHT, support_height=0, scale=LUGO, angle = 90,  id="some curve") {
     /* The curve element will be placed its sharp corner against x=0/y=0 (because this requires the least amount of code)
	In the doblo system: width= left/right length, length= forth/back length
	The tube is embedded in block that sits on a doblo block without nibbles.
	Instead of just digging a hole into a block we create a real tube, allowing for some subtler support structures some day
	Orientation is a bit messy since it has to happen within the doblo components
	This elements is similar to track () with respect to its construction and params.
	Params
	- closure is a value between 2 and 12 and it defines the height of block that will shave off the tube
	- bottom_height is the height of the block underneath the tube, e.g. the lego/duplo compatible
	- angle is either 90 or 180
	- There __no__ length/width since they are determined by the tube which is width=2 and length=2 or 4
	*/

     trace_msg (type="curve", id= id);

     if (angle == 90 ) {
	  width =2; length=2;
	  // position a lego/duplo compatible block
	  color ("red") doblo (col=col, row=row, up=up, width=width, length=length, height=bottom_height, nibbles_on_off=false,diamonds_on_off=false,scale=scale,orientation=orientation) ;
	  // Add an tube embedded in a block on top
	  curve_component (col=col, row=row, up=up+bottom_height, length=length, width=width, closure=closure, orientation=orientation, support_height=support_height, scale=scale);
	  }

     
     else if (angle == 180) {
	  width =2; length=4;
	  
	  // position a lego/duplo compatible block
	  color ("red") doblo (col=col, row=row, up=up, width=width, length=length, height=bottom_height, nibbles_on_off=false,diamonds_on_off=false,scale=scale,orientation=orientation) ;
	  // Add an tube embedded in a block on top
	  curve_component (col=col, row=row, up=up+bottom_height, length=length, width=width, closure=closure, orientation=orientation, support_height=support_height, scale=scale, angle=180);
     }
     else echo ("<font color='red'>WARNING </font>: Unsupported angle parameter used in curve function", angle);

     // if (closure > 10) // add nibbles
}

// CHECK if params are passed ok and if default combos work
// curve_component(angle=180);

module curve_component (col=0, row=0, up=0, length=2, width=2, closure=5, orientation=0, support_height=0, angle=90, scale=LUGO) {
     /* The curve_component creates narrow 90 or 180 deg angled curves embedded into a block
	width and length are not used for the moment. We could image a large lego block or event larger tubes some day
      */

     // the block that supports the tube has the same size unless support_height is set.
     upper_block_h = (support_height > 0) ? support_height : closure;
     //hack for direct use
     mylength = (angle==90) ? 2 : 4;
     // prepare the bed
     difference () {
	  color("crimson") block (col=col, row=row, up=up, width=width, length=mylength, height=upper_block_h, nibbles_on_off=false, diamonds_on_off=false, scale=scale,orientation=orientation) ;
	  // dig the hole
	  curved_tube (col=col, row=row, up=up, closure=closure, orientation=orientation,  support_height=support_height, scale=scale, filled=true, angle=angle);
     }
     // Add the pipe, shave off the top
     difference () {
	  curved_tube (col=col, row=row, up=up, closure=closure, orientation=orientation, support_height=support_height, scale=scale, angle=angle);
	  // position of the cutting the block for the tube according to closure.
	  top_block_shave (col=col-0.5, row=row-0.5, width=width+1, length=mylength+1, up=up+closure+NUDGE, height=length*4, scale=scale);
	  }
}

// curved_tube(angle=180, filled=true);
module curved_tube  (col=0, row=0, up=0, closure=5, orientation=0, angle=90, scale=LUGO, filled=false) {
     /*	Low level construct, i.e. a curved tube that is positioned flat starting x=0/y=0 by default
	If filled = true can be used for subtraction, i.e. to dig a large hole for the not filled version.
	Params:
	- angle should be either 90 or 180. Other angles could be implemented in the future, in particular when normal OpenSCAD distributions accept rotate_extruct(angle= ....)
     */
     // curve outer tube takes all of the 2x2 standard lego width
     curve_radius = 1 * PART_WIDTH(scale); // radius of the 90 deg curve
     tube_radius =  1 * PART_WIDTH(scale) -NUDGE; // vertical, must be a bit smaller than the curve_radius or openscad will fail
     inner_radius = 1 * PART_WIDTH(scale) - TUBE_WALL_WIDTH(scale);

     x_0 = col    * PART_WIDTH(scale);
     // the larger 180 deg block must be pushd down front a bit
     y_0 = (angle==90) ? -row * PART_WIDTH(scale) : -(row+2) * PART_WIDTH(scale) ;
     z_0 = up     * PART_HEIGHT(scale) + tube_radius;
     $fn = 30;
     debug_msg (str ("curved_tube: curve_radius=", curve_radius, ", tube_radius=", tube_radius, ", inner_radius=", inner_radius));


     // position the result in the coordinate system
     translate ([x_0, y_0, z_0]) {

	  difference () {	  
	       if (filled == true) {
		    rotate_extrude() {
			 // rotate_extrude(angle=90) - not working in ordinary distributions
			 translate([curve_radius, 0]) // center of rotation
			      circle(r = tube_radius); // radius of rotated circle
		    }
	       }  else {
		    difference () {
			 rotate_extrude() {
			      // rotate_extrude(angle=90) - not working in ordinatry distributions
			      translate([curve_radius, 0]) // center of rotation
				   circle(r = tube_radius); // radius of rotated circle
			 }
			 rotate_extrude() {
			      translate([curve_radius, 0]) // center of rotation
				   circle(r = inner_radius); // radius of rotated circle
			 }
			 }
		    }
	  // shave to the left (block pos are relative within this difference block !)
	       block (col=-4-NUDGE, row=-3+NUDGE, up=-curve_radius+NUDGE, length=6, width=4,height=curve_radius*2, scale=scale);
	  // shave in the back, makes it a 90 deg angle
	  if (angle == 90) 
	       block (col=-2+NUDGE, row=-2-NUDGE, up=-curve_radius+NUDGE, length=2, width=6,height=curve_radius*2, scale=scale);
	  // inside of the tube
	       }
     }
}

/* ------------------------------------- WIDE CURVES -------------------------------------------------- */

/*
For now we plan to support

- A 90deg curve sitting on a single 4x4 square block
- A 180 deg curve sitting on block with a hole in the middle.
*/

// The angle parameter requires an openscad version (2016.xx) that is not installed in Ubuntu 18 :(

// To do: Add an angle or type argument ?


// doblo (col=0, row=0, up=3*THIRD, height=THIRD, length=8, width=4, nibbles_on_off=true );
// curve_wide (row=-4, col=-4, angle=90, nibbles_on_off=true, closure=10);
// curve_wide(angle=180, support_height=3, closure=10);
// curve_wide(angle=180, support_height=3, closure=5, scale=DOBLO);
// curve_wide (row=2, col=-4, angle=90, nibbles_on_off=true, closure=5, scale=LUGO);
// curve_wide (row=-4, col=-4, angle=90, nibbles_on_off=true, closure=5, scale=DOBLO);
// curve_wide(angle=180, closure=10, scale=LUGO);
// curve_wide(angle=180, closure=10, scale=DOBLO);

module curve_wide (col=0, row=0, up=0, closure=5, orientation=0, bottom_height=BOTTOM_HEIGHT, support_height=0, scale=LUGO, angle = 90, nibbles_on_off=true,  id="some wide curve") {
     /* The curve element will be placed its sharp corner against x=0/y=0 (because this requires the least amount of code)
	In the doblo system: width= left/right length, length= forth/back length
	The tube is embedded in block that sits on a doblo block without nibbles.
	Instead of just digging a hole into a block we create a real tube, allowing for some subtler support structures some day
	Orientation is a bit messy since it has to happen within the doblo components
	This elements is similar to track () with respect to its construction and params.
	Params
	- closure is a value between 2 and 12 and it defines the height of block that will shave off the tube
	- bottom_height is the height of the block underneath the tube, e.g. the lego/duplo compatible
	- angle is either 90 or 180
	- length/width are not used for now since they are determined by the tube which its width=2.
	*/

     // if (length || width) echo ("<font color='orange'> WARNING </font>: MARBLE_RUN curve_wide element ignores length and width");
     trace_msg (type="curve_wide", id= id);
     upper_block_h = (support_height > 0) ? support_height : closure;

     if (angle == 90) {
	  width =4; length=4;
	  // position a lego/duplo compatible block
	  color ("red") doblo (col=col, row=row, up=up, width=width, length=length, height=bottom_height, nibbles_on_off=false,diamonds_on_off=false,scale=scale,orientation=orientation) ;
	  // Add an tube embedded in a block on top
	  curve_wide_component (col=col, row=row, up=up+bottom_height, length=length, width=width, closure=closure, orientation=orientation, support_height=support_height, scale=scale, angle=90);
	  // add some nibbles inside the curve
	  if (nibbles_on_off) {
	    if (upper_block_h > 9) {
	      nibbles (col=col, row=row, up=bottom_height+upper_block_h, width=4, length=4, scale=scale);
	    }
	    else {
	      nibbles (col=col, row=row, up=bottom_height+upper_block_h, width=1, length=1, scale=scale);
	      nibbles (col=col+3, row=row+3, up=bottom_height+upper_block_h, width=1, length=1, scale=scale);
	    }
	  }
     }
     else if (angle == 180) {

       width =4; length=8;
       // position a lego/duplo compatible block
       color ("red") doblo (col=col, row=row, up=up, width=width, length=length, height=bottom_height, nibbles_on_off=false,diamonds_on_off=false,scale=scale,orientation=orientation) ;
       // Add an tube embedded in a block on top
       curve_wide_component (col=col, row=row, up=up+bottom_height, length=length, width=width, closure=closure, orientation=orientation, support_height=support_height, scale=scale, angle=180);
       // nibbles
       if (nibbles_on_off)
	    if (upper_block_h > 9) {
	      nibbles (col=col, row=row, up=bottom_height+upper_block_h, width=4, length=8, scale=scale);
	    }
	    else {
	      nibbles (col=col, row=row+3, up=bottom_height+upper_block_h, width=1, length=2, scale=scale);
	      nibbles (col=col+3, row=row+7, up=bottom_height+upper_block_h, width=1, length=1, scale=scale);
	      nibbles (col=col+3, row=row, up=bottom_height+upper_block_h, width=1, length=1, scale=scale);
	    }
     }
     else echo ("<font color='red'>WARNING: </red> Unsupported angle parameter used in curve_wide function. It must be either 90 or 180", angle);
     
     // if (closure > 10) // add nibbles
}

// CHECK if params are passed ok and if default combos work

// curve_wide_component(angle=180,up=FULL);
module curve_wide_component (col=0, row=0, up=0, length=4, width=4, closure=5, orientation=0, support_height=0, angle=90, scale=LUGO) {
     /* The curve_component creates narrow 90 or 180 deg angled curves embedded into a block
      */

     // the block that supports the tube has the same size unless support_height is set.
     upper_block_h = (support_height > 0) ? support_height : closure;
     //hack for direct use
     mylength = (angle==90) ? 4 : 8;
     // prepare the bed
     difference () {
	  color("crimson") block (col=col, row=row, up=up, width=width, length=mylength, height=upper_block_h, nibbles_on_off=false, diamonds_on_off=false, scale=scale,orientation=orientation) ;
	  // dig the hole
	  curved_wide_tube (col=col, row=row-NUDGE, up=up, length=length, width=width, closure=closure, orientation=orientation,  support_height=support_height, scale=scale, filled=true, angle=angle);
     }
     // Add the pipe, shave off the top
     difference () {
	  curved_wide_tube (col=col, row=row, up=up, length=length, width=width, closure=closure, orientation=orientation, support_height=support_height, scale=scale, angle=angle);
	  // position of the cutting the block for the tube according to closure.
	  top_block_shave (col=col-width, row=row-0.5, width=width*3, length=mylength+1, up=up+closure-NUDGE, height=length*4, scale=scale);
     }
}

// curved_wide_tube(angle=180);
module curved_wide_tube  (col=0, row=0, up=0, length=8, width=4, closure=5, orientation=0, angle=90, scale=scale, filled=false) {
     /*	Low level construct, i.e. a curved tube that is positioned flat starting x=0/y=0 by default
	If filled = true can be used for subtraction, i.e. to dig a large hole for the not filled version.
	Params:
	- angle should be either 90 or 180. Other angles could be implemented in the future, in particular when normal OpenSCAD distributions accept rotate_extruct(angle= ....)
	     */
     debug_msg ("MARBLE RUN: curved_wide_tube");
     curve_radius = 3* PART_WIDTH(scale); // Width = 4 PARTS (radius = 2)
     tube_radius =  PART_WIDTH(scale);
     inner_radius = PART_WIDTH(scale) - TUBE_WALL_WIDTH (scale);
     
     x_0 = col    * PART_WIDTH(scale);
     // slide to front so that upper corner is at origin. The larger 180 deg block must be pushd more.
     y_0 = (angle==90) ? -row * PART_WIDTH(scale) : -(row+4) * PART_WIDTH(scale) ;
     z_0 = up     * PART_HEIGHT(scale) + tube_radius;
     $fn = 30;
     debug_msg (str ("curved_wide_tube: curve_radius=", curve_radius, ", tube_radius=", tube_radius, ", inner_radius=", inner_radius));
     
     // position the result in the coordinate system
     translate ([x_0, y_0, z_0]) {
	  
	  difference () {	  
	       if (filled == true) {
		    rotate_extrude() {
			 // rotate_extrude(angle=90) - not working in ordinary distributions
			 translate([curve_radius, 0]) // center of rotation
			      circle(r = tube_radius); // radius of rotated circle
		    }
	       }  else {
		    difference () {
			 rotate_extrude() {
			      // rotate_extrude(angle=90) - not working in ordinatry distributions
			      translate([curve_radius, 0]) // center of rotation
				   circle(r = tube_radius); // radius of rotated circle
			 }
			 rotate_extrude() {
			      translate([curve_radius, 0]) // center of rotation
				   circle(r = inner_radius); // radius of rotated circle
			 }
		    }
	       }
               // shave to the left (block pos are relative within this difference block !)
	       block (col=-4-NUDGE, row=-6-NUDGE, up=-FULL, length=12, width=4,height=2*FULL, scale=scale);
	       // shave in the back, makes it a 90 deg angle
	       if (angle == 90) 
		    block (col=-5+NUDGE, row=-4+NUDGE, up=-FULL+NUDGE, length=4, width=12, height=12, scale=scale);
		    // inside of the tube
		    }
	  
     }
}



/* --------------------------------------------- holes
Holes are elements that allow the ball to fall down. For now there are two types:
- left/right 6x2 with the hole in the middle and entry in the y axis
- back/forth 6x2 with the hold in the middle and a pipe in the y axis
- TODO: check if the hole prints OK (right now the two are done differently)

*/   

// hole (col=1, row=2, length=6, width=2, closure=7, id="hole A", nibbles_on_off=true);
// hole (col=2, row=-2, length=2, width=6, closure=5, id="hole A", nibbles_on_off=true);

module hole (col=0, row=0, up=0, length=2, width=6, closure=5, orientation=0, bottom_height=BOTTOM_HEIGHT, support_height=0, scale=LUGO,  id="some hole", nibbles_on_off=false, scale=SCALE){
     /* Holes are 6x2 blocks and the ball will fall through a 2x2 area in the middle. There are two variants. Ball comes along the length, ball arrives in the middle.
      */
     trace_msg (type="hole", id= id);

     // block with a hole - as ugly as can be
     // 
     cyl_h = bottom_height * PART_HEIGHT(scale) *2 ;
     half_w = PART_WIDTH(scale);
     block_w = 2;

     if (width==6 && length==2) {
	  // left/right type 
	  difference () {
	       union () {
		    color ("Ghostwhite") doblo (col=col, row=row, height=bottom_height, length=block_w,  width=width, nibbles_on_off=nibbles_on_off, scale=scale);
		    // hole component on top
		    hole_component (col=col+2, row=row, up=bottom_height, length=length, width=width, closure=closure, orientation=orientation, bottom_height=BOTTOM_HEIGHT, support_height=support_height, scale=scale);
		    if (nibbles_on_off) {
			 nibbles (col=col, row=row, up=bottom_height, width=2, length=2, scale=scale);
			 nibbles (col=col+4, row=row, up=bottom_height, width=2, length=2, scale=scale);
		    }
	       }
	       // block digs a hole in lower block plus some into the hole component for easier printing
	       // TEST PRINT WITHOUT adding PART_WDITH(scale)/2
	       block ( col=col+2+TUBE_WALL_RATIO(scale), row=row+TUBE_WALL_RATIO(scale), 
		       up= up - 10*NUDGE, height = bottom_height + PART_WIDTH(scale)/2 + 12*NUDGE,
		       width=block_w - 2*TUBE_WALL_RATIO(scale), length=block_w- 2*TUBE_WALL_RATIO(scale), scale=scale );
	  }
     }

     else if (width==2 && length==6) {
	  // definition of the back/forth type

	  // emptied doblo block at bottom
	  difference () {
	       color ("Ghostwhite") doblo (col=col, row=row, height=bottom_height, length=length,  width=block_w, nibbles_on_off=false, scale=scale );
	       block ( col=col+TUBE_WALL_RATIO(scale), row=row+2+TUBE_WALL_RATIO(scale),
		       up= up -10*NUDGE, height =bottom_height+ 20*NUDGE,
		       width=block_w - 2*TUBE_WALL_RATIO(scale), length=block_w- 2*TUBE_WALL_RATIO(scale), scale=scale );
	  }
    
	  // hole component on top 2 parts forward plus a track component
	  hole_component (col=col, row=row+2, up=bottom_height, closure=closure, orientation=orientation, bottom_height=BOTTOM_HEIGHT, support_height=support_height, scale=scale);
	  track_component (col=col, row=row+4-NUDGE, up=bottom_height, closure=closure, length=2,  width=2, nibbles_on_off=false, scale=scale );
	  if (nibbles_on_off)
	       nibbles (col=col, row=row, up=bottom_height, width=2, length=2, scale=scale);
     }

     else echo (str ("<font color='red'>WARNING/ERROR</font> : A hole must either have length=6 and width=2 or the opposite. Repair hole id = ", id));
}



// --------------------------------- hole componenent

// hole_component();

module hole_component (col=0, row=0, up=0, closure=5, orientation=0, bottom_height=BOTTOM_HEIGHT, support_height=0, scale=SCALE) {
     /* The hole component sits at 0/0/0
	- closure is a value between 2 and 12 and it defines the height of block that will shave off the tube
	- bottom_height is the height of the block underneath the tube, e.g. the lego/duplo compatible
	- lenght and width are not used for now
     */
  
     
     // the block that supports the tube has the same size unless support_height is set.
     upper_block_h = (support_height > 0) ? support_height : closure;
     cyl_h = upper_block_h * PART_HEIGHT(scale);
     half_w = PART_WIDTH(scale);

     // Dig a hole -- if this does not print, replace by the block use in hole();
     difference () {
       track_component (col=col, row=row, up=up, height=upper_block_h, closure=closure, length=2,  width=2, nibbles_on_off=false, scale=scale );
       // place the cyl with doblo system, y is inverted
       translate ([col*PART_WIDTH(scale)+ half_w, -row*PART_WIDTH(scale) - half_w, up-1] )
	 cylinder(h=cyl_h*2, r = half_w - TUBE_WALL_WIDTH(scale), center = false, $fs = CYL_FS);
	 }

     // Add a wall to stop the ball
     color("grey") block (col=col, row=row+NUDGE, up=up, width=2, length=TUBE_WALL_RATIO(scale)+NUDGE, height=upper_block_h, scale=scale);

}     



