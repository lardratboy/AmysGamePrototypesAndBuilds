package bpt.ui.button
{
	import flash.display.DisplayObject;
	import flash.display.Screen;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.System;
	import flash.ui.Multitouch;

	/**
	 * ...
	 * @author bpt
	 */
	public class SimplisticButton extends Sprite
	{
		// --------------------------------------------------------------------
		
		protected static var use_mouse_events:Boolean = true;
		
		protected static var button_that_has_focus:SimplisticButton = null;
		protected var activeState:DisplayObject = null;
		
		protected var upState_:DisplayObject;
		public function get upState():DisplayObject { return upState_; }
		public function set upState( value:DisplayObject ):void { upState_ = value; SyncState(); }

		protected var downState_:DisplayObject;
		public function get downState():DisplayObject { return downState_; }
		public function set downState( value:DisplayObject ):void { downState_ = value; SyncState(); }

		protected var overState_:DisplayObject;
		public function get overState():DisplayObject { return overState_; }
		public function set overState( value:DisplayObject ):void { overState_ = value; SyncState(); }
		
		protected var buttonDown:Boolean = false;
		protected var enabled:Boolean = true;
		
		protected var bUseVisibilityInsteadOfDetachment:Boolean = true;
		
		// --------------------------------------------------------------------
		
		protected var hidden_hit_helper_:Sprite/*Shape*/;
		
		protected function RebuildHitArea():void
		{
			var cxOverScale:Number = 0.075;
			var cyOverScale:Number = 0.075;
			
			var ocx:Number = overState.width; 
			var ocy:Number = overState.height;
			
			var cx:Number = ocx * (1.0 + (2.0 * cxOverScale)) + 0.5;
			var cy:Number = ocy * (1.0 + (2.0 * cyOverScale)) + 0.5;
			
			var bRebuild:Boolean = true;

			if ( null != hidden_hit_helper_ )
			{
				bRebuild = ((cx > hidden_hit_helper_.width) || (cy > hidden_hit_helper_.height));
				if ( bRebuild ) removeChild( hidden_hit_helper_ );
			}
			
			if ( bRebuild )
			{
				hidden_hit_helper_ = new Sprite();
				hidden_hit_helper_.graphics.lineStyle(0, 0, 0);
				hidden_hit_helper_.graphics.beginFill(0, 1);
				hidden_hit_helper_.mouseEnabled = true;
				
				hidden_hit_helper_.graphics.drawRect(
					-cx/2, //-(cx - overState.width)/4,
					-cy/2, //-(cy - overState.height)/4,
					cx,
					cy );
				
				hidden_hit_helper_.graphics.endFill();
				
				addChild( hidden_hit_helper_ );
				hidden_hit_helper_.alpha = 0;
				
				hidden_hit_helper_.x = 0; ///*overState.x*/ - hidden_hit_helper_.width/2;
				hidden_hit_helper_.y = 0; ///*overState.y*/ - hidden_hit_helper_.height/2;
			}
		}
		
		// --------------------------------------------------------------------
		
		public function SimplisticButton( _upState:DisplayObject = null, _overState:DisplayObject = null, _downState:DisplayObject = null ) 
		{
			//opaqueBackground = 0x0FF00FF; // use this to show tap area
			
			super();
			
			mouseChildren = true;
			
			upState = _upState;
			overState = _overState;
			downState = _downState;
			
			// ---------------------------------------------------------------
			
			if ( bUseVisibilityInsteadOfDetachment )
			{
				addChild( downState );
				downState.alpha = 0;
				
				addChild( overState );
				overState.alpha = 0;
				
				addChild( upState );
				overState.alpha = 0;
			}
			
			RebuildHitArea();
			
			addEventListener( Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true );
		}
		
		public function Enable( b:Boolean = true ):void
		{
			mouseEnabled = b;
			enabled = b;
			SyncState();
		}
		
		public function SyncState():void
		{
			if ( buttonDown )
			{
				SetActiveState( downState );
			}
			else
			{
				SetActiveState( upState ); // BUG.BUG.BUG - does not handle over state properly!
			}
		}
		
		private function OnTap( e:TouchEvent ):void
		{
			if ( enabled )
			{
				dispatchEvent( new MouseEvent( MouseEvent.CLICK, true, true ) );
			}
		}
		
		private function OnAddedToStage( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, OnAddedToStage );

			SetActiveState( upState );
			
			if ( Multitouch.supportsTouchEvents )
			{
				addEventListener( TouchEvent.TOUCH_TAP, OnTap, false, 0, true );
			}
			
			if ( use_mouse_events || (!Multitouch.supportsTouchEvents) )
			{
				stage.addEventListener( MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true );
				addEventListener( MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true );
				addEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OVER, OnMouseOver, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true );
			}
			
			addEventListener( Event.REMOVED_FROM_STAGE, OnRemovedFromStage, false, 0, true );
		}
		
		private function OnRemovedFromStage( e:Event ):void
		{
			//trace( "removed from stage" + this );
			
			if ( Multitouch.supportsTouchEvents )
			{
				removeEventListener( TouchEvent.TOUCH_TAP, OnTap );
			}
			
			if ( use_mouse_events || (!Multitouch.supportsTouchEvents) )
			{
				stage.removeEventListener( MouseEvent.MOUSE_UP, OnMouseUp );
				removeEventListener( MouseEvent.MOUSE_UP, OnMouseUp );
				removeEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown );
				removeEventListener( MouseEvent.MOUSE_OVER, OnMouseOver );
				removeEventListener( MouseEvent.MOUSE_OUT, OnMouseOut );
			}
			
			addEventListener( Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true );
		}
		
		private function SetActiveState( state:DisplayObject ):void
		{
			if ( activeState != state )
			{
				if ( null != activeState )
				{
					if ( bUseVisibilityInsteadOfDetachment )
					{
						activeState.alpha = 0;
					}
					else
					{
						removeChild( activeState );
					}
				}
				
				if ( null != state )
				{
					if ( bUseVisibilityInsteadOfDetachment )
					{
						state.alpha = 1;
					}
					else
					{
						addChild( state );
					}
				}
				
				activeState = state;
			}
			
			if ( null != activeState )
			{
				activeState.alpha = enabled ? 1 : 0.25;
			}
		}
		
		private function OnMouseUp( e:MouseEvent ):void
		{
			if ( !enabled ) return;
			//if ( (null == stage) ) trace( "not on stage and still getting mouse up calls? " + this );
			
			if ( buttonDown ) e.stopPropagation();

			if ( (activeState == e.target) && (this == button_that_has_focus) )
			{
				dispatchEvent( new MouseEvent( MouseEvent.CLICK, true, true ) );
			}

			if ( this == button_that_has_focus )
			{
				button_that_has_focus = null;
			}
			
			buttonDown = false;
			SetActiveState( upState );
		}
		
		private function OnMouseDown( e:MouseEvent ):void
		{
			if ( !enabled ) return;
			//if ( (null == stage) ) trace( "not on stage and still getting mouse down calls? " + this );
			
			button_that_has_focus = this;
			e.stopPropagation();
			buttonDown = true;
			SetActiveState( downState );
		}

		private function OnMouseOver( e:MouseEvent ):void
		{
			if ( !enabled ) return;
			//if ( (null == stage) ) trace( "not on stage and still getting mouse over calls? " + this );
			
			if ( this == button_that_has_focus )
			{
				if ( buttonDown ) e.stopPropagation();
				
				SetActiveState( buttonDown ? downState : overState );
			}
			else
			{
				SetActiveState( (null == button_that_has_focus) ? overState : upState );
			}
		}
		
		private function OnMouseOut( e:MouseEvent ):void
		{
			if ( !enabled ) return;
			//if ( (null == stage) ) trace( "not on stage and still getting mouse out calls? " + this );
			
			if ( buttonDown )
			{
				e.stopPropagation();
			}
			
			SetActiveState( upState );
		}
	}

}