/* 
Copyright (c) 2019 Daniel K. Schneider, TECFA, University of Geneva
Kit to produce 4x4 Lego bricks with some 2 1/2 icon and/or text on top
*/

include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

/*
This should work with many noun project 2D icons as well as any other ones. The icon_brick module takes a dxf file name as argument plus size parameters for the brick and positioning for the dxf.

IMPORTANT: The dxf import only works with straight segments.
* In Inkscape, 
** Select each path and transform Bezier curves to series of straight lines.
** Use Extensions -> Modify Path -> Flatten Beziers before save as to Desktop Cutting Plotter (dxf).
* Source: http://repraprip.blogspot.com/2011/05/inkscape-to-openscad-dxf-tutorial.html

Copyright and license for the Noun Project Icons
I, DKS have a license to reuse icons since I am a member.
You, hower, must either become a member or publish the URL of the icon reused. See at the end.
https://thenounproject.com/
*/ 

// Examples

// icon_brick("noun_woman-clean2.dxf",x_off=8.5,y_off=1,width=4,length=4,out=true);
// icon_brick("noun_art_lesson_146642.dxf",x_off=2.5,y_off=-2,width=4,length=4,out=false,d_scale=1.1);
// icon_brick("noun_reading_113880.dxf",x_off=1,y_off=-7,width=4,length=4,out=true, d_scale=1.15, d_height=4);
// icon_brick("noun_traffic-sign-right-118740_cc.dxf",x_off=1,y_off=-5.7,width=4,length=4, out=false, d_scale=1.3, d_height=4);

// icon_brick("noun_burger_177605.dxf",x_off=1.5,y_off=-34,width=4,length=4, out=true, d_scale=2.2, d_height=4);
// icon_brick("noun_burger_47698.dxf",x_off=0.7,y_off=-3.5,width=4,length=4, out=true, d_scale=1.2, d_height=4);
// icon_brick("noun_magnifyingglass_195779_cc.dxf",x_off=1,y_off=-3,width=4,length=4, out=true, d_scale=1.2, d_height=4);
// icon_brick("noun_walking_62236_cc.dxf",x_off=5,y_off=-3,width=4,length=4, out=true, d_scale=1.2, d_height=4);

// icon_brick("noun_thought_bubble_75855_cc.dxf",x_off=2,y_off=-3,width=4,length=4, out=true, d_scale=1.2, d_height=4);

// icon_brick("noun_145073_r2d2_cc.dxf",x_off=2,y_off=-3,width=4,length=4, out=true, d_scale=1.2, d_height=4);

// icon_brick("FlechedroiteJulioYanez.dxf",x_off=2,y_off=1.5,width=4,length=4, out=false, d_scale=0.35, d_height=4);

// icon_brick("noun_Hand_978273.dxf",x_off=0,y_off=0,width=4,length=4, out=true, d_scale=0.45, d_height=3);

// icon_brick("noun_Hand_978273.dxf",x_off=0,y_off=0,width=4,length=4, out=false, d_scale=0.45, d_height=3);

// icon_brick("noun_body massage_2086967.dxf",x_off=2,y_off=14,width=4,length=4, out=false, d_scale=0.35, d_height=3, text="THAI", text_size=6.3);

icon_brick("noun_Reading_253716.dxf",x_off=2, y_off=6.5, width=4,length=4, out=true, d_scale=0.37, d_height=3);

LATTICE_TYPE   = 3;  // type 3 extends lattice to bottom (more solid, but may need force to fit)
SHAVE= 0.2;

// meanigful height params = 3,4,5

