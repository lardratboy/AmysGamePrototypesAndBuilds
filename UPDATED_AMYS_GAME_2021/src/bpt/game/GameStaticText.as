package bpt.game
{
	import flash.display.Bitmap;
	
	import assets;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class GameStaticText extends Image
	{
		protected var texture_:Texture;
		protected var bitmap_:Bitmap;
		protected var text_:String;
		protected var bKeepCentered_:Boolean;
		
		public function GameStaticText( bKeepCentered:Boolean = true )
		{
			bKeepCentered_ = bKeepCentered;
		
			super( Texture.fromBitmap( assets.GetReusableTextObject( "GameStaticText" ) as Bitmap ) );
		}
		
		public function SetText( text:String, color:uint = 0xFFFFFF ):void
		{
			if ( text_ == text ) return;
			
			text_ = text;
			
			bitmap_ = assets.GetReusableTextObject( text, color ) as Bitmap;
			
			texture_ = Texture.fromBitmap( bitmap_ );
			
			if ( bKeepCentered_ )
			{
				alignPivot();
			}
			
		}
		
		static public function xGetReusableTextObject( text:String, color:uint = 0xFFFFFF, bKeepCentered:Boolean = true ):GameStaticText
		{
			var spanky:GameStaticText = new GameStaticText( bKeepCentered );
			
			spanky.SetText( text, color );
			
			return spanky;
		}
		
	}
	
	/* OLD
	
	public class GameStaticText extends Sprite
	{
	protected var bitmap_:Bitmap;
	protected var text_:String;
	protected var bKeepCentered_:Boolean;
	
	public function GameStaticText( bKeepCentered:Boolean = true )
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
	
	static public function GetReusableTextObject( text:String, color:uint = 0xFFFFFF ):GameStaticText
	{
	assets.GetReusableTextObject( text, color ),
	assets.GetStaticTextID( text, color )
	
	return null;
	}
	
	}
	
	*/
	
}