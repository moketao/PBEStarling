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
		private var _z:Number = 0;
		
		private var _position:Point = new Point();
		
		public function get position():Point { return _position; }
		public function set position(value:Point):void 
		{ 
			if (! _position.equals(value) )
			{
				_position = value; 
				reAdd();
			}
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		public function set x(value:Number ):void
		{
			if ( value != _position.x )
			{
				_position.x = value;
				reAdd();
			}
		}
		public function get y():Number
		{
			return _position.y;
		}
		public function set y(value:Number ):void
		{
			if ( value != _position.y )
			{
				_position.y = value;
				reAdd();
			}
		}
		public function get z():Number
		{
			return _z;
		}
		public function set z(value:Number ):void
		{
			if ( value != _z )
			{
				_z = value;
				reAdd();
			}
		}
		
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
			{
				//Logger.print(this, "manager ready, adding obstacle");
				addObstacle();
			}
			else
			{
				//Logger.print(this, "manager NOT ready, waiting for complete event");
				manager.owner.eventDispatcher.addEventListener(Event.COMPLETE, addObstacle );
			}
		}
		
		protected function reAdd():void
		{
			if ( _id > 0 )
			{
				manager.removeObstacle(_id);
				doAddObstacle();
			}
		}
		
		protected function addObstacle(e:Event = null):void
		{
			//Logger.print(this, "adding Obstacle");
			manager.owner.eventDispatcher.removeEventListener(Event.COMPLETE, addObstacle );
			//TODO - make a better solution. these should be added before the initial mesh creation, or spread out i
			//setTimeout(doAddObstacle, int( Math.random() * 10000) ); //rather than trying to add them all at once, try to spread them out
			doAddObstacle();
		}
		
		//test function
		private function doAddObstacle():void
		{
			//_id = manager.addObstacle(position.x, z, position.y, radius, height); //for 2d, use the z property form the y-axis
			manager.addObstacle(this);
			//Logger.print(this, "addObstacle " + _id);
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			if ( manager != null)
				manager.removeObstacle(id);
		}
		
		/*
		public function set worldPosition(value:Point):void
		{
			position = manager.worldToLocal(value);
		}
		
		public function get worldPosition():Point
		{
			return manager.localToWorld(position);
		}
		*/
		internal var _id:uint;
		
	}

}