package com.lua 
{
	/**
	 * ...
	 * @author Zo
	 */
	public class LuaUtil 
	{
		
		public function LuaUtil() 
		{
			
		}
		
		public static function setProp( object:*, propertyName:String, value:*):void
		{
			object[propertyName] = value;
		}
		
	}

}