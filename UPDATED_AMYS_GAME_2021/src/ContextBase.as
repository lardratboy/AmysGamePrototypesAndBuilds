package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.tweens.ITween;
	
	// ------------------------------------------------------------------------
	
	/**
	 * ...
	 * @author BPT
	 */
	public class ContextBase extends Sprite
	{
		//protected var effects_layer_:Sprite;
		
		protected var display_Tween_:ITween = null;
		protected var dismiss_Tween_:ITween = null;
		protected var transition_duration_:Number = 0.25;
				
		public function ContextBase() 
		{
			//effects_layer_ = new Sprite();
			//addChild( effects_layer_ );
			
			if (stage) init();
			else addEventListener( Event.ADDED_TO_STAGE, init, false, 0, true );
		}
		
		protected function AdjustScaleToFitScreen():void
		{
			return ;
			
			var borderFactor:Number = 0.95;
			
			var xContentFactor:Number = this.width / (Core.canvas_width*borderFactor); 
			var yContentFactor:Number = this.height / (Core.canvas_height*borderFactor);
			var biggestFactor:Number = Math.max( xContentFactor, yContentFactor );
			
			if ( 1.0 < biggestFactor )
			{
				this.scaleX = this.scaleY = 1.0 / biggestFactor;
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Create();
			
			addEventListener( Event.ADDED_TO_STAGE, reinit, false, 0, true );
			
			reinit( null );
		}
		
		// --------------------------------------------------------------------
		
		protected function XOriginOffset():int
		{
			return 0;
		}
		
		protected function YOriginOffset():int
		{
			return 0;
		}
		
		// --------------------------------------------------------------------
		
		/*
		
		protected function AddFallingPiece_( px:int, py:int ):void
		{
			var spr:Sprite = assets.SpriteWrapper( "original_pieces_" + (int)( Math.random() * 10 + 1 ) );
			
			spr.x = px;
			spr.y = py;
			
			effects_layer_.addChild( spr );
			
			var tween:ITween = BetweenAS3.serial(
					BetweenAS3.tween( spr, {y:Main.canvas_height*1.25}, null, 0.3, Sine.easeIn ),
					BetweenAS3.func( effects_layer_.removeChild, [ spr ] ) );
					
			tween.play();
			
			trace( spr );
		}

		protected function OnMouseMove( e:MouseEvent ):void
		{
			AddFallingPiece_( effects_layer_.mouseX, effects_layer_.mouseY );
		}
		
		protected var pt_:Point = new Point();
		
		protected function AddFallingPieceMultiTouch( e:TouchEvent ):void
		{
			pt_.x = e.stageX;
			pt_.y = e.stageY;
			
			effects_layer_.globalToLocal( pt_ );
			
			AddFallingPiece_( pt_.x, pt_.y );
			
		}
		
		protected function onTouchBegin( e:TouchEvent ):void
		{
			AddFallingPieceMultiTouch( e );
		}
		
		protected function onTouchMove( e:TouchEvent ):void
		{
			AddFallingPieceMultiTouch( e );
		}
		
		protected function onTouchEnd( e:TouchEvent ):void
		{
		}
		
		protected function SetupBackgroundInteractionFun():void
		{
			if ( 1 >= Multitouch.maxTouchPoints )
			{
				effects_layer_.stage.addEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true );
			}
			else
			{
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				effects_layer_.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, false, 0, true);
				effects_layer_.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove, false, 0, true);
				effects_layer_.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd, false, 0, true);
			}
		}
		
		protected function ShutdownBackgroundInteractionFun():void
		{
			if ( 1 >= Multitouch.maxTouchPoints )
			{
				effects_layer_.stage.removeEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove );
			}
			else
			{
				effects_layer_.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				effects_layer_.stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
				effects_layer_.stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			}
		}
		
		*/
		
		// --------------------------------------------------------------------
		
		protected function EnableButtons( b:Boolean ):void
		{
			/*
			if ( b )
			{
				SetupBackgroundInteractionFun();
			}
			else
			{
				ShutdownBackgroundInteractionFun();
			}
			*/
		}
		
		protected function reinit(e:Event):void
		{
			AdjustScaleToFitScreen();
			
			if ( null == display_Tween_ )
			{
				display_Tween_ = BetweenAS3.serial(
					BetweenAS3.tween( this, {y:YOriginOffset(),x:XOriginOffset()}, {y:YOriginOffset()-height*1.25,x:XOriginOffset()}, transition_duration_, Sine.easeOut ),
					BetweenAS3.func( EnableButtons, [ true ] ) );
			}
				
			display_Tween_.play();
		}
		
		// --------------------------------------------------------------------
		
		protected function OffscreenNowRemoveFromParent():void
		{
			parent.removeChild( this );
		}
		
		public function Dismiss():void
		{
			EnableButtons( false );
			
			if ( null == dismiss_Tween_ )
			{
				var duration:Number = 0.25;
				
				dismiss_Tween_ = BetweenAS3.serial(
					BetweenAS3.tween( this, { y:YOriginOffset()+height*1.25,x:XOriginOffset() }, {x:XOriginOffset()}, transition_duration_, Sine.easeOut ),
					BetweenAS3.func( OffscreenNowRemoveFromParent ) );
			}
				
			dismiss_Tween_.play();
		}
		
		protected function Create():void
		{
		}
		
	}

}


	


