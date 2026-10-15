package bpt.maths 
{
	/**
	 * ...
	 * @author BPT
	 */
	public class Misc
	{
		public function Misc() 
		{
		}
		
		static public function SinWaveZeroCrossingEveryN( theta:Number, zeros:Number = 1 )
		{
			return Math.sin( (theta * Math.PI) / zeros );
		}
		
		// makes some interesting looking things that could be used 
		// to draw background elements for a mario like game
		// f(x) = (((1 + sin(m x))^j / 2 - (1 + sin(p x)) / 2)^j n)^k s
		
	}

}