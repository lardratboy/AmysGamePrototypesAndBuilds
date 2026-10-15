package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import AlignedHolder;
	
	import SimplePanel;
	
	import assets;
	
	import bpt.game._global;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class AssetInfoPanel extends SimplePanel
	{
		var holder_:AlignedHolder;
		
		public function AssetInfoPanel():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "asset_info_panel_banner";
		
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
			
			var lineSpacing:int = 5 * assets.asset_runtime_scale_factor;

			var p1:AlignedHolder = new AlignedHolder();
			AddLine( p1, "Cloud Background" );
			AddLine( p1, "www.beiz.jp" );
			holder_.addChild( p1 );
			p1.Align( lineSpacing, true );
		
			var p2:AlignedHolder = new AlignedHolder();
			AddLine( p2, "Creative commons artwork" );
			AddLine( p2, "www.flaticon.com" );
			AddLine( p2, "Hand Graphic by Icomoon" );
			AddLine( p2, "Various shapes by Freepik" );
			AddLine( p2, "www.freepik.com" );
			
			holder_.addChild( p2 );
			p2.Align( lineSpacing, true );
			
			/*
			var p3:AlignedHolder = new AlignedHolder();
			AddLine( p3, "Creative commons music" );
			AddLine( p3, "Shades of Spring" );
			AddLine( p3, "Kevin MacLeod (incompetech.com)" );
			holder_.addChild( p3 );
			p3.Align( lineSpacing, true );
			*/
			
			holder_.Align( lineSpacing * 3, true );
			
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
		}
		
		protected override function reinit( e:Event ):void
		{
			super.reinit( e );
		}
		
		public override function Dismiss():void
		{
			super.Dismiss();
		}
	}
	
}