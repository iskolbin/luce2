package luce2;

typedef WidgetConfig = {
	layer: Int,
	?name: String,
	?x: Float,
	?y: Float,
	?frame: Float,
	?xscl: Float,
	?yscl: Float,
	?xskw: Float,
	?yskw: Float,
	?rot: Float,
	?red: Float,
	?green: Float,
	?blue: Float,
	?alpha: Float,
	?xpiv: Float,
	?ypiv: Float,
	?visible: Bool,
	?hit: Array<Float>,
	?hitFromFrame: Int,
	?onPointer: Widget->Float->Float->Int->Bool,
	?frames: Array<Float>,
	?parent: Widget,
	?text: TextConfig,
}

typedef TextConfig = {
	?align: Int,
	?font: String,
	?string: String,
	?tracking: Float,
	?spaceWidth: Float,
	count: Int,
}

class Factory {
	public static var batch(default,null): Batch;
	
	public static function newWidget( config: WidgetConfig ) {
		var shift = batch.add( config.layer, 1 ); 
		var widget = new Widget( 
	}
	
	public static function newText( config: WidgetConfig );
	
	public static function init( atlases: Array<Atlas>, reserveLayers: Int ) {
		batch = new Batch( atlases, reserveLayers );
	}

	function new() {
	}	
}
