package bpt.util
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	/**
	 * ...
	 * @author BPT
	 */
	public class BitStreamReader
	{
		private var _bytes:ByteArray;
		private var _cache:uint;
		private var _mask:uint;
		
		public function BitStreamReader( source:IDataInput = null ) 
		{
			reset( source );
		}
		
		private function reset( source:IDataInput = null ):void
		{
			if ( null != source )
			{
				_bytes = new ByteArray();
				
				source.readBytes( _bytes );
			}
			else
			{
				if ( null != _bytes )
				{
					_bytes.position = 0;
				}
				else
				{
					_bytes = new ByteArray();
				}
			}
			
			_cache = 0;
			_mask = 0; // force a cache refill first read...
		}
		
		public function read():Boolean
		{
			_mask <<= 1;
			
			if ( 0 == _mask )
			{
				_cache = 0;
				
				for ( var i:int = 0; i < 4; ++i )
				{
					_cache |= ((0 < _bytes.bytesAvailable) ? _bytes.readUnsignedByte() : 0) << (i * 8);
				}
				
				_mask = 1;
			}
			
			return (0 != (_cache & _mask));
		}
		
		public function read_N( n:int ):uint
		{
			var bits:uint = 0;
			
			while ( 0 <= --n )
			{
				bits <<= 1;
				if ( read() ) ++bits;
			}
			
			return bits;
		}
		
	}

}