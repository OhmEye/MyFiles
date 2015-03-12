// Diametric's Mini Quadcopter. 
// Version: 1.0
//
// Author: Ray Russell Reese III
// Email: russ@zerotech.net
// IRC: diametric@freenode.

// OhmEye modified for motors with offset mount holes

// Using hexNut(), can be substituted out.
use <Libs.scad>;

$fn = 90;

// BASIC CONFIG
// -------------------------------------------------------------

// How thick to make the base of the frame.

thickness = 4;

// The space between each prop as relative to the prop center. This will define how
// long the arms are.  Make sure this is big enough so your props clear each other.

propCenters = 145;

// This is the size of the IMU board you'll be using. The default fits a Crius MultiWii SE 2.0
// Caveat: list the larger dimension (if one) first.

imuSize = [40, 40];

// Use square standoffs (less surface contact) or a solid plate for the imu base.

imuStandoffs = true;

// Produce a battery holder.

batteryHolder = true;

// These will likely need adjustments. I've made them a little big, and will still usually have to
// drill them out.  The Turnigy 1811 motors have poor tolerances on the mounting holes. 

motorHoleDiameter = 3;
motorHoleCenters = 19; // 1811 motor=14, d2822 motor=19
motorHoleOffset = 1.5; // 1811 motor=0, d2822 motor=1.5
motorArmatureDiameter = 4.97;
motorBase = 25; // 1811 motor=20.94, d2822 motor=25

// Receiver size

receiverHolder = true;

// Default size fits a Spektrum AR6115e

receiverSize = [23, 9];

// IMU Shield

imuShield = true;
imuShieldHeight = 31;



// ADVANCED CONFIG
// -------------------------------------------------------------

// Spacing between mounting holes for the base & battery parts.

bbhSpace = 15;


// BUILD IT
// -------------------------------------------------------------

frame();

if (imuShield)
	imuShield();

if (batteryHolder)
	batteryHolder();

if (receiverHolder)
	receiverHolder();


module simpleArch(s) {
	difference() {
		translate(v = [0, 0, -s / 4])
			cube(size = [s, s / 2, s / 2], center = true);
		rotate(a = 90, v = [0, 1, 0])
			translate(v = [0, s / 4, 0])
				cylinder(r = s / 2, h = s + 0.5, center = true);
	}
}

module imuShield() {
	translate(v = [0, 55, -0.5]) {
		cube(size = [imuSize[0], imuSize[1], 3], center = true);
	
		for (i = [[17, 17, 180, 90], [-17, 17, 180, 270], [17, -17, 0, 90], [-17, -17, 0, 270]]) {
			translate(v = [i[0], i[1], 1.5 + (imuShieldHeight - 7) / 2]) {
				rotate(a = i[2], v = [0, 0, 1]) translate(v = [0, 4.5, -9])
					simpleArch(6);
				rotate(a = i[3], v = [0, 0, 1]) translate(v = [0, 4.5, -9])
					simpleArch(6);

				cube(size = [6, 6, imuShieldHeight - 7], center = true);
			}
		}
		translate(v = [0, -21.5, imuShieldHeight / 2 + 0.5]) {
			cube(size = [7.75, 3.25, imuShieldHeight + 4], center = true);
			translate(v = [0, 3.5, -imuShieldHeight / 2 + 5])
				simpleArch(7.75);
		}
		translate(v = [0, 21.5, imuShieldHeight / 2 + 0.5]) {
			cube(size = [7.75, 3.25, imuShieldHeight + 4], center = true);
			translate(v = [0, -3.5, -imuShieldHeight / 2 + 5])
				rotate(a = 180, v = [0, 0, 1])
					simpleArch(7.75);
		}
		
	}
}

module receiverHolder() {
	translate(v = [-30, 0, 1]) {
		translate(v = [8, 11, 0])
			cube(size = [4, 5, 6], center = true);
		translate(v = [8, -11, 0])
			cube(size = [4, 5, 6], center = true);
		difference() {
			cube(size = [receiverSize[1] + 4, receiverSize[0] + 4, 6], center = true);
			rotate(a = 15, v = [0, 1, 0])
				cube(size = [receiverSize[1], receiverSize[0], 10], center = true);
		}
	}	
}


// Build a battery holder.
module batteryHolder() {
	translate(v = [55, 0, -3.3])
		rotate(a = 180, v = [0, 1, 0])
			difference() {
				translate(v = [0, 0, -2.5])
					cylinder(r = 25, h = 2.5, center = true);

				for(i = [[-bbhSpace, -bbhSpace], [bbhSpace, bbhSpace], [-bbhSpace, bbhSpace], [bbhSpace, -bbhSpace]]) {
					translate(v = [i[0], i[1], -3]) {
						hexNut(size = "M2", center = true);
						cylinder(r = 1.02, h = 5, center = true);
					}
				}
			}

	for (i = [[15, [1, 0, 0]], [-15, [0, 1, 0]]]) {
		translate(v = [55, i[0], 10.5]) 
			rotate(a = 180, v = i[1]) {
					difference() {
						scale(v = [1, 0.5, 1])
							cylinder(r = 12.5, h = 23, center = true);
						translate(v = [0, 5, 0])
							cube(size = [27, 10, 25], center = true);
					}
			}
	}

