package com.pblabs.box2D.joints {
	
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.b2Body;
	import com.pblabs.box2D.Box2DManagerComponent;
	import com.pblabs.box2D.Box2DSpatialComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import flash.geom.Point;
	
	
	public class Box2DPrismaticJointComponent extends EntityComponent {
		
		
		//-----------------------------------------------------------------------------
		//
		//  Properties
		//
		//-----------------------------------------------------------------------------
		
		private var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
		
		
		//-------------------------------------
		//  spatialManager
		//-------------------------------------
		
		private var _spatialManager:Box2DManagerComponent = null;
		
		public function get spatialManager():Box2DManagerComponent {
			return _spatialManager;
        }
		
		public function set spatialManager(value:Box2DManagerComponent):void {
            if (_joint) {
				Logger.warn(this, "set Manager", "The manager can only be set before the component is registered.");
				return;
            }
			
			_spatialManager = value;
        }
		
		
		//-------------------------------------
		//  joint
		//-------------------------------------
		
		private var _joint:b2PrismaticJoint;
		
		public function get joint():b2PrismaticJoint {
            return _joint;
        }
		
		
		//-------------------------------------
		//  spatial1
		//-------------------------------------
		
		private var _spatial1:Box2DSpatialComponent;
		
		public function get spatial1():Box2DSpatialComponent {
			return _spatial1;
		}
		
		public function set spatial1(value:Box2DSpatialComponent):void {
			_spatial1 = value;
			
			if (joint) {
				//destroy existing joint... make new one...
			}
		}
		
		
		//-------------------------------------
		//  spatial2
		//-------------------------------------
		
		private var _spatial2:Box2DSpatialComponent;
		
		public function get spatial2():Box2DSpatialComponent {
			return _spatial2;
		}
		
		public function set spatial2(value:Box2DSpatialComponent):void {
			_spatial2 = value;
			
			if (joint) {
				//destroy existing joint... make new one...
			}
		}
		
		
		//-------------------------------------
		//  anchor
		//-------------------------------------
		
		private var _anchor:Point;
		
		public function get anchor():Point {
			return _anchor;
		}
		
		public function set anchor(value:Point):void {
			_anchor = value;
			
			if (joint) {
				//destroy existing joint... make new one...
			}
		}
		
		
		//-------------------------------------
		//  useGroundBody
		//-------------------------------------
		
		private var _useGroundBody:Boolean;
		
		public function get useGroundBody():Boolean {
			return _useGroundBody;
		}
		
		public function set useGroundBody(value:Boolean):void {
			_useGroundBody = value;
			
			if (joint) {
				//destroy existing joint... make new one...?
			}
		}
		
		
		//-------------------------------------
		//  axis
		//-------------------------------------
		
		private var _axis:Point;
		
		public function get axis():Point {
			return _axis;
		}
		
		public function set axis(value:Point):void {
			_axis = value;
			
			if (joint) {
				//destroy existing joint... make new one...
			}
		}
		
		
		//-------------------------------------
		//  enableLimit
		//-------------------------------------
		
		public function get enableLimit():Boolean {
			return jointDef.enableLimit;
		}
		
		public function set enableLimit(value:Boolean):void {
			jointDef.enableLimit = value;
			
			if (joint) {
				//destroy existing joint... make new one...?
			}
		}
		
		
		//-------------------------------------
		//  lowerTranslation
		//-------------------------------------
		
		public function get lowerTranslation():Number {
			return jointDef.lowerTranslation;
		}
		
		public function set lowerTranslation(value:Number):void {
			jointDef.lowerTranslation = value;
			
			if (joint) {
				//destroy existing joint... make new one...?
			}
		}
		
		
		//-------------------------------------
		//  upperTranslation
		//-------------------------------------
		
		public function get upperTranslation():Number {
			return jointDef.upperTranslation;
		}
		
		public function set upperTranslation(value:Number):void {
			jointDef.upperTranslation = value;
			
			if (joint) {
				//destroy existing joint... make new one...?
			}
		}
		
		
		//-------------------------------------
		//  enableMotor
		//-------------------------------------
		
		public function get enableMotor():Boolean {
			return jointDef.enableMotor;
		}
		
		public function set enableMotor(value:Boolean):void {
			jointDef.enableMotor = value;
			
			if (joint) {
				//destroy existing joint... make new one...?
			}
		}
		
		
		//-------------------------------------
		//  maxMotorForce
		//-------------------------------------
		
		public function get maxMotorForce():Number {
			return jointDef.maxMotorForce;
		}
		
		public function set maxMotorForce(value:Number):void {
			jointDef.maxMotorForce = value;
			
			if (joint) {
				//destroy existing joint... make new one...?
			}
		}
		
		
		//-------------------------------------
		//  motorSpeed
		//-------------------------------------
		
		public function get motorSpeed():Number {
			return jointDef.motorSpeed;
		}
		
		public function set motorSpeed(value:Number):void {
			jointDef.motorSpeed = value;
			
			if (joint) {
				//destroy existing joint... make new one...?
			}
		}
		
		
		//-----------------------------------------------------------------------------
		//
		//  Constructor
		//
		//-----------------------------------------------------------------------------
		
		public function Box2DPrismaticJointComponent():void {
		}
		
		
		//-----------------------------------------------------------------------------
		//
		//  Methods
		//
		//-----------------------------------------------------------------------------
		
		
        override protected function onReset():void {
			if (!_spatialManager) {
				Logger.warn(this, "onReset", "A Box2DPrismaticJointComponent cannot be registered without a manager.");
				return;
			}
			
			if (!_spatial1) {
				Logger.warn(this, "onReset", "A Box2DPrismaticJointComponent cannot be registered without a spatial1.");
                return;
			}
			
			if (!_spatial2 && !_useGroundBody) {
				Logger.warn(this, "onReset", "A Box2DPrismaticJointComponent cannot be registered without a spatial2 or having useGroundBody set to true.");
				return;
			}
			
			if (!_anchor) {
				Logger.warn(this, "onReset", "A Box2DPrismaticJointComponent cannot be registered without a world anchor.");
				return;
			}
			
			var body2:b2Body;
			if (useGroundBody) {
				body2 = _spatialManager.world.GetGroundBody();
			} else {
				body2 = _spatial2.body;
			}
			
			var anchor:b2Vec2 = new b2Vec2(_anchor.x, _anchor.y);
			var axis:b2Vec2 = new b2Vec2(_axis.x, _axis.y);
			
			jointDef.Initialize(_spatial1.body, body2, anchor, axis);
			
			_spatialManager.addJoint(jointDef, this, 
				function(joint:b2Joint):void
                {
                    _joint = joint as b2PrismaticJoint;
                    _joint.SetUserData(this);
                });
        }
		
		override protected function onRemove():void {
            _spatialManager.removeJoint(_joint);
            _joint = null;
        }
	}
}
