package bpt.game
{
	import bpt.game.IActSomethingtLikeAMovieClipFromAS2;
	//import bpt.game.GameSprite_Ref;
	import bpt.util.Allocator;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class onEnterFrame_Ref
	{
		public var mc:IActSomethingtLikeAMovieClipFromAS2; // needs to be managed by the MovieClip_Ref.onEnterFrame...
		public var code:Function;
		
		static public function Alloc():onEnterFrame_Ref
		{
			return (onEnterFrame_Ref)( Allocator.Alloc( onEnterFrame_Ref ) );
		}
	}
}
