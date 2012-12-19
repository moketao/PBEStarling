package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import flash.events.Event;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Zo
	 */
	public class ParticleRenderer extends DisplayObjectRenderer 
	{
		public var textureComponent:TextureComponent;
		public var config:XMLResource;
		
		public var particleSystem:PDParticleSystem;
		
		public var emitterPositionProperty:PropertyReference;
		
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( particleSystem != null && scene != null )
				scene.add( this );
			else if ( textureComponent != null && textureComponent.isLoaded && config && config.isLoaded) 
				init();
			else 
			{
				if( textureComponent != null && !textureComponent.isLoaded )//texture isn't loaded
					textureComponent.eventDispatcher.addEventListener(Event.COMPLETE, init );
				if ( config && !config.isLoaded )
					config.addEventListener(ResourceEvent.LOADED_EVENT, init );
			}
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			if( textureComponent )
				textureComponent.eventDispatcher.removeEventListener(Event.COMPLETE, init );
				
			if ( config )
				config.removeEventListener(ResourceEvent.LOADED_EVENT, init );
			
			if( particleSystem )
				particleSystem.dispose();
		}
		
		
		protected function init(e:Event=null):void
		{
			if ( particleSystem == null && textureComponent && textureComponent.isLoaded && config && config.isLoaded )
			{
				var psConfig:XML = config.XMLData;
				var psTexture:Texture = textureComponent.texture;
				
				particleSystem = new PDParticleSystem(psConfig, psTexture );
				
				this.displayObject = particleSystem;
				
				if ( scene )
					scene.add(this);
					
				//testing
				//scene.sceneView.addChild( particleSystem );
				//Starling.current.stage.addChild( particleSystem );
				particleSystem.start();
			}
		}
		
		public function get emitterPosition():Point
		{
			return _emitterPosition;
		}
		
		public function set emitterPosition(value:Point):void
		{
			if ( particleSystem && value && !value.equals( _emitterPosition) )
			{
				_emitterPosition = value;
				particleSystem.emitterX = value.x;
				particleSystem.emitterY = value.y;
			}
				
			//_transformDirty = true;
		}
		
		override public function advanceTime(deltaTime:Number):void 
		{
			trace(owner.name, "particle advanceTime");
			super.advanceTime(deltaTime);
			if( particleSystem )
				particleSystem.advanceTime(deltaTime);
				
		}
		
		override protected function updateProperties():void 
		{
			super.updateProperties();
			
			if ( emitterPositionProperty )
			{
				emitterPosition = owner.getProperty( emitterPositionProperty );
			}
		}
		
		private var _emitterPosition:Point = new Point();
	}

}