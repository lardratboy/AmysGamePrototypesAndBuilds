package bpt 
{
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author bpt
	 */
	public class Helpers
	{
		// MouseEvents as an array
		
		static public var MouseEvents:Array = [
			MouseEvent.CLICK,
			MouseEvent.DOUBLE_CLICK,
			MouseEvent.MOUSE_DOWN,
			MouseEvent.MOUSE_MOVE,
			MouseEvent.MOUSE_OUT,
			MouseEvent.MOUSE_OVER,
			MouseEvent.MOUSE_UP,
			MouseEvent.MOUSE_WHEEL,
			MouseEvent.ROLL_OUT,
			MouseEvent.ROLL_OVER,
		];
		
		// could set a random policy ?
		
		static public function Rnd( low:Number, high:Number ) : Number
		{
			return low + (Math.random() * (high - low));
		}
		
		static public function Rnd8() : uint
		{
			return (uint)(Helpers. Rnd( 0, 255 ));
		}
		
		static public function RGBA8( r:uint, g:uint, b:uint, a:uint = 255 ) : uint
		{
			return (
				(uint)((a & 255) << 24) +
				(uint)((r & 255) << 16) +
				(uint)((g & 255) << 8) +
				(uint)(b & 255) );
		}
		
		static public function RandomRGBA8( a:Object = null ):uint
		{
			return Helpers.RGBA8( Rnd8(), Rnd8(), Rnd8(), (null != a) ? (uint)(a) : 255 );
		}
	}

}