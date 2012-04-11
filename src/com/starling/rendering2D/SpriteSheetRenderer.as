package com.starling.rendering2D 
{
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import flash.events.Event;
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
		public var textureAtlasComponent:TextureAtlasComponent;
		
		public var prefix:String = "";
		
		public var fps:Number = 30;
		
		public var starlingMovieClip:MovieClip;
		
		private var _spriteIndex:int;
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( starlingMovieClip != null && scene != null )
				scene.add( this );
			else if ( textureAtlasComponent != null && textureAtlasComponent.isLoaded )
				onTextureComplete();
			else if( textureAtlasComponent != null ) //texture isn't loaded
				textureAtlasComponent.eventDispatcher.addEventListener(Event.COMPLETE, onTextureComplete );
			
		}
		
		private function onTextureComplete(e:Event=null):void
		{
			textureAtlasComponent.eventDispatcher.removeEventListener(Event.COMPLETE, onTextureComplete );
			
			var textures:Vector.<Texture> = textureAtlasComponent.textureAtlas.getTextures(prefix);
			
			if( textures != null && textures.length > 0)
			{
				starlingMovieClip = new MovieClip(textures, fps);
				this.displayObject = starlingMovieClip;
				
				if( scene != null )
					scene.add( this );
			}
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
			if( starlingMovieClip != null )
				starlingMovieClip.currentFrame = spriteIndex;
		}
		
	}

}