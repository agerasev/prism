module model.astronomy.celestial;

import model.astronomy.info.celestialinfo;

import model.geography.icosahedron;

import model.geography.info.regioninfo;

import linalg.vector;

abstract class Celestial : CelestialInfo {
public:
	static class Attribute {
		@property double radius() const {
			return 1.0;
		}
	}
	static alias infoof = CelestialInfo;
private:
	Icosahedron _surface;
protected:
	Attribute _attrib;
public:
	///position and radius
	this(Attribute attrib) {
		_attrib = attrib;
		_surface = new Icosahedron(attrib.radius);
	}
	~this() {
		delete _surface;
	}
	/**
	 * Info access
	 */
	override @property RegionInfo[] regionsInfo() {
		RegionInfo[] regpr;
		regpr.length = Icosahedron.REGIONS;
		for(int i = 0; i < Icosahedron.REGIONS; ++i) {
			regpr[i] = _surface.regions[i];
		}
		return regpr;
	}
}
