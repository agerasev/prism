module model.geography.icosahedron;

import model.geography.region;
import linalg.vector;

class Icosahedron {
public static immutable REGIONS = 20;
private:
	Region[20] _regions;
public:
	this(double radius) {
		//building geometry

		//computing angles
		import std.math;
		double sinb = 1.0/sqrt(5.0), cosb = sqrt(1.0 - sinb*sinb);

		//computing vertices
		vec3 top = vec3(0.0,0.0,1.0);
		vec3 bottom = vec3(0.0,0.0,-1.0);
		vec3[5] topRing, bottomRing;
		for(int i = 0; i < 5; ++i) {
			double phi = (2.0*PI*i)/5.0, delta = (2.0*PI*1.0)/(2.0*5.0);
			topRing[i] = vec3(cosb*cos(phi),cosb*sin(phi),sinb);
			bottomRing[i] = vec3(cosb*cos(phi+delta),cosb*sin(phi+delta),-sinb);
		}

		//filling top and bottom ring
		for(int i = 0; i < 5; ++i) {
			_regions[i] = new Region(radius,[top,topRing[i],topRing[(i+1)%5]]);
			_regions[15 + i] = new Region(radius,[bottom,bottomRing[(i+1)%5],bottomRing[i]]);
		}
		//filling middle ring
		for(int i = 0; i < 5; ++i) {
			_regions[5 + 2*i] = new Region(radius,[topRing[i],bottomRing[i],topRing[(i+1)%5]]);
			_regions[5 + 2*i + 1] = new Region(radius,[bottomRing[(i+1)%5],topRing[(i+1)%5],bottomRing[i]]);
		}
	}
	~this() {
		foreach(ref elem; _regions) {
			delete elem;
		}
	}
	@property Region[] regions() {
		return _regions;
	}
}