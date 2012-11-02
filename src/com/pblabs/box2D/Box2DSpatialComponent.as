/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.box2D
{
    import Box2D.Collision.Shapes.b2MassData;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
    
    import com.pblabs.engine.PBUtil;
    import com.pblabs.engine.core.ObjectType;
    import com.pblabs.engine.debug.Logger;
    import com.pblabs.engine.entity.EntityComponent;
    import com.pblabs.rendering2D.IMobileSpatialObject2D;
    import com.pblabs.rendering2D.IScene2D;
    import com.pblabs.rendering2D.ISpatialObject2D;
    import com.pblabs.rendering2D.RayHitInfo;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * Wraps a b2Body for use with a Box2DManagerComponent and integration into
     * PushButton Engine.
     * 
     * <p>Most properties map directly to actions in Box2D, so most of the time
     * your questions about this component will really be Box2D questions in
     * disguise.</p> 
     */
    public class Box2DSpatialComponent extends EntityComponent implements IMobileSpatialObject2D
    {
        public function get spatialManager():Box2DManagerComponent
        {
            return _manager;
        }
        
        public function set spatialManager(value:Box2DManagerComponent):void
        {
            if (_body)
            {
                Logger.warn(this, "set Manager", "The manager can only be set before the component is registered.");
                return; 
            }
            
            _manager = value;
        }
        
        public function get manager():Box2DManagerComponent
        {
            Logger.warn(this, "get manager", "manager is deprecated; switch to spatialManager.");
            return spatialManager;
        }
        
        public function set manager(value:Box2DManagerComponent):void
        {
            spatialManager = value;
            Logger.warn(this, "set manager", "manager is deprecated; switch to spatialManager.");
        }
        
        /**
         * The Box2D b2Body wrapped by this component.
         */
        public function get body():b2Body
        {
            return _body;
        }
        
        /**
         * @inheritDoc
         */
        public function get objectMask():ObjectType
        {
            return _collidesWithTypes;
        }
        
        /**
         * @inheritDoc
         */
        public function get worldExtents():Rectangle
        {
            //TODO: how far should a spatial component actually have a size?
            return new Rectangle(position.x - (size.x * 0.5), position.y - (size.y * 0.5), size.x, size.y);         
        }
		
		
		public function getWorldPosition(localPosition:Point):Point {
			return new Point(position.x + localPosition.x, position.y + localPosition.y);
		}
        
        /**
         * Not currently implemented.
         * @inheritDoc
         */
        public function castRay(start:Point, end:Point, mask:ObjectType, info:RayHitInfo):Boolean
        {
            return false;
        }
        /**
         * All points in our bounding box are occupied.
         * @inheritDoc
         */
        public function pointOccupied(pos:Point, mask:ObjectType, scene:IScene2D):Boolean
        {
            return worldExtents.containsPoint(pos);
        }	  
        
        public function get collisionType():ObjectType
        {
            return _collisionType;
        }
        
        public function set collisionType(value:ObjectType):void
        {
            _collisionType = value;
            
            if (_body)
                buildCollisionShapes();
        }
        
        public function get collidesWithTypes():ObjectType
        {
            return _collidesWithTypes;
        }
        
        public function set collidesWithTypes(value:ObjectType):void
        {
            _collidesWithTypes = value;
            
            if (_body)
                buildCollisionShapes();
        }
        
        public function get position():Point
        {
            if (_body)
            {
                var pos:b2Vec2 = _body.GetPosition();
                return new Point(pos.x * _manager.scale, pos.y * _manager.scale);
            }
            
            return new Point(_bodyDef.position.x * _manager.scale, _bodyDef.position.y * _manager.scale);
        }
        
        public function set position(value:Point):void
        {
            var position:b2Vec2 = new b2Vec2(value.x, value.y);
            _bodyDef.position = position;
            
            if (_body)
            {
                position.Multiply(_manager.inverseScale);
                _body.SetPositionAndAngle(position, _body.GetAngle());
            }
			else if (isAdded ) //fix a bug where the body def doesnt get scaled properly if the component is created by a template while the world is locked (during a collision)
			{
				_bodyDef.position.Multiply(_manager.inverseScale);
			}
        }
        
        public function get rotation():Number
        {
            var rotation:Number = _bodyDef.angle;
            
            if (_body)
                rotation = _body.GetAngle();
            
            return PBUtil.getDegreesFromRadians(rotation);
        }
        
        public function set rotation(value:Number):void
        {
            var rotation:Number = PBUtil.getRadiansFromDegrees(value);
            _bodyDef.angle = rotation;
            
            if (_body)
                _body.SetPositionAndAngle(_body.GetPosition(), rotation);
        }
        
        [EditorData(defaultValue="100|100")]
        public function get size():Point
        {
            return _size;
        }
        
        public function set size(value:Point):void
        {
            _size = value;
            
            if (_body)
                buildCollisionShapes();
        }
        
        public function get linearVelocity():Point
        {
            if (_body)
            {
                var velocity:b2Vec2 = _body.GetLinearVelocity();
                _linearVelocity.x = velocity.x * _manager.scale;
                _linearVelocity.y = velocity.y * _manager.scale;
            }
            
            return _linearVelocity;
        }
        
        public function set linearVelocity(value:Point):void
        {
            _linearVelocity = value;
            
            if (_body)
            {
                var velocity:b2Vec2 = new b2Vec2(value.x * _manager.inverseScale, value.y * _manager.inverseScale);
                _body.SetLinearVelocity(velocity);
            }
        }
        
        public function get angularVelocity():Number
        {
            if (_body)
            {
                var velocity:Number = _body.GetAngularVelocity();
                _angularVelocity = PBUtil.getDegreesFromRadians(velocity);
            }
            
            return _angularVelocity;
        }
        
        public function set angularVelocity(value:Number):void
        {
            _angularVelocity = value;
            
            if (_body)
            {
                var velocity:Number = PBUtil.getRadiansFromDegrees(value);
                _body.SetAngularVelocity(velocity);
            }
        }
        
        [EditorData(defaultValue="true")]
        public function get canMove():Boolean
        {
            return _canMove;
        }
        
        public function set canMove(value:Boolean):void
        {
            _canMove = value;
            
            if (_body)
                updateMass();
        }
        
        [EditorData(defaultValue="true")]
        public function get canRotate():Boolean
        {
            return _canRotate;
        }
        
        public function set canRotate(value:Boolean):void
        {
            _canRotate = value;
            
            if (_body)
                updateMass();
        }
        
        [EditorData(defaultValue="true")]
        public function get canSleep():Boolean
        {
            return _canSleep;
        }
        
        public function set canSleep(value:Boolean):void
        {
            _canSleep = value;
            _bodyDef.allowSleep = value;
            if (_body)
                _body.SetSleepingAllowed(value);
        }
        
        public function get collidesContinuously():Boolean
        {
            if (_body)
                return _body.IsBullet();
            
            return _bodyDef.bullet
        }
        
        public function set collidesContinuously(value:Boolean):void
        {
            _bodyDef.bullet = value;
            if (_body)
                _body.SetBullet(value);
        }
		
		public function get bodyType():uint {
			if (_body)
				return _body.GetType();
			
			return _bodyDef.type;
		}
		
		public function set bodyType(value:uint):void {
			_bodyDef.type = value;
			
			if (_body)
				_body.SetType(value);
		}
        
        [TypeHint(type="com.pblabs.box2D.CollisionShape")]
        public function get collisionShapes():Array
        {
            return _collisionShapes;
        }
        
        public function set collisionShapes(value:Array):void
        {
            _collisionShapes = value;
            if (_body)
                buildCollisionShapes();
        }
        
        public function buildCollisionShapes():void
        {
            if (!_body)
            {
                Logger.warn(this, "buildCollisionShapes", "Cannot build collision shapes prior to registration.");
                return;
            }
            
            var shape:b2Fixture = _body.GetFixtureList();
            while (shape)
            {
                var nextShape:b2Fixture = shape.GetNext();
                _body.DestroyFixture(shape);
                shape = nextShape;
            }
            
            if (_collisionShapes)
            {
                for each (var newShape:CollisionShape in _collisionShapes)
				_body.CreateFixture(newShape.createShape(this));
            }
            
            updateMass();
        }
		
		public function addCollisionShape(collisionShape:CollisionShape):void {
			_body.CreateFixture(collisionShape.createShape(this));
			
			updateMass();
		}
		
		public function removeCollisionShape(collisionShape:CollisionShape):void {
			//_body.DestroyFixture();
		}
        
        public function updateMass():void
        {
            _body.ResetMassData();
            if (!_canMove || !_canRotate)
            {
                var mass:b2MassData = new b2MassData();
                mass.center = _body.GetLocalCenter();
                if (_canMove)
                    mass.mass = _body.GetMass();
                else
                    mass.mass = 0;
                
                if (_canRotate)
                    mass.I = _body.GetInertia();
                else
                    mass.I = 0;
                
                _body.SetMassData(mass);
            }
        }
        
        override protected function onAdd():void
        {
            if (!_manager)
            {
                Logger.warn(this, "onAdd", "A Box2DSpatialComponent cannot be registered without a manager.");
                return;
            }
            
            _bodyDef.position.Multiply(_manager.inverseScale);
            
            _manager.addBody(_bodyDef, this, 
                function(body:b2Body):void
                {
                    _body = body;
                    _body.SetUserData(this);
                    _bodyDef.position.Multiply(_manager.scale);
					
					//test
					var p:b2Vec2 = _body.GetPosition();
                    
                    linearVelocity = _linearVelocity;
                    angularVelocity = _angularVelocity;
                    
                    buildCollisionShapes();
                });
				
			isAdded = true;
        }
        
        override protected function onRemove():void 
        {
            _manager.removeBody(_body);
            _body = null;
        }
		
		private var isAdded:Boolean = false;
        
        private var _manager:Box2DManagerComponent = null;
        private var _collisionType:ObjectType = null;
        private var _collidesWithTypes:ObjectType = null;
        
        private var _size:Point = new Point(10, 10);
        
        private var _canMove:Boolean = true;
        private var _canRotate:Boolean = true;
        
        private var _linearVelocity:Point = new Point(0, 0);
        private var _angularVelocity:Number = 0.0;
        private var _canSleep:Boolean = true;
        
        private var _collisionShapes:Array = null;
        private var _collidesContinuously:Boolean = false;
        
        private var _body:b2Body;
        private var _bodyDef:b2BodyDef = new b2BodyDef();
    }
}