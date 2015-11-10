package ;

import haxe.ds.Vector;
using Matrix2D;

class Transform2D {
	public var parent(default,null): Transform2D = null;
	public var children(default,null): Array<Transform2D> = null;
	public var chunk(default,null): Batch.BatchDrawChunk;
	public var shift(default,null): Int;

	public static inline var PI    = 3.14159265358979;
	public static inline var DEG_0   = 0.0;
	public static inline var DEG_90  = 0.5*PI;
	public static inline var DEG_180 = PI;
	public static inline var DEG_270 = 1.5*PI;
	public static inline var DEG_360 = 2*PI;
	
	public var transformLocal(default,null) = Matrix2D.newMatrix();
	public var transformWorld(default,null) = Matrix2D.newMatrix();
	public var sin_(default,null): Float = 0.0;
	public var cos_(default,null): Float = 1.0;
	
	public function addChild( child: Transform2D ) {
		if ( child.parent != this ) {
			if ( child.parent != null ) {
				child.parent.removeChild( child );
			}
			if ( children == null ) {
				children = new Array<Transform2D>();
			}
			children.push( child );
			child.parent = this;
			child.updateTransform();		
		}
		return this;
	}

	public function removeChild( child: Transform2D ) {
		if ( child.parent == this ) {
			children.remove( child );
			child.parent = null;
		}
		return this;
	}
	

	public function setParent( parent_: Transform2D ) {
		parent_.addChild( this );
		return parent_;
	}

	public var x(get,set): Float;
	public var y(get,set): Float;
	public var xscl(get,set): Float;
	public var yscl(get,set): Float;
	public var xskw(get,set): Float;
	public var yskw(get,set): Float;
	public var xpiv(default,set): Float = 0;
	public var ypiv(default,set): Float = 0;
	public var rot(default,set): Float = 0;
	public var visible(default,set): Bool = true;

	public var xWld(get,null): Float;
	public var yWld(get,null): Float;
	public var xsclWld(get,null): Float;
	public var ysclWld(get,null): Float;
	public var xskwWld(get,null): Float;
	public var yskwWld(get,null): Float;
	public var xpivWld(get,null): Float;
	public var ypivWld(get,null): Float;
	public var rotWld(default,null): Float = 0;
	public var visibleWld(default,null): Bool = true;

	public static function test() {
		var x = new Transform2D( null, null );
		var y = new Transform2D( null, null );
		x.x = 2;
		x.setParent( y );
		y.rot = DEG_90/2;
		y.rot = DEG_270;
	}

	function updateTransform() {
		transformWorld.copyMatrixOrigin( transformLocal );
		transformWorld.rotateClockwise( sin_, cos_, xpiv, ypiv );
		transformWorld.translate( transformLocal.getTx(), transformLocal.getTy());
		if ( parent != null ) {
			transformWorld.concat( parent.transformWorld );
		}
		if ( children != null ) {
			for ( c in children ) {
				c.updateTransform();
			}
		}
		chunk.updateTransform( shift, xWld, yWld, xsclWld, xskwWld, yskwWld, ysclWld );
	}

	function updateRotWld() {
		this.rotWld = this.rot;
		if ( parent != null ) {
			this.rotWld += parent.rotWld ;
			this.rotWld %= DEG_360;
			if ( this.rotWld < 0.0 ) {
				this.rotWld += DEG_360;
			}
		}
		if ( children != null ) {
			for ( c in children ) {
				c.updateRotWld();
			}
		}
	}

	function updateVisibleWld() {
		this.visibleWld = this.visible;
		if ( parent != null ) {
			this.visibleWld = this.visibleWld && parent.visibleWld;
		}
		if ( children != null ) {
			for ( c in children ) {
				c.updateRotWld();
			}
		}
	}

	public inline function get_x() return transformLocal.getTx();
	public inline function get_y() return transformLocal.getTy();
	public inline function get_xscl() return transformLocal.getA();
	public inline function get_yscl() return transformLocal.getD();
	public inline function get_xskw() return transformLocal.getC();
	public inline function get_yskw() return transformLocal.getB();

	public inline function get_xWld() return transformWorld.getTx();
	public inline function get_yWld() return transformWorld.getTy();
	public inline function get_xsclWld() return transformWorld.getA();
	public inline function get_ysclWld() return transformWorld.getD();
	public inline function get_xskwWld() return transformWorld.getC();
	public inline function get_yskwWld() return transformWorld.getB();
	public inline function get_xpivWld() return this.xpiv;
	public inline function get_ypivWld() return this.ypiv;

	public inline function set_x( v: Float ) { transformLocal.setTx( v ); updateTransform(); return v; }
	public inline function set_y( v: Float ) { transformLocal.setTy( v ); updateTransform(); return v; }
	public inline function set_xpiv( v: Float ) { this.xpiv = v; updateTransform(); return v; }
	public inline function set_ypiv( v: Float ) { this.ypiv = v; updateTransform(); return v; }
	public inline function set_xscl( v: Float ) { transformLocal.setA( v ); updateTransform(); return v; }
	public inline function set_yscl( v: Float ) { transformLocal.setD( v ); updateTransform(); return v; }
	public inline function set_xskw( v: Float ) { transformLocal.setC( v ); updateTransform(); return v; }
	public inline function set_yskw( v: Float ) { transformLocal.setB( v ); updateTransform(); return v; }
	public inline function set_rot( v: Float ) { 
		if ( v != this.rot ) {
			v %= DEG_360;
			if ( v < 0.0 ) {
				v += DEG_360;
			}
			switch ( v ) {
				case DEG_0:   sin_ = 0.0; cos_ = 1.0;
				case DEG_90:  sin_ = 1.0; cos_ = 0.0;
				case DEG_180: sin_ = 0.0; cos_ =-1.0;
				case DEG_270: sin_ =-1.0; cos_ = 0.0;
				case _:	      sin_ = Math.sin( v ); cos_ = Math.cos( v );
			}
			this.rot = v;
			updateTransform();
			updateRotWld();
		}	
		return v; 
	}
	public inline function set_visible( v: Bool ) {
		visible = v;
		updateVisibleWld();
		return v;
	}

	public function new( chunk: Batch.BatchDrawChunk, shift: Int ) {
		this.chunk = chunk;
		this.shift = shift;
		updateTransform();
	}
}
