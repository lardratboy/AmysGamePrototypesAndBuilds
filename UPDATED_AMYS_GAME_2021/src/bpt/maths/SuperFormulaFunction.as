package bpt.maths
{
	import flash.geom.Point;
	import bpt.maths.I2DFunction;
	
	/**
	 * ...
	 * @author BPT
	 * my 'superformula' is a slightly tweaked* version of the offical version
	 * http://en.wikipedia.org/wiki/Superformula
	 * http://mathworld.wolfram.com/Superellipse.html
	 * http://local.wasp.uwa.edu.au/~pbourke/geometry/supershape/
	 * I added a rotational spin (to allow for yet a few more shape options) :P
	 */
	public class SuperFormulaFunction implements I2DFunction
	{
		private var _m:Number;
		private var _oo_a:Number;
		private var _a:Number;

		private var _oo_b:Number;
		private var _b:Number;

		private var _oo_n1:Number;
		private var _n1:Number;
		
		private var _n2:Number;
		private var _n3:Number;
		
		private var _spinCoefficient:Number = 0;
		
		public function SuperFormulaFunction() 
		{
			// default to a circle :)
			
			a = 1;
			b = 1;
			
			m = 2;
			
			n1 = 2;
			n2 = 2;
			n3 = 2;
			
			spin = 0;
		}

		public function get spin():Number
		{
			return _spinCoefficient;
		}
		
		public function set spin( v:Number ):void
		{
			_spinCoefficient = v;
		}
		
		public function get m():Number
		{
			return _m;
		}
		
		public function set m( v:Number ):void
		{
			_m = v;
		}
		
		public function get a():Number
		{
			return _a;
		}
		
		public function set a( v:Number ):void
		{
			_a = v;
			_oo_a = (0 != _a) ? (1 / _a) : 0;
		}
		
		public function get b():Number
		{
			return _b;
		}
		
		public function set b( v:Number ):void
		{
			_b = v;
			_oo_b = (0 != _b) ? (1 / _b) : 0;
		}
		
		public function get n1():Number
		{
			return _n1;
		}
		
		public function set n1( v:Number ):void
		{
			_n1 = v;
			_oo_n1 = (0 != _n1) ? (1 / _n1) : 0;
		}

		public function get n2():Number
		{
			return _n2;
		}
		
		public function set n2( v:Number ):void
		{
			_n2 = v;
		}
		
		public function get n3():Number
		{
			return _n3;
		}
		
		public function set n3( v:Number ):void
		{
			_n3 = v;
		}
		
		/**
		 * GetSample
		 * @param   p (where to store the point)
		 * @param	t (0 to 1)
		 * @return  a point on the 'superformula'
		 */
		
		public function GetSample( p:Point, t:Number ):Point
		{
			var phi:Number = (t * Math.PI * 2);
			
			var theta:Number = (_m / 4) * phi;
			
			var t1:Number = Math.cos( theta ) * _oo_a;
			t1 = Math.pow( Math.abs( t1 ), _n2 );
			
			var t2:Number = Math.sin( theta ) * _oo_b;
			t2 = Math.pow( Math.abs( t2 ), _n3 );

			var r:Number = Math.pow( t1 + t2, -_oo_n1 );
			
			if ( 0 == Math.abs(r) )
			{
				return new Point( 0, 0 );
			}
		   
			phi += (r * _spinCoefficient);  // bpt*
			
			p.x = r * Math.cos( phi );
			p.y = r * Math.sin( phi );
			
			return p;
		}
		
		/**
		 * Sample
		 * @param	t (0 to 1)
		 * @return  a point on the 'superformula'
		 */
		
		public function Sample( t:Number ):Point
		{
			return GetSample( new Point(), t );
		}
		// ------------------------------------------------------------------
		
		/**
		 * GenerateRandomSFF
		 * @param   n what is the range of random from [-n to n]
		 * @param	m (m-fold symetry) defaults to random [2 to 10]
		 * @return
		 */
		static public function GenerateRandomSFF( n:Number, m:Number = 0 ):SuperFormulaFunction
		{
			var n2:Number = n * 2;
			var sff:SuperFormulaFunction = new SuperFormulaFunction();
			
			sff.m = (0 == m) ? (Math.floor( 1 + Math.random() * 10) * 2 ) : m;
			sff.n1 = (Math.random() - 0.5) * n2;
			sff.n2 = (Math.random() - 0.5) * n2;
			sff.n3 = (Math.random() - 0.5) * n2;
			
			sff.a = Math.random();
			sff.b = Math.random();
			
			if ( 0.5 < Math.random() ) sff.spin = (Math.random() - 0.5) * 2;
			
			return sff;
		}
		
	}

}
