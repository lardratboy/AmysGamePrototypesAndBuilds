package 
{
	//import com.demonsters.debugger.MonsterDebugger;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.StageOrientationEvent;
	import flash.media.SoundChannel;
	import flash.profiler.profile;
	import flash.profiler.showRedrawRegions;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.SetIntervalTimer;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import BetweenLevelPanel;
	
	import ConfirmClearStatistics;
	
	import DynamicTextHolder;
	
	import HowToPlay;
	
	import LargePanelBase;
	
	import PausePanel;
	
	import QuickNoMovesContext;
	
	import SettingsPanel;
	
	import Statistics;
	
	import StoryOfGame;
	
	import assets;
	
	import bpt.Helpers;
	import bpt.game.SFX_Ref;
	import bpt.game.StarlingGameRoot;
	import bpt.game._global;
	import bpt.game.game_state;
	import bpt.game.gamemain;
	import bpt.ui.button.SimplisticButton;
	
	import font_assets;
	
	import net.hires.debug.Stats;
	
	import sound_assets;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class Core extends Sprite 
	{
		static public var mStarling:starling.core.Starling;
		static public var starlingRoot:StarlingGameRoot;
		static public var instance:Core;
		static public var iOSHost:Boolean;
		
		public var game_:gamemain;
		protected var menu_:Menu;
		protected var sound_on_button:ScaledAssetButton;
		protected var sound_off_button:ScaledAssetButton;
		protected var in_game_menu_button:ScaledAssetButton;
		protected var how_to_play_:HowToPlay;
		protected var story_of_game_:StoryOfGame;
		protected var statistics_:Statistics;
		protected var betweenLevelPanel_:BetweenLevelPanel;
		protected var noMovesContext_:ContextBase;
		protected var roundClearPanel_:RoundClearPanel;
		protected var pausePanel_:PausePanel;
		protected var settingsPanel_:SettingsPanel;
		protected var confirmResetStats_:ConfirmClearStatistics;
		protected var asset_info_panel_:AssetInfoPanel;
		protected var back_restore_object_stack:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		protected var date_:Date;
		protected var dynamic_date_display_:DynamicTextHolder;
		protected var dynamic_date_timer_:uint;
		
		static public var canvas_width:int = 1024;
		static public var canvas_height:int = 768;
		static public var canvas_x_center:int = canvas_width / 2;
		static public var canvas_y_center:int = canvas_height / 2;
		static public var panel_scale:Number = 1;
		
		// --------------------------------------------------------------------
		
		protected function DynamicScalingSetup():void
		{
			//var scale:Number = (canvas_width < 960) ? ((canvas_width < 800) ? ((canvas_width <= 480) ? 0.45 : 0.5) : 0.75) : 1;
			
			var assetScale:Number = 1;
			var pieceScale:Number = 1;
			
			if ( (1024 != canvas_width) || (768 != canvas_height) ) {
			
				pieceScale = Math.min( canvas_width / 1024.0,  canvas_height / 768.0 );
				assetScale = pieceScale + 0.05;
				
			}
			
			assets.asset_runtime_scale_factor = assetScale;
			
			_global.purgatory_stage_cx = canvas_width;
			_global.purgatory_stage_cy = canvas_height;
			
			_global.purgatory_piece_normal_cx *= pieceScale;
			_global.purgatory_piece_normal_cy *= pieceScale;
			_global.purgatory_piece_tight_cx *= pieceScale;
			_global.purgatory_piece_tight_cy *= pieceScale;
			
			_global.purgatory_piece_normal_cx = (_global.purgatory_piece_normal_cx + _global.purgatory_piece_tight_cx) / 2;
			_global.purgatory_piece_normal_cy = (_global.purgatory_piece_normal_cy + _global.purgatory_piece_tight_cy) / 2;
			
			if ( canvas_width < 1024 )
			{
				_global.purgatory_small_display_device = (canvas_width < 800);
				_global.purgatory_allow_big_board = (canvas_width >= 800);
				
				//panel_scale = 0.75;
			}
			else
			{
				_global.purgatory_allow_big_board = true;
			}
			
			_global.purgatory_allow_board_scaling = true;
			_global.purgatory_allow_big_board = true; // HACK
		}
		
		// --------------------------------------------------------------------
		
		/*
		protected var musicChannel_:flash.media.SoundChannel;
		
		protected function StartMusic():void
		{
			//musicChannel_ = sound_assets.PlaySound("music",int.MAX_VALUE);
			trace( "musicChannel_ = " + musicChannel_ );
		}
		*/
		
		// --------------------------------------------------------------------
		
		protected function StartLoadingResources():void
		{
			//trace("StartLoadingResources ->");
			_global.Initialize();
			
			DynamicScalingSetup();
			sound_assets.Initialize();
			//StartMusic();
			font_assets.Initialize();
			assets.Initialize();
			
			//trace("<- StartLoadingResources");
		}
		
		/*
		protected function SetupBackground():void
		{
			var bg:Bitmap = new assets.gamebackground_gfx_class();
			
			// need to determine if we should prescale or just center...
			
			//bg.x = (canvas_width - bg.width) / 2;
			//bg.y = (canvas_height - bg.height) / 2;
			//bg.alpha = 0.5;
			
			addChild( bg );
		}
		*/
		
		// --------------------------------------------------------------------
		
		protected var DIAGNOSTIC_boot_stage_orientation:String;
		protected var DIAGNOSTIC_orientation_request:String;
		protected var DIAGNOSTIC_orientation:String;
		
		/*
		protected function onResizeEvent( e:Event ):void
		{
			if ( stage.stageWidth < stage.stageHeight )
			{
				if ( true )
				{
					stage.setOrientation( DIAGNOSTIC_orientation );
				}
				else
				{
					var angle:Number = -90;
					
					if ( StageOrientation.DEFAULT == stage.orientation )
					{
						angle = 90;
					}
					
					this.x = (0 < angle) ? 0 : canvas_x_center;
					this.y = (0 < angle) ? 0 : canvas_y_center;
					
					this.rotation = angle;
					
					if ( 0 < angle )
					{
						this.x = (canvas_y_center + canvas_x_center) - ((canvas_width - canvas_height)/2);
						this.y = (canvas_x_center - canvas_y_center) - ((canvas_width - canvas_height)/2);
					}
					else
					{
						this.x = canvas_y_center - (canvas_height / 2);
						this.y = canvas_x_center + (canvas_width / 2);
					}
				}
			}
			else
			{
				this.rotation = 0;
				this.x = 0;
				this.y = 0;
			}
		}
		*/
		
		/*
		protected function onOrientationChangeEvent( e:flash.events.StageOrientationEvent ):void
		{
			DIAGNOSTIC_orientation = e.afterOrientation;
		}
		
		protected function onOrientationChangingEvent( e:flash.events.StageOrientationEvent ):void
		{
			DIAGNOSTIC_orientation_request = e.afterOrientation;
			
			if ( e.cancelable )
			{
				if ( (flash.display.StageOrientation.DEFAULT == e.afterOrientation) || (flash.display.StageOrientation.UPSIDE_DOWN == e.afterOrientation) )
				{
					e.preventDefault();
					e.stopImmediatePropagation();
				}
			}
		}
		
		protected function SetupOrientationHandlers():void
		{
			try
			{
				DIAGNOSTIC_orientation = stage.orientation;
				DIAGNOSTIC_boot_stage_orientation = DIAGNOSTIC_orientation;
			
				//this.stage.addEventListener(Event.RESIZE, onResizeEvent);
				this.stage.addEventListener(flash.events.StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChangeEvent);
				this.stage.addEventListener(flash.events.StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChangingEvent);
			}
			catch ( e:Object )
			{
			}
		}
		*/
		
		// --------------------------------------------------------------------
		
		public static function SetupCanvasSize( width:int, height:int ):void
		{
			canvas_width = width;
			canvas_height = height;
			canvas_x_center = canvas_width/2;
			canvas_y_center = canvas_height/2;
		}
		
		public function Core( s:Stage ):void 
		{
			visible = false;
			
			StartLoadingResources();
			
			//if (stage) init();
			//else 
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		static public var _global_GameState:game_state;
		
		private var stats_:Stats = null;
		
		// --------------------------------------------------------------------
		
		private var dynamic_fps_display_:DynamicTextHolder;
		private var last_frame_in_time:int = getTimer();
		private var last_frame_out_time:int = getTimer();
		private var running_avg:Number = 0;
		
		private function EnterFrame_FPS_HUD(e:Event):void
		{
			var curr_time:uint = getTimer();
			
			var frame_time:Number = last_frame_out_time - last_frame_in_time;
			
			var delta_time:Number = curr_time - last_frame_in_time;
			
			last_frame_in_time = curr_time;
			
			var fps:int = (0 != delta_time) ? (1000 / delta_time) : 0;
			
			running_avg = (running_avg + fps) * 0.5;
			
			dynamic_fps_display_.SetText( fps.toString() ); //  + "fps (code " + frame_time + " ms)" );
			dynamic_fps_display_.x = Core.canvas_width/2;
			dynamic_fps_display_.y = 2 + dynamic_fps_display_.height / 2;

			if ( (this.numChildren - 1) != getChildIndex(dynamic_fps_display_) )
			{
				removeChild( dynamic_fps_display_ );
				addChild( dynamic_fps_display_ );
			}
		}
		
		private function ExitFrame_FPS_HUD(e:Event):void
		{
			last_frame_out_time = getTimer();
		}
		
		private function Setup_FPS_HUD():void
		{
			dynamic_fps_display_ = new DynamicTextHolder();
			//dynamic_fps_display_.alpha = 0.25;
			
			addChild( dynamic_fps_display_ );
			
			stage.addEventListener(Event.ENTER_FRAME, EnterFrame_FPS_HUD);
			stage.addEventListener(Event.EXIT_FRAME, ExitFrame_FPS_HUD);
		}
		
		// --------------------------------------------------------------------

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
//			if ( flash.system.Capabilities.isDebugger ) trace("Main.INIT ->");
			
			__init__( e );
			
//			if ( flash.system.Capabilities.isDebugger ) trace("<- Main.INIT");
			
			amys_game_shared_main.ReadyEnoughToRemoveLoadingOverlayAndStart();
		}		
		
		private function __init__(e:Event = null):void 
		{
			// ----------------------------------------------------------------
	
// BPT.2014 disabling
//			try { SetupOrientationHandlers(); } catch ( e:Object ) {}
			
			//Setup_FPS_HUD();
			
			game_ = new gamemain();
			
			// ----------------------------------------------------------------
			
			_global_GameState = new game_state();
			addChild( _global_GameState );
			
			// ----------------------------------------------------------------
			
			// entry point
			
			Multitouch.inputMode = MultitouchInputMode.NONE; // .TOUCH_POINT;
			
			/*
			stage.quality = StageQuality.BEST; // .LOW;
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			*/
			
			in_game_menu_button = new ScaledAssetButton( "pause_icon" );
			in_game_menu_button.x = Core.canvas_width - in_game_menu_button.width/2;
			in_game_menu_button.y = Core.canvas_height - in_game_menu_button.height/2;
			in_game_menu_button.addEventListener( MouseEvent.CLICK, OnInGameMenu, false, 0, true );
			
			// ----------------------------------------------------------------
			
			sound_on_button = new ScaledAssetButton( "sound_on_icon" );
			sound_on_button.x = Core.canvas_width - sound_on_button.width/2;
			sound_on_button.y = sound_on_button.height/2 + (2 * assets.asset_runtime_scale_factor);
			sound_on_button.addEventListener( MouseEvent.CLICK, OnSoundToggle, false, 0, true );
			
			sound_off_button = new ScaledAssetButton( "sound_off_icon" );
			sound_off_button.x = Core.canvas_width - sound_on_button.width/2;
			sound_off_button.y = sound_on_button.height/2 + (2 * assets.asset_runtime_scale_factor);
			sound_off_button.addEventListener( MouseEvent.CLICK, OnSoundToggle, false, 0, true );
			
			SyncSoundButton();
		
			// ----------------------------------------------------------------
			
			if ( 1 <= assets.asset_runtime_scale_factor )
			{
				dynamic_date_display_ = new DynamicTextHolder();
				dynamic_date_display_.alpha = 0.25;
				dynamic_date_display_.scaleX = 0.5;
				dynamic_date_display_.scaleY = dynamic_date_display_.scaleX;
				addChild( dynamic_date_display_ );
				dynamic_date_timer_ = setInterval( UpdateClockDisplay, 1000 );
			}
			
			// ----------------------------------------------------------------
			
		}
		
		public function ReallyStartNow():void
		{
			visible = true;
			
			GotoMenu();
		}
		
		private function UpdateClockDisplay():void
		{
			if ( null != dynamic_date_display_ )
			{
				date_ = new Date();
				
				dynamic_date_display_.SetText( date_.toLocaleString() );
				dynamic_date_display_.x = Core.canvas_width/2;
				dynamic_date_display_.y = 2 + dynamic_date_display_.height / 2;
			}
		}
		
		public function SyncSoundButton():void
		{
			if ( null != sound_on_button.parent ) removeChild( sound_on_button );
			if ( null != sound_off_button.parent ) removeChild( sound_off_button );
			addChild( game_state.sound_enabled ? sound_on_button : sound_off_button );
		}
		
		private function OnSoundToggle(e:MouseEvent):void
		{
			game_state.sound_enabled = !game_state.sound_enabled;
			
			SyncSoundButton();
			
			game_state.save();
		}
		
		private function OnInGameMenu(e:MouseEvent):void
		{
			GotoPausePanel();
		}
		
		public function GotoMenu():void
		{
			// ------------------------------------------------------------------------------------------
			
			if ( _global.bpt2014_increasing_difficulty_mode )
			{
				trace( "TODO really manage difficulty setting (for now just resetting)" );
				ResetDifficulty();
			}
			
			// ------------------------------------------------------------------------------------------
					
//			TryingOutDifficultyTables();
			
			if ( 0 != back_restore_object_stack.length )
			{
				back_restore_object_stack.length = 0;
			}
			
			if ( (null != game_) && (this == game_.parent) )
			{
				removeChild( in_game_menu_button );
				removeChild( game_ );
			}

			if ( null == menu_ )
			{
				menu_ = new Menu();
			}
			
			addChild( menu_ );
		}
		
		// --------------------------------------------------------------------
		
		public function HandleGotoBetweenLevelPanel( panel:ContextBase, context:String ):void
		{
			if ( (null != menu_) && (this == menu_.parent) )
			{
				menu_.Dismiss();
			}
			
			if ( null == game_ )
			{
				game_ = new gamemain();
			}
			
			if ( (null != game_) && (this == game_.parent) )
			{
				removeChild( in_game_menu_button );
				removeChild( game_ );
			}

			//panel.SetContext( context );
			
			addChild( panel );
		}
		
		public function GotoBetweenLevelPanel( context:String ):void
		{
			if ( null == betweenLevelPanel_ )
			{
				betweenLevelPanel_ = new BetweenLevelPanel();
			}
			
			HandleGotoBetweenLevelPanel( betweenLevelPanel_, context );
		}
		
		public function GotoRoundClearPanel( context:String ):void
		{
			if ( null == roundClearPanel_ )
			{
				roundClearPanel_ = new RoundClearPanel();
			}
			
			HandleGotoBetweenLevelPanel( roundClearPanel_, context );
		}
		
		// --------------------------------------------------------------------
		
		public function GotoNoMovesPanel( context:String ):void
		{
			if ( null == noMovesContext_ )
			{
				//noMovesContext_ = new NoMovesPanel();
				noMovesContext_ = new QuickNoMovesContext();
			}
			
			HandleGotoBetweenLevelPanel( noMovesContext_, context );
		}
		
		// --------------------------------------------------------------------
		
		public function GotoPausePanel():void
		{
			if ( (null != menu_) && (this == menu_.parent) )
			{
				menu_.Dismiss();
			}
			
			if ( null == pausePanel_ )
			{
				pausePanel_ = new PausePanel();
			}
			
			if ( (null != game_) && (this == game_.parent) )
			{
				removeChild( in_game_menu_button );
				removeChild( game_ );
			}

			addChild( pausePanel_ );
		}

		// --------------------------------------------------------------------
		
		/*
		protected var difficulty_table = [
			
			{rows:7,cols:7,pieces:4},
			{rows:7,cols:8,pieces:4},
			{rows:8,cols:8,pieces:4},
			{rows:8,cols:9,pieces:4},
			{rows:9,cols:9,pieces:4},
			{rows:9,cols:10,pieces:4},
			{rows:10,cols:10,pieces:4},
			
			{rows:7,cols:7,pieces:5},
			{rows:7,cols:8,pieces:5},
			{rows:8,cols:8,pieces:5},
			{rows:8,cols:9,pieces:5},
			{rows:9,cols:9,pieces:5},
			{rows:9,cols:10,pieces:5},
			{rows:10,cols:10,pieces:5},
			
			{rows:10,cols:10,pieces:4},
			{rows:10,cols:11,pieces:4},
		];
		*/
		
		///*
		protected function TryingOutDifficultyTables():void
		{
			for ( var i:int = 0; i < 100; i++ )
			{
				var n:int = i;
				var nBase:int = n / 10;
				var nStage:int = n % 10;
				
				var r:int = (_global.purgatory_smallest_board_rows + nBase + nStage/3);
				var c:int = (_global.purgatory_smallest_board_cols + nBase + nStage/2);
				var p:int = Math.min( 10, 4 + nBase );
				
				r = Math.max( _global.purgatory_smallest_board_rows, Math.min( r, _global.purgatory_largest_board_rows ) );
				c = Math.max( _global.purgatory_smallest_board_cols, Math.min( c, _global.purgatory_largest_board_cols ) );
				
				if ( (0 == i) || (0 == nStage) ) trace( "level:" + nBase );
				
				trace( "pieces:" + p + ", rows:" + r + ", cols:" + c ); 
			
			}
		}
		//*/
		
		// --------------------------------------------------------------------
		
		public function CountEnabledPieceTypes():int
		{
			var count:int = 0;
			
			for ( var i:int = 0; i < _global.purgatory_max_piece_types; ++i )
			{
				if ( IsPieceTypeEnabled(i) )
				{
					++count;
				}
			}
			
			return count;
		}
		
		protected function PieceTypeSettingString( id:int )
		{
			return "setting_piece_" + (id + 1) + "_enabled";
		}
		
		public function IsPieceTypeEnabled( id:int ):Boolean
		{
			var setting:String = PieceTypeSettingString( id );
			
			return game_state[ setting ];
		}
		
		public function EnablePieceType( id:int, bEnable ):Boolean
		{
			var setting:String = PieceTypeSettingString( id );
			
			game_state[ setting ] = bEnable;
		}
		
		protected function EnableAtLeastNPieceTypes( nPieces:int ):void
		{
			var remaining:int = nPieces - CountEnabledPieceTypes();
			
			if ( 0 >= remaining )
			{
				return;
			}
			
			for ( var i:int = 0; i < _global.purgatory_max_piece_types; ++i )
			{
				if ( IsPieceTypeEnabled(i) ) continue;
				
				EnablePieceType( i, true );
				
				if ( 0 == --remaining )
				{
					break;
				}
			}
		}
		
		// --------------------------------------------------------------------
		
		public function ResetDifficulty():void
		{
			_global.bpt2014_current_difficulty_progression = 1;
			
			_global.last_round_filename = "last_round.dat";
		}
		
		public function HandleIncreaseDifficulty():void
		{
			// TODO - save last layout as a file - (should be JSON) - TODO
			
			var name:String =
				"game_" + game_state.total_boards_played
			+	"_round_" + _global.bpt2014_current_difficulty_progression
			+	"_" + _global.purgatory_nPieces 
			+	"x" + _global.purgatory_board_rows 
			+	"x" + _global.purgatory_board_cols
			+	"(" + game_state.last_board_retries + ")"
			;
			
			// TODO - make a .rules file for the layout 
			// TODO - make a .playback file for the solution 
			
			if ( _global.bpt2021_replace_removed_groups_with_next_match_id )
			{
				name += ".experiment";
			}
			else if ( _global.bpt2014_allow_non_matching_moves_moves )
			{
				name += ".anywhere";
			}
			else
			{
				name += ".layout";
			}
			
			_global.SaveLastBoardAsFilename( name );
			
			_global.bpt2014_current_difficulty_progression++;
		}
		
		protected function SetupForDifficultyProgression():void
		{
			if ( _global.bpt2014_increasing_difficulty_mode )
			{
				// -------------------------------------------------------------------------------------------
				
				var rows:int, cols:int, pieces:int;
				
				if ( false )
				{
					// TODO TABLE...
					
					switch ( _global.bpt2014_current_difficulty_progression )
					{
						case 0:
							rows = 9; cols = 9; pieces = 5;
							break;
					}
					
				}
				else
				{
					var n:int = _global.bpt2014_current_difficulty_progression;
					var nBase:int = n / 5;
					var nStage:int = n % 10;
					
					rows = (_global.purgatory_smallest_board_rows + nBase + nStage/3);
					cols = (_global.purgatory_smallest_board_cols + nBase + nStage/2);
					pieces = _global.purgatory_min_piece_types + nBase; // (Math.max(cols - 4, rows - 4) / 2); // nBase + nStage / 10 + 2; // TODO need better calculation
				}
				
				rows = Math.max( _global.purgatory_smallest_board_rows, Math.min( rows, _global.purgatory_largest_board_rows ) );
				cols = Math.max( _global.purgatory_smallest_board_cols, Math.min( cols, _global.purgatory_largest_board_cols ) );
				pieces = Math.max( _global.purgatory_min_piece_types, Math.min( pieces, _global.purgatory_max_piece_types ) );
				
				trace( "pieces:" + pieces + ", rows:" + rows + ", cols:" + cols ); 
				
				_global.purgatory_board_rows = rows;
				_global.purgatory_board_cols = cols;
				_global.purgatory_nPieces = pieces;
				
				// -------------------------------------------------------------------------------------------
				// pick some random pieces (probably should bias towards their selections???)
				
				EnableAtLeastNPieceTypes( _global.purgatory_nPieces );
				
				_global.purgatory_active_pieces.length = 0;
				
				var activeCount:int = 0;
				
				for ( var i:int = 0; i < _global.purgatory_max_piece_types; ++i )
				{
					if ( IsPieceTypeEnabled(i) )
					{
						_global.purgatory_active_pieces.push( i + 1 );
						
						++activeCount;
					}
				}
				
				// scramble
				
				for ( var i:int = 0; i < activeCount; ++i )
				{
					var a:uint = bpt.Helpers.Rnd(i,activeCount-1);
					var b:uint = bpt.Helpers.Rnd(0,activeCount-1);
					
					var t:int = _global.purgatory_active_pieces[ a ];
					_global.purgatory_active_pieces[ a ] = _global.purgatory_active_pieces[ b ];
					_global.purgatory_active_pieces[ b ] = t;
				}
				
				_global.purgatory_active_pieces.length = _global.purgatory_nPieces; // chop
				
			}
		}
		
		// --------------------------------------------------------------------
		
		public function PrepareForNewBoard():void
		{
			_global.purgatory_bAllowInitialMatches = game_state.setting_initial_matches;
			
			// deal with the board size setting
			
			if ( game_state.setting_big_board )
			{
				_global.purgatory_board_rows = _global.purgatory_default_board_rows + _global.purgatory_big_board_add_rows;
				_global.purgatory_board_cols = _global.purgatory_default_board_cols + _global.purgatory_big_board_add_cols;
				_global.purgatory_piece_cx = _global.purgatory_piece_tight_cx;
				_global.purgatory_piece_cy = _global.purgatory_piece_tight_cy;
			}
			else
			{
				if ( !_global.bpt2014_increasing_difficulty_mode )
				{
					_global.purgatory_board_rows = _global.purgatory_default_board_rows;
					_global.purgatory_board_cols = _global.purgatory_default_board_cols;
				}
				
				_global.purgatory_piece_cx = _global.purgatory_piece_normal_cx;
				_global.purgatory_piece_cy = _global.purgatory_piece_normal_cy;
			}
			
			// build the active pieces table
			
			if ( _global.bpt2014_increasing_difficulty_mode )
			{
				SetupForDifficultyProgression();
			}
			else
			{
				_global.purgatory_active_pieces.length = 0;
				
				var Needed:int = _global.purgatory_bAllowInitialMatches ? 4 : 5;
				
				for ( var ensureNOMore:int = 0; ensureNOMore < 2; ++ensureNOMore )
				{
					for ( var i:int = 0; i < _global.purgatory_max_piece_types; ++i )
					{
						var setting:String = "setting_piece_" + (i + 1) + "_enabled";
						
						if ( 0 == ensureNOMore )
						{
							if ( game_state[ setting ] )
							{
								_global.purgatory_active_pieces.push( i + 1 );
							}
						}
						else
						{
							if ( !game_state[ setting ] )
							{
								game_state[ setting ] = true;
								
								_global.purgatory_active_pieces.push( i + 1 );
							}
							
							if ( Needed <= _global.purgatory_active_pieces.length ) break;
						}
					}
					
					if ( Needed <= _global.purgatory_active_pieces.length ) break;
				}
				
				_global.purgatory_nPieces = _global.purgatory_active_pieces.length;
			}
		}
		
		public function NewGameBoard():void
		{
			_global.purgatory_use_last_board_layout = false;
			
			PrepareForNewBoard();
				
			game_.ShutdownDynamicElements();
				
			game_.BOOTSTRAP_GAME_SESSION();
			
			GotoGame();
		}
		
		// --------------------------------------------------------------------
		
		public function GotoGame():void
		{
			if ( (null != betweenLevelPanel_) && (this == betweenLevelPanel_.parent) )
			{
				betweenLevelPanel_.Dismiss();
			}

			if ( (null != menu_) && (this == menu_.parent) )
			{
				menu_.Dismiss();
			}

			if ( null == game_ )
			{
				game_ = new gamemain();
			}
			
			addChild( in_game_menu_button );
			addChild( game_ );
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function GotoHowToPlay( restore:DisplayObject ):void
		{
			//GotoNoMovesPanel( "testing" ); return;
			
			if ( null != restore )
			{
				back_restore_object_stack.push( restore );
			}
			
			if ( null == how_to_play_ )
			{
				how_to_play_ = new HowToPlay();
			}
			
			addChild( how_to_play_ );
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function GotoSettings( restore:DisplayObject ):void
		{
			if ( null != restore )
			{
				back_restore_object_stack.push( restore );
			}
			
			if ( null == settingsPanel_ )
			{
				settingsPanel_ = new SettingsPanel();
			}
			
			addChild( settingsPanel_ );
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function GotoStatistics( restore:DisplayObject ):void
		{
			if ( null != restore )
			{
				back_restore_object_stack.push( restore );
			}
			
			if ( null == statistics_ )
			{
				statistics_ = new Statistics();
			}
			
			addChild( statistics_ );
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function GotoConfirmResetStatistics( restore:DisplayObject ):void
		{
			if ( null != restore )
			{
				back_restore_object_stack.push( restore );
			}
			
			if ( null == confirmResetStats_ )
			{
				confirmResetStats_ = new ConfirmClearStatistics();
			}
			
			addChild( confirmResetStats_ );
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function GotoAssetInfoPanel( restore:DisplayObject ):void
		{
			//GotoNoMovesPanel( "testing" ); return;
			
			if ( null != restore )
			{
				back_restore_object_stack.push( restore );
			}
			
			if ( null == asset_info_panel_ )
			{
				asset_info_panel_ = new AssetInfoPanel();
			}
			
			addChild( asset_info_panel_ );
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function GotoStory( restore:DisplayObject ):void
		{
			// ----------------------------------------------------------------
			
			if ( true )
			{
				if ( null == stats_ )
				{
					stats_ = new Stats();
					
					addChild( stats_ );
					
					stats_.scaleX = 2;
					stats_.scaleY = 2;
					stats_.x = 0; // Main.canvas_x_center;
					stats_.y = Core.canvas_y_center - stats_.height / 2;
				}
				else
				{
					removeChild( stats_ );
					
					stats_ = null;
				}
			}
			
			// ----------------------------------------------------------------
			
			if ( null != restore )
			{
				back_restore_object_stack.push( restore );
			}
			
			if ( null == story_of_game_ )
			{
				story_of_game_ = new StoryOfGame();
			}
			
			addChild( story_of_game_ );
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function Back( requester:DisplayObject ):void
		{
			if ( 0 != back_restore_object_stack.length )
			{
				var restore:DisplayObject = back_restore_object_stack.pop();
				
				addChild( restore );
			}
			else
			{
				GotoMenu(); // bad idea???
			}
			
			SyncSoundButton(); // make sure sound button is on top
		}
		
		public function Exit():void
		{
			NativeApplication.nativeApplication.exit(0);
		}
		
	}
	
}