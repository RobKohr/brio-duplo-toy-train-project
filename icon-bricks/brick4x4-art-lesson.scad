include <../DobloFactory/doblo-factory.scad>;
include <../DobloFactory/lib/doblo-params.scad>;

/*
This should work with many noun project icons
https://thenounproject.com/

Credits:

Art Lesson by Gerald Wildmoser from the Noun Project
https://thenounproject.com/formbuero/collection/education/?oq=student&cidx=2&i=146642

Reading by Gerald Wildmoser from the Noun Project
https://thenounproject.com/formbuero/collection/education/?oq=student&cidx=2&i=113880
*/

// Variants

// icon_brick("noun_woman-clean2.dxf",x_off=8.5,y_off=1,width=4,length=4,out=true);
// icon_brick("noun_art_lesson_146642.dxf",x_off=2.5,y_off=-2,width=4,length=4,out=false,d_scale=1.1);

// icon_brick("noun_reading_113880.dxf",x_off=1,y_off=-7,width=4,length=4,out=true, d_scale=1.15, d_height=4);

icon_brick("noun_traffic-sign-right-118740_cc.dxf",x_off=1,y_off=-6,width=4,length=4, out=true, d_scale=1.3, d_height=4);

unit = NBO(LUGO);

// meanigful height params = 3,4,5
module icon_brick (DXF,x_off=5, y_off=1, width=4, length=4,
		   out=true, d_scale=1, d_height=4) {
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
	  translate ([x_off,y_off,FULL+d_height]) // embed the thing a bit
	  {
	       color ("pink")
		    scale ([d_scale,d_scale,1]) 
		    linear_extrude(height = d_height+1, center = true, convexity = 10)
		    import (file = DXF);
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
		    color ("pink")
			 scale ([d_scale,d_scale,1])
			 linear_extrude(height = d_height+1, center = true, convexity = 10)
			 import (file = DXF);
	       }
	  }
}
}
