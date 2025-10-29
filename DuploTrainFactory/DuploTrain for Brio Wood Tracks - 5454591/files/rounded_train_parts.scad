//Created by SteAi
//published under Creative Commons Attribution-Share Alike license
//https://creativecommons.org/licenses/by-sa/3.0/
//adaptation of model created by xtopher88 (https://www.thingiverse.com/xtopher88/designs)

// Include DobloFactory library
include <../../../doblo-factory.scad>;
include <../../../lib/doblo-params-felixtec4.scad>;

module HiResSphere(radius) {
  scale(1 / 10000) sphere(10000 * radius);
}

module RoundCube(size, center = false, edge_radius = 1) {
  if (center) {
    translate(-(size / 2))
      RoundCube(size, false, edge_radius);
  } else {

    radius = min(edge_radius, size[0] / 3, size[1] / 3, size[2] / 3);
    hull() {
      translate([radius, radius, radius])
        rotate([-45, 45, 0])
          HiResSphere(radius);
      translate([size[0] - radius, size[1] - radius, radius])
        rotate([45, -45, 0])
          HiResSphere(radius);
      translate([size[0] - radius, radius, radius])
        rotate([-45, -45, 0])
          HiResSphere(radius);
      translate([radius, size[1] - radius, radius])
        rotate([45, 45, 0])
          HiResSphere(radius);
      translate([radius, radius, size[2] - radius])
        rotate([-45, 135, 0])
          HiResSphere(radius);
      translate([size[0] - radius, size[1] - radius, size[2] - radius])
        rotate([45, -135, 0])
          HiResSphere(radius);
      translate([size[0] - radius, radius, size[2] - radius])
        rotate([-45, -135, 0])
          HiResSphere(radius);
      translate([radius, size[1] - radius, size[2] - radius])
        rotate([45, 135, 0])
          HiResSphere(radius);
    }
  }
}

module HiResDonut(overallRadius, ringRadius) {
  scale(1 / 10000)
    rotate_extrude() {
      translate([10000 * (overallRadius - (ringRadius / 2)), 0, 0])
        circle(10000 * ringRadius / 2);
    }
}

module roundedCylinder(height, lowerRadius, upperRadius, rounding = 0.5, center = false) {
  if (center) {
    translate([0, 0, -height / 2])
      roundedCylinder(height, lowerRadius, upperRadius, rounding, false);
  } else {
    translate([0, 0, rounding / 2])
      hull() {
        translate([0, 0, height - rounding])
          HiResDonut(upperRadius, rounding);
        HiResDonut(lowerRadius, rounding);
      }
  }
}

module snapInPin(headHeight, headSize, neckHeight, neckSize, pinHeight, pinSizeBottom, pinSizeTip, cutout) {
  difference() {
    union() {
      scale(0.001)
        translate([0, 0, -500])
          cylinder(1000 * (neckHeight + 1), 1000 * neckSize, 1000 * neckSize);
      translate([0, 0, neckHeight])
        roundedCylinder(pinHeight, pinSizeBottom, pinSizeTip);
      translate([0, 0, -headHeight])
        roundedCylinder(headHeight, headSize, headSize);
    }
    ;

    translate([0, 0, neckHeight + pinHeight])
      cube([pinSizeBottom * 3, cutout, (neckHeight + pinHeight) * 2], true);
    translate([headSize + neckSize * 0.8, 0, 0])
      cube([headSize * 2, headSize * 2, (headHeight + neckHeight + pinHeight) * 2], true);
    translate([-pinSizeBottom - neckSize, 0, neckHeight + pinHeight / 2])
      cube([pinSizeBottom * 2, pinSizeBottom * 2, pinHeight * 2], true);
  }
}

module snapInPinCutout(headHeight, headSize, neckHeight, neckSize, pinHeight, pinSizeBottom, pinSizeTip, cutout, tolerance) {
  difference() {
    union() {
      cylinder(neckHeight, neckSize + tolerance, neckSize + tolerance);
      translate([0, 0, neckHeight - tolerance])
        cylinder(pinHeight + tolerance * 2, pinSizeBottom + tolerance, pinSizeBottom + tolerance);
    }
    ;
  }
}

