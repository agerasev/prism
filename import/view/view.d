module view.view;

import model.info.universeinfo;

import model.astronomy.info.satelliteinfo;
import model.astronomy.info.celestialinfo;

import window.renderer;

import derelict.opengl3.gl;

import linalg.vector;

class View : Renderer {
private:
	UniverseInfo _universe;
	SatelliteInfo!(CelestialInfo)[] _celestials;
public:
	void bind(UniverseInfo u) {
		_universe = u;
		_celestials = _universe.celestialsInfo;
	}
	override void render() {
		void drawVertex(vec3 p) {
			glVertex3d(p.x,p.y,p.z);
		}
		void drawTriangle(vec3[3] tp) {
			drawVertex(tp[0]);
			drawVertex(tp[1]);
			drawVertex(tp[2]);
		}
		glBegin(GL_TRIANGLES);
		foreach(c; _celestials) {
			for(int ir = 0; ir < 20; ++ir) {
				drawTriangle(c.objectInfo.regionsInfo[ir].borders);
			}
		}
		glEnd();
	}
}
