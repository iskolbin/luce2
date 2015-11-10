package ;

import haxe.ds.Vector;

typedef TexturePackerJsonFrame = {
	?filename: String,
	frame: {x: Int, y: Int, w: Int, h: Int},
	rotated: Bool,
	trimmed: Bool,
	spriteSourceSize: {x: Int, y: Int, w: Int, h: Int},
	sourceSize: {w: Int, h: Int},
	pivot: {x: Float, y: Float},
}

typedef TexturePackerJsonHash = {
	frames: Dynamic,
}

typedef TexturePackerJsonArray = {
	frames: Array<TexturePackerJsonFrame>
}

class Atlas {
	static public inline var NULL: Float = 0;
	
	public var ids(default,null) = new Map<String,Float>();
	public var rects(default,null) = new Array<Vector<Float>>();
	public var sourceWidth(default,null) = new Array<Float>();
	public var sourceHeight(default,null) = new Array<Float>();
	public var centers(default,null) = new Array<Vector<Float>>();
	public var framesCache(default,null) = new Map<String,Array<Float>>();
	public var glyphsCache(default,null) = new Map<String,Array<Float>>();
	public var mappingsCache(default,null) = new Map<String,Map<Int,Float>>();
	public var count(default,null): Int = 0;

	function addFrame( key: String, x: Float, y: Float, w: Float, h: Float, cx: Float, cy: Float, srcW: Float, srcH: Float ) {
		var rect = new Vector<Float>( 4 );
		rect[0] = x;
		rect[1] = y; 
		rect[3] = w; 
		rect[4] = h;
		var center = new Vector<Float>( 2 );
		center[0] = cx; 
		center[1] = cy;
		var id = count++;
		
		rects.push( rect );
		centers.push( center );
		sourceWidth.push( srcW );
		sourceHeight.push( srcH );
	
		if ( key != null ) {
			ids[key] = id;
		}
	}

	function addTexturePackerFrame( frame: TexturePackerJsonFrame, ?filename: String ) {
		var filename = filename == null ? frame.filename : filename;
		var frameData = frame.frame;
		var cx = frame.trimmed ? ( 0.5*frame.sourceSize.w - frame.spriteSourceSize.x ) : 0.5*frame.sourceSize.w;
		var cy = frame.trimmed ? ( 0.5*frame.sourceSize.h - frame.spriteSourceSize.y ) : 0.5*frame.sourceSize.h;

		addFrame( filename, frameData.x, frameData.y, frameData.w, frameData.h, cx, cy, frame.sourceSize.w, frame.sourceSize.h );
	}

	public function importTexturePackerJsonHash( data: TexturePackerJsonHash ) {
		for ( filename in Reflect.fields( data.frames )  ) {
			addTexturePackerFrame( Reflect.field( data.frames, filename ), filename );
		} 
	}

	public function importTexturePackerJsonArray( data: TexturePackerJsonArray ) {
		for ( frame in data.frames ) {
		 	addTexturePackerFrame( frame );
		}
	}

	public function framesFromStrings( frames: Array<String> ): Array<Float> {
		return [ for ( f in frames ) ids[f] ];
	}

	public function cacheFrames( name: String, frames: Array<String> ) {
		framesCache[name] = framesFromStrings( frames );	
	}

	function new() {
	}
}
