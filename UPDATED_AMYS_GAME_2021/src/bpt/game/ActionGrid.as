package bpt.game
{
	import flash.geom.Point;
	
	import bpt.game.GameSprite_Ref;
	import bpt.game._global;
	import bpt.game.onEnterFrame_Ref;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class ActionGrid extends GameSprite_Ref
	{
		protected var active_boundaries_indicator_mc:game_asset_based_visual;
		
		protected var selection_indicator_mc:game_asset_based_visual;
		//protected var drag_arrow_mc:game_asset_based_visual;
		//protected var drag_handle_mc:GameSprite_Ref;
		protected var drag_handle_mc:game_asset_based_visual;
		
		protected var _xy:Point;
		protected var _xmouse:Number;
		protected var _ymouse:Number;
		
		protected var _piece_size_cx:Number;
		protected var _piece_size_cy:Number;
		
		public function DisposeOfInternalClips():void
		{
			if ( null != selection_indicator_mc ) selection_indicator_mc.removeMovieClip();
			//if ( null != drag_arrow_mc ) drag_arrow_mc.removeMovieClip();
			if ( null != drag_handle_mc ) drag_handle_mc.removeMovieClip();
		}
		
		public function SetMousePositionFromGlobalCoordinates( x:Number, y:Number ):void
		{
			_xy.x = x;
			_xy.y = y;
			
			globalToLocal(_xy);
			
			_xmouse = _xy.x - _x;
			_ymouse = _xy.y - _y;
		}
		
		private function HandleVisibilityClosure():onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = new onEnterFrame_Ref();
			
			var targetAlpha:Number = 0;
			
			closure.code = function():void {
				
				//active_boundaries_indicator_mc._rotation += 0.01;
				active_boundaries_indicator_mc._x = _x;
				active_boundaries_indicator_mc._y = _y;
				active_boundaries_indicator_mc._visible = true; //closure.mc._visible;
				drag_handle_mc._visible = false;
				
				return;
				
//trace( "x:" + _x + ", y:" + _y );
				
				if ( !closure.mc._visible )
				{
					drag_handle_mc._visible = false;
					
					active_boundaries_indicator_mc._visible = drag_handle_mc._visible;
					
					if ( 0 != drag_handle_mc._alpha )
					{
						drag_handle_mc._alpha = 0;
						
						active_boundaries_indicator_mc._alpha = drag_handle_mc._alpha;
					}
					
					return;
				}
				
				if ( true ) // undefined != drag_handle_is_enabled )
				{
					drag_handle_mc._x = _xmouse;
					drag_handle_mc._y = _ymouse; 
					
					var bInsideSelector:Boolean =
						((((Math.abs(drag_handle_mc._x) < (_global.purgatory_piece_cx * 0.5))
					&&  (Math.abs(drag_handle_mc._y) < (_global.purgatory_piece_cy * 0.5)))));
					
					var bOutOfReach:Boolean = 
						(((Math.abs(drag_handle_mc._x) > (_global.purgatory_piece_cx * 1.5))
					||  (Math.abs(drag_handle_mc._y) > (_global.purgatory_piece_cy * 1.5))))
					||	bInsideSelector;
					
					//drag_handle_mc._visible = !bOutOfReach;
					drag_handle_mc._visible = true;
					
					if ( bOutOfReach )
					{
						selection_indicator_mc._alpha += (50 - selection_indicator_mc._alpha) * ((bInsideSelector) ? 0.25 : 0.125);
						targetAlpha = 0;
					}
					else
					{
						selection_indicator_mc._alpha += (100 - selection_indicator_mc._alpha) * 0.125;
						targetAlpha = 100;
					}
					
					if ( 0 != targetAlpha )
					{
						drag_handle_mc._alpha += (targetAlpha - drag_handle_mc._alpha) * 0.03125;
					}
					else
					{
						drag_handle_mc._alpha += (targetAlpha - drag_handle_mc._alpha) * 0.25;
					}
				}
				else
				{
					drag_handle_mc._visible = false;
				}
				
				//drag_handle_mc._rotation = Math.atan2( _x - drag_handle_mc._x, _y - drag_handle_mc._y ) * -180.0 / Math.PI;
				
				var tr:Number = ((0) + (Math.atan2( _x - drag_handle_mc._x, _y - drag_handle_mc._y ) * -180.0 / Math.PI)); // % 360.0;
				drag_handle_mc._rotation = (tr - drag_handle_mc._rotation) * 0.25; 
				
				active_boundaries_indicator_mc._alpha = drag_handle_mc._alpha;
				active_boundaries_indicator_mc._visible = drag_handle_mc._visible;
	
			}
			
			return closure;
		}
		
		public function ActionGrid( boundaries_indicator_mc:game_asset_based_visual ):void
		{
			super();
			
			_xy = new Point();
			
			_xmouse = 0;
			_ymouse = 0;
			
			active_boundaries_indicator_mc = boundaries_indicator_mc;
			
			selection_indicator_mc = game_asset_based_visual.Alloc( "selector_top" ); //"gfx_star" );
			selection_indicator_mc._name = "selection_indicator";
			addChild( selection_indicator_mc );
			
			drag_handle_mc = game_asset_based_visual.Alloc( "hint_arrow" );
			drag_handle_mc._xscale = 100;
			drag_handle_mc._yscale = 100;
			drag_handle_mc.rotation = 0;
			addChild( drag_handle_mc );
			
			/*
			drag_handle_mc = createEmptyMovieClip( "drag_handle", 3 );
			drag_handle_mc._alpha = 100;
			drag_arrow_mc = game_asset_based_visual.Alloc( "hint_arrow" );
			drag_arrow_mc._rotation = -180;
			drag_arrow_mc._y = drag_arrow_mc._height * 0.53;
			drag_handle_mc.addChild( drag_arrow_mc );
			*/
			
			onEnterFrame = HandleVisibilityClosure();
		}
	}
	
}
