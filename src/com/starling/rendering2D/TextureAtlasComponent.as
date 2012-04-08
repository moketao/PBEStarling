package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TextureAtlasComponent extends EntityComponent 
	{
		private var _isLoaded:Boolean = false;
		private var _image:ImageResource;
		private var _xml:XMLResource;
		
		public var textureAtlas:TextureAtlas;
		public var eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		public function get image():ImageResource
		{
			return _image;
		}
		
		public function set image(value:ImageResource):void
		{
			_image = value;
			if ( _image != null )
			{
				if ( _image.isLoaded )
					onImageResourceLoaded();
				else
					_image.addEventListener(ResourceEvent.LOADED_EVENT, onImageResourceLoaded );
			}
		}
		
		public function get xml():XMLResource
		{
			return _xml;
		}
		
		public function set xml(value:XMLResource):void
		{
			_xml = value;
			if ( _xml != null )
			{
				if ( _xml.isLoaded )
					onXMLResourceLoaded();
				else
					_xml.addEventListener(ResourceEvent.LOADED_EVENT, onXMLResourceLoaded );
			}
		}
		
		
		private function onImageResourceLoaded(e:ResourceEvent=null):void
		{
			_image.removeEventListener(ResourceEvent.LOADED_EVENT, onImageResourceLoaded );
			if ( xml != null && xml.isLoaded && image != null && image.isLoaded )
			{
				textureAtlas  = new TextureAtlas(Texture.fromBitmap( image.image), xml.XMLData );
				_isLoaded = true;
				eventDispatcher.dispatchEvent( new Event(Event.COMPLETE) );
			}
			
		}
		
		private function onXMLResourceLoaded(e:ResourceEvent=null):void
		{
			_xml.removeEventListener(ResourceEvent.LOADED_EVENT, onXMLResourceLoaded );
			if ( xml != null && xml.isLoaded && image != null && image.isLoaded )
			{
				textureAtlas  = new TextureAtlas(Texture.fromBitmap( image.image), xml.XMLData );
				_isLoaded = true;
				eventDispatcher.dispatchEvent( new Event(Event.COMPLETE) );
			}
		}
		
	}

}