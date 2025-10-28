include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

SHAVE= 0.2;
length=4;
width=4;

// icon_brick();

simple (length=2, width=2);

module simple () {

color ("red") doblo (col=0,  row=-4, up=0,  
		     width=width,  length=length, height=HALF, 
		     nibbles_on_off=false,
		     diamonds_on_off=false,
		     shave=SHAVE,		     
		     scale=LUGO);		     
}

module icon_brick () {


color ("red") doblo (col=0,  row=-4, up=0,  
		     width=width,  length=length, height=HALF, 
		     nibbles_on_off=false,
		     diamonds_on_off=false,
		     shave=SHAVE,		     
		     scale=LUGO);		     
color ("lightblue") block (col=0,  row=-4, up=HALF,  
			   width=width,  length=length, height=HALF, 
			   nibbles_on_off=false,
			   diamonds_on_off=false,
			   shave=SHAVE,
			   scale=LUGO);
}
