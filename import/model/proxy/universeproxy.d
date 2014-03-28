module model.proxy.universeproxy;

import model.astronomy.proxy.satelliteproxy;
import model.astronomy.proxy.celestialproxy;

interface UniverseProxy {
	public @property SatelliteProxy!(CelestialProxy)[] celestialsProxy();
}