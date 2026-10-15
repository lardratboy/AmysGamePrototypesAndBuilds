package 
{
	import assets;
	import bpt.game._global;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import SimplePanel;
	import ScaledAssetButton;
	import bpt.game.game_state;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class StoryOfGame extends SimplePanel
	{
		public function StoryOfGame():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "story_button";
		
		protected var secret_button_1:ScaledAssetButton;
		//protected var secret_button_2:ScaledAssetButton;
		
		protected var holder_:AlignedHolder;
		
		protected override function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected function AddLine( group:AlignedHolder, text:String ):void
		{
			var line:DynamicTextHolder = new DynamicTextHolder();
			
			line.SetText( text ); // = assets.GenerateStaticTextBitmap( text );
			
			//line.x = -group.parent.width / 2; // line.width / -2;
			//line.y = line.height / -2;
			
			group.addChild( line );
		}
		
		protected override function Create():void
		{
			super.Create();
			
			holder_ = new AlignedHolder();
			
			background_panel_.addChild( holder_ );
			
			var lineSpacing:int = 4 * assets.asset_runtime_scale_factor;
			
			var p1:AlignedHolder = new AlignedHolder();
			AddLine( p1, "What do you want for Valentines?" );
			AddLine( p1, "I want you to make my game" );
			AddLine( p1, "playable on the iPad. And he did." );
			holder_.addChild( p1 );
			p1.Align( lineSpacing, true );
			
			var p2:AlignedHolder = new AlignedHolder();
			AddLine( p2, "Eight years earlier my husband made a" );
			AddLine( p2, "game prototype, I loved it and played" );
			AddLine( p2, "for hours and hours." );
			holder_.addChild( p2 );
			p2.Align( lineSpacing, true );
			
			var p3:AlignedHolder = new AlignedHolder();
			AddLine( p3, "Now everyone can enjoy the pleasant" );
			AddLine( p3, "unwind from a hard days work" );
			AddLine( p3, "that \"Amy's Game\" provides." );
			holder_.addChild( p3 );
			p3.Align( lineSpacing, true );
			
			var p4:AlignedHolder = new AlignedHolder();
			AddLine( p4, "Cheers!" );
			AddLine( p4, "Amy" );
			holder_.addChild( p4 );
			p4.Align( lineSpacing, true );
			
			holder_.Align( lineSpacing * 3, true );
			
			holder_.y = (60 * assets.asset_runtime_scale_factor) + holder_.height/-2;
			
			secret_button_1 = new ScaledAssetButton( "gfx_star" ); //, 1, 1, 1 );
			secret_button_1.alpha = 1;
			secret_button_1.scaleX = 1;
			secret_button_1.scaleY = 1;
			secret_button_1.x = background_panel_.x + background_panel_.width/2 - (secret_button_1.width * secret_button_1.scaleX); //_global.purgatory_stage_cx - (secret_button_1.width * secret_button_1.scaleX)/2;
			secret_button_1.y = background_panel_.y + background_panel_.height/2 - (secret_button_1.height * secret_button_1.scaleY); //_global.purgatory_stage_cy - (secret_button_1.height * secret_button_1.scaleY)/2;
			secret_button_1.addEventListener( MouseEvent.CLICK, OnAssetInfoPanelButton );
			addChild( secret_button_1 );

			/*
			
			secret_button_2 = new ScaledAssetButton( "super_secret_2", 1, 1, 1 );
			secret_button_2.alpha = secret_button_1.alpha;
			secret_button_2.scaleX = 0.5;
			secret_button_2.scaleY = 0.5;
			secret_button_2.x = secret_button_1.x + secret_button_1.width + 2 + secret_button_2.width / 2;
			secret_button_2.y = secret_button_1.y; // _global.purgatory_stage_cy - (secret_button_2.height / 2);
			secret_button_2.addEventListener( MouseEvent.CLICK, OnFullBoardButton );
			addChild( secret_button_2 );
			
			*/

		}
		
		override protected function EnableButtons(b:Boolean):void 
		{
			super.EnableButtons(b);
			
			secret_button_1.Enable( b );
			//secret_button_2.Enable( b );
		}
		
		protected function OnAssetInfoPanelButton( e:MouseEvent ):void
		{
			Core.instance.GotoAssetInfoPanel( this );
			
			Dismiss();
		}
		
		/*
		protected function OnFullBoardButton( e:MouseEvent ):void
		{
			_global.purgatory_bAllowInitialMatches = !_global.purgatory_bAllowInitialMatches;
		}
		*/
		
	}
	
}