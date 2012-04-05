package com.starling.rendering2D 
{
	import starling.core.Starling;
	import starling.display.MovieClip;

	public class MovieClipRenderer extends DisplayObjectRenderer 
	{
		
		public var textureAtlas:TextureAtlasComponent;
		
		public var prefix:String;
		
		public var isAnimated:Boolean = true;
		
		public var fps:Number;
		
		public var movieClip:MovieClip;
		
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
			
			//TODO - dont add it every frame
			if ( scene != null && scene.sceneView != null && movieClip != null && (scene.getLayer(this.layerIndex) == null || !scene.getLayer(this.layerIndex).contains( movieClip ) ) )
				scene.add( this );
				//scene.sceneView.addChild( movieClip );
			
			if ( movieClip != null && isAnimated )
				movieClip.advanceTime( deltaTime );
				
		}
		
	}

}