	translate(v = [55, 0, 21])
		cube(size = [24.9, 30.5, 2], center = true);
}


// This builds an individual motor mounting plate.
module motorMount() {
	mhC = motorHoleCenters / 2;

	difference() {
		cylinder(r = motorBase / 2, h = thickness, center = true);

		// Armature Hole
		cylinder(r = motorArmatureDiameter / 2, h = thickness, center = true);

		// Mounting Holes
		for (i = [[0, mhC-motorHoleOffset], [0, -mhC+motorHoleOffset], [mhC, 0], [-mhC, 0]]) {
			translate(v = [i[0], i[1], 0])	
				cylinder(r = motorHoleDiameter / 2, h = 4, center = true);
		}


		// Motor Base Cutouts (we rely on the arms to fill in the inner-cutout.
		for (x = [[8, 8], [8, -8], [-8, -8], [-8, 8]]) {
			translate(v = [x[0], x[1], 0])
				cylinder(r = 5, h = 4, center = true);
		}
	}
}

// This builds the imu flight controller base.
module imuBase() {
	imuHalf = imuSize[0] / 2;

	difference() {
		cylinder(r = imuHalf + 5, h = 4, center = true);
	
		// Notches for cover (TODO)
		translate(v = [0, -21.5, 0])
			#cube(size = [8, 3.5, 4], center = true);
		translate(v = [0, 21.5, 0])
			#cube(size = [8, 3.5, 4], center = true);
	}

	translate(v = [0, 0, 3.5]) {
		difference() {
			cube(size = [imuSize[0], imuSize[1], 3], center = true);

			// Provides square standoffs to minimize frame->IMU contact area
			// for reducing vibrations. 
			
			if (imuStandoffs) {
				cube(size = [imuHalf, imuSize[1], 3], center = true);
				cube(size = [imuSize[0], imuHalf, 3], center = true);
			}
		}

		// Adds an additional platform on the edge of the base for arm supports to anchor to.
		for (x = [[imuHalf, imuHalf], [-imuHalf, imuHalf], [-imuHalf, -imuHalf], [imuHalf, -imuHalf]]) {
			translate(v = [x[0], x[1], 0])
				rotate(a = 45, v = [0, 0, 1])
					cube(size = [2, 2, 3], center = true);
		}
	}
}

// Build the arms with motor-wire cutouts.
module arms() {
	difference() {
		for(x = [45, 135]) {
			rotate(a = x, v = [0, 0, 1])
				cube(size = [propCenters + 30, 12, 4], center = true);
		}

			// Cut a little oval for the motor wires to go into.
		for(i = [[55, -55, 45], [-55, 55, 45], [55, 55, 135], [-55, -55, 135]]) {
			translate(v = [i[0], i[1], 0])
				rotate(a = i[2], v = [0, 0, 1])
					scale(v = [0.8, 1.2, 1])
						#cylinder(r = 3, h = 4, center = true);
				
		}
	}
}

// Individual arm support
module armSupport(len, height, width) {
	// Center it
	translate(v = [-len / 2, width / 2, height / 2])
	polyhedron(
		points = [[0, 0, 0], [0, -width, 0], [-len, -width, 0], [-len, 0, 0], [0, -width, height], [0, 0, height]],
		triangles = [[5, 3, 0], [2, 4, 1], [4, 5, 1], [1, 5, 0], [5, 4, 2], [2, 3, 5], [1, 0, 2], [0, 3, 2]]);
}

// Builds little arm supports that help keep them rigid. 
module armSupports() {
	for(i = [45, -45, 135, -135]) {
		rotate(a = i, v = [0, 0, 1]) {
			translate(v = [-6.75, 0, 0.5])
				armSupport(45, 3, 2);	
		}
	}
}

// Build the four motor mounts.
module buildMotorMounts() {
	pos = (propCenters - (motorBase / 2)) / 2;

	for(i = [[pos, pos], [-pos, pos], [-pos, -pos], [pos, -pos]]) {
		translate(v = [i[0], i[1], 0])
			motorMount();
	}	
}

// Build the base (imu base and arms)
module buildBase() {
	imuBase();
	arms();
}

module frame() {
	difference() {
		buildBase();

		// Cutout the part for mounting the battery holder.

		for(i = [[-bbhSpace, -bbhSpace], [bbhSpace, bbhSpace], [-bbhSpace, bbhSpace], [bbhSpace, -bbhSpace]]) {
			translate(v = [i[0], i[1], 3.5]) {
				cylinder(r = 4.2 / 2, h = 4, center = true);
				translate(v = [0, 0, -4])
					cylinder(r = 1.3, h = 4, center = true);		
			}
		}
	}

	difference() {
		armSupports();

		for (x = [[-55, -55, 135], [55, 55, 135], [55, -55, 45], [-55, 55, 45]]) {
			translate(v = [x[0], x[1], 0])
				rotate(a = x[2], v = [0, 0, 1])
					scale(v = [0.8, 1.2, 1])
						#cylinder(r = 3, h = 4, center=true);
		}
	}
	buildMotorMounts();
}






