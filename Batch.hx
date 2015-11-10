package ;

import haxe.ds.Vector;

class BatchDrawChunk {
	public var atlasId(default,null): Int = -1;
	public var renderList(default,null) = new Array<Float>();

	public inline function new( atlasId ) {
		this.atlasId = atlasId;
	}

	public inline function add() {
		var shift = renderList.length;
		for ( i in 0...Batch.WGT_SIZE ) {
			renderList.push( 0.0 );
		}
		return shift;
	}

	public inline function updateTransform( shift: Int, x: Float, y: Float, a: Float, b: Float, c: Float, d: Float ) {
		renderList[shift  ] = x;
		renderList[shift+1] = y;
		
		renderList[shift+3] = a;
		renderList[shift+4] = b;
		renderList[shift+5] = c;
		renderList[shift+6] = d;
	}

	public inline function updateFrame( shift: Int, id: Float ) {
		renderList[shift+2] = id;
	}

	public inline function updateColor( shift: Int, r: Float, g: Float, b: Float, a: Float ) {
		renderList[shift+7] = r;
		renderList[shift+8] = g;
		renderList[shift+9] = b;
		renderList[shift+10] = a;
	}
}

class BatchLayer {
	public var chunks(default,null) = new Array<BatchDrawChunk>();

	public function new() {
	}

	public function add( atlasId: Int ) {
		var chunk = null;
		for ( c in chunks ) {
			if ( c.atlasId == atlasId ) {
				chunk = c;
				break;
			}
		}

		if ( chunk == null ) {
			chunk = new BatchDrawChunk( atlasId );
			chunks.push( chunk );
		}

		return chunk.add();
	}
}

class Batch {
	public static inline var WGT_SIZE = 11;
	public var atlases(default,null): Vector<Atlas>;
	public var layers(default,null): Vector<BatchLayer>;

	public function new( atlases: Array<Atlas>, reserveLayers: Int ) {
		this.atlases = new Vector<Atlas>( atlases.length );
		for ( i in 0...atlases.length ) {
			this.atlases[i] = atlases[i];
		}
		this.layers = new Vector<BatchLayer>( reserveLayers );
		for ( i in 0...reserveLayers ) {
			this.layers[i] = new BatchLayer();
		}
	}
	
	public function add( atlasId: Int, layerId: Int ) {
		return layers[layerId].add( atlasId );
	}

	public function render() {
		for ( layer in layers ) {
			for ( chunk in layer.chunks ) {
			}
		}	
	}
}
