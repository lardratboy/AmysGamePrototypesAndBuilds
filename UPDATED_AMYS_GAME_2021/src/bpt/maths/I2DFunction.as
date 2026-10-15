package bpt.maths
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author BPT
	 */
	public interface I2DFunction
	{
		function GetSample( p:Point, t:Number ):Point;
		function Sample( t:Number ):Point;
	}

}