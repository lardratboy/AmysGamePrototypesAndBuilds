package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import LargePanelBase;
	
	import assets;
	
	import bpt.game._global;
	import bpt.game.board_state;
	import bpt.game.game_state;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class PausePanel extends LargePanelBase
	{
		protected var resume_button_:ScaledAssetButton;
		
		protected var holder_:AlignedHolder;
		protected var streak_:DynamicTextHolder;
		protected var baseScore_:DynamicTextHolder;
		protected var time_:DynamicTextHolder;
		protected var moves_:DynamicTextHolder;
		protected var retries_:DynamicTextHolder;
		
		public function PausePanel():void
		{
			super();
		}
		
		protected override function Create():void
		{
			super.Create();
			
			super.CreateMainMenuButton();
			
			var banner:DisplayObject = assets.SpriteWrapper( "paused_panel_banner" );
			banner.x = background_panel_.x;
			banner.y = background_panel_.y - background_panel_.height/2 + banner.height;
			addChild( banner );
			
			resume_button_ = new ScaledAssetButton( "continue_button" );
			resume_button_.x = background_panel_.x; // + background_panel_.width / 2 - resume_button_.width * 1.0;
			resume_button_.y = background_panel_.y + background_panel_.height/2 - resume_button_.height * 1.0;
			resume_button_.addEventListener( MouseEvent.CLICK, OnResumeButton );
			addChild( resume_button_ );
			
			holder_ = new AlignedHolder();
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
		
		protected override function reinit(e:Event):void
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
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			resume_button_.Enable( b );
		}
		
		protected function OnResumeButton( e:MouseEvent ):void
		{
			Core.instance.GotoGame();
			
			Dismiss();
		}
	}
	
}