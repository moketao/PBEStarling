package com.starling.rendering2D 
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.factorys.StarlingFactory;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import flash.events.Event;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class ArmatureRenderer extends DisplayObjectRenderer implements ITickedObject
	{
		public static var ARMATURE_READY:String = "armature_ready";
		
		public var armatureName:String;
		
		public var factory:FactoryComponent;
		
		public var defaultAnimation:String;
		
		[EditorData(ignore="true")]
		public function get armature():Armature
		{
			return _armature;
		}
		
		public function set armature(value:Armature):void
		{
			_armature = value;
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
				armature.advanceTime(deltaTime); 
		}
		
		protected function onFactoryReady(e:Event = null):void
		{
			
			if ( armatureName != null )
			{
				_armature = factory.factory.buildArmature(armatureName);
				armatureClip = armature.display as Sprite;
				this.displayObject = armatureClip;
				
				this.updateTransform(true);
				
				if ( defaultAnimation != null )
					armature.animation.gotoAndPlay(defaultAnimation, 0, 0);
				
				smoothBones(armature, TextureSmoothing.TRILINEAR);
				
				//armature.advanceTime();
				
				if ( displayObject != null && scene != null && scene.sceneView != null )
				{
					try {
					scene.add( this );
					}
					catch (e:Error)
					{
						trace(e.message);
					}
				}
					
				owner.eventDispatcher.dispatchEvent(new Event(ArmatureRenderer.ARMATURE_READY ) );
			}
		}
		
		protected function smoothBones(armature:Armature, smoothing:String = TextureSmoothing.TRILINEAR):void
		{
			var bones:Vector.<Bone> = armature.getBones();
			for (var i:int = 0; i < bones.length; i++ )
			{
				var b:Bone = bones[i];
				var img:Image;
				if ( b.display is Image )
					(b.display as Image).smoothing = smoothing;
					
				if ( b.childArmature )
				{
					smoothBones(b.childArmature, smoothing);
				}
			}
		}
		
		
		protected var armatureClip:Sprite;
		protected var _armature:Armature;
	}

}