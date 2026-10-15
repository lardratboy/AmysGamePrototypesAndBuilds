package bpt.game
{
	
	import flash.system.Capabilities;
	
	import assets;
	
	import bpt.game.BaseGameSprite;
	import bpt.game.IActSomethingtLikeAMovieClipFromAS2;
	import bpt.game.StarlingGameRoot;
	import bpt.game.onEnterFrame_Ref;
	import bpt.util.Allocator;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class GameSprite_Ref extends BaseGameSprite implements IActSomethingtLikeAMovieClipFromAS2
	{
		protected var _resource_asset_:String = null;
		protected var _display_object_resource_:DisplayObject = null;
		
		//public var _parent:GameSprite_Ref = null;
		
		public function GameSprite_Ref() 
		{
			super();
			
			touchable = false;
			
			/*flash*/ //this.mouseChildren = false;
			/*flash*/ //this.mouseEnabled = false;
			
//			this.addEventListener( Event.ADDED_TO_STAGE, DIAGNOSTIC_OnAddedToStage, false, 0, true );
//			this.addEventListener( Event.REMOVED_FROM_STAGE, DIAGNOSTIC_OnRemovedFromStage, false, 0, true );
		}
		
		// ====================================================================
		
		/*
		
		private function DIAGNOSTIC_OnEnterFrame(e:Event):void
		{
//			trace( _name + " @ " + x + ", " + y );
		}
		
		private function DIAGNOSTIC_OnAddedToStage( e:Event ):void
		{
			trace( this + " addedToStage" );
			
			this.removeEventListener( Event.ADDED_TO_STAGE, DIAGNOSTIC_OnAddedToStage );
			
			this.addEventListener( Event.ENTER_FRAME, DIAGNOSTIC_OnEnterFrame, false, 0, true );
		}
		
		private function DIAGNOSTIC_OnRemovedFromStage( e:Event ):void
		{
			trace( this + " removedFromStage" );
			
			this.removeEventListener( Event.ENTER_FRAME, DIAGNOSTIC_OnEnterFrame );
		}
		
		*/
		
		// ----------------
		
		public function adoptChildAtDepth( child:GameSprite_Ref, depth:int ):void
		{
			child._parent = this;
			addChild( child );
		}
		
		// ----------------
		
		private function replaceOrCreateChildAtDepth( name:String, depth:int ):GameSprite_Ref
		{
			var child:GameSprite_Ref = new GameSprite_Ref();
			
			adoptChildAtDepth( child, depth );
			
			child._name = name;
			
			return child;
		}
		
		public function AdoptAsResourceAttachment( instance:DisplayObject, resource:String ):void
		{
			releaseResource();

			_resource_asset_ = resource;
			
			_display_object_resource_ = instance;
			
			addChild( _display_object_resource_ );
		}
		
		protected function HandleResourceAttachment( child:GameSprite_Ref, resource:String ):void
		{
			child.AdoptAsResourceAttachment( GetReusableDisplayObject( resource ), resource );
		}
		
		public function attachMovie( resource:String, name:String, depth:int ):GameSprite_Ref
		{
			var child:GameSprite_Ref = replaceOrCreateChildAtDepth( name, depth );
			
			HandleResourceAttachment( child, resource );

			return child;
		}

		public function createEmptyMovieClip( name:String, depth:int ):GameSprite_Ref
		{
			return replaceOrCreateChildAtDepth( name, depth );
		}
		
		protected function releaseResource():void
		{
			if ( null != _display_object_resource_ )
			{
				ReleaseReusableDisplayObject( _resource_asset_, _display_object_resource_ );
				
				var r:DisplayObject = _display_object_resource_;
				
				_display_object_resource_ = null;
				
				_resource_asset_ = null;
				
				removeChild( r );
			}
		}
		
		public function removeMovieClip():void
		{
			if ( parent ) parent.removeChild( this );
			
			releaseResource();
			
			onEnterFrame = null;
			
			// --------------------------------------------------------------------
			
			if ( 0 < this.numChildren )
			{
				var movieClipLikeChildren:Vector.<IActSomethingtLikeAMovieClipFromAS2> = new Vector.<IActSomethingtLikeAMovieClipFromAS2>();
				
				for ( var i:int = 0; i < numChildren; ++i )
				{
					var d:DisplayObject = getChildAt( i );
					
					var mc:IActSomethingtLikeAMovieClipFromAS2 = d as IActSomethingtLikeAMovieClipFromAS2;
					
					if ( null != mc )
					{
						movieClipLikeChildren.push( mc );
					}
					
				}
				
				while ( movieClipLikeChildren.length )
				{
					var who:IActSomethingtLikeAMovieClipFromAS2 = movieClipLikeChildren.pop();
					
			//trace( "disposing \'" + who._name + "\'" );
					
					who.removeMovieClip();
				}
				
				removeChildren(); // remove anything else not accounted for by the above
			}
			
			// --------------------------------------------------------------------
			
			
			_parent = null;
		
		}
		
		public function getNextHighestDepth():int
		{
			return this.numChildren; // + 1;
		}
		
		// --------------------------------------------------------------------
		
		protected function finalize_X_scale( value:Number ):Number
		{
			return value;
		}
		
		protected function finalize_Y_scale( value:Number ):Number
		{
			return value;
		}
		
		// ====================================================================
		include "FakeAS2MovieClip.as.impl"
		// ====================================================================
		
	}
}
