// Include the library plus default parameters
include <../../doblo-factory.scad>;
include <../../lib/doblo-params-felixtec4.scad>;

module Base() {
  /* A simple Duplo compatible block, half height */
  doblo(
    col=0,
    row=0,
    up=0,
    width=2,
    length=4,
    height=FULL / 3,
    shave=0.4,
    scale=DOBLO,
    nibbles_on_off=false,
    flat_bottom_on_off=false
  );
}

Base();

// create sources using this tinkercad:
// https://www.tinkercad.com/things/g4Gn3h3ARLk-exquisite-duup-blad/edit?returnTo=https%3A%2F%2Fwww.tinkercad.com%2Fdashboard

module PlaceSource(source, row, col, up = 0) {
  merge_stl(
    file=source,
    col=col,
    row=row,
    up=(FULL / 3 - 0.2) + up,
    stl_z_offset_mm=0,
    shrink=0.98,
    scale=DOBLO
  );
}

module PlaceWoodStack() {
  center_col = 0;
  center_row = 1;
  center_up = FULL / 3 - 0.2;
  thickness = 0.5;
  heightness = 2.2;
  // Array of multipliers: [col_multiplier, row_multiplier, up_multiplier]

  positions = [
    [-2, -0, 0],
    [-1, 0, 0],
    [0, 0, 0],
    [1, 0, 0],
    [2, 0, 0],
    // second layer
    [-1.5, 0, 1],
    [-0.5, 0, 1],
    [0.5, 0, 1],
    [1.5, 0, 1],
    // third layer
    [-1, 0, 2],
    [0, 0, 2],
    [1, 0, 2],
    // fourth layer
    [-0.5, 0, 3],
    [0.5, 0, 3],
    // fifth layer
    [0, 0, 4],
  ];

  // Generate random row offsets for each position (-0.3 to 0.3, precision 0.01)
  num_positions = len(positions);
  random_row_offsets = rands(-0.3, 0.3, num_positions);

  wood_diameter = 9;
  wood_length = 64;

  for (i = [0:num_positions - 1]) {
    pos = positions[i];
    // Round to 0.01 precision
    row_offset = round(random_row_offsets[i] * 100) / 100;

    // Calculate position using same system as merge_stl
    col_pos = center_col + (thickness * pos[0]);
    row_pos = center_row + (thickness * row_offset);
    up_pos = center_up + (heightness * pos[2]);

    x_pos = col_pos * PART_WIDTH(DOBLO) + PART_WIDTH(DOBLO);
    y_pos = -(row_pos * PART_WIDTH(DOBLO) + PART_WIDTH(DOBLO));
    z_pos = up_pos * PART_HEIGHT(DOBLO);

    // Place horizontal cylinder (on its side, pointing along Y axis - along train length)
    translate([x_pos, y_pos, z_pos])
      rotate([90, 0, 0])
        cylinder(h=wood_length, d=wood_diameter, center=true);
  }
}
// PlaceSource("sources/engine.stl", 1, 0);
//  PlaceSource("sources/hopper.stl", 1, 0);
//PlaceWoodStack();
//PlaceSource("sources/passenger car.stl", 0.3, -1.42);
//PlaceSource("sources/tanker.stl", 3, -1.02);
// PlaceSource("sources/boxcar.stl", 3.04, -1.02, -0.2);
PlaceSource("sources/hotwheels_carrier.stl", 1, 2.3, -0.25);
