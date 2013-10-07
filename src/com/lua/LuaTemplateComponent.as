package com.lua 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.IEntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.engine.PBE;
	
	import sample.lua.CModule;
	import sample.lua.__lua_objrefs;
	import Lua;
	
	/**
	 * 
	 */
	public class LuaTemplateComponent extends LuaComponent 
	{
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			LuaTemplateManager.add( this );
		}
		
		public function make(templateName:String, initOptions:Object = null):IEntity
		{
			var ent:IEntity = PBE.allocateEntity();
			try {
				//Lua.lua_getglobal(luastate, "make");
				Lua.lua_getglobal(luastate, templateName); //call a lua function with templateName as the function name
				push_objref(ent);
				//Lua.lua_pushstring(luastate, templateName);
				//push_objref(initOptions);
				Lua.lua_callk(luastate, 1, 0, 0, null)
			} catch(e:*) {
				if(!panicabort)
					onError("Exception thrown while calling make:\n" + e + e.getStackTrace());
			}
			
			if ( initOptions != null )
				setProperties(ent, initOptions);
			
			// Finish deferring.
            if(ent.deferring)
                ent.deferring = false;
				
			return ent;
		}
		
		protected static function setProperties(entity:IEntity, params:Object):void
		{
			 // Set all the properties.
            for(var key:* in params)
            {
                if(key is PropertyReference)
                {
                    // Fast case.
                    entity.setProperty(key, params[key]);
                }
                else if(key is String)
                {
                    // Slow case.
                    // Special case to allow "@foo": to assign foo as a new component... named foo.
                    if(String(key).charAt(0) == "@" && String(key).indexOf(".") == -1)
                    {
                        entity.addComponent(IEntityComponent(params[key]), String(key).substring(1));
                    }
                    else
                    {
                        entity.setProperty(new PropertyReference(key), params[key]);
                    }
                }
                else
                {
                    // Error case.
                    Logger.error(PBE, "MakeEntity", "Unexpected key '" + key + "'; can only handle String or PropertyReference.");
                }
            }
		}
		
		
	}

}