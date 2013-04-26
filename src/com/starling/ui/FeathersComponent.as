package com.starling.ui 
{
	import com.starling.rendering2D.DisplayObjectRenderer;
	import feathers.core.FeathersControl;
	
	
	public class FeathersComponent extends DisplayObjectRenderer 
	{
		/*
		 * The Feathers Control to use as the displayObject of the renderer
		 */
		public var feathersControl:FeathersControl;
		
		/**
		 * An array of child Feather Controls to add as children of feathersControl when the component is added
		 */
		public var childControls:Array;
		
		override protected function onAdd():void 
		{
			if ( !feathersControl )
				return;
			
			this.displayObject = feathersControl;
			super.onAdd();
			
			if ( childControls && childControls.length > 0 )
			{
				for (var i:int = 0; i < childControls.length; i++ )
				{
					var childControl:FeathersControl = childControls[i];
					feathersControl.addChild(childControl);
					childControl.validate();
				}
			}
			feathersControl.validate();
		}
		
	}

}