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
		
		
		private var _color:int = -1;
		private var _image:Image;
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( image != null && scene != null )
				scene.add( this );
			else if ( textureComponent != null && textureComponent.isLoaded ) 
				onTextureComplete();
			else if( textureComponent != null )//texture isn't loaded
				textureComponent.eventDispatcher.addEventListener(Event.COMPLETE, onTextureComplete );
		}
		
		private function onTextureComplete(e:Event=null):void
		{
			textureComponent.eventDispatcher.removeEventListener(Event.COMPLETE, onTextureComplete );
			if ( textureComponent.texture != null )
			{
				image = new Image(textureComponent.texture);
				if (scene != null && scene.sceneView != null )
					scene.add( this );
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
				image = new Image(textureComponent.texture);
				this.updateTransform(true);
				
					scene.add( this );
				}
			}
		}
		
		public function get image():Image
		{
			return _image;
		}
		
		public function set image(value:Image):void
		{
			_image = value;
			this.displayObject = image;
		}
		
		
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