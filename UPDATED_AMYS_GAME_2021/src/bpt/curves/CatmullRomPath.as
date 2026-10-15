package bpt.curves 
{
	import flash.geom.Point;
	import bpt.maths.I2DFunction;
	
	/**
	 * ...
	 * @author BPT
	 */
	public class CatmullRomPath implements I2DFunction
	{
		protected var _points:Array = [];
		
		static protected var _distanceNeeded:Number = 33;
		
		public function CatmullRomPath() 
		{
		}
		
		public function Begin():void
		{
			_points = [];
		}
		
		public function AddPoint( p:Point, clone:Boolean = false ):void
		{
			if ( clone )
			{
				_points.push( p.clone() );
				return;
			}
			
			_points.push( p );
		}
		
		public function End():void
		{
		}
		
		public function PointCount():int
		{
			return _points.length;
		}
		
		public function GetSample( p:Point, t:Number ):Point
		{
			t = Math.max( 0, Math.min( t, 1 ) );
			var n:int = (_points.length - 1);
			var where:Number = t * n;
			var segment:int = where;
			
			var p0:Point = _points[ Math.max( 0, Math.min( segment - 1, n ) )];
			var p1:Point = _points[ Math.max( 0, Math.min( segment , n ) )];
			var p2:Point = _points[ Math.max( 0, Math.min( segment + 1, n ) )];
			var p3:Point = _points[ Math.max( 0, Math.min( segment + 2, n ) )];
			
			t = where - segment;
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			
			// http://www.mvps.org/directx/articles/catmull/ 
			// this calculation lends itself well to modification
			// if the original points never change then the terms not
			// involved with 'T' can be calculated once! - basically
			// reducing the sampling function to a couple array lookups and
			// and a few multiplies
			
			p.x = (0.5 *((2 * p1.x) +
				(-p0.x + p2.x) * t +
				(2*p0.x - 5*p1.x + 4*p2.x - p3.x) * t2 +
				( -p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3));
				
			p.y = (0.5 *((2 * p1.y) +
				(-p0.y + p2.y) * t +
				(2*p0.y - 5*p1.y + 4*p2.y - p3.y) * t2 +
				( -p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3));
				
			return p;
		}
		
		public function Sample( t:Number ):Point
		{
			return GetSample( new Point(), t );
		}
		
		/**
		 * Reparameterize
		 * 
		 * This was my cheap/first attempt to add additional control points
		 * to make navigation of the curve to be more consistent - this 
		 * should pass through the original control points and get close to
		 * having the same number of steps between all control points. (BPT)
		 * 
		 */
		
		/**
		 * AddRetargetedPoints
		 * 
		 * add new control points for the curve to make the distance between points are more consistant
		 * 
		 * @param	path
		 * @param	current
		 * @param	currentT
		 * @param	next
		 * @param	nextT
		 * @param	originalPath
		 */
		
		private static function AddRetargetedPoints( path:CatmullRomPath, current:Point, currentT:Number, next:Point, nextT:Number, originalPath:CatmullRomPath ):void
		{
			// always add the current point as it MUST pass thru node from the original
			
			path.AddPoint( current );
			
			// add additional control points (on the original path)
			// the distance between sub-division really shouldn't be
			// constant - it needs to be adjusted to match the arcLength...
			
			var dx:Number = next.x - current.x;
			var dy:Number = next.y - current.y;
			var length:Number = Math.sqrt(dx * dx + dy * dy); // should use ArcLengthAdaptorPath.FindArcLength?
			var count:Number = Math.ceil( length / _distanceNeeded ) + 1;
			
			if ( 2 > count ) return;
			
			var dT:Number = (nextT - currentT) / count;
			
			var t:Number = currentT;
			
			for ( var i:int = count - 2; 0 < count; --count )
			{
				path.AddPoint( originalPath.Sample( t += dT ) );
			}
		}
		
		/**
		 * Reparameterize
		 * 
		 * This was my cheap/first attempt to add additional control points
		 * to make navigation of the curve to be more consistent - this 
		 * should pass through the original control points and get close to
		 * having the same number of steps between all control points. (BPT)
		 * 
		 * @param	path
		 * @return
		 */
		
		public static function Reparameterize( path:CatmullRomPath ):CatmullRomPath
		{
			var p2:CatmullRomPath = new CatmullRomPath();
			
			var n:Number = path._points.length;
			var l:Number = n - 1;
			
			var t:Number = 0;
			var d:Number = 1 / l;
			
			var next:Point = path.Sample( t );
			
			for ( var i:Number = 0; i < n; ++i )
			{
				var current:Point = next;
				
				next = path.Sample( t + d );
				
				AddRetargetedPoints( p2, current, t, next, t += d, path );
			}
			
			p2.End();
			
			return p2;
		}
		
	}		

}