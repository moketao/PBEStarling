package com.starling.ui 
{
	import com.starling.rendering2D.DisplayObjectRenderer;
	import feathers.core.FeathersControl;
	
	
	public class FeathersComponent extends DisplayObjectRenderer 
	{
		
		public var feathersControl:FeathersControl;
		
		override protected function onAdd():void 
		{
			if ( feathersControl )
				this.displayObject = feathersControl;
				
			super.onAdd();
		}
		
	}

}