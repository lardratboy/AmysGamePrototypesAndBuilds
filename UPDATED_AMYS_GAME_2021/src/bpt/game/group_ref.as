package bpt.game
{
	import bpt.game.piece_ref;
	import bpt.util.Allocator;

	/**
	 * ...
	 * @author BPT
	 */
	public final class group_ref
	{
		public var group_id:int;
		public var length:int;
		public var pHead:piece_ref;
		public var pNextGroup:group_ref;
		public var pPrevGroup:group_ref;
		
		public function reset():void
		{
			group_id = 0;
			length = 0;
			pHead = null;
			pNextGroup = null;
			pPrevGroup = null;
		}
		
		public function group_ref()
		{
			reset();
		}
		
		public function push( p:piece_ref ):void
		{
			++length;
			
			p.pGroupNext = pHead;
			
			pHead = p;
		}
		
		public function pop():piece_ref
		{
			var p:piece_ref = pHead;
			
			pHead = pHead.pGroupNext;
			
			--length;
			
			return p;
		}

		static public function Alloc():group_ref
		{
			return (group_ref)( Allocator.Alloc( group_ref ) );
		}
		
	}
}
