module model.geography.region;

import model.geography.info.regioninfo;

import linalg.vector;

class Region : RegionInfo {
private:
	vec3[3] vertex;
	double radius;
public:
	this(double rad, vec3[3] av) {
		radius = rad;
		foreach(i, ref v; vertex) {
			v = av[i]*radius;
		}
	}
	/**
	 * Info access
	 */
	override @property vec3[3] borders() {
		vec3[3] rv = vertex;
		return rv;
	}
}