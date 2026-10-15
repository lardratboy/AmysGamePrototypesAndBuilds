package 
{
	import assets;
	import bpt.game._global;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import SimplePanel;
	import AlignedHolder;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class HowToPlay extends SimplePanel
	{
		protected var play_button_:ScaledAssetButton;
		
		protected var holder_:AlignedHolder;
		
		public function HowToPlay():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "how_to_play_button";
		
		protected override function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected override function Create():void
		{
			super.Create();
			
			holder_ = new AlignedHolder();
			background_panel_.addChild( holder_ );
			
			if ( true )
			{
				for ( var line:int = 0; line < assets.how_to_play_lines.length; ++line )
				{
					holder_.addChild( assets.SpriteWrapper( "how_to_play_line_" + (line + 1) ));
				}
			}
			else
			{
				holder_.addChild( assets.SpriteWrapper( "how_to_play_line_1" ));
				holder_.addChild( assets.SpriteWrapper( "how_to_play_line_2" ));
				holder_.addChild( assets.SpriteWrapper( "how_to_play_line_3" ));
				holder_.addChild( assets.SpriteWrapper( "how_to_play_line_4" ));
				holder_.addChild( assets.SpriteWrapper( "how_to_play_line_5" ));
			}

			play_button_ = new ScaledAssetButton( "play_button" );
			play_button_.x = background_panel_.x;
			play_button_.y = background_panel_.y + background_panel_.height/2 - play_button_.height * 1.0;
			play_button_.addEventListener( MouseEvent.CLICK, OnPlayButton );
			addChild( play_button_ );
			
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			if ( null != play_button_ ) play_button_.Enable( b );
		}
		
		protected function OnPlayButton( e:MouseEvent ):void
		{
			Dismiss();
			
			Core.instance.NewGameBoard();
		}
		
		protected override function reinit( e:Event ):void
		{
			super.reinit( e );
			
			holder_.Align( 6 * assets.asset_runtime_scale_factor, true );
		}
		
		public override function Dismiss():void
		{
			super.Dismiss();
		}
	}
	
}