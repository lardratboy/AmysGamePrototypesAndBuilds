package  
{
	import bpt.game.gamemain;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Sprite;
	import bpt.ui.button.SimplisticButton;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Elastic;
	import org.libspark.betweenas3.easing.Linear;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.tweens.ITween;
	import ScaledAssetButton;
	
	// ------------------------------------------------------------------------
	
	/**
	 * ...
	 * @author BPT
	 */
	public class Menu extends Sprite
	{
		protected var amys_game_logo_:SpringySprite = null;
		protected var play_button_:MenuButton = null;
		protected var how_to_play_button_:MenuButton = null;
		protected var statistics_button_:MenuButton = null;
		protected var story_button_:MenuButton = null;
		protected var settings_button_:MenuButton = null;
		protected var exit_icon_button:SimplisticButton = null;
		protected var exit_button:SimplisticButton = null;
		protected var springy_pieces:Vector.<SpringySprite> = new Vector.<SpringySprite>();
		protected var dismissTween_:ITween;
		protected var supportExitButton:Boolean = false;
		
		public function Menu() 
		{
			if (stage) init();
			else addEventListener( Event.ADDED_TO_STAGE, init, false, 0, true );
		}
		
		private function init(e:Event = null):void
		{
			// ------------------------------------------------------------------
			
			trace("BUGBUG - find out why music is not playing...." );
			sound_assets.PlaySound( "music_ambient" );

			// ------------------------------------------------------------------
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			CreateButtons();
			
			addEventListener( Event.ADDED_TO_STAGE, reinit, false, 0, true );
			
			reinit( null );
		}
		
		// --------------------------------------------------------------------
		
		private function EnableButtons( b:Boolean ):void
		{
			play_button_.Enable( b );
			how_to_play_button_.Enable( b );
			statistics_button_.Enable( b );
			story_button_.Enable( b );
			
			if ( supportExitButton )
			{
				exit_icon_button.Enable( b );
				exit_button.Enable( b );
			}
		}
		
		private function reinit(e:Event):void
		{
			x = 0;
			y = 0;
			
			EnableButtons( true );
		}
		
		// --------------------------------------------------------------------
		
		private function OffscreenNowRemoveFromParent():void
		{
			parent.removeChild( this );
		}
		
		public function Dismiss():void
		{
			EnableButtons( false );
			
			if ( null == dismissTween_ )
			{
				var duration:Number = 0.25;
				
				dismissTween_ = BetweenAS3.serial(
					BetweenAS3.tween( this, { y: height }, null, duration, Sine.easeIn ),
					BetweenAS3.func( OffscreenNowRemoveFromParent ) );
			}
				
			dismissTween_.play();
		}
		
		// --------------------------------------------------------------------
		
		private function OnPlayButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			Core.instance.NewGameBoard();
			// Main.instance.GotoBetweenLevelPanel( "" );
		}
		
		private function OnHowToPlayButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			Dismiss();
			
			Core.instance.GotoHowToPlay( this );
		}
		
		private function OnStatisticsButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			Dismiss();
			
			Core.instance.GotoStatistics( this );
		}
		
		private function OnStoryButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			Dismiss();
			
			Core.instance.GotoStory( this );
		}
		
		private function OnExitButton( e:MouseEvent ):void
		{
			Core.instance.Exit();
		}
		
		private function OnSettingsButton( e:MouseEvent ):void
		{
			//sound_assets.PlaySound( "sfx_slot_stop" );
			
			Dismiss();
			
			Core.instance.GotoSettings( null );
		}
		
		// --------------------------------------------------------------------
		
		private function WaitDelay( order:int ):Number
		{
			return order * 0.125;
		}
		
		// --------------------------------------------------------------------
		
		private function CreateButtons():void
		{
			var delay:Number = 0;
			
			// ----------------------------------------------------------------
			
			var big_button_border_cx:int = assets.GetWidth( "big_original_pieces_1" ) / 2;
			var big_button_border_cy:int = big_button_border_cx;
			
			var divisions:Number = 4.5;
			
			var cx:Number = Core.canvas_width / divisions;
			var bx:Number = cx - cx / (int)(divisions);
			
			var cy:Number = Core.canvas_height / divisions;
			var by:Number = cy - cy / (int)(divisions);
			
			play_button_ = new MenuButton(
				"play_button",
				//(int)(bx + (cx * 0)), (int)(by + (cy * 0)),
				big_button_border_cx, big_button_border_cy, 
				WaitDelay( delay++ ),
				OnPlayButton,
				assets.SpriteWrapper( "big_original_pieces_1" ) );
				
			addChild( play_button_ );
			
			how_to_play_button_ = new MenuButton(
				"how_to_play_button",
				//(int)(bx + (cx * 3)), (int)(by + (cy * 0)), // (int)(bx + (cx * 1)), (int)(by + (cy * 1))
				Core.canvas_width - big_button_border_cx, big_button_border_cy, 
				WaitDelay( delay++ ),
				OnHowToPlayButton,
				assets.SpriteWrapper( "big_original_pieces_2" ) );
				
			addChild( how_to_play_button_ );

			statistics_button_ = new MenuButton(
				"statistics_button",
				//(int)(bx + (cx * 0)), (int)(by + (cy * 3)), // (int)(bx + (cx * 2)), (int)(by + (cy * 2))
				big_button_border_cx, Core.canvas_height - big_button_border_cy, 
				WaitDelay( delay++ ),
				OnStatisticsButton,
				assets.SpriteWrapper( "big_original_pieces_5" ) );
				
			addChild( statistics_button_ );
			
			//PERFORMANCE_TEST();
			
			story_button_ = new MenuButton(
				"story_button",
				//(int)(bx + (cx * 3)), (int)(by + (cy * 3)),
				Core.canvas_width - big_button_border_cx, Core.canvas_height - big_button_border_cy, 
				WaitDelay( delay++ ),
				OnStoryButton,
				assets.SpriteWrapper( "big_original_pieces_3" ) );
				
			addChild( story_button_ );
			
			// ----------------------------------------------------------------

			var customize:ScaledAssetButton = new ScaledAssetButton( "settings_panel_banner" );
			customize.addEventListener( MouseEvent.CLICK, OnSettingsButton );
			
			settings_button_ = new MenuButton(
				"settings_icon",
				//Main.canvas_x_center, (int)(by + (cy * 3)), // (int)(bx + (cx * 2)), (int)(by + (cy * 2))
				Core.canvas_x_center, Core.canvas_height - big_button_border_cy, 
				WaitDelay( delay++ ),
				OnSettingsButton,
				customize,
				false );
				
			customize.y = settings_button_.height;
			
			addChild( settings_button_ );
			
			// ----------------------------------------------------------------
			
			/*
			if ( supportExitButton )
			{
				exit_icon_button = new ScaledAssetButton( "exit_icon" );
				exit_icon_button.x = 65;
				exit_icon_button.y = 637;
				addChild( exit_icon_button );
				exit_icon_button.addEventListener( MouseEvent.CLICK, OnExitButton );
				
				exit_button = new ScaledAssetButton( "exit_button" );
				exit_button.x = exit_icon_button.x;
				exit_button.y = exit_icon_button.y + exit_icon_button.height + 5;
				addChild( exit_button );
				exit_button.addEventListener( MouseEvent.CLICK, OnExitButton );
			}
			*/
			
			// ----------------------------------------------------------------
			
			var logo_w:int = assets.GetWidth( "amys_game_logo" );
			var logo_h:int = assets.GetHeight( "amys_game_logo" );
			var item_w:int = assets.GetWidth( "original_pieces_1" );
			var item_h:int = assets.GetWidth( "original_pieces_1" );
			
			var logo_x:int = Core.canvas_width / 2;
			var logo_y:int = Core.canvas_height / 2;
			
			logo_y -= item_h;
			
			var springy:SpringySprite;
			
			var i:int;
			
			var offset_x:int = (logo_w - (item_w * 7)) / 2 + item_w/2;
			
			// trace( offset_x );
			
			for ( i = 1; i <= 7; ++i )
			{
				springy = new SpringySprite(
					offset_x + logo_x - logo_w / 2 + ((i - 1) * item_w),
					logo_y + logo_h / 2 + item_h/2 + ((0 != (i & 1)) ? 0 : item_h/2),
					WaitDelay( ++delay ) );
				
				springy.addChild( assets.SpriteWrapper( "original_pieces_" + i ) );
				
				addChild( springy );
				
				springy_pieces.push( springy );
			}
			
			// ----------------------------------------------------------------
			
			delay -= 2;
			
			for ( i = 1; i <= 7; ++i )
			{
				springy = new SpringySprite(
					offset_x + logo_x - logo_w / 2 + ((i - 1) * item_w),
					logo_y + logo_h / 2 + item_h/2 + ((0 != (i & 1)) ? 0 : item_h/2),
					WaitDelay( ++delay ) );
				
				springy.addChild( assets.SpriteWrapper( "gfx_star") );
				
				addChild( springy );
				
				springy_pieces.push( springy );
			}
			
			// ----------------------------------------------------------------
			
			// ----------------------------------------------------------------
			
			amys_game_logo_ = new SpringySprite( logo_x, logo_y, WaitDelay( delay / 3 ) );
			amys_game_logo_.addChild( assets.SpriteWrapper( "amys_game_logo" ) );
			addChild( amys_game_logo_ );
			
		}
		
		/*
		private function PERFORMANCE_TEST():void
		{
			var count:int = 500;
			
			for ( var i:int = 0; i < count; ++i )
			{
				var spr:Sprite = assets.SpriteWrapper( "original_pieces_" + Math.floor( 1 + Math.random() * 9 ));
				
				spr.x = 100 + Math.random() * (Main.canvas_width - 32);
				spr.y = 32 + Math.random() * (Main.canvas_height - 32);
				spr.mouseEnabled = false;
				
				//spr.scaleX = spr.scaleY = 0.5 + Math.random() * 1.5;
				//spr.alpha = 0.25 + Math.random() * 0.75;
				
				var r:Number = Math.random() * 360;
				var n:Number = 1 + (0.5 < (Math.random() * 1));
				
				var tween:ITween = BetweenAS3.repeat(
					BetweenAS3.tween( spr, {rotation:r+0}, {rotation:r+360*n}, Math.random() * 0.5 + 0.5, Sine.easeInOut ), 20000 );
				
				tween.play();
				
				addChild( spr );
				
			}
		}
		*/
		
	}

}

