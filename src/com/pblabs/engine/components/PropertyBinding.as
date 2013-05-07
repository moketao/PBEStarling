package com.pblabs.engine.components 
{
	import com.pblabs.engine.entity.PropertyReference;
	/**
	 * Binds properties between objects every tick
	 */
	public class PropertyBinding extends TickedComponent 
	{
		
		/**
		 * An Array properties to set on the feathers control every frame
		 * [{from: "@Health.health", to:"@HealthLabel.feathersControl.text"},{from: "@Gold.gold", to:"@GoldLabel.feathersControl.text"}]
		 */
		public var bindings:Array;
		
		
		override public function onTick(deltaTime:Number):void 
		{
			super.onTick(deltaTime);
			
			if ( bindings != null && bindings.length > 0 )
			{
				for ( var i:int = 0; i < bindings.length; i++ )
				{
					var bind:Object = bindings[i];
					if (bind.hasOwnProperty("to") && bind.hasOwnProperty("from") )
					{
						owner.setProperty(new PropertyReference(bind.to), owner.getProperty(new PropertyReference(bind.from)) );
					}
				}
			}
		
		}
		
	}

}