package bpt.util 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import font_assets;
	import flash.display.Graphics;
	import flash.text.*;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.FontDescription;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontLookup;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class Text2BitmapData
	{
		static protected function TextLine_Create( str:String, tf:TextFormat, width:int ):TextLine {
            
            var fontDescription:FontDescription = new FontDescription();
			
			fontDescription.fontName = tf.font;
			fontDescription.fontLookup = FontLookup.EMBEDDED_CFF;
            fontDescription.fontPosture = FontPosture.NORMAL;
			
            var format:ElementFormat = new ElementFormat( fontDescription, (Number)(tf.size), (uint)(tf.color) );
            var textElement:TextElement = new TextElement( str, format );
			
            var textBlock:TextBlock = new TextBlock();
            textBlock.content = textElement;
            var textLine:TextLine = textBlock.createTextLine(null,(Number)(width));
			return textLine;
        }
		
		// TODO.TODO.this does not properly deal with the actual rendering size of the passed in display object!!!!
		
		/*
		static protected function DisplayObjectBakeFilter( dobj:DisplayObject, filter:BitmapFilter ):BitmapData
		{
			var alignedWidth:int = (int)(dobj.width + 0.5);
			var alignedHeight:int = (int)(dobj.height + 0.5);

			alignedWidth += (alignedWidth & 1);
			alignedHeight += (alignedHeight & 1);
			
			var bmd:BitmapData = new BitmapData( alignedWidth, alignedHeight, true, 0 );
			
			bmd.draw( dobj );
			
			if ( null == filter )
			{
				return bmd;
			}
			
			var boundary:Rectangle = bmd.generateFilterRect( bmd.rect, filter );
			
			alignedWidth = (int)(boundary.width + 0.5);
			alignedHeight = (int)(boundary.height + 0.5);

			alignedWidth += (alignedWidth & 1);
			alignedHeight += (alignedHeight & 1);
			
			var filteredBMD:BitmapData = new BitmapData( alignedWidth, alignedHeight, true, 0 );
			
			filteredBMD.applyFilter( bmd, bmd.rect, boundary.topLeft, filter );
			
			bmd.dispose();
			
			return filteredBMD;
		}
		*/
		
		static public function CreateTextBitmapData( existingBMD:BitmapData, text:String, tf:TextFormat, filter:BitmapFilter = null, color:uint = 0xFFFFFF ):BitmapData
		{
			var oldColor:Object = tf.color;
			
			tf.color = color;
			
			var textLine:TextLine = TextLine_Create( text, tf, 1024 );
			
			tf.color = oldColor;
			
			var holder:Sprite = new Sprite();
			
			textLine.y = textLine.ascent;
			
			holder.addChild( textLine );
			
			holder.filters = [ filter ];
			
			var bounds:Rectangle;
			
			var bmd:BitmapData = existingBMD;
			
			for ( var i:int = 0; i < 1; ++i ) // looping to include filter is currently broken :(
			{
				if ( 0 == i )
				{
					bounds = holder.getBounds( holder );
				}
				else
				{
					bounds = bmd.generateFilterRect( holder.getRect( holder ), filter);
				}
				
				// kludge because the filter seems to be a tag bigger
				bounds.width += 5;
				bounds.height += 5;
				
				var mat3x3:Matrix = new Matrix(1, 0, 0, 1, -bounds.left, -bounds.top);
				
				var w:int = (int)(bounds.width + 1.5);
				var h:int = (int)(bounds.height + 1.5);

				w += (w & 1);
				h += (h & 1);
				
				if ( (null == bmd) || ((w > bmd.width) || (h > bmd.height)) )
				{
					bmd = new BitmapData( w, h, true, 0 );
				}
				else
				{
					bmd.fillRect( bmd.rect, 0 );
				}
			}
			
			if ( true )
			{
				bmd.drawWithQuality( holder, mat3x3, null, null, null, true, StageQuality.BEST ); 
			}
			else
			{
				var oldQuality:String = Core.instance.stage.quality;
				Core.instance.stage.quality = StageQuality.BEST;
				bmd.draw( holder, mat3x3 );
				Core.instance.stage.quality = oldQuality;
			}
			
			return bmd;
			
			/*
			
			var bmd:BitmapData = DisplayObjectBakeFilter( holder, filter );
			
			holder.removeChild( textLine );
			
			holder = null;
			
			return bmd;
			*/
		}
	}

}