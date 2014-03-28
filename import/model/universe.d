module model.universe;

import model.info.universeinfo;

import model.astronomy.celestial;
import model.astronomy.satellite;
import model.astronomy.orbit;
import model.astronomy.star;
import model.astronomy.info.satelliteinfo;
import model.astronomy.info.celestialinfo;

class Universe : UniverseInfo {
private:
	Satellite!Celestial[] _celestials;
public:
	this() {
		produce();
	}
	~this() {
		reduce();
	}
private:
	void produce() {
		_celestials.length++;
		_celestials[$-1] = new Satellite!Celestial(new Star(new Star.Attribute()), new Orbit.Attribute());
	}
	void reduce() {
		foreach(ref c; _celestials) {
			Celestial s = c.object;
			delete c;
			delete s;
		}
	}
public:
	///Info access
	override @property SatelliteInfo!(CelestialInfo)[] celestialsInfo() {
		SatelliteInfo!(CelestialInfo)[] satpr;
		satpr.length = _celestials.length;
		for(int i = 0; i < _celestials.length; ++i) {
			satpr[i] = _celestials[i];
		}
		return satpr;
	}
}
