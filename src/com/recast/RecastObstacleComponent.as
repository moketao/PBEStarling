package com.recast 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RecastObstacleComponent extends EntityComponent 
	{
		public var manager:RecastManager;
		public var radius:Number = 1;
		public var height:Number = 2;
		
		public var position:Point = new Point();
		
		public var z:Number = 0;
		
		/**
		 * The unique obstacle id returned from the addObstacle method
		 */
		public function get id():uint
		{
			return _id;
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( manager != null && manager.ready)
				addObstacle();
			else
				manager.owner.eventDispatcher.addEventListener(Event.COMPLETE, addObstacle );
		}
		
		protected function addObstacle(e:Event = null):void
		{
			
			manager.owner.eventDispatcher.removeEventListener(Event.COMPLETE, addObstacle );
			//TODO - make a better solution. these should be added before the initial mesh creation, or spread out i
			//setTimeout(doAddObstacle, int( Math.random() * 10000) ); //rather than trying to add them all at once, try to spread them out
			doAddObstacle();
		}
		
		//test function
		private function doAddObstacle():void
		{
			_id = manager.addObstacle(worldPosition.x, z, worldPosition.y, radius, height); //for 2d, use the z property form the y-axis
			//Logger.print(this, "addObstacle " + _id);
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			if ( manager != null)
				manager.removeObstacle(id);
		}
		
		public function set worldPosition(value:Point):void
		{
			position = manager.worldToLocal(value);
		}
		
		public function get worldPosition():Point
		{
			return manager.localToWorld(position);
		}
		
		private var _id:uint;
		
	}

}