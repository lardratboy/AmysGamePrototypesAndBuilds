package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import LargePanelBase;
	
	import assets;
	
	import bpt.Helpers;
	import bpt.game._global;
	import bpt.game.game_state;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class BetweenLevelPanel extends LargePanelBase
	{
		protected var new_board_button_:ScaledAssetButton;
		protected var replay_board_button_:ScaledAssetButton;
		protected var continue_button_:ScaledAssetButton;
//		protected var last_context:String;
		protected var settings_button_bg_:Sprite;
		protected var settings_button_:ScaledAssetButton;
		
		public function BetweenLevelPanel():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "between_levels_panel_banner";
		
		protected function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		public function AllowContinueButton():Boolean
		{
			return true;
		}
		
		protected function CreateSettingsButton():void
		{
			settings_button_bg_ = assets.SpriteWrapper( "panel_button_hole_bg" );
			settings_button_bg_.x = background_panel_.x + background_panel_.width/2 - settings_button_bg_.width * 0.75;
			settings_button_bg_.y = background_panel_.y - background_panel_.height/2 + settings_button_bg_.height * 0.75;
			addChild( settings_button_bg_ );

			settings_button_ = new ScaledAssetButton( "settings_icon" );
			settings_button_.x = settings_button_bg_.x;
			settings_button_.y = settings_button_bg_.y;
			settings_button_.addEventListener( MouseEvent.CLICK, OnSettingsButton );
			addChild( settings_button_ );
		}
		
		protected function OnSettingsButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			Core.instance.GotoSettings( this );
			
			Dismiss();
		}
		
		protected override function Create():void
		{
			super.Create();
			
			super.CreateMainMenuButton();
			
			CreateSettingsButton();
			
			var banner:DisplayObject = assets.SpriteWrapper( GetBannerAssetName() );
			banner.x = background_panel_.x;
			banner.y = background_panel_.y - background_panel_.height/2 + banner.height;
			addChild( banner );
			
			if ( true ) 
			{
				new_board_button_ = new ScaledAssetButton( "play_button" );
				new_board_button_.x = background_panel_.x;
				new_board_button_.y = background_panel_.y + background_panel_.height/2 - new_board_button_.height * 1.0;
				new_board_button_.addEventListener( MouseEvent.CLICK, OnNewBoardButton );
				addChild( new_board_button_ );
			}
			else
			{
				new_board_button_ = new ScaledAssetButton( "new_board_button" );
				new_board_button_.x = background_panel_.x + background_panel_.width/2 - new_board_button_.width * 1.0;
				new_board_button_.y = background_panel_.y + background_panel_.height/2 - new_board_button_.height * 1.0;
				new_board_button_.addEventListener( MouseEvent.CLICK, OnNewBoardButton );
				addChild( new_board_button_ );
				
				replay_board_button_ = new ScaledAssetButton( "replay_board_button" );
				replay_board_button_.x = background_panel_.x - background_panel_.width/2 + replay_board_button_.width * 1.0;
				replay_board_button_.y = background_panel_.y + background_panel_.height/2 - replay_board_button_.height * 1.0;
				replay_board_button_.addEventListener( MouseEvent.CLICK, OnReplayBoardButton );
				addChild( replay_board_button_ );
				replay_board_button_.Enable( false );
			}
			
			continue_button_ = new ScaledAssetButton( "continue_button" );
			continue_button_.x = background_panel_.x;
			continue_button_.y = background_panel_.y;
			continue_button_.addEventListener( MouseEvent.CLICK, OnContinueButton );
		}
		
		protected override function reinit(e:Event):void
		{
			super.reinit( e );
			
			if ( AllowContinueButton() && Core.instance.game_.game_in_progress )
			{
				if ( null == continue_button_.parent )
				{
					addChild( continue_button_ );
				}
			}
			else
			{
				if ( null != continue_button_.parent )
				{
					removeChild( continue_button_ );
				}
			}
			
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			if ( null != replay_board_button_ )
			{
				replay_board_button_.Enable( b && _global.DoesLastBoardExist() ); // need to make sure there is a board to play...
			}
			
			new_board_button_.Enable( b );
			
			main_menu_button_.Enable( b );
			
			continue_button_.Enable( b );
			
			settings_button_.Enable( b );
		}
		
		protected function OnContinueButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			if ( Core.instance.game_.game_in_progress )
			{
				Core.instance.GotoGame();
				Dismiss();
			}
			else
			{
				OnReplayBoardButton( e );
			}
		}
		
		/*
		protected function OldPrepareForNewBoard_SCRAPS():void
		{
			if ( game_state.random_board_sizes_enabled )
			{
				var bigger:int = Helpers.Rnd(0,4);
				_global.purgatory_board_rows = 9 + 2 + bigger; // + 3;
				_global.purgatory_board_cols = 13 + 2 + bigger; // + 3;
				
				if ( (_global.purgatory_default_board_rows >= _global.purgatory_board_rows) &&
					(_global.purgatory_default_board_cols >= _global.purgatory_board_cols) )
				{
					_global.purgatory_piece_cx = _global.purgatory_piece_normal_cx;
					_global.purgatory_piece_cy = _global.purgatory_piece_normal_cy;
				}
				else
				{
					_global.purgatory_piece_cx = _global.purgatory_piece_tight_cx;
					_global.purgatory_piece_cy = _global.purgatory_piece_tight_cy;
				}
			}
			else
			{
				_global.purgatory_board_rows = _global.purgatory_default_board_rows;
				_global.purgatory_board_cols = _global.purgatory_default_board_cols;
				_global.purgatory_piece_cx = _global.purgatory_piece_normal_cx;
				_global.purgatory_piece_cy = _global.purgatory_piece_normal_cy;
			}
			
			if ( HandleDifficultyIncrease() )
			{
				trace( "pieces now = " + _global.purgatory_nPieces );
			}
		}
		*/
		
		protected function OnNewBoardButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			Dismiss();
			
			Core.instance.NewGameBoard();
		}
		
		/*
		protected function DifficultyForumla( x:Number ):Number
		{
		return x / 2;
		}
		
		protected function HandleDifficultyIncrease():Boolean
		{
			var last:int = _global.purgatory_nPieces;
			
			if ( 0 == game_state.current_streak )
			{
				--_global.purgatory_nPieces;
			}
			
			var canidate:int = _global.purgatory_nPieces + DifficultyForumla( game_state.current_streak );
			
			_global.purgatory_nPieces = Math.max(
				_global.purgatory_min_piece_types,
				Math.min( canidate, _global.purgatory_max_piece_types ) );
			
			return (last != _global.purgatory_nPieces);
		}
		*/
		
		/*
		protected function OnMainMenuButton( e:MouseEvent ):void
		{
			Main.instance.GotoMenu();
			
			Dismiss();
		}
		*/
		
		protected function OnReplayBoardButton( e:MouseEvent ):void
		{
			Core.instance.GotoGame();
			
			_global.purgatory_use_last_board_layout = true;
			
			Core.instance.game_.ShutdownDynamicElements();
			
			Core.instance.game_.BOOTSTRAP_GAME_SESSION();
			
			Dismiss();
		}
		
		/*
		public function SetContext( context:String ):void
		{
			last_context = context;
		}
		*/
		
		override public function Dismiss():void 
		{
			game_state.save();
			
			super.Dismiss();
		}
	}
	
}