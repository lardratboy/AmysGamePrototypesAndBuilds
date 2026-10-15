package 
{
	import assets;
	import bpt.game._global;
	import bpt.game.game_state;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import LargePanelBase;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class ConfirmClearStatistics extends LargePanelBase
	{
		protected var yes_button_:ScaledAssetButton;
		protected var no_button_:ScaledAssetButton;
		
		public function ConfirmClearStatistics():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "confirm_clear_statistics_panel_banner";
		
		protected function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected override function Create():void
		{
			super.Create();
			
			super.CreateMainMenuButton();
			
			var banner:DisplayObject = assets.SpriteWrapper( GetBannerAssetName() );
			banner.x = background_panel_.x;
			banner.y = background_panel_.y - background_panel_.height/2 + banner.height;
			addChild( banner );
			
			yes_button_ = new ScaledAssetButton( "yes_button" );
			yes_button_.x = background_panel_.x + background_panel_.width/3 - yes_button_.width * 1.0;
			yes_button_.y = background_panel_.y + background_panel_.height/2 - yes_button_.height * 1.0;
			yes_button_.addEventListener( MouseEvent.CLICK, OnYesButton );
			addChild( yes_button_ );
			
			no_button_ = new ScaledAssetButton( "no_button" );
			no_button_.x = background_panel_.x - background_panel_.width/3 + no_button_.width * 1.0;
			no_button_.y = background_panel_.y + background_panel_.height/2 - no_button_.height * 1.0;
			no_button_.addEventListener( MouseEvent.CLICK, OnNoButton );
			addChild( no_button_ );
		}
		
		protected override function reinit(e:Event):void
		{
			super.reinit( e );
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			no_button_.Enable( b );
			
			yes_button_.Enable( b );
			
			main_menu_button_.Enable( b );
		}
		
		protected function OnYesButton( e:MouseEvent ):void
		{
			game_state.RESET();
			
			Core.instance.GotoStatistics( null );
			
			Dismiss();
		}
		
		protected function OnNoButton( e:MouseEvent ):void
		{
			Core.instance.GotoStatistics( null );
			
			Dismiss();
		}
		
	}
	
}