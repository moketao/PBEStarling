package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import dragonBones.factorys.StarlingFactory;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class FactoryComponent extends EntityComponent 
	{
		/**
		 * The Skeleton Animation swf output (with xml merged) that was exported from Dragon Bones 
		 */
		public var resource:DataResource;
		
		
		public var factory:StarlingFactory = new StarlingFactory();
		
		public var isReady:Boolean = false;
		
		override protected function onAdd():void 
		{
			super.onAdd();
			if ( resource != null && resource.isLoaded )
			{
				onResourceComplete();
			}
			else if ( resource != null )
			{
				resource.addEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
				resource.load(resource.filename);
			}
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
		}
		
		
		protected function onResourceComplete(e:Event = null):void 
		{
			resource.removeEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
			
			factory.addEventListener(Event.COMPLETE, textureCompleteHandler);
			factory.parseData(resource.data); //calls the textureCompleteHandler when finished
		}
		
		
		protected function textureCompleteHandler(e:Event=null):void 
		{
			if( resource != null )
				resource.removeEventListener(ResourceEvent.LOADED_EVENT, textureCompleteHandler );
			
			factory.removeEventListener(Event.COMPLETE, textureCompleteHandler);
			
			isReady = true;
			
		}
		
	}

}