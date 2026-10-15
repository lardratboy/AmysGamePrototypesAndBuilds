package bpt.maths 
{
	import bpt.maths.I2DFunction;
	import flash.geom.Point;
	
	// ------------------------------------------------------------------------
	// with various help from 
	// http://gamedev.stackexchange.com/questions/5373/moving-ships-between-two-planets-along-a-bezier-missing-some-equations-for-accel
	// http://www.planetclegg.com/projects/WarpingTextToSplines.html
	// ------------------------------------------------------------------------
		
	/**
	 * ...
	 * @author BPT
	 */
	public class ArcLengthAdaptor implements I2DFunction
	{
		private var _capturedDivisonLengths:Array = null;
		private var _path:I2DFunction = null;
		private var _divisions:int;
		
		public function ArcLengthAdaptor( path:I2DFunction, divisions:int = 100 ) 
		{
			_path = path;
			_divisions = divisions;
		}
		
		/* INTERFACE bpt.maths.I2DFunction */
		
		public function GetSample(p:Point, t:Number):Point 
		{
			if ( null != _path )
			{
				_path.GetSample( p, ArcLengthParameterize( t ) ); 
			}
			
			return p;
		}
		
		public function Sample(t:Number):Point 
		{
			return GetSample( new Point(), t );
		}
		
		// --------------------------------------------------------------------
		
		public static function FindArcLength( path:I2DFunction, captureDivisonLengths:Array = null, from:Number = 0, to:Number = 1, divisions:Number = 100 ):Number
		{
			var samples:Number = divisions + 1;
			
			if ( (null != captureDivisonLengths) && (samples >= captureDivisonLengths.length) )
			{
				samples = captureDivisonLengths.length - 1;
			}
			
			var prev:Point = path.Sample( from );
			
			var sum:Number = 0;
			
			if ( null != captureDivisonLengths ) captureDivisonLengths[ 0 ] = 0;
			
			for ( var i:Number = 1; i <= samples; ++i )
			{
				var t:Number = Math.max( from, Math.min( to * i / samples, to ) );
				var curr:Point = path.Sample( t );
				var dx:Number = curr.x - prev.x;
				var dy:Number = curr.y - prev.y;
				
				sum += Math.sqrt( (dx * dx) + (dy * dy) );

				if ( null != captureDivisonLengths ) captureDivisonLengths[ i ] = sum;
				
				prev = curr;
			}
			
			return sum;
		}

		// --------------------------------------------------------------------
		
		public function ArcLengthParameterize( t:Number ):Number
		{
			if ( (null != _path) && (null == _capturedDivisonLengths) )
			{
				_capturedDivisonLengths = new Array( _divisions + 1 );
			
				ArcLengthAdaptor.FindArcLength( _path, _capturedDivisonLengths, 0, 1, _divisions );
			}
			
			var u:Number = t;
			
			// ------------------------------------------------------------
			
			var lastCaptureIndex:Number = _capturedDivisonLengths.length - 1;
			var targetLength:Number = t * _capturedDivisonLengths[ lastCaptureIndex ];
			
			var index:int = 0;
			var low:int = 0;
			var high:int = lastCaptureIndex;
			
			while (low < high)
			{
				index = low + ((high - low) / 2);
				
				if ( targetLength > _capturedDivisonLengths[index] )
				{
					low = index + 1;
				}
				else
				{
					high = index;
				}
			}
			
			if ( _capturedDivisonLengths[index] > targetLength )
			{
				index--;
			}

			var lengthBefore:Number = _capturedDivisonLengths[index];
			
			if (lengthBefore == targetLength)
			{
				return index / lastCaptureIndex;
			}
			
			return (index + (targetLength - lengthBefore) / (_capturedDivisonLengths[index + 1] - lengthBefore)) / lastCaptureIndex;
		}
		
	}

}