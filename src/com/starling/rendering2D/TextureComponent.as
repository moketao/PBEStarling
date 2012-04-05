package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.ImageResource;
	import starling.textures.Texture;
	
	public class TextureComponent extends EntityComponent 
	{
		
		public var image:ImageResource;
		
		private var _texture:Texture;
		
		public function get texture():Texture
		{
			if ( image.isLoaded && _texture == null)
				_texture  = Texture.fromBitmap( image.image );
			
			return _texture;
		}
		
	}

}