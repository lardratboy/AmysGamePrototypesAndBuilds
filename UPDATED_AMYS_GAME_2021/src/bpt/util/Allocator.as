package bpt.util 
{
	/**
	 * ...
	 * @author BPT
	 */
	public class Allocator
	{
		import flash.utils.Dictionary;
		import flash.utils.getQualifiedClassName;
		import flash.utils.getDefinitionByName;
		
		static protected var allocators_:Dictionary = new Dictionary();
		
		static protected function GetCacheForType( type:Class, fnReset:Function = null, prealloc:int = 64 ):AllocatorCache
		{
			var cache:AllocatorCache = allocators_[ type ];
			
			if ( null == cache )
			{
				cache = new AllocatorCache( type, fnReset, prealloc );
				
				allocators_[ type ] = cache;
			}
			
			return cache;
		}
		
		static public function Alloc( type:Class ):Object
		{
			var cache:AllocatorCache = GetCacheForType( type );
			
			return cache.Alloc();
		}
		
		static public function Release( object:Object ):void
		{
			var className:String = flash.utils.getQualifiedClassName( object );
			var type:Class = flash.utils.getDefinitionByName( className ) as Class;

			var cache:AllocatorCache = GetCacheForType( type );
			
			return cache.Release( object );
		}
		
		static public function Register( type:Class, reset:Function, prealloc:int ):void
		{
			var cache:AllocatorCache = GetCacheForType( type, reset, prealloc );
		}
	}

}

internal class AllocatorCache
{
	public var type_:Class;
	
	public var fnReset_:Function;
	
	public var cache_:Array = new Array();
	
	public function AllocatorCache( type:Class, fnReset:Function = null, prealloc:int = 0 )
	{
		type_ = type;
		
		Adjust( fnReset, prealloc );
	}
	
	public function Alloc():Object
	{
		if ( 0 == cache_.length )
		{
			
//trace( "new " + type_ );
			
			return new type_();
		}
		
//trace( "recycle " + type_ );
			
		return cache_.pop();
	}
	
	public function Release( object:Object ):void
	{
		if ( -1 != cache_.indexOf( object ) )
		{
			trace( "BUG BUG BUG BUG - object is already in cache!!!!" );
		}
		
		if ( null != fnReset_ )
		{
			fnReset_( object );
		}
		
		cache_.push( object );
	}
	
	public function Adjust( fnReset:Function, prealloc:int ):void
	{
		if ( (null != fnReset_) && (fnReset != fnReset_) )
		{
			trace( "assigning the cache instance reset function for type " + type_ + " more than once this is most likely a bug!" );
		}
		
		fnReset_ = fnReset;
		
		for ( var i:int = prealloc - cache_.length; 0 <= --i; )
		{
			// trace( "preallocating " + i + " remaining" );
			
			Release( Alloc() );
		}
	}
}
