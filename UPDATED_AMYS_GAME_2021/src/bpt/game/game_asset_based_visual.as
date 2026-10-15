package bpt.game
{
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import assets;
	
	import bpt.game.IActSomethingtLikeAMovieClipFromAS2;
	import bpt.util.Allocator;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author BPT
	 */
	public final class game_asset_based_visual extends Image implements IActSomethingtLikeAMovieClipFromAS2
	{
		protected var asset_:String;
		protected var starling_asset_x_base_scale_coefficient:Number;
		protected var starling_asset_y_base_scale_coefficient:Number;
		
		public function game_asset_based_visual( asset:String )
		{
			super( assets.starling_GetTextureForAsset( asset ) );
			touchable = false;
			alignPivot();
			asset_ = asset;
			starling_asset_x_base_scale_coefficient = assets.starling_GetAssetScaleXCoefficient( asset );
			starling_asset_y_base_scale_coefficient = assets.starling_GetAssetScaleXCoefficient( asset );
			Reset();
		}
		
		public function Reset():void
		{
			onEnterFrame = null;
			_name = "";
			_x = 0;
			_y = 0;
			_alpha = 100;
			_xscale = 100;
			_yscale = 100;
			_rotation = 0;
			_visible = true;
		}
		
		public function removeMovieClip():void
		{
			
	//trace( _name + ".removeMovieClip()" );			
			
			Release();
			
			if ( parent ) parent.removeChild( this );
		}
		
		public function getNextHighestDepth():int
		{
			return 1;
		}
		
		// --------------------------------------------------------------------
		
		protected function finalize_X_scale( value:Number ):Number
		{
			return value * starling_asset_x_base_scale_coefficient;
		}
		
		protected function finalize_Y_scale( value:Number ):Number
		{
			return value * starling_asset_y_base_scale_coefficient;
		}
		
		// --------------------------------------------------------------------
		
		static protected var cache_:Dictionary = new Dictionary();
		
		static protected function GetCacheForAsset( asset:String ):Vector.<game_asset_based_visual>
		{
			var cache:Vector.<game_asset_based_visual> = cache_[ asset ];
			
			if ( null == cache )
			{
				cache = new Vector.<game_asset_based_visual>();
				
				cache_[ asset ] = cache;
			}
			
			return cache;
		}
		
		static public function Alloc( asset:String ):game_asset_based_visual
		{
			var cache_for_asset:Vector.<game_asset_based_visual> = GetCacheForAsset(asset);
			
			if ( 0 < cache_for_asset.length )
			{
				
	//trace("using type " + asset + " from cache" );
				
				return cache_for_asset.pop();
			}
			
	//trace("creating new type " + asset );
			
			var visual:game_asset_based_visual = new game_asset_based_visual( asset );
			
			return visual;
		}
		
		public function Release():void
		{
			var cache_for_asset:Vector.<game_asset_based_visual> = GetCacheForAsset( asset_ );
			
			Reset();
			
	//trace("adding type " + asset_ + " to cache" );
			
			cache_for_asset.push( this );
		}
		
		// ====================================================================
		include "FakeAS2MovieClip.as.impl"
		// ====================================================================
	}
}