module duplo_nipple(outer = 9.55, inner = 6.93, height = 4.5) {
  nipple_sf = 10000;
  difference() {
    scale(1 / nipple_sf)
      cylinder(height * nipple_sf, outer / 2 * nipple_sf, outer / 2 * nipple_sf, center=true);
    scale(1 / nipple_sf)
      translate([0, 0, nipple_sf * 2])
        cylinder((height + 1) * nipple_sf, inner / 2 * nipple_sf, inner / 2 * nipple_sf, center=true);
  }
}

module duplo_top(x = 2, y = 4, spacing = 16.0, parimeter = 3.2 + 9.5 / 2, height = 4.5, thickness = 2) {
  // Use DobloFactory doblo module with FLAT_BOTTOM mode
  // Calculate height in PART_HEIGHT units (thickness / PART_HEIGHT(DOBLO))
  height_units = thickness / PART_HEIGHT(DOBLO);

  // Center the doblo block at origin and lower by 2mm to be flush with train car
  // doblo with col=0, row=0 centers at (width*PART_WIDTH/2, -length*PART_WIDTH/2)
  // So we offset to center at origin
  translate([-x * PART_WIDTH(DOBLO) / 2, y * PART_WIDTH(DOBLO) / 2, -0.5])
    doblo(
      col=0,
      row=0,
      up=0,
      width=x,
      length=y,
      height=FULL,
      scale=DOBLO,
      shave=0.4,
      nibbles_on_off=true,
      flat_bottom_on_off=true
    );
}

module duplo_top_old(x = 2, y = 4, spacing = 16.0, parimeter = 3.2 + 9.5 / 2, height = 4.5, thickness = 2) {
  union() {
    for (i = [0:x - 1]) {
      for (j = [0:y - 1]) {
        translate([( (i - (x - 1) / 2) * spacing), ( (j - (y - 1) / 2) * spacing), (height + thickness) / 2 - 0.1]) duplo_nipple();
      }
    }
    RoundCube([(x - 1) * spacing + 2 * parimeter, (y - 1) * spacing + 2 * parimeter, thickness], center=true);
  }
}

module half_hook(inner_offset = 0.2) {
  outer_diameter = 18.0;
  thickness = 5.5;
  inner_diameter = 7.8 + inner_offset;
  wall_thinkness = (outer_diameter - inner_diameter) / 2;
  difference() {
    union() {
      difference() {
        cylinder(thickness, outer_diameter / 2, outer_diameter / 2, center=true);
        translate([outer_diameter / 4, 0, 0]) cube([outer_diameter / 2, outer_diameter, thickness + 1], center=true);
      }
      translate([0, (inner_diameter / 2 + wall_thinkness / 2), 0]) cylinder(thickness, wall_thinkness / 2, wall_thinkness / 2, center=true);
    }
    cylinder(thickness + 1, inner_diameter / 2, inner_diameter / 2, center=true);
    translate([0, 0, -(thickness * 3 + 0.1) / 8]) cylinder(thickness / 4, (inner_diameter + 3) / 2, inner_diameter / 2, center=true);
    translate([0, 0, (thickness * 3 + 0.1) / 8]) cylinder(thickness / 4, inner_diameter / 2, (inner_diameter + 3) / 2, center=true);
  }
}

module hook_1() {
  angle = 50;
  attach_width = 4;
  attach_length = 13;
  attach_thickness = 5.5;
  union() {
    rotate([0, 0, angle]) half_hook();
    rotate([0, 0, -angle]) rotate([0, 180, 0]) half_hook();
    translate([0, -7.5, 0]) cube([attach_length, attach_width, attach_thickness], center=true);
  }
}

module hook_2() {
  hook_diameter = 7.0;
  latch_diameter = hook_diameter + 0.2;
  latch_thickness = 2.3;
  height = 16;
  base_thinkness = 7.0;
  attach_width = 11;
  attach_length = 13;
  attach_thickness = 5.5;
  translate([0, 0, -1.5])
    union() {
      translate([0, 0, -height / 2]) roundedCylinder(height, hook_diameter / 2, hook_diameter / 2);
      translate([0, 0, (height - latch_thickness) / 2])
        difference() {
          translate([0, 0, -latch_thickness / 2])
            roundedCylinder(latch_thickness, latch_diameter / 2, latch_diameter / 2);
          translate([0, latch_diameter / 4, 0]) cube([latch_diameter, latch_diameter / 2, latch_thickness + 1], center=true);
        }
      translate([0, 4.5, -(height - attach_thickness) / 2])
        difference() {
          translate([0, 1.5, 0])
            cube([attach_length, attach_width + 3, attach_thickness], center=true);
          translate([-8.5, 0, 0]) rotate([0, 0, 18]) cube([attach_length / 2, attach_width * 2, attach_thickness + 1], center=true);
          translate([8.5, 0, 0]) rotate([0, 0, -18]) cube([attach_length / 2, attach_width * 2, attach_thickness + 1], center=true);
        }
    }
}

