include <../DobloFactory/doblo-factory.scad>;
include <../DobloFactory/lib/doblo-params.scad>;

/*
This should work with many noun project icons
https://thenounproject.com/

Credits:

Art Lesson by Gerald Wildmoser from the Noun Project
https://thenounproject.com/formbuero/collection/education/?oq=student&cidx=2&i=146642

*/

// Variants

// icon_brick("noun_woman-clean2.dxf",x_off=8.5,y_off=1,width=4,length=4,out=false);
icon_brick("noun_art_lesson_146642.dxf",x_off=2.5,y_off=-2,width=4,length=4,out=true,tscale=1.1);

unit = NBO(LUGO);

module icon_brick (DXF,x_off=5, y_off=1,width=4,length=4,out=true) {
     if (out==true) {
	  color ("lightblue") doblo (col=0,  row=-4, up=0,  
				     width=width,  length=length, height=HALF, 
				     nibbles_on_off=false,
				     diamonds_on_off=false,
				     scale=LUGO);
	  color ("lightblue") block (col=0,  row=-4, up=HALF,  
				     width=width,  length=length, height=HALF, 
				     nibbles_on_off=false,
				     diamonds_on_off=false,
				     scale=LUGO);
	  translate ([x_off,y_off,FULL+HALF]) {
	       color ("pink") linear_extrude(height = 5, center = true, convexity = 10)
		    scale (tscale) import (file = DXF);
	  }
     }
     else
     {
	  difference () {
	       union () {
		    color ("lightgrey") doblo (col=0,  row=-4, up=0,  
					       width=width,  length=length, height=HALF, 
					       nibbles_on_off=false,
					       diamonds_on_off=false,
					       scale=LUGO);
		    color ("lightgrey") block (col=0,  row=-4, up=HALF,  
					       width=width,  length=length, height=HALF, 
					       nibbles_on_off=false,
					       diamonds_on_off=false,
					       scale=LUGO);
	       }
	       
	       translate ([x_off,y_off,FULL+THIRD]) {
		    color ("pink") linear_extrude(height = 5, center = true, convexity = 10)
			 import (file = DXF);
	       }
	  }
}
}
