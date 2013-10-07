package com.lua 
{
	import com.pblabs.engine.entity.IEntity;
	import flash.utils.Dictionary;
	/**
	 * Make entities defined in LuaTemplateComponent 
	 */
	public class LuaTemplateManager 
	{
		public static var templatesByName:Dictionary = new Dictionary();
		
		public function LuaTemplateManager() 
		{
			
		}
		
		internal static function add(comp:LuaTemplateComponent):void
		{
			templatesByName[ comp.name ] = comp;
		}
		
		public static function makeEntity(groupName:String, templateName:String, entityName:String=null, params:Object = null):IEntity
        {
			var entity:IEntity;
			if ( templatesByName[ groupName ] )
			{
				entity = (templatesByName[groupName] as LuaTemplateComponent).make( templateName, params );
			}
			else
			{
				throw new Error("Cannot find the script: " + groupName + ", " + templateName +"." );
			}
			
			return entity;
        }
		
	}

}