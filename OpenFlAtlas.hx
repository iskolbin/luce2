package ;

import openfl.display.Tilesheet;
import openfl.display.BitmapData;

class OpenFlAtlas extends Atlas {
	public var tilesheet(default,null): Tilesheet;
	public var bitmapData(default,null): BitmapData;
	
	public function new( bitmapData: BitmapData ) {
		super();
		tilesheet = new Tilesheet( bitmapData );
	}
}
