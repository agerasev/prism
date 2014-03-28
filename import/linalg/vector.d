module linalg.vector;

unittest{
	ivec3 v1 = ivec3(4,4,4);
	vec3 v2 = v1;
	assert(-(+(-v1)) == ivec3(4,4,4), "comparing fault");
	assert((v1 + ivec3(1,1,1)) - ivec3(1,1,1) == v1, "summing fault");
	assert(ivec2(2,2)*ivec2(1,-1) == 0, "scalar product fault");
	assert((v1 += ivec3(1,1,1)) == v1, "opassign fault");
	assert(2*ivec2(1,1) == ivec2(2,2), "multiplication fault");
	v1 = ivec3([4,4,4]);
}

/**
	Vector struct
*/
struct vec(type, uint dim) {
@system:
	static assert(__traits(isScalar,type), "vec allowed only for scalar types");
	static assert(dim >= 2, "vector must have more than one dimensions");

private:
	type[dim] field;
	alias current = vec!(type,dim);
	
public:
	this(type[] arr) {
		field[] = arr[];
	}
	this(vtype)(vec!(vtype,dim) v) {
		foreach( i, ref comp; v.field ) {
			field[i] = cast(type)comp;
		}
	}
	this(atypes...)(atypes args) {
		static assert(args.length == dim, "wrong number of arguments");
		foreach( i, ref comp; args ) {
			field[i] = comp;
		}
	}
	
	/*
		Property
	*/
private:
	@property type* data() {
		return field.ptr;
	}
	@property uint size() {
		return dim;
	}

	@property type get_(uint n)() const {
		return field[n];
	}
	@property void set_(uint n)(type val) {
		field[n] = val;
	}

public:
	static if(dim <= 4) {
		alias get_!0 x;
		alias set_!0 x;
		alias get_!1 y;
		alias set_!1 y;
		static if(dim > 2) {
			alias get_!2 z;
			alias set_!2 z;
			alias x r;
			alias y g;
			alias z b;
			static if(dim > 3) {
				alias get_!3 t;
				alias set_!3 t;
				alias t w;
				alias t a;
			}
		}
	}

	/*
		Index access
	*/
	ref type opIndex(uint x) {
		return field[x];
	}
	
	/*
		Unary operators
	*/
	current opUnary(string op : "+")() {
		return this;
	}
	current opUnary(string op : "-")() {
		current rv;
		rv.field[] = -field[];
		return rv;
	}
	
	/*
		Equals operators
	*/
	bool opEquals()(auto ref const current v) {
		foreach(i, ref comp; field) {
			if(comp != v.field[i]) {
				return false;
			}
		}
		return true;
	}
	
	/*
		Binary operators
	*/
	current opBinary(string op)(current v) {
		current rv;
		static if(op == "+") {
			rv.field[] = field[] + v.field[];
		} else
		static if(op == "-") {
			rv.field[] = field[] - v.field[];
		}
		return rv;
	}
	current opBinary(string op : "*")(type s) {
		current rv;
		for(uint i = 0; i < dim; ++i) {
			rv[i] = s*this[i];
		}
		return rv;
	}
	current opBinaryRight(string op : "*")(type s) {
		return this*s;
	}
	current opBinary(string op : "/")(type s) {
		type r = cast(type)(1/s);
		return this*r;
	}
	/*
		Scalar product
	*/
	type opBinary(string op : "*")(current v) {
		type rv = cast(type)0;
		foreach( i, ref comp; v.field ) {
			rv += field[i]*comp;
		}
		return rv;
	}
	type opBinary(string op : "^^", int deg : 2)(int deg) {
		return this*this;
	}

	/*
		OpAssigns
	*/
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
	
	static if(dim == 2) {
		/*
			Cross product
		*/
		type opBinary(string op : "^")(current v) {
			return x*v.y - y*v.x;
		}
	} else
	static if(dim == 3) {
		/*
			Cross product
		*/
		current opBinary(string op : "^")(current v) {
			return current(
				y*v.z - z*v.y,
				z*v.x - x*v.z,
				x*v.y - y*v.x
				);
		}
	} else
	static if(dim == 4) {
		/*
			Cross product
		*/
		current opBinary(string op : "^")(current v) {
			return current(
				y*v.z - z*v.y,
				z*v.x - x*v.z,
				x*v.y - y*v.x,
				1.0
				);
		}
	}

	type abs() {
		type s = cast(type)0;
		for(uint i = 0; i < dim; ++i) {
			s += this[i]^^2;
		}
		return s;
	}

	current norm() {
		return this/this.abs();
	}
}

alias vec2 = vec!(double,2);
alias vec3 = vec!(double,3);
alias vec4 = vec!(double,4);
alias ivec2 = vec!(int,2);
alias ivec3 = vec!(int,3);
alias ivec4 = vec!(int,4);

immutable vec2 nullvec2 = vec2(0.0,0.0);
immutable vec3 nullvec3 = vec3(0.0,0.0,0.0);
immutable vec4 nullvec4 = vec4(0.0,0.0,0.0,0.0);

immutable vec2 nullivec2 = ivec2(0,0);
immutable vec3 nullivec3 = ivec3(0,0,0);
immutable vec4 nullivec4 = ivec4(0,0,0,0);

