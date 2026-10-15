package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ContextBase;
	
	import assets;
	
	import bpt.Helpers;
	import bpt.game._global;
	import bpt.game.game_state;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class QuickNoMovesContext extends ContextBase
	{
		protected var new_board_button_:ScaledAssetButton;
		protected var replay_board_button_:ScaledAssetButton;
		protected var retry_info_1_:DynamicTextHolder;
		protected var retry_info_2_:DynamicTextHolder;
		protected var retry_alignment_group_:AlignedHolder;
		
		public function QuickNoMovesContext():void
		{
			super();
		}
		
		protected override function Create():void
		{
			super.Create();
			
			var border:int = 5;
			
			if ( true ) { // BPT.2014 encourage retry
				
				retry_alignment_group_ = new AlignedHolder();
				
					replay_board_button_ = new ScaledAssetButton( "replay_board_button" );
					replay_board_button_.x = 0; //Main.canvas_x_center; // background_panel_.x;
					replay_board_button_.y = 0; //Main.canvas_y_center; // background_panel_.y;
					replay_board_button_.addEventListener( MouseEvent.CLICK, OnReplayBoardButton );
					retry_alignment_group_.addChild( replay_board_button_ );
					
					retry_info_1_ = new DynamicTextHolder();
					retry_info_1_.SetText("retry line 1.");
					retry_info_1_.x = 0; //Main.canvas_x_center;
					retry_info_1_.y = 0; //replay_board_button_.y + replay_board_button_.height;
					retry_alignment_group_.addChild( retry_info_1_ );
					
					retry_info_2_ = new DynamicTextHolder();
					retry_info_2_.SetText("retry line 2.");
					retry_info_2_.x = 0; //Main.canvas_x_center;
					retry_info_2_.y = 0; //replay_board_button_.y + replay_board_button_.height;
					retry_alignment_group_.addChild( retry_info_2_ );
				
					retry_alignment_group_.Align( 10 * assets.asset_runtime_scale_factor, true );
					
				addChild( retry_alignment_group_ );
				
				new_board_button_ = new ScaledAssetButton( "new_board_button" );
				new_board_button_.x = border + new_board_button_.width * 0.5;
				new_board_button_.y = Core.canvas_height - new_board_button_.height * 0.5 - border;
				new_board_button_.addEventListener( MouseEvent.CLICK, OnNewBoardButton );
				addChild( new_board_button_ );
				
			} else {
			
				new_board_button_ = new ScaledAssetButton( "new_board_button" );
				new_board_button_.x = Core.canvas_x_center; // background_panel_.x;
				new_board_button_.y = Core.canvas_y_center; // background_panel_.y;
				new_board_button_.addEventListener( MouseEvent.CLICK, OnNewBoardButton );
				addChild( new_board_button_ );
				
				replay_board_button_ = new ScaledAssetButton( "replay_board_button" );
				replay_board_button_.x = border + replay_board_button_.width * 0.5;
				replay_board_button_.y = Core.canvas_height - replay_board_button_.height * 0.5 - border;
				replay_board_button_.addEventListener( MouseEvent.CLICK, OnReplayBoardButton );
				addChild( replay_board_button_ );
				
			}
			
			replay_board_button_.Enable( false );
		}
		
		protected override function reinit(e:Event):void
		{
			var suffix:String = ", " + game_state.last_board_remaining_stars.toString() + " remaining stars.";
			
			if ( 0 == game_state.last_board_retries ) {
				
				retry_info_1_.SetText( "No retries yet" + suffix );
				
			} else if ( 1 == game_state.last_board_retries ) {
				
				retry_info_1_.SetText( "1 retry so far" + suffix );
				
			} else {
			
				retry_info_1_.SetText( game_state.last_board_retries.toString() + " retries so far" + suffix );
				
			}
			
			retry_info_2_.SetText( "(fewest stars remaining " + game_state.last_board_fewest_remaining_stars + ")." );
			
			if ( null != retry_alignment_group_ )
			{
				retry_alignment_group_.Align( 10 * assets.asset_runtime_scale_factor, true );
				retry_alignment_group_.x = Core.canvas_x_center;
				retry_alignment_group_.y = Core.canvas_y_center - retry_alignment_group_.height/3;
			}
			
			super.reinit( e );
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			if ( null != replay_board_button_ )
			{
				replay_board_button_.Enable( b && _global.DoesLastBoardExist() ); // need to make sure there is a board to play...
			}
			
			new_board_button_.Enable( b );
		}
		
		protected function OnNewBoardButton( e:MouseEvent ):void
		{
			Dismiss();
			
			Core.instance.NewGameBoard();
		}
		
		protected function OnReplayBoardButton( e:MouseEvent ):void
		{
			Core.instance.GotoGame();
			
			_global.purgatory_use_last_board_layout = true;
			
			Core.instance.game_.ShutdownDynamicElements();
			
			Core.instance.game_.BOOTSTRAP_GAME_SESSION();
			
			Dismiss();
		}
		
		override public function Dismiss():void 
		{
			game_state.save();
			
			super.Dismiss();
		}
	}
	
}