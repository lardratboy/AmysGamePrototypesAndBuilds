package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import LargePanelBase;
	
	import SimplisticCheckBox;
	
	import assets;
	
	import bpt.game._global;
	import bpt.game.game_state;
	import com.bit101.components.*;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class SettingsPanel extends LargePanelBase
	{
		protected var ready_button_:ScaledAssetButton;
		protected var holder_:AlignedHolder;
		protected var checkboxes_holder_:AlignedHolder;
		protected var left_checkboxes_holder_:AlignedHolder;
		protected var right_checkboxes_holder_:AlignedHolder;
		protected var pieces_options_holder_:AlignedHolder;
		protected var big_board_option_:GameStateCheckbox;
		protected var initial_matches_option_:GameStateCheckbox;
		protected var tougher_stars_option_:GameStateCheckbox;
		protected var pieces_option_:Vector.<GameStateCheckbox>;
		protected var disable_hints_option_:GameStateCheckbox;
		protected var prototypeGameSettingsWindow_:Window;
		
		public function SettingsPanel():void
		{
			super();
		}
		
		protected override function Create():void
		{
			super.Create();
			
			super.CreateMainMenuButton();
			
			var banner:DisplayObject = assets.SpriteWrapper( "settings_panel_banner" );
			banner.x = background_panel_.x;
			banner.y = background_panel_.y - background_panel_.height/2 + banner.height;
			addChild( banner );
			
			ready_button_ = new ScaledAssetButton( "done" );
			ready_button_.x = background_panel_.x;
			ready_button_.y = background_panel_.y + background_panel_.height/2 - ready_button_.height * 1.0;
			ready_button_.addEventListener( MouseEvent.CLICK, OnReadyButton );
			addChild( ready_button_ );
			
			holder_ = new AlignedHolder();
			//background_panel_.
			addChild( holder_ );
			
			// ----------------------------------------------------------------
			
			/*
			if ( !_global.purgatory_small_display_device )
			{
				var txt:DynamicTextHolder = new DynamicTextHolder();
				
				txt.SetText( "Pieces" );
				
				holder_.addChild( txt );
			}
			*/
			
			// ----------------------------------------------------------------
			
			pieces_options_holder_ = new AlignedHolder();
			
			pieces_option_ = new Vector.<GameStateCheckbox>();
			
			var piece_id:int = 1;
			var perLine:int = 6;
			
			for ( var line:int = 0; line < 4; ++line )
			{
				var aligner:Sprite = new Sprite();
				
				var pieces_holder:AlignedHolder = new AlignedHolder();
				
				aligner.addChild( pieces_holder ); 
				
				for ( var i:int = 0; i < perLine; ++i )
				{
					var pb:GameStateCheckbox =  new GameStateCheckbox( "original_pieces_" + piece_id, "setting_piece_" + piece_id + "_enabled" );
					
					pieces_option_.push( pb );
					
					pieces_holder.addChild( pb );
					
					++piece_id;
					
					if ( piece_id > _global.purgatory_max_piece_types ) break;
				}
				
				pieces_holder.Align( 15 /*30*/ * assets.asset_runtime_scale_factor, false );
				pieces_options_holder_.addChild( aligner );
				
				var rect:Rectangle = pieces_holder.getRect( aligner );
				pieces_holder.x = -rect.left - rect.width;

				if ( piece_id > _global.purgatory_max_piece_types ) break;
			}
			
			holder_.addChild( pieces_options_holder_ );
			
			// ----------------------------------------------------------------

			checkboxes_holder_ = new AlignedHolder();
			
			left_checkboxes_holder_ = new AlignedHolder();
			
			if ( _global.purgatory_allow_big_board )
			{
				big_board_option_ = new GameStateCheckbox( "big_board_option", "setting_big_board" );
				left_checkboxes_holder_.addChild( big_board_option_ );
			}
			
			initial_matches_option_ = new GameStateCheckbox( "initial_matches_option", "setting_initial_matches" );
			left_checkboxes_holder_.addChild( initial_matches_option_ );
			
			right_checkboxes_holder_ = new AlignedHolder();
			
			tougher_stars_option_ = new GameStateCheckbox( "tougher_stars_option", "setting_tougher_stars" );
			right_checkboxes_holder_.addChild( tougher_stars_option_ );
			
			disable_hints_option_ = new GameStateCheckbox( "disable_hints_option", "setting_disable_hints" );
			right_checkboxes_holder_.addChild( disable_hints_option_ );
			
			checkboxes_holder_.addChild( left_checkboxes_holder_ );
			checkboxes_holder_.addChild( right_checkboxes_holder_ );

			holder_.addChild( checkboxes_holder_ );
			
			// ---------------------------------------------------------------------------------------------
			
			InitProtypeOptionsWindow();
			
			// ---------------------------------------------------------------------------------------------
			
			reinit(null);
		}
		
		// =================================================================================================================
		
		/*
		static public var bpt2014_allow_diagonal_moves:Boolean = true;// false;
		static public var purgatory_bIncludeDiagonalsInConnectivity:Boolean = true;// only to play like all the other games out there...
		static public var bpt2014_keep_board_full:Boolean = false;// true; (typical matching game)
		static public var purgatory_going_down:Boolean = true;
		static public var bpt2014_increasing_difficulty_mode:Boolean = true;
		static public var bpt2014_current_difficulty_progression:int = 1;
		static public var bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode:Boolean = false; // allow for OCD finishing
		static public var bpt2014_allow_non_matching_moves_moves:Boolean = false; // false; // another interesting variation in match 3 (can stalemate easily)
		*/
		
		protected function OnHandleProtypeCheckbox( e:MouseEvent ):void
		{
			var checkbox:CheckBox = e.currentTarget as CheckBox;
			
			if ( null == checkbox ) return;
			
			switch ( checkbox.label )
			{
				case "ocd bonus":
					_global.bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode = checkbox.selected;
					break;
					
				case "diagonals":
					_global.purgatory_bIncludeDiagonalsInConnectivity = checkbox.selected;
					_global.bpt2014_allow_diagonal_moves = checkbox.selected;
					break;
					
				case "fullboard":
					_global.bpt2014_keep_board_full = checkbox.selected;
					break;
					
				case "downward":
					_global.purgatory_going_down = checkbox.selected;
					break;
					
				case "non matching":
					_global.bpt2014_allow_non_matching_moves_moves = checkbox.selected;
					break;
					
				case "replace mode":
					_global.bpt2021_replace_removed_groups_with_next_match_id = checkbox.selected;
					break;
					
				default:
					trace( "??? checkbox " + checkbox.label + " " + checkbox.selected );
					break;

			}
			
		}
		
		protected var prototype_ocdCheckbox:CheckBox;
		protected var prototype_diagonalsCheckbox:CheckBox;
		protected var prototype_fullboardCheckbox:CheckBox;
		protected var prototype_downwardCheckbox:CheckBox;
		protected var prototype_nonMatchingMovesCheckbox:CheckBox;
		protected var prototype_replaceModeCheckbox:CheckBox;
		
		protected function ReinitProtypeOptions()
		{
			prototype_ocdCheckbox.selected = _global.bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode;
			prototype_diagonalsCheckbox.selected = _global.bpt2014_allow_diagonal_moves;
			prototype_fullboardCheckbox.selected = _global.bpt2014_keep_board_full;
			prototype_downwardCheckbox.selected = _global.purgatory_going_down;
			prototype_nonMatchingMovesCheckbox.selected = _global.bpt2014_allow_non_matching_moves_moves;
			prototype_replaceModeCheckbox.selected = _global.bpt2021_replace_removed_groups_with_next_match_id;
		}
		
		protected function InitProtypeOptionsWindow():void
		{
			prototypeGameSettingsWindow_ = new Window(this);
			prototypeGameSettingsWindow_.scaleX = 3;
			prototypeGameSettingsWindow_.scaleY = 3;
			prototypeGameSettingsWindow_.hasMinimizeButton = true;
			
			prototype_ocdCheckbox = new CheckBox(prototypeGameSettingsWindow_, 0, 0, "ocd bonus", OnHandleProtypeCheckbox );
			prototype_diagonalsCheckbox = new CheckBox(prototypeGameSettingsWindow_, 0, 10, "diagonals", OnHandleProtypeCheckbox );
			prototype_fullboardCheckbox = new CheckBox(prototypeGameSettingsWindow_, 0, 20, "fullboard", OnHandleProtypeCheckbox );
			prototype_downwardCheckbox = new CheckBox(prototypeGameSettingsWindow_, 0, 30, "downward", OnHandleProtypeCheckbox );
			prototype_nonMatchingMovesCheckbox = new CheckBox(prototypeGameSettingsWindow_, 0, 40, "non matching", OnHandleProtypeCheckbox );
			prototype_replaceModeCheckbox = new CheckBox(prototypeGameSettingsWindow_, 0, 50, "replace mode", OnHandleProtypeCheckbox );
		}
		
		// =================================================================================================================
		
		protected override function reinit(e:Event):void
		{
			super.reinit( e );
			
			ReinitProtypeOptions();
			
			// need to work on the alignment stuff this is so hacky
			
			holder_.scaleX = holder_.scaleY = 1;
			
			for ( var i:int = 0; i < 2; ++i )
			{
				holder_.x = holder_.y = 0;
				
				var r:Rectangle = holder_.getRect( holder_.parent );
				
				var scaler:Number = (0 == i) ? 1 : Math.min(
					(background_panel_.width * 0.75) / r.width,
					(background_panel_.height * 0.75) / r.height
				);
				
//trace( "pass " + (i + 1) + " scaler " + scaler );
				
				var alignGap:Number = 15 /*30*/ * assets.asset_runtime_scale_factor * scaler*1.5;
				
				pieces_options_holder_.Align( alignGap, true, scaler );
				left_checkboxes_holder_.Align( alignGap, true, scaler );
				right_checkboxes_holder_.Align( alignGap, true, scaler );
				
				checkboxes_holder_.x = 0;
				checkboxes_holder_.y = 0;
				
				checkboxes_holder_.Align( alignGap, true );
				checkboxes_holder_.Align( alignGap, false );
				
				holder_.Align( 10 * assets.asset_runtime_scale_factor * scaler*1.5, true );
				
				checkboxes_holder_.x = -checkboxes_holder_.width/4; 
				
				holder_.x += background_panel_.x;
				holder_.y += background_panel_.y + background_panel_.height/16;
			}
			
			/*
			holder_.scaleX = Math.min(
				(background_panel_.width * 0.8) / holder_.width,
				(background_panel_.height * 0.8) / holder_.height
			);
			
			holder_.scaleY = holder_.scaleX;
			
			holder_.y = holder_.height/3 + background_panel_.height/-2;
			*/

			if ( _global.purgatory_allow_big_board )
			{
				big_board_option_.Sync();
			}
			
			initial_matches_option_.Sync();
			tougher_stars_option_.Sync();
		
			for each ( var cb:GameStateCheckbox in pieces_option_ )
			{
				cb.Sync();
			}
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			ready_button_.Enable( b );
			initial_matches_option_.Enable( b );
			tougher_stars_option_.Enable( b );
			
			if ( _global.purgatory_allow_big_board )
			{
				big_board_option_.Enable( b );
			}
			
			for each ( var cb:GameStateCheckbox in pieces_option_ )
			{
				cb.Enable( b );
			}
		}
		
		protected function OnReadyButton( e:MouseEvent ):void
		{
			Core.instance.Back( this );
			
			Dismiss();
		}
		
		override public function Dismiss():void 
		{
			game_state.save();
			
			super.Dismiss();
		}
	}
}

// ----------------------------------------------------------------------------

import flash.events.TouchEvent;

import bpt.game.game_state;

internal class GameStateCheckbox extends SimplisticCheckBox
{
	protected var state_variable_:String;
	
	public function GameStateCheckbox( asset:String, state_variable:String )
	{
		super( asset );
		
		state_variable_ = state_variable;
		
		Sync();
		
		addEventListener( flash.events.TouchEvent.TOUCH_TAP, OnTap );
		addEventListener( flash.events.MouseEvent.MOUSE_DOWN, OnDown );
	}
	
	protected function Toggle():void
	{
		sound_assets.PlaySound( "sfx_slot_stop" );
		
		game_state[ state_variable_ ] = !game_state[ state_variable_ ];
		
		Sync();
	}
	
	protected function OnTap( e:flash.events.TouchEvent ):void // flash.events.MouseEvent ):void
	{
		Toggle();
	}
	
	protected function OnDown( e:flash.events.MouseEvent ):void
	{
		Toggle();
	}
	
	public function Sync():void
	{
		SetCheck( game_state[ state_variable_ ] );
		
//		trace( state_variable_ + " = " + game_state[ state_variable_ ] );
	}
	
}