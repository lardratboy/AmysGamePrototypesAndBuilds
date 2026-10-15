package bpt.game
{
	import bpt.game.piece_visual;
	import bpt.game.group_ref;
	import bpt.util.Allocator;
	
	/**
	 * ...
	 * @author BPT
	 */
	public final class piece_ref
	{
		public var occupied:Boolean;
		public var row:int;
		public var col:int;
		public var match_id:int;
		public var pGroupHead:group_ref;
		public var pGroupNext:piece_ref;
		protected var _clip_mc_:piece_visual;
		
		public function get clip_mc():piece_visual { return _clip_mc_; }
		
		public function set clip_mc( value:piece_visual ):void
		{
			if ( value != _clip_mc_ ) 
			{
				_clip_mc_ = value;
			}
		}
		
		public function clear( r:int, c:int ):void 
		{
			clip_mc = null;
			occupied = false;
			row = r;
			col = c;
			match_id = 0;
			pGroupHead = null;
			pGroupNext = null;
		}

		public function piece_ref( row_:int = 0, col_:int = 0, occupied_:Boolean = false )
		{
			clear( row_, col_ );

			occupied = occupied_;
		}
		
		static public function Alloc( row_:int = 0, col_:int = 0, occupied_:Boolean = false ):piece_ref
		{
			var piece:piece_ref = (piece_ref)( Allocator.Alloc( piece_ref ) );
			
			piece.clear( row_, col_ );

			piece.occupied = occupied_;
			
			return piece;
		}

	}
}
