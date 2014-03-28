module model.astronomy.planet;

import model.astronomy.info.planetinfo;

import model.astronomy.celestial;
import model.astronomy.satellite;

import linalg.vector;

class Planet : Celestial, PlanetInfo {
public:
	static class Attribute : Celestial.Attribute {
	private:
		Planet.Attribute[] _moons;
	public:
		void addMoon(Planet.Attribute attrib) {
			_moons[$++] = attrib;
		}
	}
	static alias infoof = PlanetInfo;
private:
	Satellite!Planet[] moons;
public:
	this(Planet.Attribute attrib) {
		super(attrib);
	}
}
