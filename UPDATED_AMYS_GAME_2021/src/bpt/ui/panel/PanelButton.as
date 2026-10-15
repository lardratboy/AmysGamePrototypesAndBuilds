package bpt.ui.panel
{
	import bpt.ui.button.SimplisticButton;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.text.engine.TextLine;
	import font_assets;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.FontDescription;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontLookup;

	/**
	 * ...
	 * @author bpt
	 */
	public class PanelButton extends SimplisticButton
	{
		static public var default_text_format:TextFormat = null;
		
		// --------------------------------------------------------------------
		
		protected function TextLine_Create( str:String, tf:TextFormat, width:int ):TextLine {
            
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

		// --------------------------------------------------------------------
		
		protected function MakeButtonState( text:String, stateWidth:int, stateHeight:int, textColor:uint, baseColor:uint, outlineColor:uint, tf:TextFormat ):Sprite
		{
			var temp:Sprite = new Sprite();
			
			var aa:Number = 1.5; // without this the corners look like crap WTF? (because of pixel hinting I think...)
			
			temp.graphics.lineStyle( 3, outlineColor );
			temp.graphics.beginFill( baseColor );
			temp.graphics.drawRoundRect( aa, aa, stateWidth - aa, stateHeight - aa, 11 );
			temp.graphics.endFill();
			
			if ( true )
			{
				var textLine:TextLine = TextLine_Create( text, tf, stateWidth );
				textLine.x = ((Number)(stateWidth) - textLine.width) / 2;
				textLine.y = ((Number)(stateHeight) - textLine.height) / 2 + textLine.ascent;
				temp.addChild(textLine);
			}
			else
			{
				var txt:TextField = new TextField();
					txt.text = text;
					txt.x = 0;
					txt.y = 0;
					txt.autoSize=TextFieldAutoSize.CENTER;
					txt.setTextFormat( tf );
					txt.selectable = false;
					txt.mouseEnabled = false;

				temp.addChild( txt );
				txt.x = (stateWidth - txt.width) / 2;
				txt.y = (stateHeight - txt.height) / 2;
			}
				
			var data:BitmapData = new BitmapData( stateWidth + 2, stateHeight + 2, true, 0 );
			
			data.draw( temp );
			
			temp = null;
			
			var out:Sprite = new Sprite();
			
			out.addChild( new Bitmap( data, assets.PixelSnappingPolicy, false ) );
			
			return out;
		}
		
		public function PanelButton( text:String, width:int, height:int, textColor:uint = 0x000000, upColor:uint = 0xF0F0F0, overColor:uint = 0xFFFFFF, downColor:uint = 0xD0D0D0, outlineColor:uint = 0x000000, tf:TextFormat = null ) 
		{
			super();
			
			if ( null == default_text_format )
			{
				var font:Font = font_assets.GetFont( "HVD_Comic_Serif_Pro_font" );
				
//				var fonts:Array = Font.enumerateFonts(false);
//				trace( fonts );
				
				default_text_format = new TextFormat();
				default_text_format.color = textColor;
				default_text_format.font = font.fontName;
				default_text_format.size = 30;
				default_text_format.align = "center";
			}
			
			if ( null == tf ) tf = default_text_format;
			 
			upState = MakeButtonState( text, width, height, textColor, upColor, outlineColor, tf );
			downState = MakeButtonState( text, width, height, textColor, downColor, outlineColor, tf );
			overState = MakeButtonState( text, width, height, textColor, overColor, outlineColor, tf );
		}
		
	}
}