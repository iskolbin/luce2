package ;

import junge.Tween;

class Widget implements Tween.Tweenable {
	static public var NULL_FRAMES = [0.0];

	static public inline var X:     Int = 0;
	static public inline var Y:     Int = 1;
	static public inline var Frame: Int = 2;
	static public inline var XScl:  Int = 3;
	static public inline var YScl:  Int = 4;
	static public inline var XSkw:  Int = 5;
	static public inline var YSkw:  Int = 6;
	static public inline var Red:   Int = 7;
	static public inline var Blue:  Int = 8;
	static public inline var Green: Int = 9;
	static public inline var Alpha: Int = 10;
	static public inline var Rot:   Int = 11;
	static public inline var XPiv:  Int = 12;
	static public inline var YPiv:  Int = 13;

	public var parent(default,null): Widget = null;
	public var children(default,null): Array<Widget> = null;
	public var chunk(default,null): Batch.BatchDrawChunk;
	public var shift(default,null): Int;
	public var reserved(default,null): Int;
	public var frame(default,set): Float = 0;
	public var framesList(default,null): Array<Float> = NULL_FRAMES;
	public var color(default,null): Color;
	public var transform(default,null): Transform2D;

	public function addChild( child: Widget ) {
		if ( child.parent != this ) {
			if ( child.parent != null ) {
				child.parent.removeChild( child );
			}
			if ( children == null ) {
				children = new Array<Widget>();
			}
			children.push( child );
			child.parent = this;

			transform.addChild( child.transform );
			color.addChild( child.color );

			child.updateFrame();		
		}	
	}

	public function removeChild( child: Widget ) {
		if ( child.parent == this ) {
			children.remove( child );
			child.parent = null;
	
			transform.removeChild( child.transform );
			color.removeChild( child.color );
		}
	}

	public inline function updateFrame() {
		chunk.updateFrame( shift, transform.visible ? frame : 0.0 ); 	
	}

	public inline function set_frame( v: Float ) {
		frame = v;
		updateFrame();
		return v;
	}

	public function new( chunk: Batch.BatchDrawChunk, shift: Int, reserved: Int ) {
		this.chunk = chunk;
	 	this.shift = shift;
		this.reserved = reserved;
		color = new Color( chunk, shift );
		transform = new Transform2D( chunk, shift );
	}
	
	public function setAttr( id: Int, v: Float ) {
		switch( id ) {
			case X: transform.x = v; 
			case Y: transform.y = v;
			case XScl: transform.xscl = v;
			case YScl: transform.yscl = v;
			case XSkw: transform.xskw = v;
			case YSkw: transform.yskw = v;
			case Rot: transform.rot = v;
			case XPiv: transform.xpiv = v;
			case YPiv: transform.ypiv = v;
			case Red: color.red = v;
			case Green: color.green = v;
			case Blue: color.blue = v;
			case Alpha: color.alpha = v;	
			case Frame: frame = v;
		}
	}	
	
	public function getAttr( id: Int ) {
		return switch( id ) {
			case X: transform.x;
			case Y: transform.y;
			case XScl: transform.xscl;
			case YScl: transform.yscl;
			case XSkw: transform.xskw;
			case YSkw: transform.yskw;
			case Rot: transform.rot;
			case XPiv: transform.xpiv;
			case YPiv: transform.ypiv;
			case Red: color.red;
			case Green: color.green;
			case Blue: color.blue;
			case Alpha: color.alpha;	
			case Frame: frame;
			case _: Math.NaN;
		}
	}

	public inline function move ( attr: Int, target: Float, length: Float, ease:Int, after: Int ) return Tween.move( this, attr, target, length, ease, after );
	public inline function move2( attr: Int, pairsList: Array<Float>, ease: Int, after: Int ) return Tween.move2( this, attr, pairsList, ease, after );
	public inline function move3( attr: Int, pairsList: Array<Float>, after: Int ) return Tween.move3( this, attr, pairsList, after );
}

