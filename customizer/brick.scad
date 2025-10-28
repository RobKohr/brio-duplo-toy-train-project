/* Castle kit, Lego and Duplo compatible-- examples
Daniel.schneider@unige.ch (DKS)
VERFSION 1 april 2018

The doblo factory is documented here:
http://edutechwiki.unige.ch/en/Doblo_factory

Download
http://tecfa.unige.ch/guides/3dprinting/doblo-factory/

*/

// *** SCALE MUST BE SET ! *** (but you can override later)

// SCALE=1;   // DUPLO Size, partially print tested
SCALE =0.5;   // Lego size, print tested
// SCALE=0.25; // Half lego size (1/8 volume, not print tested)

// LOAD doblo factory
include <../doblo-factory.scad>;
echo (str ("LATTICE-WIDTH = ", LATTICE_WIDTH(SCALE)));	
echo (str ("SCALE = ", SCALE));

Col=0;
Row=0;
Up=0;
Width=4;
Length=2;
Height=6;
Nibbles_On_Off=true;
Diamonds_On_Off=false;
Scale=0.5;

doblo (col=Col,
       row=Row,
       up=Up,
       width=Width,
       length=Length,
       height=Height,
       nibbles_on_off=Nibbles_On_Off,
       diamonds_on_off=Diamonds_On_Off,
       scale=Scale);
