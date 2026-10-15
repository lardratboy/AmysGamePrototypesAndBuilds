package 
{
	import assets;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import LargePanelBase;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class SimplePanel extends LargePanelBase
	{
		public function SimplePanel():void
		{
			super();
		}
		
		protected function GetBannerAssetName():String
		{
			return null;
		}
		
		protected override function Create():void
		{
			super.Create();
			
			super.CreateMainMenuButton( OnBackButton );
			
			if ( null != GetBannerAssetName() )
			{
				var banner:DisplayObject = assets.SpriteWrapper( GetBannerAssetName() );
				banner.x = background_panel_.x;
				banner.y = background_panel_.y - background_panel_.height/2 + banner.height;
				addChild( banner );
			}
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
		}
		
		// --------------------------------------------------------------------
		
		protected function OnBackButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			Core.instance.Back( this );
			
			Dismiss();
		}
		
	}
	
}