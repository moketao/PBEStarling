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
		public var trackObject:DisplayObjectRenderer;
		public var trackOffset:Point = new Point();
		public var trackLimitRectangle:Rectangle;
		public var zoom:Number = 1;
		
		protected var _layers:Array = [];
		protected var _sceneView:Sprite;
		
		public function get sceneView():Sprite
        {
            if (!_sceneView )
				_sceneView = Starling.current.stage.getChildAt(0) as Sprite;
                //sceneView = PBE.findChild(_sceneViewName) as IUITarget;
            
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
			
			if ( trackObject && trackObject.displayObject != null )
			{
				trackObject.advanceTime(time); //amke sure the track object advances first, so the position does not stutter
				
				sceneView.x = -(trackObject.displayObject.x + trackOffset.x);
				sceneView.y = -(trackObject.displayObject.y + trackOffset.y);
				
			}
			
			// Apply limit to camera movement.
            if(trackLimitRectangle != null)
            {
            	var centeredLimitBounds:Rectangle = new Rectangle( trackLimitRectangle.x     + (sceneView.stage.stageWidth * 0.5) / zoom, trackLimitRectangle.y      + (sceneView.stage.stageHeight * 0.5) / zoom,
            	                                                   trackLimitRectangle.width - (sceneView.stage.stageWidth / zoom)      , trackLimitRectangle.height - (sceneView.stage.stageHeight / zoom) );
                
                //position = new Point(PBUtil.clamp(position.x, -centeredLimitBounds.right, -centeredLimitBounds.left ), 
                 //                    PBUtil.clamp(position.y, -centeredLimitBounds.bottom, -centeredLimitBounds.top) );
				 
				 sceneView.x = PBUtil.clamp(sceneView.x, -centeredLimitBounds.right, -centeredLimitBounds.left);
				 sceneView.y = PBUtil.clamp(sceneView.y, -centeredLimitBounds.bottom, -centeredLimitBounds.top)
            }
		}
		
		
        public function add(dor:DisplayObjectRenderer):void
        {
            // Add to the appropriate layer.
            var layer:DisplayObjectSceneLayer = getLayer(dor.layerIndex, true);
            layer.add(dor);
            //if (dor.displayObject)
            //    _renderers[dor.displayObject] = dor;
        }
        
        public function remove(dor:DisplayObjectRenderer):void
        {
            var layer:DisplayObjectSceneLayer = getLayer(dor.layerIndex, false);
            if(!layer)
                return;

            layer.remove(dor);
            //if (dor.displayObject)
              //  delete _renderers[dor.displayObject];
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
			// return _rootSprite.localToGlobal(inPos); 
			return sceneView.localToGlobal(inPos);
        }
        
        public function transformScreenToWorld(inPos:Point):Point
        {
            //return _rootSprite.globalToLocal(inPos);    
			return sceneView.globalToLocal(inPos);
        }
		
	}

}