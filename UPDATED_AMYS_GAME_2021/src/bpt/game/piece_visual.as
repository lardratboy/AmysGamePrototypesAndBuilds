package bpt.game
{
	import bpt.game.IActSomethingtLikeAMovieClipFromAS2;
	import starling.display.DisplayObjectContainer;
	import starling.display.DisplayObject;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import bpt.util.Allocator;
	import flash.system.Capabilities;
	import assets;
	
	/**
	 * ...
	 * @author BPT
	 */
	public final class piece_visual extends Image implements IActSomethingtLikeAMovieClipFromAS2
	{
		protected var id_:int;
		protected var starling_asset_x_base_scale_coefficient:Number;
		protected var starling_asset_y_base_scale_coefficient:Number;
		
		public function piece_visual( id:int )
		{
			var asset:String = GenerateAssetName( id );
			super( assets.starling_GetTextureForAsset( asset ) );
			touchable = false;
			alignPivot();
			id_ = id;
			starling_asset_x_base_scale_coefficient = assets.starling_GetAssetScaleXCoefficient( asset );
			starling_asset_y_base_scale_coefficient = assets.starling_GetAssetScaleYCoefficient( asset );
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
			
			Release( this );
			
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
		
		static private function GenerateAssetName( id:int ):String
		{
			return "original_pieces_" + id;
		}
		
		static protected function GetCacheForType( id:int ):Vector.<piece_visual>
		{
			var cache:Vector.<piece_visual> = cache_[ id ];
			
			if ( null == cache )
			{
				cache = new Vector.<piece_visual>();
				
				cache_[ id ] = cache;
			}
			
			return cache;
		}
		
		static public function Alloc( id:int ):piece_visual
		{
			var cache_for_id:Vector.<piece_visual> = GetCacheForType(id);
			
			if ( 0 < cache_for_id.length )
			{
				
	//trace("using type " + id + " from cache" );
				
				return cache_for_id.pop();
			}
			
	//trace("creating new type " + id );
			
			var piece:piece_visual = new piece_visual( id );
			
			return piece;
		}
		
		static public function Release( piece:piece_visual ):void
		{
			var cache:Vector.<piece_visual> = GetCacheForType( piece.id_ );
			
			piece.Reset();
			
	//trace("adding type " + piece.id_ + " to cache" );
			
			cache.push( piece );
		}
		
		// ====================================================================
		include "FakeAS2MovieClip.as.impl"
		// ====================================================================
	}
}
