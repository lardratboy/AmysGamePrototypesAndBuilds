package 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author BPT
	 */

	public class AlignedHolder extends Sprite
	{
		public function Align( gap:int, bVertical:Boolean, scaleItemCoefficient:Number = 1 ):void
		{
			var xPos:int = 0;
			var xGap:int = bVertical ? 0 : gap;
			
			var yPos:int = 0;
			var yGap:int =  bVertical ? gap : 0;
			
			for ( var i:int = 0; i < numChildren; ++i )
			{
				var dobj:DisplayObject = getChildAt( i );
				
				dobj.scaleX = scaleItemCoefficient;
				dobj.scaleY = scaleItemCoefficient;
				
				dobj.x = xPos;
				dobj.y = yPos;
				
				if ( dobj.visible )
				{
					if ( bVertical )
					{
						var h:Number = dobj.height;

						if ( 0 == h )
						{
							h = dobj.getRect( this ).height;
						}
						
						yPos += (h + yGap);
					}
					else
					{
						var w:Number = dobj.width;
						
						if ( 0 == w )
						{
							w = dobj.getRect( this ).width;
						}
						
						xPos += (w + xGap);
					}
				}
			}
			
			if ( bVertical )
			{
				y = height / -2;
			}
			else
			{
				x = width / -2;
			}
		}
	}
	
}