module wheels() {
  wheel_diameter = 22;
  thinkness = 3.5;
  center_thinkness = 5;
  center_diameter = 10;
  hole = 7.2;
  difference() {
    union() {
      translate([0, 0, -(center_thinkness - thinkness) / 2]) roundedCylinder(thinkness, wheel_diameter / 2, wheel_diameter / 2, center=true);
      roundedCylinder(center_thinkness, center_diameter / 2, center_diameter / 2, center=true);
    }

    scale(1 / 10000) cylinder(10000 * (center_thinkness + 1), 10000 * hole / 2, 10000 * hole / 2, center=true);
  }
}

module snapInWheelPin(diameter = 6, cutout = false) {
  if (cutout) {
    rotate([180, 0, 270]) translate([0, 0, 1.2 - 7])
        snapInPinCutout(2, diameter, 12, diameter / 2, 2, diameter * 0.65, diameter / 2 * 0.9, diameter / 3, 0.2);
  } else {
    rotate([180, 0, 270]) translate([0, 0, 1.2 - 7])
        snapInPin(2, diameter, 12, diameter / 2, 2, diameter * 0.65, diameter / 2 * 0.9, diameter / 3);
  }
}

module train_car(hook_support = 1, length = 63.75, wheel_length = 40, width = 31.75, height = 20, hole = 6.0) {

  wheel_well = 26;
  well_depth = (width - 19) / 2;
  difference() {
    union() {
      //main Body of train car (consisting of two cubes)
      translate([0, 0, 1.5]) RoundCube([width, length - wheel_length - 10, height + 3], center=true);
      RoundCube([width - well_depth * 2, length, height], center=true);

      //add duplo top with smooth transition
      translate([0, 0, (height - 2) / 2 + 3]) {
        union() {
          duplo_top();
          //printable slimming from duplo top to train car top
          translate([0, 0, -5.5]) hull() {
              RoundCube([width - well_depth * 2, length, 1], true);
              translate([0, 0, 5])
                RoundCube([(2 - 1) * 16 + 2 * (3.2 + 9.35 / 2), (4 - 1) * 16 + 2 * (3.2 + 9.35 / 2), 1], true);
            }
          ;
        }
        ;
      }
      ;
    }
    ;

    //holes for pins
    translate([9.5, wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, 90, 0]) snapInWheelPin(hole, true);
    translate([-9.5, wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, -90, 0]) snapInWheelPin(hole, true);
    translate([9.5, -wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, 90, 0]) snapInWheelPin(hole, true);
    translate([-9.5, -wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, -90, 0]) snapInWheelPin(hole, true);

    //transparent wheels
    %translate([9.5, wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, 90, 0]) snapInWheelPin(hole);
    %translate([-9.5, wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, -90, 0]) snapInWheelPin(hole);
    %translate([9.5, -wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, 90, 0]) snapInWheelPin(hole);
    %translate([-9.5, -wheel_length / 2, -5]) rotate([90, 0, 0]) rotate([0, -90, 0]) snapInWheelPin(hole);
    %translate([12, wheel_length / 2, -5]) rotate([0, -90, 0]) wheels();
    %translate([12, -wheel_length / 2, -5]) rotate([0, -90, 0]) wheels();
    %translate([-12, wheel_length / 2, -5]) rotate([0, 90, 0]) wheels();
    %translate([-12, -wheel_length / 2, -5]) rotate([0, 90, 0]) wheels();
  }

  //hooks
  hook_height = -0.5;
  translate([0, -(length / 2 + 10), hook_height]) hook_2();
  translate([0, (length / 2 + 9.5) - 0.01, hook_height])
    union() {
      hook_1();
      //hook support
      if (hook_support == 1)
        translate([0, 0, -6.25]) difference() {
            cylinder(7, 14 / 2, 14 / 2, center=true);
            cylinder(7 + 1, 13 / 2, 13 / 2, center=true);
          }
    }
}

//wheels();
//rotate([90,0,0]) snapInWheelPin();
train_car(hook_support=0);
