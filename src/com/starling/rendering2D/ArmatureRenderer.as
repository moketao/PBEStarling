package com.starling.rendering2D 
{
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	import starling.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class ArmatureRenderer extends DisplayObjectRenderer 
	{
		
		/**
		 * The Skeleton Animation swf output (with xml merged) that was exported from Dragon Bones 
		 */
		public var resource:DataResource;
		
		public var armatureName:String;
		public var defaultAnimation:String;
		
		public function get armature():Armature
		{
			return _armature;
		}
		
		
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
		
		override public function advanceTime(deltaTime:Number):void 
		{
			super.advanceTime(deltaTime);
			
			if ( armature != null )
				armature.update(); 
		}
		
		private function onResourceComplete(e:Event = null):void 
		{
			resource.removeEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
			
			factory.addEventListener(Event.COMPLETE, textureCompleteHandler);
			factory.parseData(resource.data); //calls the textureCompleteHandler when finished
		}
		
		private function textureCompleteHandler(e:Event=null):void 
		{
			if( resource != null )
				resource.removeEventListener(ResourceEvent.LOADED_EVENT, textureCompleteHandler );
			
			factory.removeEventListener(Event.COMPLETE, textureCompleteHandler);
			
			if ( armatureName != null )
			{
				_armature = factory.buildArmature(armatureName);
				armatureClip = armature.display as Sprite;
				this.displayObject = armatureClip;
				
				if ( defaultAnimation != null )
					armature.animation.gotoAndPlay(defaultAnimation);
					
				armature.update();
				
				if ( displayObject != null && scene != null && scene.sceneView != null )
					scene.add( this );
				
			}
		}

		protected var factory:StarlingFactory = new StarlingFactory();;
		protected var armatureClip:Sprite;
		protected var _armature:Armature;
	}

}