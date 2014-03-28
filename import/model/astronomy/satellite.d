module model.astronomy.satellite;

import model.astronomy.info.satelliteinfo;

import model.astronomy.celestial;
import model.astronomy.orbit;

import model.astronomy.info.orbitinfo;

class Satellite(T : Celestial) : SatelliteInfo!(T.infoof) {
public:
	static alias infoof = SatelliteInfo!(T.infoof);
private:
	T _object;
	Orbit _orbit;
public:
	this(T obj, Orbit.Attribute orbAttrib) {
		_object = obj;
		_orbit = new Orbit(orbAttrib);
	}
	~this() {
		delete _orbit;
	}
	@property T object() {
		return _object;
	}
	/**
	 * Info access
	 */
	override @property T.infoof objectInfo() {
		return _object;
	}
	override @property OrbitInfo orbitInfo() {
		return _orbit;
	}
}