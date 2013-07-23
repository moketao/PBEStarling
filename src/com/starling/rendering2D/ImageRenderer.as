package com.starling.rendering2D 
{
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import flash.events.Event;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * Renders an image in Starling using the starling.display.Image class.
	 * 
	 * <listing>
		 <component type="com.starling.rendering2D.ImageRenderer" name="Render">
			<spriteSheet componentReference="PlatformSpriteSheet"/>
			<scene componentReference="Scene"/>
			<positionProperty>@Spatial.position</positionProperty>
			<rotationProperty>@Spatial.rotation</rotationProperty>
			<scaleProperty>@Spatial.scale</scaleProperty>
		</component>
	   </listing>
	 */
	public class ImageRenderer extends DisplayObjectRenderer 
	{
		public var textureComponent:TextureComponent;
		
		
		protected var _color:int = -1;
		protected var _image:Image;
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( image == null && textureComponent != null && textureComponent.isLoaded ) 
				onTextureComplete();
			else if( textureComponent != null )//texture isn't loaded
				textureComponent.eventDispatcher.addEventListener(Event.COMPLETE, onTextureComplete );
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			if ( textureComponent )
				textureComponent.eventDispatcher.removeEventListener(Event.COMPLETE, onTextureComplete );
		}
		
		protected function onTextureComplete(e:Event=null):void
		{
			if ( textureComponent )
			{
				textureComponent.eventDispatcher.removeEventListener(Event.COMPLETE, onTextureComplete );
				if ( textureComponent.texture != null )
				{
					image = new Image(textureComponent.texture);
					if (scene != null && scene.sceneView != null )
						scene.add( this );
				}
			}
		}
		
		public function updateTexture(newTexture:TextureComponent):void
		{
 			if ( newTexture != null && newTexture.isLoaded ) 
			{
				if (scene != null && scene.sceneView != null )
				{
					scene.remove(this);
					textureComponent = newTexture;
					if( image )
						image.dispose();
					image = new Image(textureComponent.texture);
					this.updateTransform(true);
					
					scene.add( this );
				}
			}
		}
		
		[EditorData(ignore="true")]
		public function get image():Image
		{
			return _image;
		}
		
		public function set image(value:Image):void
		{
			_image = value;
			this.displayObject = image;
		}
		
		[EditorData(defaultValue="4294967295")]
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			if (value == _color)
                return;
				
			_color = value;
			_transformDirty = true;
		}
		
		override public function updateTransform(updateProps:Boolean = false):void 
		{
			super.updateTransform(updateProps);
			
			if ( _color >= 0 )
			{
				image.color = this.color;
			}
		}
		
		
	}

}