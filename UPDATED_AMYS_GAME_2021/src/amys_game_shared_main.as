package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import Core;
	
	import bpt.game.StarlingGameRoot;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.tweens.ITween;
	
	import starling.core.Starling;
	
	public class amys_game_shared_main extends Sprite
	{
		static public var real_outter_instance_:amys_game_shared_main;
//		protected var _main:Main;
		//protected var mStarling:Starling;
		protected var _loadingOverlay:Bitmap;
		//protected var loading_done_Tween_:ITween = null;
		
		protected function SetupActualGameContent():void
		{
			Core.iOSHost = (-1 != Capabilities.manufacturer.indexOf("iOS"));
			
			Starling.handleLostContext = !Core.iOSHost;
			
			var fsr:Rectangle = new Rectangle( 0, 0, Core.canvas_width, Core.canvas_height );
			
			Core.mStarling = new Starling( bpt.game.StarlingGameRoot, stage, fsr );
			
			Core.mStarling.start();
		}
		
		/*
		protected function LoadingDoneTweenDone():void
		{
			removeChild(_loadingOverlay);
			_loadingOverlay = null;
			loading_done_Tween_ = null;
			
			_main.ReallyStartNow();
		}
		
		protected function DoneLoading():void
		{
			loading_done_Tween_ = BetweenAS3.serial(
				BetweenAS3.tween( _loadingOverlay, {alpha:0}, null, 3, Sine.easeOut ),
				BetweenAS3.func( LoadingDoneTweenDone ) );
			
			loading_done_Tween_.play();
		}
		*/
		
		static public function ReadyEnoughToRemoveLoadingOverlayAndStart():void
		{
			Core.starlingRoot.HandleLoadingOverlayFade( real_outter_instance_._loadingOverlay );
			real_outter_instance_._loadingOverlay = null;
		}
		
		protected function SetupLoadingContent():void
		{
			SetupActualGameContent();
		}
		
		protected function init( bRemoveAddToStageListener:Boolean = true ):void
		{
			
//			if ( flash.system.Capabilities.isDebugger ) trace("bootstrap.INIT ->");
			
			__init__( bRemoveAddToStageListener );
			
//			if ( flash.system.Capabilities.isDebugger ) trace("<- bootstrap.INIT");
			
		}
		
		protected function __GetDesiredCanvasWidth__():int
		{
			return stage.stageWidth;
		}
		
		protected function __GetDesiredCanvasHeight__():int
		{
			return stage.stageHeight
		}
		
		protected function __init__( bRemoveAddToStageListener:Boolean = true ):void
		{
			if ( bRemoveAddToStageListener )
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}
			
			stage.frameRate = 60;
			stage.quality = StageQuality.HIGH; // .LOW;
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0x1283DF;
			
			// -------------------------------------------
			
			Core.SetupCanvasSize( __GetDesiredCanvasWidth__(), __GetDesiredCanvasHeight__() );
			
			// -------------------------------------------

			_loadingOverlay = assets.GetLoadingArtBitmap();
			_loadingOverlay.pixelSnapping = flash.display.PixelSnapping.AUTO;
			_loadingOverlay.smoothing = true;
			_loadingOverlay.scaleX = Core.canvas_width / 1024.0;
			_loadingOverlay.scaleY = _loadingOverlay.scaleX;
			_loadingOverlay.x = (Core.canvas_width - _loadingOverlay.width) / 2;
			_loadingOverlay.y = (Core.canvas_height - _loadingOverlay.height) / 2;
			
			addChild( _loadingOverlay );
			
			// --------------------------------------------
			
			SetupLoadingContent();
		}
		
		public function amys_game_shared_main()
		{
			real_outter_instance_ = this;
			
			super();

			if (stage) init(false);
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
}