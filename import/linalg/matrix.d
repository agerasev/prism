module linalg.matrix;

import linalg.vector;

import std.math;

unittest {
	import std.conv;
	imat3 m0 = nullimat3;
	imat4 m1 = -identimat4;
	assert(m0[0,0] == 0);
	assert(m1[2,2] == -1);
	assert(m1[3,2] == 0);
	imat3 m2 = identimat3;
	assert((m0 - m2)[2,2] == -1);
	assert((m0*m2)[0,0] == 0);
	assert((-m2).det() == -1, "det() equals " ~ text(m1.det()));
}

alias uvec2 = vec!(uint,2);

/**
	Matrix struct
*/
struct mat(type, uint w, uint h) {
@system:
	static assert(__traits(isScalar,type), "matrix allowed only for scalar types");
	static assert(w > 1 && h > 1, "martix must be 2x2 or greater");

private:
	type[h*w] field;
	alias current = mat!(type,w,h);

public:
	this(ctypes...)(ctypes args) {
		static assert(args.length == w*h, "wrong number of arguments");
		foreach(i, arg; args) {
			this[i%w,i/w] = cast(type)arg;
		}
	}
	this(ctype)(mat!(ctype,w,h) m) {
		for(uint iy = 0; iy < h; ++iy) {
			for(uint ix = 0; ix < w; ++ix) {
				this[ix,iy] = cast(type)(m[ix,iy]);
			}
		}
	}

	@property type* data() {
		return field.ptr;
	}
	@property uvec2 size() {
		return uvec2(w,h);
	}

	/**
	 Index access
	 */
	ref type opIndex(uvec2 v) {
		return field[v.y*w + v.x];
	}
	ref type opIndex(uint x, uint y) {
		return field[y*w + x];
	}
	type opIndex(uvec2 v) const {
		return field[v.y*w + v.x];
	}
	type opIndex(uint x, uint y) const {
		return field[y*w + x];
	}

private:
	vec!(type,w) getRow(uint y) {
		vec!(type,w) v;
		for(uint ix = 0; ix < w; ++ix) {
			v[ix] = this[ix,y];
		}
		return v;
	}
	vec!(type,h) getCol(uint x) {
		vec!(type,w) v;
		for(uint iy = 0; iy < h; ++iy) {
			v[iy] = this[x,iy];
		}
		return v;
	}

public:
	/**
	 * Unary
	 */
	current opUnary(string op)() const {
		current r;
		for(uint iy = 0; iy < h; ++iy) {
			for(uint ix = 0; ix < w; ++ix) {
				static if(op == "+") {
					r[ix,iy] = this[ix,iy];
				} else static if(op == "-") {
					r[ix,iy] = -this[ix,iy];
				}
			}
		}
		return r;
	}

	/**
	 * Binary
	 */
	current opBinary(string op : "-")(current m) {
		current r;
		for(uint iy = 0; iy < h; ++iy) {
			for(uint ix = 0; ix < w; ++ix) {
				r[ix,iy] = this[ix,iy] - m[ix,iy];
			}
		}
		return r;
	}

	current opBinary(string op : "*")(type s) {
		current r;
		for(uint iy = 0; iy < h; ++iy) {
			for(uint ix = 0; ix < w; ++ix) {
				r[ix,iy] = s*this[ix,iy];
			}
		}
		return r;
	}
	current opBinaryRight(string op : "*")(type s) {
		return this*s;
	}

	vec!(type,h) opBinary(string op : "*")(vec!(type,w) v) {
		vec!(type,h) r;
		for(int iy = 0; iy < h; ++iy) {
			r[iy] = v*getRow(iy);
		}
		return r;
	}
	vec!(type,w) opBinaryRight(string op : "*")(vec!(type,h) v) {
		vec!(type,w) r;
		for(int ix = 0; ix < w; ++ix) {
			r[ix] = v*getCol(ix);
		}
		return r;
	}

	mat!(type,wm,h) opBinary(string op : "*", uint wm, uint hm)(mat!(type,wm,hm) m) {
		mat!(type,wm,h) r;
		for(int iy = 0; iy < h; ++iy) {
			for(int ix = 0; ix < wm; ++ix) {
				r[ix,iy] = getRow(iy)*m.getCol(ix);
			}
		}
		return r;
	}

	ref current opOpAssign(string op)(current v) {
		static if(op == "+") {
			this = this + v;
		} else
		static if(op == "-") {
			this = this - v;
		}
		return this;
	}
	
