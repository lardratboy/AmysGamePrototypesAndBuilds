package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.StageWebView;
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
	public class AssetInfoPanelHTML extends SimplePanel
	{
		[Embed(source="../asset_sources/html/credits.html",mimeType="application/octet-stream")]
		static public var credits_html_class:Class;
		
		protected var webView_:flash.media.StageWebView;
		
		public function AssetInfoPanelHTML():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "asset_info_panel_banner";
		
		protected override function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected override function Create():void
		{
			super.Create();
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			webView_.stage = b ? this.stage : null;
		}
		
		protected override function reinit( e:Event ):void
		{
			super.reinit( e );
			
			if ( null == webView_ )
			{
				webView_ = new StageWebView();
				
				var b:ByteArray = new credits_html_class();
				var s:String = b.readUTFBytes(b.length)
				webView_.loadString(s);
				
			}
			
			var pw:int = (int)(background_panel_.width * 2.5 / 4);
			var ph:int = (int)(background_panel_.height * 3 / 4);
			
			webView_.viewPort = new flash.geom.Rectangle(
				background_panel_.x - (background_panel_.width/2) + (background_panel_.width - pw) / 2,
				background_panel_.y - (background_panel_.height/2) + (background_panel_.height - ph) / 2,
				pw, ph );
		}
		
		public override function Dismiss():void
		{
			super.Dismiss();
		}
	}
	
}