package com.pblabs.box2D.joints {
	
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import com.pblabs.box2D.Box2DManagerComponent;
	import com.pblabs.box2D.Box2DSpatialComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import flash.geom.Point;
	
	
	public class Box2DDistanceJointComponent extends EntityComponent {
		
		
		//-----------------------------------------------------------------------------
		//
		//  Properties
		//
		//-----------------------------------------------------------------------------
		
		private var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
		
		
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
		
		private var _joint:b2DistanceJoint;
		
		public function get joint():b2DistanceJoint {
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
			
			jointDef.bodyA = value.body;
			
			if (joint)
				resetJoint();
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
			
			jointDef.bodyB = value.body;
			
			if (joint)
				resetJoint();
		}
		
		
		//-------------------------------------
		//  anchor1
		//-------------------------------------
		
		private var _anchor1:Point;
		
		public function get anchor1():Point {
			var anchor1:Point = new Point(jointDef.localAnchorA.x, jointDef.localAnchorA.y);
			
			return anchor1;
		}
		
		public function set anchor1(value:Point):void {
			_anchor1 = value;
			
			jointDef.localAnchorA = new b2Vec2(value.x, value.y);
			
			if (joint)
				resetJoint();
		}
		
		
		//-------------------------------------
		//  anchor2
		//-------------------------------------
		
		private var _anchor2:Point;
		
		public function get anchor2():Point {
			var anchor2:Point = new Point(jointDef.localAnchorB.x, jointDef.localAnchorB.y);
			
			return anchor2;
		}
		
		public function set anchor2(value:Point):void {
			_anchor2 = value;
			
			jointDef.localAnchorB = new b2Vec2(value.x, value.y);
			
			if (joint)
				resetJoint();
		}
		
		
		//-------------------------------------
		//  worldAnchor1
		//-------------------------------------
		
		public function get worldAnchor1():Point {
			var worldAnchor1:Point = new Point(joint.GetAnchorA().x, joint.GetAnchorA().y);
			
			return worldAnchor1;
		}
		
		
		//-------------------------------------
		//  worldAnchor2
		//-------------------------------------
		
		public function get worldAnchor2():Point {
			var worldAnchor2:Point = new Point(joint.GetAnchorA().x, joint.GetAnchorA().y);
			
			return worldAnchor2;
		}
		
		
		//-------------------------------------
		//  frequency
		//-------------------------------------
		
		private var _frequency:Number;
		
		public function get frequency():Number {
			if (_joint)
				return _joint.GetFrequency();
			
			return jointDef.frequencyHz;
		}
		
		public function set frequency(value:Number):void {
			_frequency = value;
			
			jointDef.frequencyHz = value;
			
			if (joint)
				joint.SetFrequency(value);
		}
		
		
		//-------------------------------------
		//  damping
		//-------------------------------------
		
		private var _dampingRatio:Number;
		
		public function get dampingRatio():Number {
			if (_joint)
				return _joint.GetDampingRatio();
			
			return jointDef.dampingRatio;
		}
		
		public function set dampingRatio(value:Number):void {
			_dampingRatio = value;
			
			jointDef.dampingRatio = value;
			
			if (joint)
				joint.SetDampingRatio(value);
		}
		
		
		//-------------------------------------
		//  length
		//-------------------------------------
		
		private var _length:Number = -1;
		
		public function get length():Number {
			if (joint)
				return joint.GetLength();
			
			return jointDef.length;
		}
		
		public function set length(value:Number):void {
			_length = value;
			
			jointDef.length = value;
			
			if (joint)
				joint.SetLength(value);
		}
		
		
		//-------------------------------------
		//  collideConnected
		//-------------------------------------
		
		public function get collideConnected():Boolean {
			return jointDef.collideConnected;
		}
		
		public function set collideConnected(value:Boolean):void {
			jointDef.collideConnected = value;
			
			if (joint)
				resetJoint();
		}
		
		
		//-----------------------------------------------------------------------------
		//
		//  Constructor
		//
		//-----------------------------------------------------------------------------
		
		public function Box2DDistanceJointComponent():void {
			initialize();
		}
		
		
		//-----------------------------------------------------------------------------
		//
		//  Methods
		//
		//-----------------------------------------------------------------------------
		
		override protected function onAdd():void {
			super.onAdd();
			
			setup();
		}
		
		
        override protected function onReset():void {
			super.onReset();
			
			setup();
        }
        
        override protected function onRemove():void {
			dispose();
        }
		
		
		//-------------------------------------
		//
		//  Initialize
		//
		//-------------------------------------
		
		private function initialize():void {
			_dampingRatio = 0;
			_frequency = 0;
		}
		
		
		//-------------------------------------
		//
		//  Setup
		//
		//-------------------------------------
		
		private function setup():void {
			if (_spatialManager == null) return;
			if (_spatial1 == null) return;
			if (_spatial2 == null) return;
			
			setupJoint();
		}
		
		private function dispose():void {
			_spatialManager.removeJoint(_joint);
			
			_joint = null;
		}
		
		
		//-------------------------------------
		//  joint
		//-------------------------------------
		
		private function setupJoint():void {
			if (_joint)
				disposeJoint();
			
			updateBodies();
			updateAnchors();
			
			_spatialManager.addJoint(jointDef, this, setupJointCompleteHandler); 
		}
		
		private function setupJointCompleteHandler(joint:b2Joint):void {
			_joint = joint as b2DistanceJoint;
			_joint.SetUserData(this);
		}
		
		private function disposeJoint():void {
			if (_joint == null)
				return;
			
			_spatialManager.removeJoint(_joint);
			
			_joint = null;
		}
		
		
		//-------------------------------------
		//
		//  Box2DDistanceJointComponent
		//
		//-------------------------------------
		
		private function resetJoint():void {
			disposeJoint();
			setupJoint();
		}
		
		private function updateBodies():void {
			if (spatial1 == null || spatial2 == null)
				return;
			
			jointDef.bodyA = _spatial1.body;
			jointDef.bodyB = _spatial2.body;
		}
		
		private function updateAnchors():void {
			if (_anchor1 == null) {
				var point1:b2Vec2 = _spatial1.body.GetLocalPoint(_spatial1.body.GetWorldCenter());
				
				anchor1 = new Point(point1.x, point1.y);
			}
			
			if (_anchor2 == null) {
				var point2:b2Vec2 = _spatial2.body.GetLocalPoint(_spatial2.body.GetWorldCenter());
				
				anchor2 = new Point(point2.x, point2.y);
			}
			
			var worldAnchor1:b2Vec2 = _spatial1.body.GetWorldPoint(new b2Vec2(anchor1.x, anchor1.y));
			var worldAnchor2:b2Vec2 = _spatial2.body.GetWorldPoint(new b2Vec2(anchor2.x, anchor2.y));
			
			var xDistance:Number = worldAnchor2.x - worldAnchor1.x;
			var yDistance:Number = worldAnchor2.y - worldAnchor1.y;
			
			length = Math.sqrt(xDistance * xDistance + yDistance * yDistance);
		}
	}
}
