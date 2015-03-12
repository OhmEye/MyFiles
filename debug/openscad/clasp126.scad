for (y = [0:11]){
for (x = [0:10]){
	if (y%2 == 0) {
		if (x >0)
    		translate([x*20, y*21, 0])import("clasp.stl");
	} else {
		translate([x*20+10, y*21, 0])import("clasp.stl");
	}
}
}
