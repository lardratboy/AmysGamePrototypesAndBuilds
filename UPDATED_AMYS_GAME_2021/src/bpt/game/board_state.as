package bpt.game
{
	/**
	 * ...
	 * @author BPT
	 */
	public final class board_state
	{
		static public var multiplier:Number;
		static public var score:int;
		static public var active_rows:int;
		static public var active_cols:int;
		static public var meta_cols_layout:Vector.<int> = new Vector.<int>();
		static public var board_layout:Vector.< Vector.<int> > = new Vector.< Vector.<int> >();
		
		static public function CaptureState():void
		{
		}
	}
}
