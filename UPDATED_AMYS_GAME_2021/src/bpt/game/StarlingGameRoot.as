package bpt.game
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import Core;
	
	import bpt.game.IActSomethingtLikeAMovieClipFromAS2;
	
//	import feathers.controls.Button;
//	import feathers.core.FeathersControl;
//	import feathers.themes.MetalWorksMobileTheme;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.events.TweenEvent;
	import org.libspark.betweenas3.tweens.ITween;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
//	import starling.display.GraphicsLine;
//	import starling.display.graphics;
//	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	public class StarlingGameRoot extends starling.display.Sprite
	{
		public var content_:DisplayObject = null;
		public var gamebackground_:Image = null;
		protected var accelerometer_:Accelerometer;
		
		private function addedToStageHandler( event:starling.events.Event ):void
		{
			Core.instance = new Core( amys_game_shared_main.real_outter_instance_.stage );
			
			SetupGameBackground();
			
			Core.mStarling.nativeOverlay.addChild( Core.instance  );
			
			/*
			new feathers.themes.MetalWorksMobileTheme();
			var button:Button = new Button();
			button.label = "Click Me";
			button.x = 200;
			button.y = 150;
			this.addChild( button );
			*/
		}		
		
		public function StarlingGameRoot()
		{
			super();
			
			Core.starlingRoot = this;
			
			addEventListener( starling.events.Event.ADDED_TO_STAGE, addedToStageHandler );
			
			assets.starling_PrepareAssetManager();
			
			visible = true;
		}
		
		// --------------------------------------------------------------------
		
		protected var _loadingOverlay:starling.display.Image;
		protected var _placeholderOverlay:flash.display.Bitmap;
		protected var loading_done_Tween_:ITween = null;
		protected var _loading_has_started_game:Boolean = false;
//		protected var _loading_tween_done_called:Boolean = false;
		
		protected function LaunchGameIfNotLaunched():void
		{
			if ( !_loading_has_started_game )
			{
				_loading_has_started_game = true;
				
				Core.instance.ReallyStartNow();
			}
		}

		/*
		protected function LoadingDoneTweenDone():void
		{
			if ( LoadingDoneTweenDone )
			{
				if ( flash.system.Capabilities.isDebugger ) trace("Already done ignoring repeated call");
				
				return;
			}
			
			_loading_tween_done_called = true;
			
			if ( flash.system.Capabilities.isDebugger ) trace("LoadingDoneTweenDone ->");
			
//			loading_done_Tween_.stop();
			loading_done_Tween_ = null;
			
			_loadingOverlay.removeFromParent(true);
			_loadingOverlay = null;
			
			if ( flash.system.Capabilities.isDebugger ) trace("<- LoadingDoneTweenDone");

		}
		*/
		
		protected function __LaunchTweenComplete__( e:TweenEvent = null ):void
		{
			loading_done_Tween_.removeEventListener(TweenEvent.COMPLETE, LaunchTweenComplete);
			_loadingOverlay.removeFromParent(true);
			_loadingOverlay = null;
			loading_done_Tween_ = null;
			LaunchGameIfNotLaunched();
		}

		protected function LaunchTweenComplete( e:TweenEvent = null ):void
		{
			
//			if ( flash.system.Capabilities.isDebugger ) trace("-> LaunchTweenComplete");
			
			__LaunchTweenComplete__( e );
			
//			if ( flash.system.Capabilities.isDebugger ) trace("<- LaunchTweenComplete");
			
		}
		
		protected function RemovePlaceholderOverlay():void
		{
			_placeholderOverlay.parent.parent.removeChild( _placeholderOverlay.parent );
			
			_placeholderOverlay = null;
		}

		public function HandleLoadingOverlayFade( placeholder:flash.display.Bitmap ):void
		{
			
//			if ( flash.system.Capabilities.isDebugger ) trace("HandleLoadingOverlayFade ->");
			
			__HandleLoadingOverlayFade__( placeholder );
			
//			if ( flash.system.Capabilities.isDebugger ) trace("<- HandleLoadingOverlayFade");
			
		}
		
		public function __HandleLoadingOverlayFade__( placeholder:flash.display.Bitmap ):void
		{
			_placeholderOverlay = placeholder;
			
			_loadingOverlay = starling.display.Image.fromBitmap( placeholder );
			_loadingOverlay.alignPivot();
			
			_loadingOverlay.scaleX = placeholder.scaleX;
			_loadingOverlay.scaleY = placeholder.scaleY;
			_loadingOverlay.x = Core.canvas_x_center;
			_loadingOverlay.y = Core.canvas_y_center;
			
			addChild( _loadingOverlay );
			
			loading_done_Tween_ = BetweenAS3.serial(
				BetweenAS3.func( RemovePlaceholderOverlay ),
				BetweenAS3.serial(
					BetweenAS3.tween( gamebackground_, {alpha:1}, null, 1.5, Sine.easeIn ),
					BetweenAS3.serial(
						BetweenAS3.tween( _loadingOverlay, {scaleX:4,scaleY:4,alpha:0,rotation:Math.PI}, null, 2, Sine.easeOut ),
						BetweenAS3.func( LaunchGameIfNotLaunched )
					)
				),
				BetweenAS3.func( LaunchGameIfNotLaunched )
			);
			
			loading_done_Tween_.stopOnComplete = true;
			loading_done_Tween_.addEventListener( TweenEvent.COMPLETE, LaunchTweenComplete );
			loading_done_Tween_.play();
		}
		
		// --------------------------------------------------------------------
		
		protected var background_overscroll_area:Number = 0.1;
		
		protected var background_scroll_x:Number = 0.0;
		protected var background_scroll_y:Number = 0.0;
		protected var background_scroll_x_min:Number = 0.0;
		protected var background_scroll_x_max:Number = 0.0;
		protected var background_scroll_y_min:Number = 0.0;
		protected var background_scroll_y_max:Number = 0.0;
		
		protected function onAccelerometerUpdate( evt:AccelerometerEvent ):void
		{
			var amplify:Number = 15.0;
			background_scroll_x = Math.max( background_scroll_x_min, Math.min( background_scroll_x - evt.accelerationX*amplify, background_scroll_x_max ) );
			background_scroll_y = Math.max( background_scroll_y_min, Math.min( background_scroll_y + evt.accelerationY*amplify, background_scroll_y_max ) );
		}
		
		protected function SetupGameBackground():void
		{
			gamebackground_ = new Image( assets.starling_GetTextureForAsset( "gamebackground" ) );
			
			gamebackground_.alignPivot();
			
			gamebackground_.alpha = 0;
			
			gamebackground_.x = Core.canvas_x_center;
			gamebackground_.y = Core.canvas_y_center;
			
			gamebackground_.scaleX = Math.max( Core.canvas_width, Core.canvas_height ) / (gamebackground_.width * (1.0 - background_overscroll_area));
			gamebackground_.scaleY = gamebackground_.scaleX;
			
			addChild( gamebackground_ );
			
			background_scroll_x_max = (gamebackground_.width * background_overscroll_area) * 0.25;
			background_scroll_x_min = -background_scroll_x_max; 
			
			background_scroll_y_max = (gamebackground_.height * background_overscroll_area) * 0.25;
			background_scroll_y_min = -background_scroll_y_max; 
			
			if ( Accelerometer.isSupported )
			{
				accelerometer_ = new Accelerometer();
				
				accelerometer_.addEventListener( AccelerometerEvent.UPDATE, onAccelerometerUpdate );
				
				addEventListener( starling.events.Event.ENTER_FRAME, onEnterFrameForAccelerometerScroll);
			}
			
			/*			
			var s:Shape = new Shape();
			s.graphics.beginFill(0xff7b00);
			s.graphics.drawRoundRectComplex( 0, 110, 430, 100, 0, 20, 40, 80 );
			s.graphics.endFill();			
			addChild(s);
			*/
			
		}
		
		protected function onEnterFrameForAccelerometerScroll( e ):void
		{
			
/*
if ( !Accelerometer.isSupported )
{
	background_scroll_x = Math.max( background_scroll_x_min, Math.min( background_scroll_x + (Main.canvas_x_center - Main.instance.mouseX), background_scroll_x_max ) );
	background_scroll_y = Math.max( background_scroll_y_min, Math.min( background_scroll_y + (Main.instance.mouseY - Main.canvas_y_center), background_scroll_y_max ) );
}
*/
			
			var blend:Number = 0.00125 * 4.0;
			gamebackground_.x += ((Core.canvas_x_center + background_scroll_x) - gamebackground_.x) * blend;
			gamebackground_.y += ((Core.canvas_y_center + background_scroll_y) - gamebackground_.y) * blend;
		}
		
		// --------------------------------------------------------------------
		
		public function ShowContent( bShow:Boolean ):void
		{
			if ( null != content_ ) content_.visible = bShow;
		}
		
		public function SetContent( content:DisplayObject ):void
		{
			if ( null != content_ ) content_.removeFromParent( true );
			
			content_ = content;
			
			if ( null != content_ ) addChild( content_ );
		}
		
		// --------------------------------------------------------------------
		
		static protected var registered_collective:Boolean = false;
		
		static protected var enter_frame_handlers_:Dictionary = new Dictionary( true );
		
		static protected var processing:Vector.<IActSomethingtLikeAMovieClipFromAS2> = new Vector.<IActSomethingtLikeAMovieClipFromAS2>();
		
		static protected function COLLECTIVE_ENTER_FRAME_HANDLER( e ):void
		{
			if ( (null == Core.starlingRoot.content_ ) || (!Core.starlingRoot.content_.visible) ) {
				return;
			}
			
			var who:IActSomethingtLikeAMovieClipFromAS2;
			
			for each ( who in enter_frame_handlers_ )
			{
				processing.push( who );
			}
			
			for each ( who in processing )
			{
				who.callClosure_( null );
			}
			
			// if ( 0 != processing.length ) trace( "calls = " + processing.length );
			
			processing.length = 0;
		}
		
		static public function REGISTER_ENTER_FRAME_LISTENER( who:IActSomethingtLikeAMovieClipFromAS2 ):void
		{
			if ( !registered_collective )
			{
				registered_collective = true;
				
				//Main.instance.addEventListener( Event.ENTER_FRAME, COLLECTIVE_ENTER_FRAME_HANDLER, false, 0, true );
				Core.starlingRoot.addEventListener( starling.events.Event.ENTER_FRAME, COLLECTIVE_ENTER_FRAME_HANDLER );
			}
			
			enter_frame_handlers_[ who ] = who;
		}
		
		static public function REMOVE_ENTER_FRAME_LISTENER( who:IActSomethingtLikeAMovieClipFromAS2 ):void
		{
			delete enter_frame_handlers_[ who ];
		}
		
	}
}