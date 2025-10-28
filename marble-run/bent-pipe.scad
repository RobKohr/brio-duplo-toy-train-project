// http://forum.openscad.org/How-to-model-a-bent-pipe-td1868.html

bent_pipe (10,8,3,0,180,10,20);

module bent_pipe(radius, inner_radius, bend_radius, angle_1, angle_2, lower_arm_length, upper_arm_length) {
     union() {
	  // lower arm
	  if (lower_arm_length>0) {
	       rotate([0, 0, angle_1])
		    translate([bend_radius + radius, 0.02, 0])
		    rotate([90, 0, 0])
		    difference() {
		    cylinder(r=radius, h=lower_arm_length);
		    translate([0, 0, -1])
			 cylinder(r=inner_radius, h=lower_arm_length+2);
	       }
	  }
	  // upper arm
	  if (upper_arm_length>0) {
	       rotate([0, 0, angle_2])
		    translate([bend_radius + radius, -0.02, 0])
		    rotate([-90, 0, 0])
		    difference() {
		    cylinder(r=radius, h=upper_arm_length);
		    translate([0, 0, -1])
			 cylinder(r=inner_radius, h=upper_arm_length+2);
	       }
	  }
	  // bend
	  difference() {
	       // torus
	       rotate_extrude()
		    translate([bend_radius + radius, 0, 0])
		    circle(r=radius);

	       // torus cutout
	       rotate_extrude()
		    translate([bend_radius + radius, 0, 0])
		    circle(r=inner_radius);
	       // lower cutout
	       rotate([0, 0, angle_1])
		    translate([-(bend_radius+2*radius+1) * (((angle_2 - angle_1) <= 180)?1:0), -bend_radius-2*radius-2, -(radius+1)])
		    cube([2*(bend_radius+2*radius+1), bend_radius+2*radius+2, 2*(radius+1)]);
	       // upper cutout
	       rotate([0, 0, angle_2])
		    translate([-(bend_radius+2*radius+1) * (((angle_2 - angle_1) <= 180)?1:0), 0, -radius])
		    cube([2*(bend_radius+2*radius+1), bend_radius+2*radius+1, 2*(radius+1)]);
	  }
     }
     
} 
