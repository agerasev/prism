module linalg.quaternion;

import linalg.vector;

struct quaternion(type) {
private:
	vec!(type,4) vector;
	alias current = quaternion!(type);

public:
	alias x = vector[0], y = vector[1], z = vector[2], w = vector[3];

	@property vec!(type) vec() {
		return vector;
	}

	//...

	/**
	 * Do I need it?
	 */
}