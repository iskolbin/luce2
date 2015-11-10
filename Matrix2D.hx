//package luce;
package;

import haxe.ds.Vector;

/*
	 [ 0 1 _ ]
	 [ 2 3 _ ]
	 [ 4 5 _ ]
*/

class Matrix2D {
	public static inline function newMatrix( a: Float = 1.0, b: Float = 0.0, c: Float = 0.0, d: Float = 1.0, tx: Float = 0.0, ty: Float = 0.0 ) {
		var v = new Vector<Float>( 6 );
		v[0] = a;
		v[1] = b;
		v[2] = c;
		v[3] = d;
		v[4] = tx;
		v[5] = ty;	
		return v;
	}

	public static inline function idendity( this_: Vector<Float> ) {
		this_[0] = 1.0;
		this_[1] = 0.0;
		this_[2] = 0.0;
		this_[3] = 1.0;
		this_[4] = 0.0;
		this_[5] = 0.0;
		return this_;
	}

	public static inline function copyMatrix( this_: Vector<Float>, m: Vector<Float> ) {
		this_[0] = m[0];
		this_[1] = m[1];
		this_[2] = m[2];
		this_[3] = m[3];
		this_[4] = m[4];
		this_[5] = m[5];
		return this_;
	}

	public static inline function copyMatrixOrigin( this_: Vector<Float>, m: Vector<Float> ) {
		this_[0] = m[0];
		this_[1] = m[1];
		this_[2] = m[2];
		this_[3] = m[3];
		this_[4] = 0.0;
		this_[5] = 0.0;
		return this_;
	}

	public static inline function translate( this_: Vector<Float>, dx: Float, dy: Float ): Vector<Float> {
		this_[4] += dx;
		this_[5] += dy;
		return this_;
	}

	public static inline function apply( this_: Vector<Float>, a: Float, b: Float, c: Float, d: Float ): Vector<Float> {
		if ( isIdentity( this_ )) {
			this_[0] = a;
			this_[1] = b;
			this_[2] = c;
			this_[3] = d;
		} else {
			var this_0 = this_[0]*a + this_[1]*b;
			this_[1] = this_[0]*c + this_[1]*d;
			this_[0] = this_0;

			var this_2 = this_[2]*a + this_[3]*b;
			this_[3] = this_[2]*c + this_[3]*d;
			this_[2] = this_2;
		}
			var this_4 = this_[4]*a + this_[5]*b;
			this_[5] = this_[4]*c + this_[5]*d;
			this_[4] = this_4;
		
		return this_;
	}

	public static inline function rotateClockwise( this_: Vector<Float>, sin_: Float, cos_: Float, xpiv: Float, ypiv: Float ): Vector<Float> {	
		if ( sin_ != 0.0 || cos_ != 1.0 ) {
			if ( xpiv != 0.0 || ypiv != 0.0 ) {
				translate( this_, xpiv, ypiv );
				apply( this_, cos_, -sin_, sin_, cos_ );
				translate( this_, -xpiv, -ypiv );
			} else {
				apply( this_, cos_, -sin_, sin_, cos_ );
			}
		} 
		return this_;
	}

	public static inline function concat( this_: Vector<Float>, m: Vector<Float> ): Vector<Float> {
		if ( !isIdentity( m )) {
			apply( this_, m[0], m[1], m[2], m[3] );
		}
		translate( this_, m[4], m[5] );
		return this_;
	}

	public static inline function equal( this_: Vector<Float>, m: Vector<Float> ) {
		return this_[0] == m[0] && this_[1] == m[1] && this_[2] == m[2] && this_[3] == m[3] && this_[4] == m[4] && this_[5] == m[5];
	}

	public static inline function isIdentity( this_: Vector<Float> ) {
		return this_[0] == 1.0 && this_[1] == 0.0 && this_[2] == 0.0 && this_[3] == 1.0; 	
	}

	public static inline function setA( this_: Vector<Float>, v: Float ) this_[0] = v;
	public static inline function setB( this_: Vector<Float>, v: Float ) this_[1] = v;
	public static inline function setC( this_: Vector<Float>, v: Float ) this_[2] = v;
	public static inline function setD( this_: Vector<Float>, v: Float ) this_[3] = v;
	public static inline function setTx( this_: Vector<Float>, v: Float ) this_[4] = v;
	public static inline function setTy( this_: Vector<Float>, v: Float ) this_[5] = v;

	public static inline function getA( this_: Vector<Float> ) return this_[0];
	public static inline function getB( this_: Vector<Float> ) return this_[1];
	public static inline function getC( this_: Vector<Float> ) return this_[2];
	public static inline function getD( this_: Vector<Float> ) return this_[3];
	public static inline function getTx( this_: Vector<Float> ) return this_[4];
	public static inline function getTy( this_: Vector<Float> ) return this_[5];
}

