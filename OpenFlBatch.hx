package ;

import openfl.display.Graphics;
import openfl.display.Tilesheet;
import haxe.ds.Vector;

class OpenFlBatch extends Batch {
	public var graphics(default,null): Graphics;
	public var tilesheets(default,null): Vector<Tilesheet>;
	public var smooth = true;
	static public inline var RENDER_FLAGS = Tilesheet.TILE_TRANS_2x2 | Tilesheet.TILE_RGB | Tilesheet.TILE_ALPHA;

	public function new( graphics: Graphics, atlases: Array<OpenFlAtlas>, reserveLayers: Int ) {
		super( cast atlases, reserveLayers );
		this.graphics = graphics;
		tilesheets = new Vector<Tilesheet>( atlases.length );
		for ( i in 0...atlases.length ) {
			tilesheets[i] = atlases[i].tilesheet;
		}
	}

	override public function render() {
		for ( layer in layers ) {
			for ( chunk in layer.chunks ) {
				tilesheets[chunk.atlasId].drawTiles( graphics, chunk.renderList, smooth, RENDER_FLAGS );
			}
		}	
	}
}
