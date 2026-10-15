package 
{
	import assets;
	import flash.display.Sprite;
	import SimplePanel;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class Achievements extends SimplePanel
	{
		public function Achievements():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "achievements_button";
		
		protected override function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected override function Create():void
		{
			super.Create();
		}
	}
	
}