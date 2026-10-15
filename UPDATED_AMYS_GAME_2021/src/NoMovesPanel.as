package 
{
	import assets;
	import bpt.game.game_state;
	import flash.display.Sprite;
	import BetweenLevelPanel
	import flash.events.Event;
	import DynamicTextHolder;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class NoMovesPanel extends BetweenLevelPanel
	{
		public function NoMovesPanel():void
		{
			super();
		}
		
		protected var retry_counter_message:DynamicTextHolder = null;
		
		public override function AllowContinueButton():Boolean
		{
			return false;
		}
		
		static private var banner_asset_name_:String = "no_moves_banner";
		
		protected override function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected override function Create():void
		{
			super.Create();
			
			retry_counter_message = new DynamicTextHolder();
			addChild( retry_counter_message );
			
			retry_counter_message.x = this.background_panel_.x;
			retry_counter_message.y = this.background_panel_.y;
		}
		
		protected override function reinit( e:Event ):void
		{
			super.reinit( e );
			
			switch ( game_state.last_board_retries )
			{
				case 0:
					retry_counter_message.SetText( "No retries yet..." );
					break;
					
				case 1:
					retry_counter_message.SetText(
						game_state.last_board_retries + " retry so far..." );
					break;
					
				default:
					retry_counter_message.SetText(
						game_state.last_board_retries + " retries so far..." );
					break;
			}
			
		}
	}
	
}