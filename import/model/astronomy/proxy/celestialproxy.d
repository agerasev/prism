module model.astronomy.proxy.celestialproxy;

import model.geography.proxy.regionproxy;

interface CelestialProxy {
public:
	@property RegionProxy[] regionsProxy();
}