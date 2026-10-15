package
{
	import flash.text.Font;
	import flash.utils.Dictionary;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class font_assets
	{
		// --------------------------------------------------------------------
		
		// see http://www.spikything.com/blog/index.php/2009/09/06/how-to-embed-fonts-in-pure-as3/
		// 
		
		[Embed(
			source = "../asset_sources/fonts/HVD_Comic_Serif_Pro.otf"
		,	fontName = 'HVD_Comic_Serif_Pro_font'
		,	mimeType = "application/x-font"
		,	unicodeRange = 'U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E'
			)]
		static public var HVD_Comic_Serif_Pro_font_class:Class;
	
		// --------------------------------------------------------------------
		
		static private var bInitialized:Boolean = false;
		
		static private var cache_:Object = new Dictionary();
		
		static private function AddToCache( name:String, font:Font ):void
		{
			cache_[ name ] = font;
		}
		
		static public function reference_to_ensure_available():void
		{
		}
		
		static public function Initialize():void
		{
			
//			if ( flash.system.Capabilities.isDebugger ) trace("font_assets.INIT ->");

			__Initialize__();

//			if ( flash.system.Capabilities.isDebugger ) trace("<- font_assets.INIT");

		}
		
		static public function __Initialize__():void
		{
			if ( bInitialized ) return;
			
			bInitialized = true;
			
			AddToCache( "HVD_Comic_Serif_Pro_font", new HVD_Comic_Serif_Pro_font_class() );
		}
		
		static public function GetFont( asset:String ):Font
		{
			if ( !bInitialized ) Initialize();
			
			var font:Font = cache_[asset];
			
			if ( null == font)
			{
				trace( "missing font asset \"" + asset + "\" generating fake ?" );
				
				AddToCache( asset, undefined );
				
				font = cache_[asset];
			}
			
			return font;
		}
		
	}
}
