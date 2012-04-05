package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.XMLResource;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TextureAtlasComponent extends EntityComponent 
	{
		public var xml:XMLResource;
		
		public var image:ImageResource;
		
		private var _textureAtlas:TextureAtlas;
		
		public function get textureAtlas():TextureAtlas
		{
			if ( xml != null && xml.isLoaded && image != null && image.isLoaded && _textureAtlas == null)
				_textureAtlas  = new TextureAtlas(Texture.fromBitmap( image.image), xml.XMLData );
			
			return _textureAtlas;
		}
		
	}

}