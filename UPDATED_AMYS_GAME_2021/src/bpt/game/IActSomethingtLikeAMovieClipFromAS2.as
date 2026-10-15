package bpt.game
{
	import starling.display.DisplayObject;
	import bpt.game.onEnterFrame_Ref;
	
	public interface IActSomethingtLikeAMovieClipFromAS2
	{
		function GetDisplayObject():DisplayObject;
		
		function removeMovieClip():void;
		function get onEnterFrame():onEnterFrame_Ref;
		function set onEnterFrame( value:onEnterFrame_Ref ):void;
		function callClosure_( e ):void;
		
		/*
		function get _xmouse():Number;
		function get _ymouse():Number;
		*/
		
		function get _name():String;
		function set _name( value:String ):void;
		
		function get _visible():Boolean;
		function set _visible( value:Boolean ):void;
		
		function get _x():Number;
		function set _x( value:Number ):void;
		
		function get _y():Number;
		function set _y( value:Number ):void;
		
		function get _xscale():Number;
		function set _xscale( value:Number ):void;
		
		function get _yscale():Number;
		function set _yscale( value:Number ):void;
		
		function get _width():Number;
		function get _height():Number;
		
		function get _rotation():Number;
		function set _rotation( value:Number ):void;
		
		function get _alpha():Number;
		function set _alpha( value:Number ):void;
		
		/*
		
		function play():void;
		function stop():void;
		function gotoAndStop( frame:String ):void;
		function gotoAndPlay( frame:String ):void;
		function getNextHighestDepth():int;
		function changeToHighestDepth():void;
		function get _currentFrame():int;
		function set _currentFrame( value:int ):void;
		function get _totalFrames():int;
		function set _totalFrames( value:int ):void;
		
		*/
		
		
	}
}