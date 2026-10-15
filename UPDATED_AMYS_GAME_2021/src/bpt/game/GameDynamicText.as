package bpt.game
{
	import flash.display.Bitmap;
	
	import assets;
	
	import bpt.game.BaseGameSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author BPT
	 */
	/* Starling.text
	public class GameDynamicText extends TextField
	{
		protected var text_:String;
		protected var bKeepCentered_:Boolean;
		
		public function GameDynamicText( bKeepCentered:Boolean = true )
		{
			bKeepCentered_ = bKeepCentered;
			
			var tf:TextFormat = assets.GetDefaultTextFormat();
			
			super( 128, (int)(Number(tf.size)*1.5), "GameDynamicText", tf.font, tf.size, tf.color );
		}
		
		public function SetText( text:String ):void
		{
			if ( text_ == text ) return;
			
			this.autoScale = true;
			
			text_ = text;
			this.text = text_;
		}
		
	}
	*/
	
	///* IMAGE BASED
	public class GameDynamicText extends Image
	{
		protected var image_:Image;
		protected var bitmap_:Bitmap;
		protected var text_:String;
		protected var bKeepCentered_:Boolean;
		
		public function GameDynamicText( bKeepCentered:Boolean = true )
		{
			bKeepCentered_ = bKeepCentered;
			
			super( Texture.fromBitmap( assets.GetReusableTextObject( "GameDynamicText" ) as Bitmap ) );
		}
		
		public function SetText( text:String ):void
		{
			if ( text_ == text ) return;
			
			text_ = text;
			
			if ( null == bitmap_ )
			{
				bitmap_ = assets.GenerateDynamicTextBitmap( text );
			}
			else
			{
				assets.ChangeDyanmicTextBitmap( bitmap_, text );
			}
			
			texture.dispose();
			
			texture = Texture.fromBitmap( bitmap_ );
			
			readjustSize();
			
			if ( bKeepCentered_ )
			{
				alignPivot();
			}
		}
		
	}
	//*/

	
	/*OLD
	public class GameDynamicText extends Sprite
	{
	protected var bitmap_:Bitmap;
	protected var text_:String;
	protected var bKeepCentered_:Boolean;
	
	public function GameDynamicText( bKeepCentered:Boolean = true )
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
	*/
	
}