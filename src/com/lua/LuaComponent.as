package com.lua 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import flash.utils.Dictionary;
	
	import sample.lua.__lua_objrefs;
	
	/**
	 * Lua Entity Component.
	 * Executes a Lua script that implements onAdd, onRemove
	 */
	public class LuaComponent extends EntityComponent 
	{
		protected var luaUtil:LuaUtil = null;//make sure it is included in the compile
		
		public var luascript:String;
		
		public var luaFile:DataResource = new DataResource();
		
		
		
		public var luastate:int;
		protected var panicabort:Boolean = false
		
		public function LuaComponent() 
		{
			
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( luaFile.isLoaded )
			{
				initLua();
			}
			else if ( luaFile )
			{
				luaFile.addEventListener(ResourceEvent.LOADED_EVENT, initLua );
			}
		}
		
		protected function initLua(e:ResourceEvent =null ):void
		{
			
			luascript = String(luaFile.data);
				
			// Initialize Lua and load our script
			var err:int = 0
			luastate = Lua.luaL_newstate()
			panicabort = false
			Lua.lua_atpanic(luastate, atPanic)
			Lua.luaL_openlibs(luastate)

			err = Lua.luaL_loadstring(luastate, luascript)
			if(err) {
				onError("Error " + err + ": " + Lua.luaL_checklstring(luastate, 1, 0))
				Lua.lua_close(luastate)
				return
			}
			
			try {
				sample.lua.__lua_objrefs = new Dictionary()

				// This runs everything in the global scope
				err = Lua.lua_pcallk(luastate, 0, Lua.LUA_MULTRET, 0, 0, null)

				// give the lua code a reference to this
				Lua.lua_getglobal(luastate, "onAdd")
				push_objref(this)
				//push_objref(Starling.current.nativeStage.stage3Ds[0].context3D)
				//Lua.lua_pushinteger(luastate, Starling.current.viewPort.width)
				//Lua.lua_pushinteger(luastate, Starling.current.viewPort.height)
				//Lua.lua_callk(luastate, 4, 0, 0, null)
				Lua.lua_callk(luastate, 1, 0, 0, null)
			} catch(e:*) {
				onError("Exception thrown while initializing code:\n" + e + e.getStackTrace());
			}
		}
		
		
		
		protected function push_objref(o:*):void
		{
			var udptr:int = Lua.push_flashref(luastate)
			sample.lua.__lua_objrefs[udptr] = o
		}
		
		public function atPanic(e:*): void
        {
        	onError("Lua Panic: " + Lua.luaL_checklstring(luastate, -1, 0))
        	panicabort = true
        }
		
		public function onError(e:*):void
        {
        	trace(e)
			Logger.error(this, "onAdd", String(e) );
        }
		
	}

}