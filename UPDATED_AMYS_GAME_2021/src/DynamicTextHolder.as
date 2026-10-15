package 
{
	import assets;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class DynamicTextHolder extends Sprite
	{
		protected var bitmap_:Bitmap;
		protected var text_:String;
		protected var bKeepCentered_:Boolean;
		
		public function DynamicTextHolder( bKeepCentered:Boolean = true )
		{
			bKeepCentered_ = bKeepCentered;
			super();
		}
		
		public function SetText( text:String ):void
		{
			if ( text_ == text ) return;
			
			text_ = text;
			
			if ( null == bitmap_ )
			{
				bitmap_ = assets.GenerateDynamicTextBitmap( text );
				
				addChild( bitmap_ );
			}
			else
			{
				assets.ChangeDyanmicTextBitmap( bitmap_, text );
			}
			
			if ( bKeepCentered_ )
			{
				bitmap_.x = bitmap_.width / -2;
				bitmap_.y = bitmap_.height / -2;
			}
			
		}
		
	}
	
}