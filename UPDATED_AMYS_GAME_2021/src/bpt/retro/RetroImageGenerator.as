package bpt.retro
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class RetroImageGenerator
	{
		public function RetroImageGenerator() 
		{
		}
		
		static public function RenderSimplePixel( graphics:Graphics, x:int, y:int, cx:int, cy:int, baseColor:uint, outlineColor:uint = 0, outlineThickness:Number = 0, alpha:Number = 1 ):void
		{
			var x1:Number = x - cx/2;
			var y1:Number = y - cy/2;
			var x2:Number = x1 + cx;
			var y2:Number = y1 + cy;
			
			graphics.beginFill( baseColor, alpha );
			graphics.lineStyle( outlineThickness, outlineColor, alpha ); // , true, LineScaleMode.NONE );
			
			graphics.moveTo( x1, y1 );
			graphics.lineTo( x2, y1 );
			graphics.lineTo( x2, y2 );
			graphics.lineTo( x1, y2 );
			graphics.lineTo( x1, y1 );	

			graphics.endFill();
		}
		
		static public function RenderInto_( graphics:Graphics, x:int, y:int, shapeBitPattern:uint, colorsBitPattern:uint, dotSize:int, colorTable:Array, alpha:Number, dotRenderer:Function ):void
		{
			var mask:uint, h:int, v:int, daColor:uint;
			var xPos:Number, ixPos:Number;
			
			var cx:Number = dotSize;
			var cy:Number = dotSize;
			
			var xStart:Number = x + ((cx * 5) / -2) + (cx/2);
			var yStart:Number = y + ((cy * 5) / -2) + (cy/2);
			
			var bits:uint = shapeBitPattern;
			var yPos:Number = yStart;
			
			for ( v = 0; v < 5; ++v )
			{
				mask = 1;
				
				xPos = xStart;
				ixPos = xStart + (cx * 4);
				
				for ( h = 0; h < 3; ++h )
				{
					if ( bits & mask )
					{
						daColor = colorTable[ colorsBitPattern & 3 ];
						
						colorsBitPattern >>= 2;
						
						dotRenderer( graphics, xPos, yPos, cx, cy, daColor, alpha );
						
						if ( 2 > h )
						{
							dotRenderer( graphics, ixPos, yPos, cx, cy, daColor, alpha );
						}
					}
					
					mask <<= 1;
					
					xPos += cx;
					ixPos -= cx;
					
				}
				
				yPos += cy;
				
				bits >>= 3;
				
			}
			
		}
		
		static public function RenderInto( graphics:Graphics, x:int, y:int, shapeBitPattern:uint, colorsBitPattern:uint, dotSize:int, colorTable:Array, alpha:Number ):void
		{
			RenderInto_( graphics, x, y, shapeBitPattern, colorsBitPattern, dotSize, colorTable, alpha, RetroImageGenerator.RenderSimplePixel );
		}
		
		static private function MakePrimaryColor( index:int ):uint
		{
			return (
				((index & 1) ? 0xFF0000 : 0) + 
				((index & 2) ? 0x00FF00 : 0) +
				((index & 4) ? 0x0000FF : 0)
			);
		}
		
		static public function RenderRandom( graphics:Graphics, x:int, y:int, dotSize:int, alpha:Number ):void
		{
			RenderInto(
				graphics
				,x
				,y 
				,uint( Math.random() * 0xFFFF )
				,uint( Math.random() * 0xFFFFFFFF )
				,dotSize
				,[
					0xFFFFFF // MakePrimaryColor( 1 + int( Math.random() * 7 ) )
				,	0x7F7F7F // MakePrimaryColor( 1 + int( Math.random() * 7 ) )
				,	0x3F3F3F // MakePrimaryColor( 1 + int( Math.random() * 7 ) )
				,	0x1F1F1F // MakePrimaryColor( 1 + int( Math.random() * 7 ) )
				]
				,alpha
				);
		}
		
		static public function RandomShape( dotSize:int, alpha:uint ):Shape
		{
			var shape:Shape = new Shape();
			
			RenderRandom( shape.graphics, 0, 0, dotSize, alpha );
			
			return shape;
		}
		
		static public function RenderRetroIntoBitmapData( target:BitmapData, x:int, y:int, dotSize:int, alpha:Number ):void
		{
			var shape:Shape = RandomShape( dotSize, alpha );
			
			target.draw( shape, new Matrix( 1, 0, 0, 1, x, y ), new ColorTransform( 1, 1, 1, alpha ) );
			
			shape.graphics.clear();
			
			shape = null;
			
		}
		
		static public function MakeRandomBitmap( dotSize:int, alpha:Number ):Bitmap
		{
			var cx:int = dotSize * 5 + 2;
			var cy:int = dotSize * 5 + 2;
			
			var shape:Shape = RandomShape( dotSize, alpha );
			
			shape.filters = [ new DropShadowFilter() ];
			
			var bitmapData:BitmapData = new BitmapData( cx + 5, cy + 5, true, 0 );
			
			bitmapData.draw( shape, new Matrix( 1, 0, 0, 1, int(cx / 2), int(cy / 2) ) );
			
			var bitmap:Bitmap = new Bitmap( bitmapData, assets.PixelSnappingPolicy, false );
			
			return bitmap;
		}
	}

}

