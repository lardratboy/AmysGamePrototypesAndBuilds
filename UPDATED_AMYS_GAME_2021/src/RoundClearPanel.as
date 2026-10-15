package 
{
	import assets;
	import bpt.game._global;
	import bpt.game.board_state;
	import bpt.game.game_state;
	import flash.display.Sprite;
	import BetweenLevelPanel
	import flash.events.Event;
	import AlignedHolder;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class RoundClearPanel extends BetweenLevelPanel
	{
		protected var holder_:AlignedHolder;
		
		protected var streak_:DynamicTextHolder;
		protected var baseScore_:DynamicTextHolder;
		protected var time_:DynamicTextHolder;
		protected var moves_:DynamicTextHolder;
		protected var retries_:DynamicTextHolder;
		
		public function RoundClearPanel():void
		{
			super();
		}
		
		public override function AllowContinueButton():Boolean
		{
			return false;
		}
		
		static private var banner_asset_name_:String = "round_clear_banner";
		
		protected override function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected override function Create():void
		{
			holder_ = new AlignedHolder();
			
			super.Create();
			
			background_panel_.addChild( holder_ );
			
		}
		
		protected function UpdateTextNode( item:DynamicTextHolder, text:String ):DynamicTextHolder
		{
			if ( null == item )
			{
				item = new DynamicTextHolder();
				
				holder_.addChild( item );
			}
			
			// trace( text );
			
			item.SetText( text );
			
			return item;
		}
		
		protected override function reinit( e:Event ):void
		{
			super.reinit( e );
			
			streak_ = UpdateTextNode( streak_, "Wins in a row " + game_state.current_streak );
			streak_.visible = (1 < game_state.current_streak);
			time_ = UpdateTextNode( time_, "Time " + Math.floor( game_state.last_board_seconds + 0.5 ) + " seconds" );
			moves_ = UpdateTextNode( moves_, "Moves " + game_state.last_board_moves );
			retries_ = UpdateTextNode( retries_, "Retries " + game_state.last_board_retries );
			retries_.visible = (0 != game_state.last_board_retries);
			baseScore_ = UpdateTextNode( baseScore_, "Score " + board_state.score );
			
			holder_.Align( 10 * assets.asset_runtime_scale_factor, true );

		}
	}
	
}

// ----------------------------------------------------------------------------

/*

import flash.display.Sprite;
import flash.display.DisplayObject;

internal class AlignedHolder extends Sprite
{
	public function Align( gap:int, bVertical:Boolean ):void
	{
		var xPos:int = 0;
		var xGap:int = bVertical ? 0 : gap;
		
		var yPos:int = 0;
		var yGap:int =  bVertical ? gap : 0;
		
		for ( var i:int = 0; i < numChildren; ++i )
		{
			var dobj:DisplayObject = getChildAt( i );
			
			dobj.x = xPos;
			dobj.y = yPos;
			
			if ( dobj.visible )
			{
				if ( bVertical )
				{
					yPos += (dobj.height + yGap);
				}
				else
				{
					xPos += (dobj.width + xGap);
				}
			}
		}
		
		if ( bVertical )
		{
			y = height / -2;
		}
		else
		{
			x = width / -2;
		}
	}
}

*/

