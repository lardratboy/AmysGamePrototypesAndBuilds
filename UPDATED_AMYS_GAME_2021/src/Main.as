package
{
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0x1283DF")]
	public class Main extends amys_game_shared_main
	{
		override protected function __GetDesiredCanvasWidth__():int
		{
			return 1024;
		}
		
		override protected function __GetDesiredCanvasHeight__():int
		{
			return 768;
		}
		
		function Main()
		{
			super();
		}
	}
}