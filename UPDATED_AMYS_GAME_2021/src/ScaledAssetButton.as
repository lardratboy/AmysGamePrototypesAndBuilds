package 
{
	import assets;
	import flash.display.Sprite;
	import bpt.ui.button.SimplisticButton;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class ScaledAssetButton extends SimplisticButton
	{
		protected function OnClick( e:MouseEvent ):void
		{
			sound_assets.PlaySound( "sfx_slot_stop" );
		}
		
		public function ScaledAssetButton( baseAssetName:String, upScale:Number = 1, overScale:Number = 1.05, downScale:Number = 0.95 ):void
		{
			var upSprite:Sprite = assets.SpriteWrapper( baseAssetName );
			upSprite.scaleX = upSprite.scaleY = upScale;
			
			var ovSprite:Sprite = assets.SpriteWrapper( baseAssetName );
			ovSprite.scaleX = ovSprite.scaleY = overScale;
			
			var dnSprite:Sprite = assets.SpriteWrapper( baseAssetName );
			dnSprite.scaleX = dnSprite.scaleY = downScale;
			
			super( upSprite, ovSprite, dnSprite );
			
			this.addEventListener( MouseEvent.CLICK, OnClick );
		}
	}
	
}