// -----------------------------------------------------------------------------

import assets;
import flash.display.Sprite;
import bpt.ui.button.SimplisticButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;
import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.easing.Bounce;
import org.libspark.betweenas3.easing.Sine;
import org.libspark.betweenas3.easing.Elastic;
import org.libspark.betweenas3.tweens.ITween;
import ScaledAssetButton;

internal class SpringySprite extends Sprite
{
	protected var xAnchor:int;
	protected var yAnchor:int;
	
	protected var xTargetPos:int;
	protected var yTargetPos:int;
	
	protected var dragging:Boolean;
	protected var delay:Number;
	
	protected var tween_:ITween;
	
	protected var sequence_number:int;
	
	public function Reset():void
	{
		x = xAnchor;
		y = yAnchor;
		
		if ( (null == tween_) || (tween_.isPlaying) )
		{
			tween_ = BetweenAS3.serial(
				BetweenAS3.delay(
					BetweenAS3.tween(
						this, {y:yTargetPos}, {y:yAnchor}, 0.25, org.libspark.betweenas3.easing.Sine.easeOut ), delay ) );
		}
		
		tween_.play();
	}
	
	public function SpringySprite( xp:int, yp:int, waitDelay:Number, sequence_number:int = -1 )
	{
		dragging = false;
		delay = waitDelay;
		
		xAnchor = xp;
		yAnchor = -256;
		
		xTargetPos = xp;
		yTargetPos = yp;
		
		x = xAnchor;
		y = yAnchor;
		
		addEventListener( Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true );
		addEventListener( Event.REMOVED_FROM_STAGE, OnRemovedFromStage, false, 0, true );
	}
	
