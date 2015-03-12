// FFF extruder using geared stepper motor http://www.2engineers.com/shop/motor-1/
// Designed by OhmEye (github.com/OhmEye)
// uses blddk hobb, 605zz bearing, 2x3/8" corner brace from Ace hardware, and some fasteners.
// Copyright 2012 OhmEye, James L Paul
// Licensed GPLv3


use <ohmstruder_lever28.scad>;
translate([17,50,0])rotate([0,0,0])lever();


translate([0,0,7])rotate([-90,0,0]){

difference(){
	union(){	
		translate([0,0,0])cube([80,7,16.8]); // lower body
		translate([69,-9.5,10])cylinder(r=5,h=5,$fn=24,center=true); // well screw riser
		hull(){
			translate([20,0,45])cube([40,7,1]); // upright body
			translate([0,0,9])cube([80,7,10]); // upright body
			}
		translate([0,-19,0])cube([80,20,10]); // groovemount flange
		hull(){
			translate([0,0,0])cube([3,3,19]); // end brace
			translate([0,-19,0])cube([3,3,10]); // end brace
			}
		hull(){
			translate([77,0,0])cube([3,3,19]); // end brace
			translate([77,-19,0])cube([3,3,10]); // end brace
			}
		translate([22.5,0,39.5])rotate([90,0,0])cylinder(r=4.8,h=7.7,$fn=36,center=true); // lever spacer
		}
		translate([33,-9,0])groovemountholes();
		translate([21.5,0,13.8])motorholes();
		
		translate([69,-9.5,8])cylinder(r=2.55,h=10,$fn=24,center=true); // well screw hole for M5x10
	}
}




module motorholes(){
	// motor mount holes
translate([18,8.8,10.5])rotate([0,45,0]){
	translate([-14,-9.8,0])rotate([90,0,0])cylinder(r=1.8,h=22,$fn=18,center=true);
	translate([14,-9.8,0])rotate([90,0,0])cylinder(r=1.8,h=22,$fn=18,center=true);
	translate([0,-9.8,-14])rotate([90,0,0])cylinder(r=1.8,h=22,$fn=18,center=true);
	translate([0,-9.8,14])rotate([90,0,0])cylinder(r=1.8,h=22,$fn=18,center=true);
	}

	//fulcrum hole
	translate([1.5,0,25.5])rotate([90,0,0])cylinder(r=2.2,h=30,$fn=18,center=true);

	// motor planetary gearhead hole
	translate([18,-1.5,10.5])rotate([90,0,0])cylinder(r=11.2,h=10+9,$fn=96,center=true);


}
module groovemountholes(){
	translate([0,0,0])cylinder(r=8,h=12,$fn=64,center=true);
	translate([0,0,8])cylinder(r1=1.6,r2=2.6,h=4.1,$fn=64,center=true);
	translate([-25,0,0])cylinder(r=2.6,h=30,$fn=64,center=true);
	translate([25,0,0])cylinder(r=2.6,h=30,$fn=64,center=true);
	translate([-25,0,9])cylinder(r=4.5,h=4,$fn=6,center=true);
	translate([25,0,9])cylinder(r=4.5,h=4,$fn=6,center=true);
}
