module model.geography.proxy.regionproxy;

import linalg.vector;

interface RegionProxy {
public:
	@property vec3[3] borders(); 
}