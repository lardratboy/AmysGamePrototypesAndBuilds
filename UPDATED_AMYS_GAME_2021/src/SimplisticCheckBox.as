package 
{
	import assets;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import ScaledAssetButton;
	import flash.display.Sprite;
	import bpt.ui.button.SimplisticButton;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class SimplisticCheckBox extends SimplisticButton
	{
		protected var marks_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		protected function BuildCheckboxState( asset:String, scale:Number ):Sprite
		{
			var holder:Sprite = new Sprite();
			
			var position_adjuster:Sprite = new Sprite();
			
			var box:DisplayObject = assets.GetDisplayObject( "check_box" );
			position_adjuster.addChild( box );
			
			var msg:DisplayObject = assets.GetDisplayObject( asset );
			position_adjuster.addChild( msg );
			
			var mark:DisplayObject = assets.GetDisplayObject( "check_mark" );
			mark.name = "mark";
			position_adjuster.addChild( mark );
			marks_.push( mark );
			
			box.x = msg.width / -2 - box.width/2;
			mark.x = box.x;
			
			holder.scaleX = scale;
			holder.scaleY = scale;
			
			holder.addChild( position_adjuster );
			
			var rect:Rectangle = position_adjuster.getRect( holder );
			
			// trace( rect );
			
			position_adjuster.x = rect.width/-2 - rect.left;
			
			return holder;
		}
		
		public function SimplisticCheckBox( asset:String ):void
		{
			var upSprite:Sprite = BuildCheckboxState( asset, 1 );
			var ovSprite:Sprite = BuildCheckboxState( asset, 1.05 );
			var dnSprite:Sprite = BuildCheckboxState( asset, 0.95 );
			
			super( upSprite, ovSprite, dnSprite );
		}
		
		public function SetCheck( bCheck:Boolean ):void
		{
			for each ( var mark:DisplayObject in marks_ )
			{
				mark.visible = bCheck;
			}
		}
	}
	
}