package com.recast 
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.EntityComponent;
	import flash.geom.Point;
	
	/**
	 * Moves an agent to the desired position if the snapThreshold is exceeded
	 */
	public class AgentMoverComponent extends TickedComponent 
	{
		
		public var agent:RecastAgentComponent;
		
		public var position:Point = new Point();
		
		public var snapThreshold:Number = 0;
		
		/*
		public function get worldPosition():Point
		{
			var result:Point;
			if ( agent )
				result = new Point(position.x * agent.manager.scale, position.y * agent.manager.scale );
			return result;
		}
		
		public function set worldPosition(value:Point):void
		{
			if ( agent )
			{
				position.x = value.x / agent.manager.scale;
				position.y = value.y / agent.manager.scale;
			}
		}
		*/
		
		public function get x():Number
		{
			return position.x;
		}
		
		public function set x(value:Number ):void
		{
			if ( position.x != value )
			{
				position.x = value;
				_positionDirty = true;
			}
			
		}
		
		public function get y():Number
		{
			return position.y;
		}
		
		public function set y(value:Number ):void
		{
			
			if ( position.y != value )
			{
				position.y = value;
				_positionDirty = true;
			}
			
		}
		public function get z():Number
		{
			return _z;
		}
		
		public function set z(value:Number ):void
		{
			
			if ( _z != value )
			{
				_z = value;
				_positionDirty = true;
			}
			
		}
		
		private var _z:Number = 0;
		
		override public function onTick(deltaTime:Number):void 
		{
			super.onTick(deltaTime);
			
			if ( agent == null)
				return;
			
			if ( _positionDirty )
			{
				
				if ( agent.position.subtract(position).length >= snapThreshold )
				{
					//agent's position needs to be adjust, remove agent and readd at the new positon
					agent.removeAgent();
					//todo - smooth to the position
					agent.position = position.clone();
					agent.addAgent();
					agent.goalDirty = true; //make sure the goal is updated again, calling a move
					
					_positionDirty = false;
				}
			}
		}
		
		private var _positionDirty:Boolean = false;
		
	}

}