module model.astronomy.proxy.satelliteproxy;

import model.astronomy.proxy.celestialproxy;
import model.astronomy.proxy.orbitproxy;

interface SatelliteProxy(T : CelestialProxy) {
public:
	@property T objectProxy();
	@property OrbitProxy orbitProxy();
}