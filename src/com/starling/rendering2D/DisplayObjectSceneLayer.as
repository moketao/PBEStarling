package com.starling.rendering2D 
{
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	public class DisplayObjectSceneLayer extends Sprite
	{
		
		/**
         * Array.sort() compatible function used to determine draw order. 
         */
        public var drawOrderFunction:Function;
        
        /**
         * All the renderers in this layer. 
         */
        public var rendererList:Array = new Array();
        
        /**
         * Set to true when we need to resort the layer. 
         */
        internal var needSort:Boolean = false;
        
        /**
         * Default sort function, which orders by zindex.
         */
        static public function defaultSortFunction(a:DisplayObjectRenderer, b:DisplayObjectRenderer):int
        {
            return a.zIndex - b.zIndex;
        }
        
        public function DisplayObjectSceneLayer()
        {
            drawOrderFunction = defaultSortFunction;
            //mouseEnabled = false;
        }
        
        /**
         * Indicates this layer is dirty and needs to resort.
         */
        public function markDirty():void
        {
            needSort = true;
        }
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			if(needSort)
            {
                updateOrder();
                needSort = false;
            }
			
			super.render(support, alpha);
		}
        
        public function updateOrder():void
        {
            // Get our renderers in order.
            // TODO: A bubble sort might be more efficient in cases where
            // things don't change order much.
            rendererList.sort(drawOrderFunction);
            
            // Apply the order.
            var updated:int = 0;
            for(var i:int=0; i<rendererList.length; i++)
            {
                var d:DisplayObject = rendererList[i].displayObject;
                if(getChildAt(i) == d)
                    continue;
                
                updated++;
                setChildIndex(d, i);
            }
            
            // This is useful if you suspect you're changing order too much.
            //trace("Reordered " + updated + " items.");
        }
        
        public function add(dor:DisplayObjectRenderer):void
        {
            var idx:int = rendererList.indexOf(dor);
            if(idx != -1)
                throw new Error("Already added!");
            
            rendererList.push(dor);
            addChild(dor.displayObject);
            markDirty();
        }
        
        public function remove(dor:DisplayObjectRenderer):void
        {
            var idx:int = rendererList.indexOf(dor);
            if(idx == -1)
                return;
            rendererList.splice(idx, 1);
            removeChild(dor.displayObject);
        }
		
	}

}