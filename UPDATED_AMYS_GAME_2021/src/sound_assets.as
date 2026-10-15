package
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	import flash.system.Capabilities;
	
	import bpt.game._global;
	import bpt.game.game_state;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class sound_assets
	{
		// new
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/sfx/sfx_pack_noise.mp3" )]
		static public var sfx_pack_noise_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_lucky_spin.mp3" )]
		static public var sfx_lucky_spin_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_remove_column.mp3" )]
		static public var sfx_remove_column_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_bonus_mode.mp3" )]
		static public var sfx_bonus_mode_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_board_over.mp3" )]
		static public var sfx_board_over_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_super_jackpot.mp3" )]
		static public var sfx_super_jackpot_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_jackpot.mp3" )]
		static public var sfx_jackpot_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_winner.mp3" )]
		static public var sfx_winner_class:Class;
		
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/music/incompetech.com/Shades of Spring.mp3" )] // StyleFunk.mp3")] //
		static public var music_ambient_class:Class;
		
		// --------------------------------------------------------------------
		
		[Embed(source="../asset_sources/sfx/sfx_meta_remove.mp3" )]
		static public var sfx_meta_remove_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_board_cleared.mp3" )]
		static public var sfx_board_cleared_class:Class;
		
		[Embed(source="../asset_sources/sfx/sfx_no_moves.mp3" )]
		static public var sfx_no_moves_class:Class;
		
		// --------------------------------------------------------------------
		
		//[Embed(source="../asset_sources/sfx/sounds.swf", symbol="main_menu_sound.wav" )]
		//static public var main_menu_sound_class:Class;
		
		[Embed(source="../asset_sources/sfx/sounds.swf", symbol="sfx_remove_noise.wav" )]
		static public var sfx_remove_noise_class:Class;
		
		[Embed(source="../asset_sources/sfx/sounds.swf", symbol="sfx_slot_stop.wav" )]
		static public var sfx_slot_stop_class:Class;
		
		[Embed(source="../asset_sources/sfx/sounds.swf", symbol="silence.wav" )]
		static public var silence_class:Class;
		
		// --------------------------------------------------------------------
		
		static private var bInitialized:Boolean = false;
		
		static private var cache_:Object = new Dictionary();
		
		static private function AddToCache( name:String, sound:Sound ):void
		{
			cache_[ name ] = sound;
			
			//trace("AddToCache " + name + ", " + sound );
		}
		
		static public function Initialize():void
		{
			
//			if ( flash.system.Capabilities.isDebugger ) trace("sound_assets.INIT ->");
			
			__Initialize__();
			
//			if ( flash.system.Capabilities.isDebugger ) trace("<- sound_assets.INIT");
			
		}
		
		static public function __Initialize__():void
		{
			//trace("sound_assets.Initialize()");
			
			if ( bInitialized ) return;
			
			bInitialized = true;
			
			AddToCache( "sfx_pack_noise", new sfx_pack_noise_class() );
			AddToCache( "sfx_lucky_spin", new sfx_lucky_spin_class() );
			AddToCache( "sfx_remove_column", new sfx_remove_column_class() );
			AddToCache( "sfx_bonus_mode", new sfx_bonus_mode_class() );
			AddToCache( "sfx_board_over", new sfx_board_over_class() );
			AddToCache( "sfx_super_jackpot", new sfx_super_jackpot_class() );
			AddToCache( "sfx_jackpot", new sfx_jackpot_class() );
			AddToCache( "sfx_winner", new sfx_winner_class() );
			AddToCache( "music_ambient", new music_ambient_class() );
			
			AddToCache( "sfx_meta_remove", new sfx_meta_remove_class() );
			AddToCache( "sfx_board_cleared", new sfx_board_cleared_class() );
			AddToCache( "sfx_no_moves", new sfx_no_moves_class() );

			// AddToCache( "main_menu_sound", new main_menu_sound_class() );
			AddToCache( "sfx_remove_noise", new sfx_remove_noise_class() );
			AddToCache( "sfx_slot_stop", new sfx_slot_stop_class() );
			AddToCache( "silence", new silence_class() );
			
			//GetSound( "silence" ).play( 0, int.MAX_VALUE ); // trying to solve the speaker popping by constantly playing silence... 
			
		}
		
		static public function GetSound( asset:String ):Sound
		{
			if ( !bInitialized ) Initialize();
			
			var sound:Sound = cache_[asset];
			
			if ( null == sound)
			{
				trace( "missing sound asset \"" + asset + "\" generating fake ?" );
				
				AddToCache( asset, undefined );
				
				sound = cache_[asset];
			}
			else
			{
				// ??
			}
			
			return sound;
		}
		
		static public function PlaySound( asset:String, loops:int = 0 ):SoundChannel
		{
			if ( !game_state.sound_enabled ) return null;
			
			var sound:Sound = GetSound( asset );
			
			if ( null == sound ) return null;
			
			return sound.play( 0, loops );
		}
		
	}
}
