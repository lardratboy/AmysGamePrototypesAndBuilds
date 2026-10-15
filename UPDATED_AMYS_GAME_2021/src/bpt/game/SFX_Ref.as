package bpt.game
{
	import flash.media.Sound;
	
	import bpt.game.game_state;
	
	/**
	 * ...
	 * @author BPT
	 */
	public final class SFX_Ref
	{
		public var name:String;
		public var sound:Sound;
		
		public function SFX_Ref( resource:String )
		{
			name = resource;
			sound = sound_assets.GetSound( resource );
		}
		
		public function Start( loops:int = 0 ):void
		{
			if ( (null == sound) || (!game_state.sound_enabled) ) return;
			
			sound.play( 0, loops );
		}
	}
}
