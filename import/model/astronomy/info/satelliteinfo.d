module model.astronomy.info.satelliteinfo;

import model.astronomy.info.celestialinfo;
import model.astronomy.info.orbitinfo;

interface SatelliteInfo(T : CelestialInfo) {
public:
	@property T objectInfo();
	@property OrbitInfo orbitInfo();
}