module icon_brick (DXF,x_off=5, y_off=1, width=4, length=4,
		   out=false, d_scale=1, d_height=4, 
		   text="", font="Comic Sans MS", font="Barlow:style=Bold", text_size=6, text_x=1.5, text_y=1
) {
     if (out==true) {

	  color ("lightblue") doblo (col=0,  row=-4, up=0,  
				     width=width,  length=length, height=HALF, 
				     nibbles_on_off=false,
				     shave=SHAVE,
				     scale=LUGO);
	  color ("lightblue") block (col=0,  row=-4, up=HALF,  
				     width=width,  length=length, height=HALF, 
				     nibbles_on_off=false,
				     shave=SHAVE,
				     scale=LUGO);
	  translate ([x_off,y_off,FULL+d_height]) // embed the thing a bit
	  {
	       color ("pink")
		    scale ([d_scale,d_scale,1]) 
		    linear_extrude(height = d_height+1, center = true, convexity = 10)
		    import (file = DXF);
	  }
	  if (text) {
	       translate ([text_x,text_y,FULL+d_height]) // embed the thing a bit
		    linear_extrude(height = d_height+1, center = true, convexity = 10)
		    text(text, font=font, size=text_size);
	  }
     }
     else
     {
	  difference () {
	       union () {
		    color ("lightgrey") doblo (col=0,  row=-4, up=0,  
					       width=width,  length=length, height=HALF, 
					       nibbles_on_off=false,
					       shave=SHAVE,
					       scale=LUGO);
		    color ("lightgrey") block (col=0,  row=-4, up=HALF,  
					       width=width,  length=length, height=HALF, 
					       nibbles_on_off=false,
					       shave=SHAVE,
					       scale=LUGO);
	       }
	       
	       translate ([x_off,y_off,FULL+THIRD]) {
		    color ("pink")
			 scale ([d_scale,d_scale,1])
			 linear_extrude(height = d_height+1, center = true, convexity = 10)
			 import (file = DXF);
	       }
	       if (text) {
		    translate ([text_x,text_y,FULL+THIRD]) // embed the thing a bit
			 linear_extrude(height = d_height+1, center = true, convexity = 10)
			 text(text, font=font, size=text_size);
	       }
	       
	  }
     }
}

/* Special module to add text */


/*
 special purpose module for Pasta lovers (should be parametrized some day)
 uncomment the lines below to see what it does. Verify this code !!
*/ 

// likes_pasta("Daniel",font="Comic Sans MS", style="Bold", size=8, x=0, y=2);
// likes_pasta("LUCY");

module likes_pasta (name, font="Comic Sans MS: style=Bold", size=7, x=1, y=2) {
     icon_brick("noun_spaghetti_195363.dxf",x_off=1.2,y_off=-20,width=4,length=4, out=true, d_scale=1.8, d_height=3.7);
     translate ([x,y,FULL+3]) // embed the thing a bit
     {
	  color ("blue")
	       linear_extrude(height = FULL, center = true, convexity = 10)
	       text(name, font=font, size=size);
     }
     // a little heart
     translate ([23,10,FULL+3]) // embed the thing a bit
     {
	       linear_extrude(height = FULL, center = true, convexity = 10)
	       text("Y", font="Webdings: style=Bold",size=7);
	       }
}

/*
  
Credits:

Art Lesson by Gerald Wildmoser from the Noun Project
https://thenounproject.com/formbuero/collection/education/?oq=student&cidx=2&i=146642

Reading by Gerald Wildmoser from the Noun Project
https://thenounproject.com/formbuero/collection/education/?oq=student&cidx=2&i=113880

Traffic sign by Jonathan Li, CA
https://thenounproject.com/search/?q=traffic+signs&i=118740

Burger by https://thenounproject.com/search/?q=food&i=177605
https://thenounproject.com/search/?q=food&i=177605

Burger by Florent Artis
https://thenounproject.com/search/?q=food&i=47698

spaghetti by retinaicon from the Noun Project
https://thenounproject.com/search/?q=pasta&i=195363

Walking by Arthur Shlain from the Noun Project
https://thenounproject.com/search/?q=walking&i=62236

Magnifying Glass by Aha-Soft from the Noun Project
https://thenounproject.com/ahasoft/collection/health-care/?i=195779

Thought Bubble by Juan Pablo Bravo from the Noun Project
https://thenounproject.com/search/?q=concept&i=75855

R2-D2 by Lluis Pareras from the Noun Project
https://thenounproject.com/search/?q=r2d2&i=145073

Hand by By Jake Dunham, FR, from the Noun Project
https://thenounproject.com/search/?q=fuck&i=978273

thai massage By Gan Khoon Lay
https://thenounproject.com/term/thai-massage/2737076/

body massage By Kokota, EE 
https://thenounproject.com/term/body-massage/2086967/

Reading By Vectors Market
https://thenounproject.com/search/?q=learner&i=253716

*/
