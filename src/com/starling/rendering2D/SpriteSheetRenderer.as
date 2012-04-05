package com.starling.rendering2D 
{
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import starling.display.MovieClip;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * Renders a spritesheet by constructing a Starling MovieClip from a defined TextureAtlas.
	 * If the TextureAtlas contains multiple spritesheets, the prefix property should be defined.
	 * 
	 */
	public class SpriteSheetRenderer extends ImageRenderer
	{
		public var textureAtlas:TextureAtlasComponent;
		
		public var prefix:String = "";
		
		public var isAnimated:Boolean = true;
		
		public var fps:Number;
		
		public var movieClip:MovieClip;
		
		private var _spriteIndex:int;
		
		override public function advanceTime(deltaTime:Number):void 
		{
			super.advanceTime(deltaTime);
			
			if ( textureAtlas != null && textureAtlas.textureAtlas != null && movieClip == null)
			{
				movieClip = new MovieClip(textureAtlas.textureAtlas.getTextures(prefix), fps);
				this.displayObject = movieClip;
				
				//if (isAnimated)
					//Starling.juggler.add(movieClip);
			}
			
			if ( scene != null && scene.sceneView != null && movieClip != null && (scene.getLayer(this.layerIndex) == null || !scene.getLayer(this.layerIndex).contains( movieClip) ) )
				scene.add( this );
			
			//if ( movieClip != null && isAnimated )
			//	movieClip.advanceTime( deltaTime );
				
		}
		
		/**
		 * Controls the currentFrame of the starling MovieClip.
		 * @see com.starling.animation.AnimatorComponent
		 */
		public function get spriteIndex():int
		{
			return _spriteIndex;
		}
		
		public function set spriteIndex(value:int):void
		{
			_spriteIndex = value;
			
			//update
			if( movieClip != null )
				movieClip.currentFrame = spriteIndex;
		}
		
	}

}