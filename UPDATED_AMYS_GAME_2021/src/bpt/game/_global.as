package bpt.game
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author BPT
	 */
	public final class _global
	{
		// the magic sauce of beyond columns (diagonals)
		static public var bpt2014_allow_diagonal_moves:Boolean = true;// false;
		static public var purgatory_bIncludeDiagonalsInConnectivity:Boolean = true;// only to play like all the other games out there...
		static public var bpt2014_keep_board_full:Boolean = false;// true; (typical matching game)
		static public var purgatory_going_down:Boolean = true;
		static public var bpt2014_increasing_difficulty_mode:Boolean = true;
		static public var bpt2014_current_difficulty_progression:int = 1;
		static public var bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode:Boolean = false; // allow for OCD finishing
		static public var bpt2014_allow_non_matching_moves_moves:Boolean = false; // false; // another interesting variation in match 3 (can stalemate easily)
		
		static public var bpt2021_replace_removed_groups_with_next_match_id:Boolean = false; // kind of weird needs better feedback animation
		
		static public var bpt2021_use_original_removal_strategy:Boolean = true; // this controls the timing of successive removals (not 100% certain once upon a time doesn't break the scoring)
		static public var bpt2021_automatically_advance_to_next_round:Boolean = false; // TODO this isn't complete yet
		
		static public var bpt2021_remove_when_groups_larger_than:int = 2; // 2 is the original number
		static public var purgatory_bAllowInitialMatches:Boolean = false;
		static public var purgatory_replay_on_board_loss:Boolean = true;
		
		static public var bpt2014_remove_base_duration:int = 55; //60;
		static public var bpt2014_remove_animation_speed_coefficient_start:Number = 1.0;
		static public var bpt2014_remove_animation_speed_coefficient_min:Number = 0.2;
		static public var bpt2014_remove_animation_speed_coefficient_max:Number = 2.0;
		static public var bpt2014_remove_animation_speed_delta:Number = 0.0; // -0.00625 * 0.25;
		
		static public var bpt2014_play_removal_sound_per_item:Boolean = false;
		static public var bpt2014_collect_points_once_per_group:Boolean = true;
		static public var bpt2014_experiment_allow_move_and_hold_test:Boolean = false; /* experimenting with alternate play mechanism WTF does this do????*/
		
		static public var bpt2014_tap_zoom_mode:Boolean = false; /* code activated by this currently almost works but is too weird to use */
		static public var bDisableRisingTextEffects:Boolean = false;
		
		static public var bpt2014_brads_game_hacks_enabled:Boolean = false;
		static public var purgatory_demo_mode:Boolean = false; // autoplay type mode is currently broken? fix this
		static public var purgatory_demo_mode_increase_speed:Boolean = true;
		
		static public var purgatory_pack_all_columns_at_once:Boolean = true;

		static public var purgatory_last_meta_cols_layout:Vector.<int> = new Vector.<int>();
		static public var purgatory_last_board_layout:Vector.< Vector.<int> > = new Vector.< Vector.<int> >();
		static public var purgatory_last_board_rows:int = 0;
		static public var purgatory_last_board_cols:int = 0;
		static public var purgatory_use_last_board_layout:Boolean;
		static public var purgatory_allow_board_scaling:Boolean = false; // false;
		static public var purgatory_board_scaling_enabled:Boolean = false; // false;
		
		static public var purgatory_nPieces:int = 5;
		static public var purgatory_min_piece_types:int = 4;
		static public var purgatory_max_piece_types:int = 24;
		static public var purgatory_active_pieces:Vector.<int> = new Vector.<int>();
		
		//static public var purgatory_min_active_piece_types:int = purgatory_min_piece_types; // for increasing difficulty mode
		//static public var purgatory_max_active_piece_types:int = 15; // for increasing difficulty mode
		
		//static public var purgatory_played_types_original_counts:Vector.<int> = new Vector.<int>();
		//static public var purgatory_played_types_removed_counter:Vector.<int> = new Vector.<int>();
		
		// --------------------------------------------------------------------
		
		static public var purgatory_stage_cx:int = 1024;
		static public var purgatory_stage_cy:int = 768;
		static public var purgatory_piece_normal_cx:int = 65;
		static public var purgatory_piece_normal_cy:int = 65;
		static public var purgatory_piece_tight_cx:int = 55;
		static public var purgatory_piece_tight_cy:int = 55;
		static public var purgatory_piece_cx:int = purgatory_piece_normal_cx; // 65; // -10 still is large enough to play
		static public var purgatory_piece_cy:int = purgatory_piece_normal_cy; // 65;
		
		// bpt2014_increasing_difficulty_mode
		
		static public var purgatory_smallest_board_rows:int = 9;// 11;
		static public var purgatory_smallest_board_cols:int = 9;// 11;
		static public var purgatory_largest_board_rows:int = 15;
		static public var purgatory_largest_board_cols:int = 20;
		
		static public var purgatory_default_board_rows:int = 7 + 2; // 9 + 2;// - 6; // - 6; // + 2;
		static public var purgatory_default_board_cols:int = 7 + 2; // 13 + 2; // - 9; // - 9; // + 4;
		
		static public var purgatory_big_board_add_rows:int = 2 + 2; // testing crazy big + 10;
		static public var purgatory_big_board_add_cols:int = 2 + 2; // testing crazy big + 20;
		
		static public var purgatory_board_rows:int = purgatory_default_board_rows; // 9 + 2; // + 3;
		static public var purgatory_board_cols:int = purgatory_default_board_cols; // 13 + 2; // + 3;
		
		static public var purgatory_allow_big_board:Boolean = false;
		static public var purgatory_small_display_device:Boolean = false;
		
		// --------------------------------------------------------------------
		
		static public function Initialize():void
		{
			LoadSavedLayout();
		}
		
		// ---------------------------------------------------------------------------------------------------------------
		
		static public var last_round_filename:String = "last_round.dat";
		
		static public function DoesLastBoardExist():Boolean
		{
			var bExists:Boolean = false;
			
			try
			{
				bExists = DoesLastBoardExist__();
			}
			catch ( e:Object )
			{
			}
			
			return bExists;
		}
		
		static private function DoesLastBoardExist__():Boolean
		{
			var bExists:Boolean = false;
			
			try
			{
				var f:File = File.applicationStorageDirectory.resolvePath( last_round_filename );
				
				bExists = f.exists;
			}
			catch ( e:Object )
			{
			}
			
			return bExists;
		}
		
		static public function LoadSavedLayout():void
		{
			try
			{
				LoadSavedLayout__();
			}
			catch ( e:Object )
			{
			}
		}
		
		// TODO - make a real save/load system for building a library of fun levels!!!!!!!!
		
		static public function LoadSavedLayoutFromFilename( name:String ):Boolean
		{
			var bResult = false;
			
			var f:File = File.applicationStorageDirectory.resolvePath( name );
			
			var fs:FileStream = new FileStream();
			
			try
			{
				fs.open( f, FileMode.READ );
				
				purgatory_last_board_rows = fs.readInt();
				purgatory_last_board_cols = fs.readInt();
				
				purgatory_last_meta_cols_layout = new Vector.<int>();
				
				purgatory_last_meta_cols_layout.length = purgatory_last_board_cols;
				
				for ( var meta_col:int = 0; meta_col < purgatory_last_board_cols; ++meta_col )
				{
					purgatory_last_meta_cols_layout[ meta_col ] = fs.readInt();
				}
				
				for ( var row:int = 0; row < purgatory_last_board_rows; ++row )
				{
					var row_vector:Vector.<int> = new Vector.<int>();
					
					row_vector.length = purgatory_last_board_cols;
					
					purgatory_last_board_layout[ row ] = row_vector;
					
					purgatory_last_board_layout[ row ];
					
					for ( var col:int = 0; col < purgatory_last_board_cols; ++col )
					{
						row_vector[ col ] = fs.readInt();
					}
				}
				
				fs.close();
				
				bResult = true;
			}
			catch ( e:Error )
			{
				/// ???
			}
			
			return bResult;
			
		}
		
		static private function LoadSavedLayout__():void
		{
			if ( !DoesLastBoardExist() ) return;
			
			LoadSavedLayoutFromFilename( last_round_filename );
		}

		static public function SaveBoardLayout():void
		{
			try
			{
				SaveBoardLayout__();
			}
			catch ( e:Object )
			{
			}
		}
		
		static public function SaveLastBoardAsFilename( name:String ):Boolean
		{
			var f:File = File.applicationStorageDirectory.resolvePath( name );
			
			var fs:FileStream = new FileStream();
			
			var bResult = false;
			
			try
			{
				fs.open( f, FileMode.UPDATE );
				
				fs.position = 0;
				
				fs.writeInt( purgatory_last_board_rows );
				
				fs.writeInt( purgatory_last_board_cols );
				
				for ( var meta_col:int = 0; meta_col < purgatory_last_board_cols; ++meta_col )
				{
					fs.writeInt( purgatory_last_meta_cols_layout[ meta_col ] );
				}
				
				for ( var row:int = 0; row < purgatory_last_board_rows; ++row )
				{
					var row_vector:Vector.<int> = purgatory_last_board_layout[ row ];
					
					for ( var col:int = 0; col < purgatory_last_board_cols; ++col )
					{
						fs.writeInt( row_vector[ col ] );
					}
				}
				
				fs.close();
				
				bResult = true;
			}
			catch ( e:Error )
			{
				/// ???
			}
			
			return bResult;
		}
		
		static private function SaveBoardLayout__():void
		{
			try
			{
				SaveLastBoardAsFilename( last_round_filename );
			}
			catch ( e:Error )
			{
				/// ???
			}
		}
		
		// --------------------------------------------------------------------
		
	}

}