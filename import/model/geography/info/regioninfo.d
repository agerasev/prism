module model.geography.info.regioninfo;

import linalg.vector;

interface RegionInfo {
public:
	@property vec3[3] borders(); 
}