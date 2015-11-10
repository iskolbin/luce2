package ;

class Color {
	public var parent(default,null): Color = null;
	public var children(default,null): Array<Color> = null;
	public var chunk(default,null): Batch.BatchDrawChunk;
	public var shift(default,null): Int;
	
	public var red(default,set):   Float = 1;
	public var green(default,set): Float = 1;
	public var blue(default,set):  Float = 1;
	public var alpha(default,set): Float = 1;

	public var redWld(default,null):   Float = 1;
	public var greenWld(default,null): Float = 1;
	public var blueWld(default,null):  Float = 1;
	public var alphaWld(default,null): Float = 1;

	public function new( chunk: Batch.BatchDrawChunk, shift: Int ) {
		this.chunk = chunk;
		this.shift = shift;
		updateColor();	
	}

	public function addChild( child: Color ) {
		if ( child.parent != this ) {
			if ( child.parent != null ) {
				child.parent.removeChild( child );
			}
			if ( children == null ) {
				children = new Array<Color>();
			}
			children.push( child );
			child.parent = this;
			child.updateColor();		
		}	
	}

	public function removeChild( child: Color ) {
		if ( child.parent == this ) {
			children.remove( child );
			child.parent = null;
		}
	}

	function updateColor() {
		redWld = red;
		greenWld = green;
		blueWld = blue;
		alphaWld = alpha;
		if ( parent != null ) {
			redWld *= parent.redWld;
			greenWld *= parent.greenWld;
			blueWld *= parent.blueWld;
			alphaWld *= parent.alphaWld;
		}
		if ( children != null ) {
			for ( c in children ) {
				c.updateColor();
			}
		}
		chunk.updateColor( shift, redWld, greenWld, blueWld, alphaWld );
	}

	public inline function setRGB( r: Float, g: Float, b: Float ) { red = r; green = g; blue = b; }
	public inline function setRGBA( r: Float, g: Float, b: Float, a: Float ) { setRGB( r, g, b ); alpha = a; }
	
	public inline function set_red( v: Float )   { this.red = v; updateColor(); return v; }
	public inline function set_green( v: Float ) { this.green = v; updateColor(); return v; }
	public inline function set_blue( v: Float )  { this.blue = v; updateColor(); return v; }
	public inline function set_alpha( v: Float ) { this.alpha = v; updateColor(); return v; }
}
