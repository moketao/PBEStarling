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
		
		override protected function onRemove():void 
		{
			super.onRemove();
			if( armature != null )
				armature.dispose();
				
			PBE.processManager.removeTickedObject(this);
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