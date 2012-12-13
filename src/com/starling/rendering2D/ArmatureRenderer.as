package com.starling.rendering2D 
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.PBE;
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
	public class ArmatureRenderer extends DisplayObjectRenderer implements ITickedObject
	{
		
		/**
		 * The Skeleton Animation swf output (with xml merged) that was exported from Dragon Bones 
		 */
		//public var resource:DataResource;
		
		public var armatureName:String;
		
		public var factory:FactoryComponent;
		
		public var defaultAnimation:String;
		
		public function get armature():Armature
		{
			return _armature;
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			PBE.processManager.addTickedObject(this);
		}
		
		public function onTick(deltaTime:Number):void
		{
			
			if ( armature == null && factory != null && factory.isReady )
				onFactoryReady();
			
			if ( armature != null )
				armature.update(); 
		}
		
		protected function onFactoryReady(e:Event = null):void
		{
			
			if ( armatureName != null )
			{
				_armature = factory.factory.buildArmature(armatureName);
				armatureClip = armature.display as Sprite;
				this.displayObject = armatureClip;
				
				if ( defaultAnimation != null )
					armature.animation.gotoAndPlay(defaultAnimation);
					
				armature.update();
				
				if ( displayObject != null && scene != null && scene.sceneView != null )
					scene.add( this );
				
			}
		}
		
		

		protected var armatureClip:Sprite;
		protected var _armature:Armature;
	}

}