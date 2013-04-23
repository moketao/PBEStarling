package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import dragonBones.factorys.StarlingFactory;
	import dragonBones.objects.SkeletonData;
	import dragonBones.objects.XMLDataParser;
	import dragonBones.textures.StarlingTextureAtlas;
	import flash.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class FactoryComponent extends EntityComponent 
	{
		/**
		 * The Skeleton Animation swf output (with xml merged) that was exported from Dragon Bones 
		 */
		public var swfXmlMerged:DataResource;
		
		public var pngResource:ImageResource;
		public var textureXmlResource:XMLResource;
		public var skeletonXmlResource:XMLResource;
		
		
		public var factory:StarlingFactory = new StarlingFactory();
		
		public var isReady:Boolean = false;
		
		override protected function onAdd():void 
		{
			super.onAdd();
			if ( swfXmlMerged != null )
			{
				if(  swfXmlMerged.isLoaded )
					onResourceComplete();
				else
				{
					swfXmlMerged.addEventListener(ResourceEvent.LOADED_EVENT, onSwfMergedLoadComplete );
					swfXmlMerged.load(swfXmlMerged.filename);
				}
			}
			else if ( pngResource && textureXmlResource && skeletonXmlResource )
			{
				if ( pngResource.isLoaded && textureXmlResource.isLoaded && skeletonXmlResource.isLoaded )
				{
					buildFromPngAndXml();
				}
				else
				{
					pngResource.addEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
					textureXmlResource.addEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
					skeletonXmlResource.addEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
					
					pngResource.load(pngResource.filename);
					textureXmlResource.load(textureXmlResource.filename);
					skeletonXmlResource.load(skeletonXmlResource.filename);
				}
			
			}
			
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
		}
		
		protected function onResourceComplete(e:Event = null):void
		{
			if ( pngResource.isLoaded && textureXmlResource.isLoaded && skeletonXmlResource.isLoaded )
			{
				buildFromPngAndXml();
			}
		}
		
		//called when pngResource, texture, and skeleton xml are loaded
		protected function buildFromPngAndXml():void
		{
			pngResource.removeEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
			textureXmlResource.removeEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
			skeletonXmlResource.removeEventListener(ResourceEvent.LOADED_EVENT, onResourceComplete );
					
			var skeletonData:SkeletonData = XMLDataParser.parseSkeletonData(skeletonXmlResource.XMLData);
			factory.addSkeletonData(skeletonData);

			//
			var textureAtlas:StarlingTextureAtlas = new StarlingTextureAtlas(
				Texture.fromBitmapData(pngResource.bitmapData), 
				textureXmlResource.XMLData
			);
			factory.addTextureAtlas(textureAtlas);
			
			isReady = true;
		}
		
		
		protected function onSwfMergedLoadComplete(e:Event = null):void 
		{
			swfXmlMerged.removeEventListener(ResourceEvent.LOADED_EVENT, onSwfMergedLoadComplete );
			
			factory.addEventListener(Event.COMPLETE, textureCompleteHandler);
			factory.parseData(swfXmlMerged.data); //calls the textureCompleteHandler when finished
		}
		
		
		protected function textureCompleteHandler(e:Event=null):void 
		{
			if( swfXmlMerged != null )
				swfXmlMerged.removeEventListener(ResourceEvent.LOADED_EVENT, textureCompleteHandler );
			
			factory.removeEventListener(Event.COMPLETE, textureCompleteHandler);
			
			isReady = true;
			
		}
		
	}

}