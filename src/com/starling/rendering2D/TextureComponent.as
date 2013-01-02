package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import starling.textures.Texture;
	
	public class TextureComponent extends EntityComponent 
	{
		private var _image:ImageResource;
		
		public var texture:Texture;
		public var eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public function get isLoaded():Boolean
		{
			return texture != null;
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
		
		protected function onImageResourceLoaded(e:ResourceEvent=null):void
		{
			_image.removeEventListener(ResourceEvent.LOADED_EVENT, onImageResourceLoaded );
			texture  = Texture.fromBitmap( image.image );
			eventDispatcher.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
	}

}