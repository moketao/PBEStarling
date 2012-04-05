package com.starling.rendering2D 
{
	import starling.display.Sprite;
	public class DisplayObjectSceneLayer extends Sprite
	{
		
		public function add(dor:DisplayObjectRenderer):void
        {
            if (dor.displayObject)
				this.addChild( dor.displayObject);
        }
        
        public function remove(dor:DisplayObjectRenderer):void
        {
            if (dor.displayObject && this.contains( dor.displayObject))
				this.removeChild( dor.displayObject);
        }
		
	}

}