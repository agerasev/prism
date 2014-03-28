module model.info.universeinfo;

import model.astronomy.info.satelliteinfo;
import model.astronomy.info.celestialinfo;

interface UniverseInfo {
	public @property SatelliteInfo!(CelestialInfo)[] celestialsInfo();
}