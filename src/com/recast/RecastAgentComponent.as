package com.recast 
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import flash.events.Event;
	import flash.geom.Point;
	import org.recastnavigation._wrap_DT_CROWD_ANTICIPATE_TURNS;
	import org.recastnavigation._wrap_DT_CROWD_OBSTACLE_AVOIDANCE;
	import org.recastnavigation._wrap_DT_CROWD_OPTIMIZE_TOPO;
	import org.recastnavigation._wrap_DT_CROWD_OPTIMIZE_VIS;
	import org.recastnavigation.CModule;
	import org.recastnavigation.dtCrowdAgentParams;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RecastAgentComponent extends TickedComponent 
	{
		public var manager:RecastManager;
		
		public var radius:Number = 0.6;
		public var height:Number = 2;
		private var _maxAccel:Number = 8.0;
		private var _maxAccelDirty:Boolean = false;
		private var _maxSpeed:Number = 3.5;
		private var _maxSpeedDirty:Boolean = false;
		public var collisionQueryRange:Number = 12.0;
		public var pathOptimizationRange:Number = 30.0;
		public var separationWeight:Number = 2.0;
		
		/**
		 * If set, the agent's maxAccel is set from this property
		 */
		public var maxAccelReference:PropertyReference;
		
		/**
		 * If set, the agent's maxSpeed is set from this property
		 */
		public var maxSpeedReference:PropertyReference;
		
		//obstacle avoidance params
		public var 	velBias:Number = 0.4, 
					weightDesVel:Number = 2.0, 
					weightCurVel:Number = 0.75, 
					weightSide:Number = 0.75, 
					weightToi:Number = 2.5,  
					horizTime:Number = 2.5, 
					gridSize:Number = 33, 
					adaptiveDivs:Number = 7, 
					adaptiveRings:Number = 2, 
					adaptiveDepth:Number = 5;
		
		/**
		 * The z position of the agent
		 */
		public var z:Number = 0; 
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( manager != null && manager.ready )
				init();
			else if ( manager != null)
				manager.owner.eventDispatcher.addEventListener(Event.COMPLETE, init);
		}
		
		protected function init(e:Event = null):void
		{
			manager.owner.eventDispatcher.removeEventListener(Event.COMPLETE, init);
			addAgent();
		}
		
		public function addAgent():void
		{
			//Logger.print(this, "addAgent");
			if ( maxAccelReference != null && owner != null )
				maxAccel = owner.getProperty(maxAccelReference);
			
			if ( maxSpeedReference != null && owner != null )
				maxSpeed = owner.getProperty(maxSpeedReference);
				
			if ( manager != null && manager.ready && _idx <= 0 ) //only add the agent if it is not already added
			{
				
				var params:dtCrowdAgentParams = dtCrowdAgentParams.create();
				params.radius  = radius;
				params.height  = height;
				params.maxAcceleration = maxAccel;
				params.maxSpeed = maxSpeed;
				params.collisionQueryRange = collisionQueryRange;
				params.pathOptimizationRange = pathOptimizationRange;
				
				params.separationWeight = separationWeight;
				params.obstacleAvoidanceType = String.fromCharCode(0); //0, 3.0, 1
				var updateFlags:uint = 0;
				//updateFlags |= _wrap_DT_CROWD_ANTICIPATE_TURNS();
				updateFlags |= _wrap_DT_CROWD_OPTIMIZE_VIS();
				updateFlags |= _wrap_DT_CROWD_OPTIMIZE_TOPO();
				//updateFlags |= _wrap_DT_CROWD_OBSTACLE_AVOIDANCE();
				//updateFlags |= _wrap_DT_CROWD_SEPARATION();
				params.updateFlags = String.fromCharCode(updateFlags); //since updateFlags is stored as a char in recast, need to save the string as the char code value
				//trace(params.updateFlags.charCodeAt(0) );
				
				_idx = manager.addAgent(position.x, z, position.y, params.swigCPtr );
			
				agentPositionPointer = manager.getAgentPosition(_idx);
				agentVelocityPointer = manager.getAgentVelocity(_idx);
				//TODO - only do this if the avoidance params are different from the default.  Set avoidanceParamsDirty to true when any of the default params change.
				manager.setObstacleAvoidanceParams( _idx, velBias, weightDesVel, weightCurVel, weightSide, weightToi, horizTime, gridSize, adaptiveDivs, adaptiveRings, adaptiveDepth);
			}
		}
		
		public function removeAgent():void
		{
			//Logger.print(this, "removeAgent");
			if ( _idx >= 0 )
			{
				manager.removeAgent(_idx);
				_idx = -1;
				
				//set the velocity to zero when an agent gets removed
				_velocity.x = 0;
				_velocity.y = 0;
			}
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			removeAgent();
		}
		
		public function set maxAccel(value:Number):void
		{
			if ( value != _maxAccel )
			{
				_maxAccel = value;
				_maxAccelDirty = true;
			}
		}
		
		public function get maxAccel():Number
		{
			return _maxAccel;
		}
		
		
		public function set maxSpeed(value:Number):void
		{
			if ( value != _maxSpeed )
			{
				_maxSpeed = value;
				_maxSpeedDirty = true;
			}
		}
		
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		override public function onTick(deltaTime:Number):void 
		{
			super.onTick(deltaTime);
			
			if ( maxAccelReference != null )
			{
				maxAccel = owner.getProperty(maxAccelReference);
			}
			
			if ( maxSpeedReference != null )
			{
				maxSpeed = owner.getProperty(maxSpeedReference);
			}
			
			if ( _maxAccelDirty || _maxSpeedDirty )
			{
				//when the max accel or maxspeed change, remove and add the agent
				
				removeAgent();
				addAgent();
				
				_maxAccelDirty = false;
				_maxSpeedDirty = false;
			}
			
			if ( _idx > 0 && manager != null ) //only update the position and velocity if the agent id is set, incase the agent is removed and readded
			{
				
				//if the goal has changed, request a move to the goalPosition
				if ( _goalDirty )
				{
					//Logger.print(this, "Move Agent to " + _goalPosition.x + " " + _goalPosition.y );
					//manager.moveAgent(_idx, _goalPosition.x, z, _goalPosition.y );
					manager.moveAgent(_idx, goalPosition.x, z, goalPosition.y );
					_goalDirty = false;
				}
				
				
				_position.x = CModule.readFloat(agentPositionPointer);
				//_position.y = CModule.readFloat(agentPositionPointer + 4); 
				_position.y = CModule.readFloat(agentPositionPointer + 8); //for 2D grab the z value
				
				_velocity.x = CModule.readFloat(agentVelocityPointer);
				_velocity.y = CModule.readFloat(agentVelocityPointer + 8);
			}
			
		}
		
		/**
		 * The agent id returned from recast lib when an agent is added
		 */
		public function get idx():int
		{
			return _idx;
		}
		
		
        public function get velocity():Point
        {
            return _velocity.clone();
        }
        
        public function set velocity(value:Point):void
        {
            _velocity.x = value.x;
            _velocity.y = value.y;
        }
		
		 
        public function get position():Point
        {
            return _position.clone();
        }
        
        public function set position(value:Point):void
        {
			if (! _position.equals(value) )
			{
				_position.x = value.x;
				_position.y = value.y;
				_positionDirty = true;
			}
        }
		
		/**
		 * returns the agents worldPosition (agent's position * recast scale)
		 
		public function get worldPosition():Point
		{
			return manager.localToWorld(_position);
		}
		public function set worldPosition(worldPosition:Point):void
		{
			position = manager.worldToLocal(worldPosition);
		}
		*/
		public function get goalDirty():Boolean
		{
			return _goalDirty;
		}
		
		public function set goalDirty(value:Boolean):void
		{
			_goalDirty = value;
		}
		
		
		public function get goalX():Number
		{
			return _goalPosition.x;
		}
	
		public function set goalX(value:Number):void
		{
			if ( value != _goalPosition.x )
			{
				_goalPosition.x = value;
				_goalDirty = true;
			}
		}
		
		public function get goalY():Number
		{
			return _goalPosition.y;
		}
	
		public function set goalY(value:Number):void
		{
			if ( value != _goalPosition.y )
			{
				_goalPosition.y = value;
				_goalDirty = true;
			}
		}
		
		/**
		 * The position to move the agent to with pathfinding
		
        public function get goalWorldPosition():Point
        {
			return manager.localToWorld(_goalPosition);
        }
		 */
		/**
		 * set the agent's goal position from the world position
		
		public function set goalWorldPosition(worldPosition:Point):void
		{
			goalPosition = manager.worldToLocal(worldPosition);
		}
		 */
		
		
		/**
		 * The position to move the agent to with pathfinding
		 */
        public function get goalPosition():Point
        {
            return _goalPosition.clone();
        }
        
        public function set goalPosition(value:Point):void
        {
			if ( value != null && !value.equals( _goalPosition ) )
			{
				_goalPosition.x = value.x;
				_goalPosition.y = value.y;
				
				_goalDirty = true;
			}
        }
		
		
		
        public function set x(value:Number):void
        {
			if ( value != _position.x )
			{
				_position.x = value;
				_positionDirty = true;
			}
        }
        
        public function get x():Number
        {
            return _position.x;
        }
        
		
        public function set y(value:Number):void
        {
			if ( value != _position.y )
			{
				_position.y = value;
				_positionDirty = true;
			}
        }
        
        public function get y():Number
        {
            return _position.y;
        }
		
		private var _positionDirty:Boolean;
		private var _goalDirty:Boolean;
		private var _position:Point = new Point();
		private var _goalPosition:Point = new Point();
		private var _velocity:Point = new Point();
		private var _idx:int = -1;
		private var agentPositionPointer:uint; //the memory address of the position array
		private var agentVelocityPointer:uint; //the memory address of the velocity array
	}

}