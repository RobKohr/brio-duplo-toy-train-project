/* Lego brick example
   Daniel.schneider@unige.ch
   feb. 2019

   Basic parameters are below. If you change these, most elements will adjust correctly, but some won't, i.e. need some manual adjustment. Parameters are different for Lego and Duplo compatibles. Legos work in "third" sizes and Duplos in "half". Length below are not absolute heights, but just length as defined in our Lego conventions. Therefore, they must be multiplied with either PART_WIDTH or PART_HEIGHT if you do some openscad coding. See more here:
   https://edutechwiki.unige.ch/en/Doblo_factory
*/

// SCALE MUST BE set, although one can override it using the LUGO (0.5) and DOBLO (1) constants.
// PART_WIDTH(SCALE)  is 8mm for Lego and 16mm for duplo compatible

// SCALE =0.5;   // Lego size, print tested
SCALE =1;   // Duplo size, less tested
// Overrides
LATTICE_TYPE   = 2;  // type 2 is more, type 3 extends lattice to bottom (more solid, but may need force to fit)

// Make the objects smaller in width and length than they should be (a hack to cope with FDM printing)
SHAVE = 0.0;

// LOAD doblo factory
include <../doblo-factory.scad>;

NUDGE = 0.001;

SHAVE = 0.2; // shave off some outer wall, to accomodate fdm printers that print to wide ....

echo (str ("SCALE = ", SCALE));
echo (str ("LATTICE-WIDTH = ", LATTICE_WIDTH(SCALE)));	

// calibration (row=0, col=0, width=2, length=2, height=HALF, scale=SCALE, nibbles_on_off=false, scale=DOBLO);
calibration (row=0, col=0, width=4, length=4, height=2*THIRD, scale=SCALE, nibbles_on_off=false, scale=LUGO);
// calibration (row=0, col=0, width=4, length=2, height=HALF, scale=SCALE, nibbles_on_off=false, scale=LUGO);
// calibration ();

module calibration (row=0, col=0, width=2, length=4, height=2*THIRD, scale=SCALE, nibbles_on_off=true) {
     /* --- simple 4x2 lego brick sitting in the center for calibration / test
	If the piece does not fit, you either can play with slicer settings or change the code (preferred).
	(1) Slicer settings: If the piece is too loose, change wall settings to fatter in your slicer. If the piece does not fit, try smaller walls in your slicer, e.g. 2 /wall. Some slicer refuse to print small Lego walls (e.g. most versions of Cura). Use another slicer
	(2) If the above does not help then figure out your own parameters. Copy ../lib/doblo-params.scad, make changes and replace the link in file ../doblo-factory.scad on top
	By default include we use a setting that makes walls and nibbles underneath smaller than they are in realy. In addition we create a shave argument that shaves off something from the outer walls. This was the only way to make it work with the free RepetierHost/Cura combo.

	<lib/doblo-params-felixtec4.scad>; // A modern fast PLA printer, slightly smaller walls.
 */
     //     (col, row, up, width,length,height,nibbles_on_off) 
     doblo (row=row, col=col, width=width, length=length, height=height, nibbles_on_off=nibbles_on_off, scale=scale
	 );
}

