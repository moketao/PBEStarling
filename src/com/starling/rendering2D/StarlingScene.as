package com.starling.rendering2D 
{
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.PBUtil;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	
	public class StarlingScene extends EntityComponent implements IAnimatable 
	{
		/**
         * Minimum allowed zoom level.
         * 
         * @see zoom 
         */
        public var minZoom:Number = .1;
        
        /**
         * Maximum allowed zoom level.
         * 
         * @see zoom 
         */
        public var maxZoom:Number = 1;
        
		/**
         * If set, every frame, trackObject's position is read and assigned
         * to the scene's position, so that the scene follows the trackObject.
         */
		public var trackObject:DisplayObjectRenderer;
		
		/**
         * An x/y offset for adjusting the camera's focus around the tracked
         * object.
         * 
         * Only applies if trackObject is set.
         */
		public var trackOffset:Point = new Point();
		
		/**
		 * The rectangle to limit the tracking to, so the scene doesnt pan outside the bounds of the rect.
		 */
		public var trackLimitRectangle:Rectangle;
		
		protected var _zoom:Number = 1;
		protected var _layers:Array = [];
		protected var _sceneView:Sprite;
		
		public function get sceneView():Sprite
        {
            if (!_sceneView )
				_sceneView = Starling.current.stage.getChildAt(0) as Sprite;
            
            return _sceneView;
        }
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			//if( trackObject != null )
			Starling.juggler.add(this);
		}
		
		public function advanceTime(time:Number):void
		{
			if(!sceneView)
            {
                Logger.warn(this, "updateTransform", "sceneView is null, so we aren't rendering."); 
                return;
            }
			/*
			if ( trackObject && trackObject.displayObject != null )
			{
				trackObject.advanceTime(time); //amke sure the track object advances first, so the position does not stutter
				
				sceneView.x = -((trackObject.displayObject.x * zoom) + trackOffset.x );
				sceneView.y = -((trackObject.displayObject.y * zoom) + trackOffset.y);
				
			}
			
			// Apply limit to camera movement.
            if(trackLimitRectangle != null)
            {
                var centeredLimitBounds:Rectangle = new Rectangle( trackLimitRectangle.x     + (sceneView.stage.stageWidth * 0.5), trackLimitRectangle.y      + (sceneView.stage.stageHeight * 0.5) ,
            	                                                  trackLimitRectangle.width * zoom - (sceneView.stage.stageWidth )      , trackLimitRectangle.height * zoom - (sceneView.stage.stageHeight ) );
               
				 sceneView.x = PBUtil.clamp(sceneView.x, -centeredLimitBounds.right, -centeredLimitBounds.left);
				 sceneView.y = PBUtil.clamp(sceneView.y, -centeredLimitBounds.bottom, -centeredLimitBounds.top)
            }
			
			
			
			 //zoom
			sceneView.scaleX = sceneView.scaleY = zoom;
			*/
			
			var trackToRotation:Boolean = true;
			if ( trackObject && trackObject.displayObject != null)
			{
				trackObject.advanceTime(time);
				sceneView.pivotX = trackObject.position.x;
				sceneView.pivotY = trackObject.position.y;
				
				/*
				var rDelta:Number = PBUtil.getRadianShortDelta( -trackObject.rotation, sceneView.rotation  );
				var rDeltaSmooth:Number = rDelta > 0 ? 0.02 : -0.02;//rDelta * 0.01;
				if ( rDelta < 0.02 && rDelta > -0.02)
				{
					trace("fix rotation");
					sceneView.rotation = -trackObject.rotation;
				}
				else
					sceneView.rotation -= rDeltaSmooth;
				*/
					
				if( trackToRotation )
					sceneView.rotation = PBUtil.getRadiansFromDegrees(-trackObject.rotation);
			
				
				sceneView.x = -trackOffset.x;
				sceneView.y = -trackOffset.y;
				
				//sceneView.x = -((trackObject.displayObject.x * zoom) + trackOffset.x );
				//sceneView.y = -((trackObject.displayObject.y * zoom) + trackOffset.y);
				
			
				
			}
			 //zoom
			if( !isNaN(zoom) )
				sceneView.scaleX = sceneView.scaleY = zoom;
		}
		
		
        public function add(dor:DisplayObjectRenderer):void
        {
            // Add to the appropriate layer.
            var layer:DisplayObjectSceneLayer = getLayer(dor.layerIndex, true);
            layer.add(dor);
        }
        
        public function remove(dor:DisplayObjectRenderer):void
        {
            var layer:DisplayObjectSceneLayer = getLayer(dor.layerIndex, false);
            if(!layer)
                return;

            layer.remove(dor);
        }
		
		public function get zoom():Number
        {
            return _zoom;
        }
        
        public function set zoom(value:Number):void
        {
            // Make sure our zoom level stays within the desired bounds
            value = PBUtil.clamp(value, minZoom, maxZoom);
            
            if (_zoom == value)
                return;
                
            _zoom = value;
        }
		
		public function get layerCount():int
        {
            return _layers.length;
        }
		
		public function getLayer(index:int, allocateIfAbsent:Boolean = false):DisplayObjectSceneLayer
        {
            // Maybe it already exists.
            if(_layers[index])
                return _layers[index];
            
            if(allocateIfAbsent == false)
                return null;
            
            // Allocate the layer.
             _layers[index] = generateLayer(index);
                        
            // Order the layers. This is suboptimal but we are probably not going
            // to be adding a lot of layers all the time.
            while(sceneView.numChildren)
                sceneView.removeChildAt(sceneView.numChildren-1);
            for(var i:int=0; i<layerCount; i++)
            {
                if (_layers[i])
                    sceneView.addChild(_layers[i]);
            }
            
            // Return new layer.
            return _layers[index];
        }
		
		 /**
         * Convenience funtion for subclasses to control what class of layer
         * they are using.
         */
        protected function generateLayer(layerIndex:int):DisplayObjectSceneLayer
        {
            var outLayer:DisplayObjectSceneLayer;
            
            // Do we have that layer already specified?
            if (_layers && _layers[layerIndex])
                outLayer = _layers[layerIndex] as DisplayObjectSceneLayer;

            // Go with default.
            if (!outLayer)
                outLayer = new DisplayObjectSceneLayer();

            //TODO: set any properties we want for our layer.
            outLayer.name = "Layer" + layerIndex;
            
            return outLayer;
        }
		
		
        public function transformWorldToScreen(inPos:Point):Point
        {
			return sceneView.localToGlobal(inPos);
        }
        
        public function transformScreenToWorld(inPos:Point):Point
        {   
			return sceneView.globalToLocal(inPos);
        }
		
	}

}