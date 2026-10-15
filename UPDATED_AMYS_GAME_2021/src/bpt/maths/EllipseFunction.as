package bpt.maths 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author BPT
	 */
	public class EllipseFunction implements I2DFunction
	{
		private var _a:Number = 1;
		private var _b:Number = 1;
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		public function EllipseFunction( x_:Number, y_:Number, a_:Number, b_:Number ) 
		{
			x = x_;
			y = y_;
			a = a_;
			b = b_;
		}
		
		public function get a():Number
		{
			return _a;
		}
		
		public function set a( v:Number ):void
		{
			_a = v;
		}
		
		public function get b():Number
		{
			return _b;
		}
		
		public function set b( v:Number ):void
		{
			_b = v;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x( v:Number ):void
		{
			_x = v;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y( v:Number ):void
		{
			_y = v;
		}
		
		/* INTERFACE bpt.maths.I2DFunction */
		
		public function GetSample(p:Point, t:Number):Point 
		{
			var phi:Number = t * Math.PI * 2;
			
			p.x = _x + Math.cos( phi ) * _a;
			p.y = _y + Math.sin( phi ) * _b;
			
			return p;			
		}
		
		public function Sample(t:Number):Point 
		{
			return GetSample( new Point(), t );
		}
		
	}

}