package  bpt.ui.panel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author bpt
	 */
	public class PanelSprite extends Sprite
	{
		protected var _draggable:Boolean = false;
		
		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		public function set draggable( setting:Boolean ):void
		{
			_draggable = setting;
		}
		
		protected function onMouseDown( e:MouseEvent ):void
		{
			e.stopPropagation();
			
			parent.setChildIndex(this, parent.numChildren - 1 );
			
			if ( _draggable && (this == e.target) )
			{
				startDrag();
			}
		}
		
		protected function onMouseUp( e:MouseEvent ):void
		{
			if ( this == e.target )
			{
				e.stopPropagation();
				
				if ( _draggable )
				{
					stopDrag();
				}
			}
		}
		
		private var bitmap:Bitmap;
		private var data:BitmapData;
		
		public function PanelSprite( color:uint, width:int, height:int, thickness:Number = 3, ellipseWidth:Number = 21, ellipseHeight:Number = 21 ) 
		{
			super();
			
			// no vectors!
			
			data = new BitmapData( width + 2, height + 2, true, 0 );
			
			var temp:Sprite = new Sprite();
			
			var aa:Number = 1.5; // without this the corners look like crap WTF? (pixel hinting might be involved however this seems to render nicely and is easy)
			temp.graphics.lineStyle(thickness,0,1,true);
			temp.graphics.beginFill( color );
			temp.graphics.drawRoundRect( aa, aa, width - aa, height - aa, ellipseWidth, ellipseHeight );
			temp.graphics.endFill();
			
			data.draw( temp );
			temp = null;
			
			bitmap = new Bitmap( data, assets.PixelSnappingPolicy, false );
			addChild( bitmap );
			
			addEventListener( Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true );
		}
		
		private function OnAddedToStage( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, OnAddedToStage );
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true );
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, OnRemovedFromStage, false, 0, true );
		}
		
		private function OnRemovedFromStage( e:Event ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE, OnRemovedFromStage );
			removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			addEventListener( Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true );
		}
	}

}