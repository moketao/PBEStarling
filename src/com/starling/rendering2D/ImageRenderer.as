package com.starling.rendering2D 
{
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
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
		
		
		override public function advanceTime(deltaTime:Number):void 
		{
			if ( textureComponent != null && textureComponent.texture != null && image == null )
			{
				image = new Image(textureComponent.texture);
			}
			
			//TODO - move this for when the textureComponent is loaded
			if ( scene != null && scene.sceneView != null && image != null && (scene.getLayer(this.layerIndex) == null || !scene.getLayer(this.layerIndex).contains( image) ) )
				scene.add( this );
				//scene.sceneView.addChild( image );
			
			super.advanceTime(deltaTime);
		}
		
	}

}