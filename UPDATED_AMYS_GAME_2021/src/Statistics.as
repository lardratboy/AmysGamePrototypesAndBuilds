package 
{
	import assets;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import SimplePanel;
	import bpt.game.game_state;
	import DynamicTextHolder;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class Statistics extends SimplePanel
	{
		protected var holder_:Sprite;
		protected var reset_button_:ScaledAssetButton;
		
		public function Statistics():void
		{
			super();
		}
		
		static private var banner_asset_name_:String = "statistics_button";
		
		protected override function GetBannerAssetName():String
		{
			return banner_asset_name_;
		}
		
		protected override function Create():void
		{
			super.Create();
			
			holder_ = new Sprite();
			addChild( holder_ );
			
			reset_button_ = new ScaledAssetButton( "reset_button" );
			reset_button_.x = background_panel_.x;
			reset_button_.y = background_panel_.y + background_panel_.height/2 - reset_button_.height * 1.0;
			reset_button_.addEventListener( MouseEvent.CLICK, OnResetButton );
			addChild( reset_button_ );
		}
		
		protected function OnResetButton( e:MouseEvent ):void
		{
			Core.instance.GotoConfirmResetStatistics( null );
			
			Dismiss();
		}
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			reset_button_.Enable( b );
		}
		
		protected function StatsNode( item:DynamicTextHolder, text:String ):DynamicTextHolder
		{
			if ( null == item )
			{
				item = new DynamicTextHolder();
				
				holder_.addChild( item );
			}
			
			// trace( text );
			
			item.SetText( text );
			
			return item;
		}

		protected var total_boards_played:DynamicTextHolder = null;
		protected var total_seconds_played:DynamicTextHolder = null;
		protected var total_boards_solved:DynamicTextHolder = null;
		protected var min_moves_to_solve:DynamicTextHolder = null;
		protected var max_retries_for_any_round:DynamicTextHolder = null;
		protected var longest_winining_streak:DynamicTextHolder = null;
		protected var current_streak:DynamicTextHolder = null;
		protected var high_score:DynamicTextHolder = null;
		
		//protected var total_unique_boards:DynamicTextHolder = null;
		//protected var total_moves:DynamicTextHolder = null;
		//protected var total_pieces_removed:DynamicTextHolder = null;
		//protected var last_board_moves:DynamicTextHolder = null;
		//protected var last_board_retries:DynamicTextHolder = null;
		
		static public function SecondsToTimeMessage( seconds:Number ):String
		{
			var minutes:Number = (seconds + 30) / 60;
			
			var hours:Number = minutes / 60;
			
			if ( true )
			{
				minutes = Math.floor( minutes );
				
				return minutes + " minutes";
			}
			
			hours = Math.floor( hours * 10 ) / 10;
			
			return hours + " hours";
		}
		
		protected function MovesToMessage( moves:int ):String
		{
			if ( int.MAX_VALUE == moves ) return "NA";
			
			return moves.toString();
		}
		
		protected override function reinit( e:Event ):void
		{
			super.reinit( e );
			
			total_seconds_played = StatsNode( total_seconds_played, "Total time played: " + SecondsToTimeMessage( game_state.total_seconds_playing ) );
			total_boards_solved = StatsNode( total_boards_solved, "Number of rounds won: " + game_state.total_boards_solved );
			total_boards_played = StatsNode( total_boards_played, "Total rounds played: " + game_state.total_boards_played );
			min_moves_to_solve = StatsNode( min_moves_to_solve, "Fewest moves to win a round: " + MovesToMessage( game_state.min_moves_to_solve ) );
			longest_winining_streak = StatsNode( longest_winining_streak, "Longest winining streak: " + game_state.longest_winining_streak );
			current_streak = StatsNode( current_streak, "Current winning streak: " + game_state.current_streak );
			max_retries_for_any_round = StatsNode( max_retries_for_any_round, "Most retries: " + game_state.max_retries_for_any_round );
			high_score = StatsNode( high_score, "High Score: " + game_state.high_score );
			
			//total_unique_boards = StatsNode( total_unique_boards, "Boards generated " + game_state.total_unique_boards );
			//total_moves = StatsNode( total_moves, game_state.total_moves + " moves made" );
			//total_pieces_removed = StatsNode( total_pieces_removed, "Pieces removed " + game_state.total_pieces_removed );
			//last_board_moves = StatsNode( last_board_moves, "Moves last board " + game_state.last_board_moves );
			//last_board_retries = StatsNode( last_board_retries, game_state.last_board_retries + " retries last board" );
			
			var yPos:int = 0;
			var yGap:int = 10 * assets.asset_runtime_scale_factor + 0.5;
			
			for ( var i:int = 0; i < holder_.numChildren; ++i )
			{
				var dobj:DisplayObject = holder_.getChildAt( i );
				
				dobj.x = 0;
				dobj.y = yPos;
				yPos += (dobj.height + yGap);
			}
			
			holder_.x = this.background_panel_.x;
			holder_.y = this.background_panel_.y - (holder_.height/2);
			
		}
	}
	
}

