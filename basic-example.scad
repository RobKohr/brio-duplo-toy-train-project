/*
Doblo library usage example. For more information, please read:
https://edutechwiki.unige.ch/en/Doblo_factory#Using_openscad_doblo_modules

This is an example on how to use this library. It will create two simple objects.
- A: A lego brick with a block on top followed by an imported STL
- B: A lego brick with some nibbles and some 3D text on top

V1. Daniel.Schneider@unige.ch, April 2018

The owl was taken from https://www.thingiverse.com/thing:647060. I was made by Sailor96.
Low Poly Owl by Sailor96 is licensed under the Creative Commons - Attribution - Share Alike license.
(http://creativecommons.org/licenses/by-sa/3.0/)

*/

// Include the library plus default parameters
include <doblo-factory.scad>;
// include <lib/doblo-params.scad>; // in case you want to override
include <lib/doblo-params-felixtec4.scad>; // A modern fast PLA printer, slightly smaller walls underneath

/* uncomment one of these */

//A ();
B();
//C ();

module C() {
  /* A simple Lego compatible block, normal height */
  doblo(
    col=1,
    row=0,
    up=0,
    width=4,
    length=2,
    height=FULL,
    scale=LUGO,
    shave=0.2,
    nibbles_on_off=true
  );
}

module B() {
  /* A simple Duplo compatible block, half height */
  doblo(
    col=0,
    row=0,
    up=0,
    width=2,
    length=4,
    height=FULL/3,
    shave=0.4,
    scale=DOBLO,
    nibbles_on_off=false,
    flat_bottom_on_off=false
  );
}

module A() {
  /* Object A has three parts:
- a brick of size 6x4, 1/3rd height, no nibbles on top
- a block on top 2/3 height
- an imported owl on top (from the stls directory)
*/

  // ------ Create a 6x4 brick in position 0,0

  doblo(
    col=0,
    row=0,
    up=0,
    width=6,
    length=4,
    height=THIRD,
    nibbles_on_off=false
  );

  // put a block on top
  color("blue") block(col=0, row=0, up=THIRD, width=6, length=4, height=4);

  // Add the owl
  merge_stl(file="stls/Owl_LowPoly.stl", col=2, row=1.2, up=4, stl_z_offset_mm=0, shrink=2);

  // ------- Create a brick in position 10,0

  color("red") doblo(
      col=10,
      row=0,
      up=0,
      width=6,
      length=4,
      height=2 * THIRD,
      nibbles_on_off=false
    );

  difference() {
    // put a block on top
    color("green") block(col=10, row=0, up=2 * THIRD, width=6, length=4, height=THIRD);
    // ---- subtract some text
    #color("black") write(text="DOCK", col=10.1, row=1.5, up=5, size=12, height=3);
  }
  // --- add some nibbles
  nibbles(col=10, row=0, up=FULL, width=6, length=1);
  nibbles(col=10, row=3, up=FULL, width=6, length=1);
}
