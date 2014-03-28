module model.astronomy.star;

import model.astronomy.info.starinfo;

import model.astronomy.celestial;
import model.astronomy.planet;
import model.astronomy.satellite;

import linalg.vector;

class Star : Celestial, StarInfo {
public:
	static class Attribute : Celestial.Attribute {
	private:
		Planet.Attribute[] _system;
	public:
		void addPlanet(Planet.Attribute attrib) {
			_system.length++;
			_system[$-1] = attrib;
		}
	}
	static alias infoof = StarInfo;
private:
	Satellite!Planet[] _system;

	void produce() {

	}
	void reduce() {

	}
public:
	this(Star.Attribute attrib) {
		super(attrib);
	}
}