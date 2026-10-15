package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import bpt.game.gamemain;
	import bpt.retro.RetroImageGenerator;
	import bpt.util.Text2BitmapData;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class assets
	{
//		static public var PixelSnappingPolicy:String = PixelSnapping.AUTO;
		static public var PixelSnappingPolicy:String = PixelSnapping.ALWAYS;
		static public var BitmapSmoothingPolicy:Boolean = true;
		static public var reusableBitmapCacheMatrix_:Matrix = new Matrix();
		
		// --------------------------------------------------------------------
		
		static public var asset_runtime_scale_factor:Number = 1;
		
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/art/ui/loading_art.png")] 
		static public var loading_art_gfx_class:Class;
		
		static public function GetLoadingArtBitmap():Bitmap
		{
			return new loading_art_gfx_class();
		}
		
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/art/ui/gamebackground.jpg")] 
		static public var gamebackground_gfx_class:Class;

		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/art/starling_game_assets_128.png")]
		static private var starling_game_assets_128_class:Class;
		
		[Embed(source="../asset_sources/art/starling_game_assets_128.xml", mimeType="application/octet-stream")]
		static private var starling_game_assets_128_xml:Class;
		
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/art/animations.swf", symbol="throbbing_selector_anim")]
		static private var selection_indicator_class:Class;
	
		[Embed(source="../asset_sources/art/animations.swf", symbol="throbbing_arrow_anim")]
		static private var hint_arrow_shape_class:Class;
		
		[Embed(source="../asset_sources/art/animations.swf", symbol="check_box_anim")]
		static private var check_box_class:Class;

		[Embed(source="../asset_sources/art/animations.swf", symbol="check_mark_anim")]
		static private var check_mark_class:Class;
		
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/art/cute_star.png")]
		static private var cute_star_class:Class;
		//[Embed(source="../asset_sources/art/assets.swf", symbol="cute_star")]
		//static private var cute_star_class:Class;

		// --------------------------------------------------------------------

		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_1")]
		static private var vector_piece_1_class:Class;
		
		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_2")]
		static private var vector_piece_2_class:Class;

		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_3")]
		static private var vector_piece_3_class:Class;
		
		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_4")]
		static private var vector_piece_4_class:Class;
		
		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_5")]
		static private var vector_piece_5_class:Class;
		
		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_6")]
		static private var vector_piece_6_class:Class;
		
		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_7")]
		static private var vector_piece_7_class:Class;

		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_8")]
		static private var vector_piece_8_class:Class;
		
		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_9")]
		static private var vector_piece_9_class:Class;
		
		[Embed(source="../asset_sources/art/assets.swf", symbol="piece_10")]
		static private var vector_piece_10_class:Class;
		
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/art/original_pieces_64x64_0001.png")]
		static private var original_pieces_64x64_0001_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_64x64_0002.png")]
		static private var original_pieces_64x64_0002_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_64x64_0003.png")]
		static private var original_pieces_64x64_0003_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_64x64_0004.png")]
		static private var original_pieces_64x64_0004_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_64x64_0005.png")]
		static private var original_pieces_64x64_0005_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_64x64_0006.png")]
		static private var original_pieces_64x64_0006_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_64x64_0007.png")]
		static private var original_pieces_64x64_0007_class:Class;
		
		[Embed(source="../asset_sources/art/original_pieces_64x64_0008.png")]
		static private var original_pieces_64x64_0008_class:Class;
		
		[Embed(source="../asset_sources/art/original_pieces_64x64_0009.png")]
		static private var original_pieces_64x64_0009_class:Class;
		
		[Embed(source="../asset_sources/art/original_pieces_64x64_0010.png")]
		static private var original_pieces_64x64_0010_class:Class;
		
		// new pieces
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0000_piece_0011.png")]
		static private var original_pieces_64x64_0011_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0001_piece_0012.png")]
		static private var original_pieces_64x64_0012_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0002_piece_0013.png")]
		static private var original_pieces_64x64_0013_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0003_piece_0014.png")]
		static private var original_pieces_64x64_0014_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0004_piece_0015.png")]
		static private var original_pieces_64x64_0015_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0005_piece_0016.png")]
		static private var original_pieces_64x64_0016_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0006_piece_0017.png")]
		static private var original_pieces_64x64_0017_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0007_piece_0018.png")]
		static private var original_pieces_64x64_0018_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0008_piece_0019.png")]
		static private var original_pieces_64x64_0019_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0009_piece_0020.png")]
		static private var original_pieces_64x64_0020_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0010_piece_0021.png")]
		static private var original_pieces_64x64_0021_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0011_piece_0022.png")]
		static private var original_pieces_64x64_0022_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0012_piece_0023.png")]
		static private var original_pieces_64x64_0023_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0013_piece_0024.png")]
		static private var original_pieces_64x64_0024_class:Class;
		
		[Embed(source="../asset_sources/art/new_pieces_64/new_64__0014_piece_0025.png")]
		static private var original_pieces_64x64_0025_class:Class;
		
		// --------------------------------------------------------------------

		[Embed(source="../asset_sources/art/original_pieces_256x256_0001.png")]
		static private var original_pieces_256x256_0001_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_256x256_0002.png")]
		static private var original_pieces_256x256_0002_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_256x256_0003.png")]
		static private var original_pieces_256x256_0003_class:Class;

		//[Embed(source="../asset_sources/art/original_pieces_256x256_0004.png")]
		//static private var original_pieces_256x256_0004_class:Class;

		[Embed(source="../asset_sources/art/original_pieces_256x256_0005.png")]
		static private var original_pieces_256x256_0005_class:Class;

		//[Embed(source="../asset_sources/art/original_pieces_256x256_0006.png")]
		//static private var original_pieces_256x256_0006_class:Class;

		//[Embed(source="../asset_sources/art/original_pieces_256x256_0007.png")]
		//static private var original_pieces_256x256_0007_class:Class;
		
		// --------------------------------------------------------------------
	
/*		
		
		[Embed(source="../asset_sources/art/ui/achievements_button.png")]
		static private var achievements_button_class:Class;
		
		[Embed(source="../asset_sources/art/ui/exit_button.png")]
		static private var exit_button_class:Class;
		
		[Embed(source="../asset_sources/art/ui/how_to_play_button.png")]
		static private var how_to_play_button_class:Class;
		
		[Embed(source="../asset_sources/art/ui/play_button.png")]
		static private var play_button_class:Class;
		
		[Embed(source="../asset_sources/art/ui/story_button.png")]
		static private var story_button_class:Class;
		
*/

		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/art/ui/sound_on_icon.png")]
		static private var sound_on_icon_class:Class;

		[Embed(source="../asset_sources/art/ui/sound_off_icon.png")]
		static private var sound_off_icon_class:Class;
		
		[Embed(source="../asset_sources/art/ui/pause_icon.png")]
		static private var pause_icon_class:Class;
		
		//[Embed(source="../asset_sources/art/ui/item_node_base.png")]
		//static private var item_node_base_class:Class;
		
		[Embed(source="../asset_sources/art/ui/settings_icon.png")]
		static private var settings_icon_class:Class;
		
		[Embed(source="../asset_sources/art/ui/home_icon.png")]
		static private var home_icon_class:Class;
		
		[Embed(source="../asset_sources/art/ui/amys_game_logo.png")]
		static private var amys_game_logo_class:Class;
		
		[Embed(source="../asset_sources/art/ui/large_panel.png")]
		static private var large_panel_class:Class;

		[Embed(source="../asset_sources/art/ui/panel_button_hole_bg.png")]
		static private var panel_button_hole_bg_class:Class;

		// --------------------------------------------------------------------
		
		static private var bInitialized:Boolean = false;
		
		static private var cache_classes_:Object = new Dictionary();
		static private var cache_:Object = new Dictionary();
		static private var lookup_:Object = new Dictionary();
		
		static protected var cacheRuntimeScaleMatrix_:Matrix = null;
		
		// --------------------------------------------------------------------
		
		static protected function ScaleAssetAxis( x:int ):int
		{
			var xx:int = (int)(x * asset_runtime_scale_factor);
			
			if ( 0 != (xx & 1) ) xx += 1;
			
			return xx;
		}
		
		// --------------------------------------------------------------------
		
		static public function InstanceToAssetName( instance:DisplayObject ):String
		{
			return lookup_[ instance ] as String;
		}
		
		static public function AddToCache( name:String, rep:Class, defaultInstance:DisplayObject = null, bPreScale:Boolean = true ):void
		{
			cache_classes_[ name ] = rep;
			
			cache_[ name ] = (null != defaultInstance) ? defaultInstance : (new rep);
			
//trace( name + " = " + rep + " instance = " + cache_[ name ] );
			
			lookup_[ cache_[ name ] as DisplayObject ] = name;
			
			// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

			// this was an attempt to preload the gpu textures
			
			if ( bPreScale && (1 != asset_runtime_scale_factor) )
			{
				var o:Object = cache_[ name ];
				
				var b:Bitmap = (o as Bitmap);
				
				if ( null != b )
				{
					if ( null == cacheRuntimeScaleMatrix_ )
					{
						cacheRuntimeScaleMatrix_ = new Matrix( asset_runtime_scale_factor, 0, 0, asset_runtime_scale_factor, 0.5, 0.5 );
					}
					
//					trace( "\tprescaling" );
					
					var bmd:BitmapData;
					var old:BitmapData;
					
					if ( true )
					{
						bmd = new BitmapData( ScaleAssetAxis(b.width), ScaleAssetAxis(b.height), true, 0);
						bmd.drawWithQuality( b.bitmapData, cacheRuntimeScaleMatrix_, null, null, null, true, StageQuality.BEST );
						old = b.bitmapData;
						b.bitmapData = bmd;
						old.dispose();
					}
					else
					{
						var originalQuality:String = Core.instance.stage.quality;
						Core.instance.stage.quality = StageQuality.BEST;
						
						bmd = new BitmapData( ScaleAssetAxis(b.width), ScaleAssetAxis(b.height), true, 0); //0x001283DF ); // true, 0 );
						bmd.draw( b, cacheRuntimeScaleMatrix_, null, null, null, true );
						
						old = b.bitmapData;
						b.bitmapData = bmd;
						old.dispose();
	
						Core.instance.stage.quality = originalQuality;
					}
				}
			}
			
			// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			
		}
		
		static protected function RedirectContent( c:Class ):Class
		{
			return c;
		}
		
		// --------------------------------------------------------------------
		
		static protected function RetargetPieceGraphic( asset:String, srcClass:Class, target_w:int, target_h:int, src_w:int, src_h:int ):void
		{
			if ( true )
			{
				/* needs to really rasterize */
			}
			else
			{
				AddToCache( asset, RedirectContent( srcClass ) );
			}
		}
		
		static protected function GenerateGameplayPieces_FROM_VECTORS():void
		{
			var originalQuality:String = Core.instance.stage.quality;
			Core.instance.stage.quality = StageQuality.BEST;
			
			var src_w:int = 64;
			var src_h:int = 64;
			
			var target_w:int = src_w * asset_runtime_scale_factor;
			var target_h:int = src_h * asset_runtime_scale_factor;
			
			target_w += (target_w & 1);
			target_h += (target_h & 1);

			RetargetPieceGraphic( "original_pieces_1", RedirectContent( vector_piece_1_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_2", RedirectContent( vector_piece_2_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_3", RedirectContent( vector_piece_3_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_4", RedirectContent( vector_piece_4_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_5", RedirectContent( vector_piece_5_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_6", RedirectContent( vector_piece_6_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_7", RedirectContent( vector_piece_7_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_8", RedirectContent( vector_piece_8_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_9", RedirectContent( vector_piece_9_class ), target_w, target_h, src_w, src_h );
			RetargetPieceGraphic( "original_pieces_10", RedirectContent( vector_piece_10_class ), target_w, target_h, src_w, src_h );
			
			Core.instance.stage.quality = originalQuality;
		}
		
		static protected function GenerateGameplayPieces_FROM_BITMAPS():void
		{
			// This should use the graphics from the atlas!!!!!
			
			AddToCache( "original_pieces_1", RedirectContent( original_pieces_64x64_0001_class ) );
			AddToCache( "original_pieces_2", RedirectContent( original_pieces_64x64_0002_class ) );
			AddToCache( "original_pieces_3", RedirectContent( original_pieces_64x64_0003_class ) );
			AddToCache( "original_pieces_4", RedirectContent( original_pieces_64x64_0004_class ) );
			AddToCache( "original_pieces_5", RedirectContent( original_pieces_64x64_0005_class ) );
			AddToCache( "original_pieces_6", RedirectContent( original_pieces_64x64_0006_class ) );
			AddToCache( "original_pieces_7", RedirectContent( original_pieces_64x64_0007_class ) );
			AddToCache( "original_pieces_8", RedirectContent( original_pieces_64x64_0008_class ) );
			AddToCache( "original_pieces_9", RedirectContent( original_pieces_64x64_0009_class ) );
			AddToCache( "original_pieces_10", RedirectContent( original_pieces_64x64_0010_class ) );
			
			AddToCache( "original_pieces_11", RedirectContent( original_pieces_64x64_0011_class ) );
			AddToCache( "original_pieces_12", RedirectContent( original_pieces_64x64_0012_class ) );
			AddToCache( "original_pieces_13", RedirectContent( original_pieces_64x64_0013_class ) );
			AddToCache( "original_pieces_14", RedirectContent( original_pieces_64x64_0014_class ) );
			AddToCache( "original_pieces_15", RedirectContent( original_pieces_64x64_0015_class ) );
			AddToCache( "original_pieces_16", RedirectContent( original_pieces_64x64_0016_class ) );
			AddToCache( "original_pieces_17", RedirectContent( original_pieces_64x64_0017_class ) );
			AddToCache( "original_pieces_18", RedirectContent( original_pieces_64x64_0018_class ) );
			AddToCache( "original_pieces_19", RedirectContent( original_pieces_64x64_0019_class ) );
			AddToCache( "original_pieces_20", RedirectContent( original_pieces_64x64_0020_class ) );
			AddToCache( "original_pieces_21", RedirectContent( original_pieces_64x64_0021_class ) );
			AddToCache( "original_pieces_22", RedirectContent( original_pieces_64x64_0022_class ) );
			AddToCache( "original_pieces_23", RedirectContent( original_pieces_64x64_0023_class ) );
			AddToCache( "original_pieces_24", RedirectContent( original_pieces_64x64_0024_class ) );
			AddToCache( "original_pieces_25", RedirectContent( original_pieces_64x64_0025_class ) );
			
			
		}
		
		static protected function GenerateGameplayPieces():void
		{
			GenerateGameplayPieces_FROM_BITMAPS();
		}
		
		// --------------------------------------------------------------------
		
		static protected function GenerateLogoPieces():void
		{
			AddToCache( "big_original_pieces_1", RedirectContent( original_pieces_256x256_0001_class ) );
			AddToCache( "big_original_pieces_2", RedirectContent( original_pieces_256x256_0002_class ) );
			AddToCache( "big_original_pieces_3", RedirectContent( original_pieces_256x256_0003_class ) );
			AddToCache( "big_original_pieces_5", RedirectContent( original_pieces_256x256_0005_class ) );
			
			//AddToCache( "big_original_pieces_4", RedirectContent( original_pieces_256x256_0004_class ) );
			//AddToCache( "big_original_pieces_6", RedirectContent( original_pieces_256x256_0006_class ) );
			//AddToCache( "big_original_pieces_7", RedirectContent( original_pieces_256x256_0007_class ) );
		}
		
		// --------------------------------------------------------------------
		
		static public function Initialize():void
		{
			
//			if ( flash.system.Capabilities.isDebugger ) trace("assets.INIT ->");
			
			__Initialize__();
			
//			if ( flash.system.Capabilities.isDebugger ) trace("<- assets.INIT");
			
		}
		
		static public function __Initialize__():void
		{
			if ( bInitialized ) return;
			
			bInitialized = true;
			
			//AddToCache( "starling_game_assets_128", RedirectContent( starling_game_assets_128_class ) ); // BPT.2014
			
			AddToCache( "check_mark", RedirectContent( check_mark_class ) );
			AddToCache( "check_box", RedirectContent( check_box_class ) );
			AddToCache( "sound_on_icon", RedirectContent( sound_on_icon_class ) );
			AddToCache( "sound_off_icon", RedirectContent( sound_off_icon_class ) );
			AddToCache( "pause_icon", RedirectContent( pause_icon_class ) );
			AddToCache( "gfx_star", RedirectContent( cute_star_class ) );
			AddToCache( "selection_indicator", RedirectContent( selection_indicator_class ) );
			AddToCache( "throbbing_arrow", RedirectContent( hint_arrow_shape_class ) );
			
			AddToCache( "amys_game_logo", RedirectContent( amys_game_logo_class ) );
			AddToCache( "large_panel", RedirectContent( large_panel_class ) );
			AddToCache( "panel_button_hole_bg", RedirectContent( panel_button_hole_bg_class ) );
			AddToCache( "home_icon", RedirectContent( home_icon_class ) );
			AddToCache( "settings_icon", RedirectContent( settings_icon_class ) );
			
			//AddToCache( "item_node_base",RedirectContent( item_node_base_class ) );
			
			// generate dynamic elements
			
			GenerateGameplayPieces();
			
			GenerateLogoPieces();
			
			Generate();
		}
		
		// --------------------------------------------------------------------
		
		public static var how_to_play_lines:Array = [
			"Swap a shape with any of its eight",
			"neighboring locations empty or otherwise,",
			"to form groups of three or more.",
			"Horizontal vertical or diagonal groups are",
			"then removed and any shapes they were",
			"supporting move down to fill the spaces.",
			"Stars are collected by removing shapes from",
			"their locations, collect them all and you win!",
			"it's that easy."
		];	
		
		/*
		public static var how_to_play_lines:Array = [
			"Match 3 or more pieces to free all the stars,",
			"any of its surrounding locations as long as the",
			"move and match pieces in diagonal,",
			"horizontal or vertical groupings.",
			"Don't forget you CAN move",
			"\"outside the box\"..."
		];
		*/
		
		// --------------------------------------------------------------------
		
		static protected var default_text_format:TextFormat;
		
		static public function GetDefaultTextFormat():TextFormat
		{
			if ( null != default_text_format ) return default_text_format;
			
			default_text_format = new TextFormat();
			default_text_format.color = 0xFFFFFF;
			default_text_format.font = "HVD_Comic_Serif_Pro_font";
			default_text_format.size = (Number)(36 * asset_runtime_scale_factor);
			default_text_format.align = "center";
			
			var s:int = (int)(default_text_format.size);
			
			if ( s & 1 ) default_text_format.size = s - 1;
			
			return default_text_format;
		}
		
		static protected var default_text_bitmap_filter:DropShadowFilter = null;
		
		static public function GetDefaultTextBitmapFilter():BitmapFilter
		{
			if ( null == default_text_bitmap_filter )
			{
				default_text_bitmap_filter = new DropShadowFilter();
				
				default_text_bitmap_filter.strength = 0.75;
				default_text_bitmap_filter.distance *= asset_runtime_scale_factor;
				default_text_bitmap_filter.blurX *= asset_runtime_scale_factor;
				default_text_bitmap_filter.blurY *= asset_runtime_scale_factor;
				default_text_bitmap_filter.quality = BitmapFilterQuality.HIGH;
			}
			
			return default_text_bitmap_filter;
		}
		
		// --------------------------------------------------------------------
		
		static protected function GenerateTextAsAsset( id:String, text:String, tf:TextFormat, bf:BitmapFilter, preScalePolicy:Boolean ):void
		{
			AddToCache( id, Bitmap,
				new Bitmap( Text2BitmapData.CreateTextBitmapData(
					null, text, tf, bf ), assets.PixelSnappingPolicy, assets.BitmapSmoothingPolicy ), preScalePolicy );
		}
		
		static protected function Generate():void
		{
			var tf:TextFormat = GetDefaultTextFormat();
			var bf:BitmapFilter = GetDefaultTextBitmapFilter();
			
			var preScalePolicy:Boolean = false;
			
			GenerateTextAsAsset( "settings_panel_banner", "Customize", tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "statistics_button", "Statistics", tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "exit_button", "Exit", tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "how_to_play_button", "How to play", tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "play_button", "Play game", tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "story_button", "Back-story", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "asset_info_panel_banner", "Additional Art", tf, bf, preScalePolicy );
			
			// ----------------------------------------------------------------
			
			// larger than default text...
			
			var originalSize:Number = (Number)(tf.size);
			
			tf.size = originalSize * 2.0;
			
			//GenerateTextAsAsset( "new_board_button", "Try new board" /*"Play"*/, tf, bf, preScalePolicy );
			GenerateTextAsAsset( "replay_board_button", "Try again?" /*"Replay"*/, tf, bf, preScalePolicy );
			
			tf.size = originalSize * 2;
			
			GenerateTextAsAsset( "no_moves", "No Moves", tf, bf, preScalePolicy );
			GenerateTextAsAsset( "bonus_mode", "DOUBLE POINTS!", tf, bf, preScalePolicy );
			GenerateTextAsAsset( "board_over", "Board Over", tf, bf, preScalePolicy );
			GenerateTextAsAsset( "super_jackpot", "SUPER JACKPOT!", tf, bf, preScalePolicy );
			
			tf.size = originalSize;
			
			// ----------------------------------------------------------------
			
			//GenerateTextAsAsset( "replay_board_button", "Retry same board" /*"Replay"*/, tf, bf, preScalePolicy );
			GenerateTextAsAsset( "new_board_button", "Give up and play a new board?" /*"Play"*/, tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "paused_panel_banner", "Game Paused", tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "continue_button", "Continue Playing", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "between_levels_panel_banner", "Ready to Play?", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "no_moves_banner", "No more moves, retry board?", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "round_clear_banner", "Congrats all stars collected!", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "confirm_clear_statistics_panel_banner", "Confirm Reset Statistics?", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "yes_button", "Yes", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "no_button", "No", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "reset_button", "Press here to reset statistics...", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "done", "Done", tf, bf, preScalePolicy );
					
			// ----------------------------------------------------------------
			
			GenerateTextAsAsset( "big_board_option", "Biggest Board", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "initial_matches_option", "Initial matches", tf, bf, preScalePolicy );
					
			GenerateTextAsAsset( "tougher_stars_option", "Tougher stars", tf, bf, preScalePolicy );
			
			GenerateTextAsAsset( "disable_hints_option", "Disable hints", tf, bf, preScalePolicy );
			
			// ----------------------------------------------------------------
			
			for ( var line:int = 0; line < how_to_play_lines.length; ++line )
			{
				GenerateTextAsAsset( "how_to_play_line_" + (line + 1), how_to_play_lines[line], tf, bf, preScalePolicy );
			}
					
			// ----------------------------------------------------------------
			
			/*
			
			AddToCache( "achievements_button", achievements_button_class );
			AddToCache( "exit_button", exit_button_class );
			AddToCache( "how_to_play_button", how_to_play_button_class );
			AddToCache( "play_button", play_button_class );
			AddToCache( "story_button", story_button_class );
			
			*/
			
			gamemain.RegisterCommonPopupTextMessages();
			
		}
		
		// --------------------------------------------------------------------
		
		static public function GetStaticTextID( text:String, color:uint ):String
		{
			return "STATIC_(" + text + ")." + color.toString(16);
		}
		
		static public function GenerateStaticTextBitmap( text:String, color:uint = 0xFFFFFF ):DisplayObject // Bitmap
		{
			var asset_key:String = GetStaticTextID( text, color );
			
			if ( null == cache_[ asset_key ] )
			{
				AddToCache( asset_key, Bitmap, GenerateDynamicTextBitmap( text, color ), false );
			}
			
			return GetDisplayObject( asset_key );
		}
		
		static public function GenerateDynamicTextBitmapData(text:String, color:uint = 0xFFFFFF ):BitmapData
		{
			return Text2BitmapData.CreateTextBitmapData(
				null, text, GetDefaultTextFormat(), GetDefaultTextBitmapFilter(), color );
		}
		
		static public function GenerateDynamicTextBitmap( text:String, color:uint = 0xFFFFFF ):Bitmap
		{
			var bm:Bitmap = new Bitmap( GenerateDynamicTextBitmapData(text,color), assets.PixelSnappingPolicy, assets.BitmapSmoothingPolicy );
			//var bm:Bitmap = RetroImageGenerator.MakeRandomBitmap( (int)(10 * asset_runtime_scale_factor + 0.5), 1 );
				
			PrepareDisplayObjectForUse( bm );
			
			return bm;
		}
		
		static public function ChangeDyanmicTextBitmap( bitmap:Bitmap, text:String, color:uint = 0xFFFFFF ):void
		{
			bitmap.bitmapData = Text2BitmapData.CreateTextBitmapData(
				bitmap.bitmapData, text, GetDefaultTextFormat(), GetDefaultTextBitmapFilter(), color );
//			bitmap.bitmapData = RetroImageGenerator.MakeRandomBitmap( (int)(10 * asset_runtime_scale_factor + 0.5), 1 ).bitmapData;
		}
		
		// --------------------------------------------------------------------
		
		static public function GetBitmapData( asset:String ):BitmapData
		{
			if ( !bInitialized ) Initialize();
			
			var co:Object = cache_[ asset ];
			
			var check_bmd:BitmapData = co as BitmapData;
			
			if ( null != check_bmd )
			{
				return check_bmd;
			}
			
			var bm:Bitmap = cache_[asset] as Bitmap;
			
			if ( null == bm )
			{
				trace( "missing art asset \"" + asset + "\" generating fake bitmap" );
				
				AddToCache( asset, Bitmap, RetroImageGenerator.MakeRandomBitmap( (int)(10 * asset_runtime_scale_factor + 0.5), 1 ), false );
				
				bm = (Bitmap)(cache_[asset]);
			}
			
			return bm.bitmapData;
		}
				
		static protected function PrepareDisplayObjectForUse( obj:DisplayObject ):void
		{
			//obj.cacheAsBitmap = true;
			//obj.cacheAsBitmapMatrix = reusableBitmapCacheMatrix_; 
			
			/*
			if ( 1 != asset_runtime_scale_factor )
			{
				obj.scaleX = asset_runtime_scale_factor;
				obj.scaleY = asset_runtime_scale_factor;
			}
			*/
		}
		
		static public function GetDisplayObject( asset:String ):DisplayObject
		{
			if ( null == cache_[asset] )
			{
				GetBitmapData( asset );
			}

			var displayObject:DisplayObject = cache_[asset];
			
			// --------------------------------------------------------------------------
			
			if ( (null != (displayObject as MovieClip)) ||
				(null != (displayObject as Shape)) ||
				(null != (displayObject as Sprite))
			)
			{
				if ( true )
				{
					var dispObj:DisplayObject = new cache_classes_[ asset ];
					PrepareDisplayObjectForUse( dispObj );
					
					dispObj.scaleX = asset_runtime_scale_factor;
					dispObj.scaleY = asset_runtime_scale_factor;
					
					return dispObj;
				}
				else
				{
					return GetDisplayObject( "_UGH_" );
				}
			}
			
			// --------------------------------------------------------------------------
			
			var b:Bitmap = new Bitmap( GetBitmapData( asset ), assets.PixelSnappingPolicy, assets.BitmapSmoothingPolicy );
			
			PrepareDisplayObjectForUse( b );
			
			b.x = (int)(b.width / -2);
			b.y = (int)(b.height / -2);
			
			return b;
		}
		
		static public function SpriteWrapper( asset:String ):Sprite
		{
			var s:Sprite = new Sprite;
			
			s.addChild( GetDisplayObject( asset ) );
			
			return s;
		}
		
		static public function GetRawCacheDisplayObject( asset:String ):DisplayObject
		{
			if ( null == cache_[asset] )
			{
				GetBitmapData( asset );
			}

			return cache_[asset] as DisplayObject;
		}
		
		static public function GetWidth( asset:String ):int
		{
			return GetRawCacheDisplayObject( asset ).width; // * asset_runtime_scale_factor;
		}
		
		static public function GetHeight( asset:String ):int
		{
			return GetRawCacheDisplayObject( asset ).height; // * asset_runtime_scale_factor;
		}
		
		// --------------------------------------------------------------------
		
		/* NOTE this should probably be a class */
		
		static private var resuable_sources_:Object = new Dictionary();
		
		static protected function ReusableAssetsStack( asset:String ):Array
		{
			var ra:Array = resuable_sources_[ asset ];
			
			if ( null == ra )
			{
				ra = new Array();
				
				resuable_sources_[ asset ] = ra;
			}
			
			return ra;
		}
		
		static public function GetReusableTextObject( text:String, color:uint = 0xFFFFFFFF ):DisplayObject
		{
			var ra:Array = ReusableAssetsStack( GetStaticTextID( text, color ) );
			
			if ( 0 != ra.length )
			{
				return ra.pop();
			}
			
			return GenerateStaticTextBitmap( text, color );
		}
		
		static public function GetReusableDisplayObject( asset:String ):DisplayObject
		{
			var ra:Array = ReusableAssetsStack( asset );
			
			if ( 0 != ra.length )
			{
				return ra.pop();
			}
			
			return assets.GetDisplayObject( asset );
		}
		
		static public function ReleaseReusableDisplayObject( asset:String, displayObject:DisplayObject ):void
		{
			var ra:Array = ReusableAssetsStack( asset );
			
			ra.push( displayObject );
		}
		
		// --------------------------------------------------------------------
		
		/* NOTE this should probably be a class */
		
		static private var starling_resuable_sources_:Object = new Dictionary();
		
		static protected function starling_ReusableAssetsStack( asset:String ):Array
		{
			var ra:Array = starling_resuable_sources_[ asset ];
			
			if ( null == ra )
			{
				ra = new Array();
				
				starling_resuable_sources_[ asset ] = ra;
			}
			
			return ra;
		}

		static public function starling_GetReusableTextObject( text:String, color:uint = 0xFFFFFFFF ):starling.display.DisplayObject
		{
			var asset_key:String = GetStaticTextID( text, color );
			
			if ( null == cache_[ asset_key ] )
			{
				AddToCache( asset_key, Bitmap, GenerateDynamicTextBitmap( text, color ), false );
			}
			
			return starling_GetReusableDisplayObject( asset_key );
		}
		
		static public function starling_GetReusableDisplayObject( asset:String ):starling.display.DisplayObject
		{
			var ra:Array = starling_ReusableAssetsStack( asset );
			
			if ( 0 != ra.length )
			{
				return ra.pop();
			}
			
			var img:Image = new Image( Texture.fromBitmapData( assets.GetBitmapData( asset ) ) );
			
			img.touchable = false;
			
			img.alignPivot();
			
			return img;
		}
		
		static public function starling_ReleaseReusableDisplayObject( asset:String, displayObject:starling.display.DisplayObject ):void
		{
			var ra:Array = starling_ReusableAssetsStack( asset );
			
			ra.push( displayObject );
		}
		
		// --------------------------------------------------------------------
		
		static private var starling_assets_manager:AssetManager = new AssetManager(1,true);
		
		static private var starling_resuable_texture_:Object = new Dictionary();
		
		static public function starling_GetTextureForAsset( asset:String ):Texture
		{
			var tex:Texture = starling_resuable_texture_[ asset ];
			
			if ( null == tex )
			{
				tex = starling_assets_manager.getTexture( asset );
				
				if ( null == tex )
				{
					tex = Texture.fromBitmapData( assets.GetBitmapData( asset + "_missing" ) );
				}
				else
				{
					//trace( "\'" + asset + "\' using atlas element!!!!" );
				}
					
				starling_resuable_texture_[ asset ] = tex;
			}
			
			return tex;
		}
		
		// ----------------------------------------------------------------------
		
		// probably could do some sort of aspect ratio compensation here
		
		static private const starling_asset_scale_table:Object = { "meta_star" : 0.33 }; 
		
		static public function starling_GetAssetScaleXCoefficient( asset:String ):Number
		{
			if ( undefined != starling_asset_scale_table[ asset ] ) return starling_asset_scale_table[ asset ] * asset_runtime_scale_factor;
			
			return 0.5 * asset_runtime_scale_factor;
		}
		
		static public function starling_GetAssetScaleYCoefficient( asset:String ):Number
		{
			return starling_GetAssetScaleXCoefficient( asset );
		}
		
		// ----------------------------------------------------------------------
		
		static public function starling_PrepareAssetManager():void
		{
			var atlas_xml:XML = new XML( new starling_game_assets_128_xml );
			
			//var atlas:TextureAtlas = new TextureAtlas( starling_GetTextureForAsset("starling_game_assets_128" ), atlas_xml );
			
			var atlas:TextureAtlas = new TextureAtlas( Texture.fromBitmap( new starling_game_assets_128_class() ), atlas_xml );
			
			starling_assets_manager.addTextureAtlas( "starling_game_assets_128", atlas );
			
			// should have alternate versions for smaller res?
			
			starling_assets_manager.addTexture( "gamebackground", Texture.fromBitmap( new gamebackground_gfx_class() ) );
			
		}
		
	}
}
