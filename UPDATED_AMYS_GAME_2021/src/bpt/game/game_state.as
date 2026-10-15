package bpt.game
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author BPT
	 */
	public class game_state extends Sprite
	{
		static public var load_counter:int = 0;
		static public var total_boards_played:int = 0;
		static public var total_unique_boards:int = 0;
		static public var total_seconds_playing:Number = 0;
		static public var total_boards_solved:int = 0;
		static public var total_moves:int = 0;
		static public var total_pieces_removed:int = 0;
		static public var min_moves_to_solve:int = int.MAX_VALUE;
		static public var longest_winining_streak:int = 0;
		static public var current_streak:int = 0;
		static public var last_board_moves:int = 0;
		static public var last_board_retries:int = 0;
		static public var last_board_seconds:Number = 0;
		static public var max_retries_for_any_round:int = 0;
		static public var high_score:int = 0;
		static public var sound_enabled:Boolean = true;
		static public var random_board_sizes_enabled:Boolean = false;
		
		static public var setting_big_board:Boolean = false;
		static public var setting_initial_matches:Boolean = true;
		static public var setting_tougher_stars:Boolean = false;
		static public var setting_piece_1_enabled:Boolean = true;
		static public var setting_piece_2_enabled:Boolean = true;
		static public var setting_piece_3_enabled:Boolean = true;
		static public var setting_piece_4_enabled:Boolean = true;
		static public var setting_piece_5_enabled:Boolean = true;
		static public var setting_piece_6_enabled:Boolean = false;
		static public var setting_piece_7_enabled:Boolean = false;
		static public var setting_piece_8_enabled:Boolean = false;
		static public var setting_piece_9_enabled:Boolean = false;
		static public var setting_piece_10_enabled:Boolean = false;
		
		static public var setting_piece_11_enabled:Boolean = false;
		static public var setting_piece_12_enabled:Boolean = false;
		static public var setting_piece_13_enabled:Boolean = false;
		static public var setting_piece_14_enabled:Boolean = false;
		static public var setting_piece_15_enabled:Boolean = false;
		static public var setting_piece_16_enabled:Boolean = false;
		static public var setting_piece_17_enabled:Boolean = false;
		static public var setting_piece_18_enabled:Boolean = false;
		static public var setting_piece_19_enabled:Boolean = false;
		static public var setting_piece_20_enabled:Boolean = false;
		static public var setting_piece_21_enabled:Boolean = false;
		static public var setting_piece_22_enabled:Boolean = false;
		static public var setting_piece_23_enabled:Boolean = false;
		static public var setting_piece_24_enabled:Boolean = false;
		static public var setting_piece_25_enabled:Boolean = false;
		
		static public var last_board_fewest_remaining_stars:int = 0;
		static public var last_board_remaining_stars:int = 0;
		static public var setting_disable_hints:Boolean = false; 
		
		public function DUMP( prefix:String ):void
		{
			trace( prefix );
			
			trace( "\tload_counter " + game_state.load_counter );
			trace( "\ttotal_boards_played " + game_state.total_boards_played );
			trace( "\ttotal_unique_boards " + game_state.total_unique_boards );
			trace( "\ttotal_seconds_playing " + game_state.total_seconds_playing );
			trace( "\ttotal_boards_solved " + game_state.total_boards_solved );
			trace( "\ttotal_moves " + game_state.total_moves );
			trace( "\ttotal_pieces_removed " + game_state.total_pieces_removed );
			trace( "\tmin_moves_to_solve " + game_state.min_moves_to_solve );
			trace( "\tlongest_winining_streak " + game_state.longest_winining_streak );
			trace( "\tcurrent_streak " + game_state.current_streak );
			trace( "\tlast_board_moves " + game_state.last_board_moves );
			trace( "\tlast_board_retries " + game_state.last_board_retries );
			trace( "\tlast_board_seconds " + game_state.last_board_seconds );
			trace( "\tmax_retries_for_any_round " + game_state.max_retries_for_any_round );
			trace( "\thigh_score " + game_state.high_score );
			trace( "\tsound_enabled " + game_state.sound_enabled );
			trace( "\tsetting_big_board " + setting_big_board );
			trace( "\tsetting_initial_matches " + setting_initial_matches );
			trace( "\tsetting_tougher_stars " + setting_tougher_stars );
			trace( "\tsetting_piece_1_enabled " + setting_piece_1_enabled );
			trace( "\tsetting_piece_2_enabled " + setting_piece_2_enabled );
			trace( "\tsetting_piece_3_enabled " + setting_piece_3_enabled );
			trace( "\tsetting_piece_4_enabled " + setting_piece_4_enabled );
			trace( "\tsetting_piece_5_enabled " + setting_piece_5_enabled );
			trace( "\tsetting_piece_6_enabled " + setting_piece_6_enabled );
			trace( "\tsetting_piece_7_enabled " + setting_piece_7_enabled );
			trace( "\tsetting_piece_8_enabled " + setting_piece_8_enabled );
			trace( "\tsetting_piece_9_enabled " + setting_piece_9_enabled );
			trace( "\tsetting_piece_10_enabled " + setting_piece_10_enabled );
			
			trace( "\tsetting_piece_11_enabled " + setting_piece_11_enabled );
			trace( "\tsetting_piece_12_enabled " + setting_piece_12_enabled );
			trace( "\tsetting_piece_13_enabled " + setting_piece_13_enabled );
			trace( "\tsetting_piece_14_enabled " + setting_piece_14_enabled );
			trace( "\tsetting_piece_15_enabled " + setting_piece_15_enabled );
			trace( "\tsetting_piece_16_enabled " + setting_piece_16_enabled );
			trace( "\tsetting_piece_17_enabled " + setting_piece_17_enabled );
			trace( "\tsetting_piece_18_enabled " + setting_piece_18_enabled );
			trace( "\tsetting_piece_19_enabled " + setting_piece_19_enabled );
			trace( "\tsetting_piece_20_enabled " + setting_piece_20_enabled );
			trace( "\tsetting_piece_21_enabled " + setting_piece_21_enabled );
			trace( "\tsetting_piece_22_enabled " + setting_piece_22_enabled );
			trace( "\tsetting_piece_23_enabled " + setting_piece_23_enabled );
			trace( "\tsetting_piece_24_enabled " + setting_piece_24_enabled );
			trace( "\tsetting_piece_25_enabled " + setting_piece_25_enabled );
			
			trace( "\tlast_board_fewest_remaining_stars " + last_board_fewest_remaining_stars );
			trace( "\tlast_board_remaining_stars " + last_board_remaining_stars );
			trace( "\tsetting_disable_hints " + setting_disable_hints );
			
		}
		
		public static function RESET():void
		{
			load_counter = 1;
			total_boards_played = 0;
			total_unique_boards = 0;
			total_seconds_playing = 0;
			total_boards_solved = 0;
			total_moves = 0;
			total_pieces_removed = 0;
			min_moves_to_solve = int.MAX_VALUE;
			longest_winining_streak = 0;
			current_streak = 0;
			last_board_moves = 0;
			last_board_retries = 0;
			last_board_seconds = 0;
			max_retries_for_any_round = 0;
			high_score = 0;
			last_board_fewest_remaining_stars = 0;
			last_board_remaining_stars = 0;
			
			save();			
		}
		
		public function game_state()
		{
			try
			{
				NativeApplication.nativeApplication.addEventListener( Event.EXITING, onExit );
			}
			catch ( e:Object )
			{
			}
			
			load();
		}
		
		static protected var stats_key:String = "AmysGame.Stats";
		
		public function load():void
		{
			var so:SharedObject = SharedObject.getLocal( stats_key );
			
			game_state.load_counter = int( so.data[ 'load_counter' ] );
			
			++game_state.load_counter;
			
			if ( 1 >= game_state.load_counter )
			{
				save();
				
				return;
			}

			game_state.total_boards_played = int( so.data[ 'total_boards_played' ] );
			game_state.total_unique_boards = int( so.data[ 'total_unique_boards' ] );
			game_state.total_seconds_playing = Number( so.data[ 'total_seconds_playing' ] );
			game_state.total_boards_solved = int( so.data[ 'total_boards_solved' ] );
			game_state.total_moves = int( so.data[ 'total_moves' ] );
			game_state.total_pieces_removed = int( so.data[ 'total_pieces_removed' ] );
			game_state.min_moves_to_solve = int( so.data[ 'min_moves_to_solve' ] );
			game_state.longest_winining_streak = int( so.data[ 'longest_winining_streak' ] );
			game_state.current_streak = int( so.data[ 'current_streak' ] );
			game_state.last_board_moves = int( so.data[ 'last_board_moves' ] );
			game_state.last_board_retries = int( so.data[ 'last_board_retries' ] );
			game_state.last_board_seconds = Number( so.data[ 'last_board_seconds' ] );
			game_state.max_retries_for_any_round = int( so.data[ 'max_retries_for_any_round' ] );
			game_state.high_score = int( so.data[ 'high_score' ] );
			game_state.sound_enabled = Boolean( so.data[ 'sound_enabled' ] );
			
			game_state.setting_big_board = Boolean( so.data[ 'setting_big_board' ] );
			game_state.setting_initial_matches = Boolean( so.data[ 'setting_initial_matches' ] );
			game_state.setting_tougher_stars = Boolean( so.data[ 'setting_tougher_stars' ] );
			game_state.setting_piece_1_enabled = Boolean( so.data[ 'setting_piece_1_enabled' ] );
			game_state.setting_piece_2_enabled = Boolean( so.data[ 'setting_piece_2_enabled' ] );
			game_state.setting_piece_3_enabled = Boolean( so.data[ 'setting_piece_3_enabled' ] );
			game_state.setting_piece_4_enabled = Boolean( so.data[ 'setting_piece_4_enabled' ] );
			game_state.setting_piece_5_enabled = Boolean( so.data[ 'setting_piece_5_enabled' ] );
			game_state.setting_piece_6_enabled = Boolean( so.data[ 'setting_piece_6_enabled' ] );
			game_state.setting_piece_7_enabled = Boolean( so.data[ 'setting_piece_7_enabled' ] );
			game_state.setting_piece_8_enabled = Boolean( so.data[ 'setting_piece_8_enabled' ] );
			game_state.setting_piece_9_enabled = Boolean( so.data[ 'setting_piece_9_enabled' ] );
			game_state.setting_piece_10_enabled = Boolean( so.data[ 'setting_piece_10_enabled' ] );

			game_state.setting_piece_11_enabled = Boolean( so.data[ 'setting_piece_11_enabled' ] );
			game_state.setting_piece_12_enabled = Boolean( so.data[ 'setting_piece_12_enabled' ] );
			game_state.setting_piece_13_enabled = Boolean( so.data[ 'setting_piece_13_enabled' ] );
			game_state.setting_piece_14_enabled = Boolean( so.data[ 'setting_piece_14_enabled' ] );
			game_state.setting_piece_15_enabled = Boolean( so.data[ 'setting_piece_15_enabled' ] );
			game_state.setting_piece_16_enabled = Boolean( so.data[ 'setting_piece_16_enabled' ] );
			game_state.setting_piece_17_enabled = Boolean( so.data[ 'setting_piece_17_enabled' ] );
			game_state.setting_piece_18_enabled = Boolean( so.data[ 'setting_piece_18_enabled' ] );
			game_state.setting_piece_19_enabled = Boolean( so.data[ 'setting_piece_19_enabled' ] );
			game_state.setting_piece_20_enabled = Boolean( so.data[ 'setting_piece_20_enabled' ] );
			game_state.setting_piece_21_enabled = Boolean( so.data[ 'setting_piece_21_enabled' ] );
			game_state.setting_piece_22_enabled = Boolean( so.data[ 'setting_piece_22_enabled' ] );
			game_state.setting_piece_23_enabled = Boolean( so.data[ 'setting_piece_23_enabled' ] );
			game_state.setting_piece_24_enabled = Boolean( so.data[ 'setting_piece_24_enabled' ] );
			game_state.setting_piece_25_enabled = Boolean( so.data[ 'setting_piece_25_enabled' ] );
			
			game_state.last_board_fewest_remaining_stars = int( so.data[ 'last_board_fewest_remaining_stars' ] );
			game_state.last_board_remaining_stars = int( so.data[ 'last_board_remaining_stars' ] );
			game_state.setting_disable_hints = int( so.data[ 'setting_disable_hints' ] );
			
		}
		
		static public function save():void
		{
			var so:SharedObject = SharedObject.getLocal( stats_key );
			
			so.data[ 'load_counter' ] = game_state.load_counter;
			so.data[ 'total_boards_played' ] = game_state.total_boards_played;
			so.data[ 'total_unique_boards' ] = game_state.total_unique_boards;
			so.data[ 'total_seconds_playing' ] = game_state.total_seconds_playing;
			so.data[ 'total_boards_solved' ] = game_state.total_boards_solved;
			so.data[ 'total_moves' ] = game_state.total_moves;
			so.data[ 'total_pieces_removed' ] = game_state.total_pieces_removed;
			so.data[ 'min_moves_to_solve' ] = game_state.min_moves_to_solve;
			so.data[ 'longest_winining_streak' ] = game_state.longest_winining_streak;
			so.data[ 'current_streak' ] = game_state.current_streak;
			so.data[ 'last_board_moves' ] = game_state.last_board_moves;
			so.data[ 'last_board_retries' ] = game_state.last_board_retries;
			so.data[ 'last_board_seconds' ] = game_state.last_board_seconds;
			so.data[ 'max_retries_for_any_round' ] = game_state.max_retries_for_any_round;
			so.data[ 'high_score' ] = game_state.high_score;
			so.data[ 'sound_enabled' ] = game_state.sound_enabled;
			
			so.data[ 'setting_big_board' ] = game_state.setting_big_board;
			so.data[ 'setting_initial_matches' ] = game_state.setting_initial_matches;
			so.data[ 'setting_tougher_stars' ] = game_state.setting_tougher_stars;
			so.data[ 'setting_piece_1_enabled' ] = game_state.setting_piece_1_enabled;
			so.data[ 'setting_piece_2_enabled' ] = game_state.setting_piece_2_enabled;
			so.data[ 'setting_piece_3_enabled' ] = game_state.setting_piece_3_enabled;
			so.data[ 'setting_piece_4_enabled' ] = game_state.setting_piece_4_enabled;
			so.data[ 'setting_piece_5_enabled' ] = game_state.setting_piece_5_enabled;
			so.data[ 'setting_piece_6_enabled' ] = game_state.setting_piece_6_enabled;
			so.data[ 'setting_piece_7_enabled' ] = game_state.setting_piece_7_enabled;
			so.data[ 'setting_piece_8_enabled' ] = game_state.setting_piece_8_enabled;
			so.data[ 'setting_piece_9_enabled' ] = game_state.setting_piece_9_enabled;
			so.data[ 'setting_piece_10_enabled' ] = game_state.setting_piece_10_enabled;

			so.data[ 'setting_piece_11_enabled' ] = game_state.setting_piece_11_enabled;
			so.data[ 'setting_piece_12_enabled' ] = game_state.setting_piece_12_enabled;
			so.data[ 'setting_piece_13_enabled' ] = game_state.setting_piece_13_enabled;
			so.data[ 'setting_piece_14_enabled' ] = game_state.setting_piece_14_enabled;
			so.data[ 'setting_piece_15_enabled' ] = game_state.setting_piece_15_enabled;
			so.data[ 'setting_piece_16_enabled' ] = game_state.setting_piece_16_enabled;
			so.data[ 'setting_piece_17_enabled' ] = game_state.setting_piece_17_enabled;
			so.data[ 'setting_piece_18_enabled' ] = game_state.setting_piece_18_enabled;
			so.data[ 'setting_piece_19_enabled' ] = game_state.setting_piece_19_enabled;
			so.data[ 'setting_piece_20_enabled' ] = game_state.setting_piece_20_enabled;
			so.data[ 'setting_piece_21_enabled' ] = game_state.setting_piece_21_enabled;
			so.data[ 'setting_piece_22_enabled' ] = game_state.setting_piece_22_enabled;
			so.data[ 'setting_piece_23_enabled' ] = game_state.setting_piece_23_enabled;
			so.data[ 'setting_piece_24_enabled' ] = game_state.setting_piece_24_enabled;
			so.data[ 'setting_piece_25_enabled' ] = game_state.setting_piece_25_enabled;
			
			so.data[ 'last_board_fewest_remaining_stars' ] = game_state.last_board_fewest_remaining_stars;
			so.data[ 'last_board_remaining_stars' ] = game_state.last_board_remaining_stars;
			
			so.data[ 'setting_disable_hints' ] = game_state.setting_disable_hints;

			so.flush();
		}

		protected function onExit( e:Event ):void
		{
			save();
		}
		
	}
}
