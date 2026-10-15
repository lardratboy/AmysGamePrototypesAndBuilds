package bpt.game
{
	import assets;
	import starling.display.DisplayObjectContainer;
	import starling.display.DisplayObject;
	
	public class BaseGameSprite extends DisplayObjectContainer
	{
		public function BaseGameSprite()
		{
			super();
			touchable = false;
		}
		
		public static function CreateFromAsset( asset:String ):BaseGameSprite
		{
			var spanky:BaseGameSprite = new BaseGameSprite();
			
			spanky.addChild( GetReusableDisplayObject( asset ) );
				
			return spanky;
		}
		
		public static function GetReusableDisplayObject( asset:String ):DisplayObject
		{
			return assets.starling_GetReusableDisplayObject( asset );
		}
		
		public static function ReleaseReusableDisplayObject( asset:String, o:DisplayObject ):void
		{
			o.removeFromParent();
			
			assets.starling_ReleaseReusableDisplayObject( asset, o );
		}
		
	}
}