	ref current opOpAssign(string op : "*")(type s) {
		this = s*this;
		return this;
	}

	static if(w == h) {
		ref current opOpAssign(string op : "*")(current m) {
			this = this*m;
			return this;
		}
	}

	mat!(type,h,w) t() {
		mat!(type,h,w) m;
		for(uint iy = 0; iy < h; ++iy) {
			for(uint ix = 0; ix < w; ++ix) {
				m[iy,ix] = this[ix,iy];
			}
		}
		return m;
	}

	static if(w > 2 && h > 2) {
		mat!(type,w-1,h-1) cofract(uint x, uint y) {
			mat!(type,w-1,h-1) mm;
			for(uint iy = 0, py = 0; iy < h-1; ++iy, ++py) {
				if(iy == y) {
					++py;
				}
				for(uint ix = 0, px = 0; ix < w-1; ++ix, ++px) {
					if(ix == x) {
						++px;
					}
					mm[ix,iy] = this[px,py];
				}
			}
			return mm;
		}

		type minor(uint x, uint y) {
			return cofract(x,y).det();
		}

		type cofractor(uint x, uint y) {
			return cast(type)(1 - 2*((x+y)%2))*minor(x,y);
		}
	}

	static if(w == h) {
		/*
		 * Determinant
		 */
		static if(w > 2) {
			type det() {
				import std.stdio;
				type val = cast(type)0;
				for(uint i = 0; i < w; ++i) {
					val += this[i,0]*cofractor(i,0);
				}
				return val;
			}
		} else {
			type det() {
				return this[0,0]*this[1,1] - this[0,1]*this[1,0];
			}
		}
		/*
		 * Inverted matrix
		 */
		current invert() {
			return (1/det())*adjunct();
		}

		static if(w > 2 && h > 2) {
			current adjunct() {
				current m;
				for(uint iy = 0; iy < h; ++iy) {
					for(uint ix = 0; ix < w; ++ix) {
						m[ix,iy] = cofractor(ix,iy);
					}
				}
				return m;
			}
		} else {
			current adjunct() {
				return current(this[1,1],-this[1,0],-this[0,1],this[0,0]);
			}
		}
	}

	/**
	 * Rotation
	 */
	static if(w == 2 && h == 2) {
		static current rotation(double phi) {
			return current(
				cos(phi), sin(phi),
				-sin(phi), cos(phi)
				);
		}
	} else static if(w == 3 && h == 3) {
		static current rotation(vec!(type,w) axis, double theta) {
			type sint = cast(type)sin(theta), cost = cast(type)cos(theta), rcost = cast(type)(1.0 - cost);
			with(axis) {
				return mat!(type,3,3)(
					cost + rcost*(x*x), rcost*(x*y) - sint*z, rcost*(x*z) + sint*y,
					rcost*(y*x) + sint*z, cost + rcost*(y*y), rcost*(y*z) - sint*x,
					rcost*(z*x) - sint*y, rcost*(z*y) + sint*x, cost + rcost*(z*z)
					);
			}
		}
		/*
		static current direction(vec!(type,w) dir, vec!(type,w) top) {
			auto right = (dir^top).norm;
		}
		*/
	} else static if(w == 4 && h == 4) {
		/*
		static current rotation(vec!(type,w) axis, double theta) {
			return current(
				cos(phi), sin(phi),
				-sin(phi), cos(phi)
				);
		}
		static current direction(vec!(type,w) dir, vec!(type,w) top) {
			return current(
				cos(phi), sin(phi),
				-sin(phi), cos(phi)
				);
		}
		*/
	}
}

alias mat2 = mat!(double,2,2);
alias mat3 = mat!(double,3,3);
alias mat4 = mat!(double,4,4);

alias imat2 = mat!(int,2,2);
alias imat3 = mat!(int,3,3);
alias imat4 = mat!(int,4,4);

immutable imat2 nullimat2 = imat2(0,0,0,0);
immutable imat3 nullimat3 = imat3(0,0,0,0,0,0,0,0,0);
immutable imat4 nullimat4 = imat4(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

immutable imat2 identimat2 = imat2(1,0,0,1);
immutable imat3 identimat3 = imat3(1,0,0,0,1,0,0,0,1);
immutable imat4 identimat4 = imat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);

immutable mat2 nullmat2 = nullimat2;
immutable mat3 nullmat3 = nullimat3;
immutable mat4 nullmat4 = nullimat4;

immutable mat2 identmat2 = identimat2;
immutable mat3 identmat3 = identimat3;
immutable mat4 identmat4 = identimat4;