	protected function OnAddedToStage( e:Event ):void
	{
		Reset();
	}
	
	protected function OnRemovedFromStage( e:Event ):void
	{
	}
}

internal class MenuButton extends SpringySprite
{
	protected var backdrop_:Sprite;
	protected var button_:SimplisticButton;
	
	public function MenuButton( baseAssetName:String, xPos:int, yPos:int, waitDelay:Number, click:Function, backdrop:Sprite, bUseBackdropAsHitArea:Boolean = true )
	{
		super( xPos, yPos, waitDelay );
		
		if ( null == backdrop )
		{
			backdrop_ = assets.SpriteWrapper( "item_node_base" );
		}
		else
		{
			backdrop_ = backdrop;
			backdrop_.alpha = 1.0;
		}
		
		addChild( backdrop_ );
		
		button_ = new ScaledAssetButton( baseAssetName );
		
		if ( bUseBackdropAsHitArea )
		{
			backdrop_.mouseChildren = false;
			backdrop_.mouseEnabled = false;
			button_.hitArea = backdrop_;
		}
		else
		{
			backdrop_.mouseChildren = true;
			backdrop_.mouseEnabled = true;
		}
			
		button_.addEventListener( flash.events.MouseEvent.CLICK, click, false, 0, true );
			
		addChild( button_ );
	}
	
	public function Enable( b:Boolean ):void
	{
		button_.Enable( b );
		
		Core.instance.SyncSoundButton();
		
	}
	
}
	// ------------------------------------------------------------------------
	


