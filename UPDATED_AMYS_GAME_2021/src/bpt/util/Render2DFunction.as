package bpt.util 
{
	import bpt.maths.I2DFunction;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class Render2DFunction
	{
		
		public function Render2DFunction() 
		{
			
		}
		
		static public function Dots( g:Graphics, f:I2DFunction, scale:Point, offset:Point, color:uint, alpha:Number, dots:int, size:int ):void
		{
			var t:Number = 0;
			var d:Number = 1 / (dots - 1);
			
			var s:Point = new Point();
			
			g.lineStyle();
			
			for ( var i:Number = 0; i < dots; ++i )
			{
				f.GetSample( s, t );
				t += d;
				
				g.beginFill( color, alpha );
				g.drawCircle( s.x * scale.x + offset.x, s.y * scale.y + offset.y, size );
				g.endFill();
			}
		}
		
		static public function Lines( g:Graphics, f:I2DFunction, scale:Point, offset:Point, color:uint, alpha:Number, lines:int, thickness:Number, close:Boolean ):void
		{
			var t:Number = 0;
			var d:Number = 1 / (lines - 1);
			
			var s:Point = new Point();
			
			g.lineStyle(thickness, color, alpha);
			
			for ( var i:Number = 1; i < lines; ++i )
			{
				f.GetSample( s, t );
				
				if ( 1 != i )
				{
					g.lineTo( s.x * scale.x + offset.x, s.y * scale.y + offset.y );
				}
				else
				{
					g.moveTo( s.x * scale.x + offset.x, s.y * scale.y + offset.y );
				}
				
				t += d;
			}
			
			f.GetSample( s, t );
			
			g.lineTo( s.x * scale.x + offset.x, s.y * scale.y + offset.y );
			
			if ( close )
			{
				f.GetSample( s, 0 );
			
				g.lineTo( s.x * scale.x + offset.x, s.y * scale.y + offset.y );
			}
		}
		
	}

}