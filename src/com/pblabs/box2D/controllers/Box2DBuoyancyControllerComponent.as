package com.pblabs.box2D.controllers {
	
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Controllers.b2BuoyancyController;
	import com.pblabs.box2D.Box2DManagerComponent;
	import com.pblabs.box2D.Box2DSpatialComponent;
	import com.pblabs.engine.entity.EntityComponent;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Ben Zabloski
	 */
	public class Box2DBuoyancyControllerComponent extends EntityComponent {
		
		
		//-----------------------------------------------------------------------------
		//
		//  Properties
		//
		//-----------------------------------------------------------------------------
		
		private var buoyancyController:b2BuoyancyController;
		
		
		//-------------------------------------
		//  spatialManager
		//-------------------------------------
		
		private var _spatialManager:Box2DManagerComponent;
		
		public function get spatialManager():Box2DManagerComponent {
			return _spatialManager;
		}
		
		public function set spatialManager(value:Box2DManagerComponent):void {
			if (value == _spatialManager)
				return;
			
			if (buoyancyController) {
				disposeBuoyancyController();
				
				_spatialManager = value;
				
				setupBuoyancyController();
			} else {
				_spatialManager = value;
			}
		}
		
		
		//-------------------------------------
		//  spatials
		//-------------------------------------
		
		private var _spatials:Array;
		
		public function get spatials():Array {
			return _spatials;
		}
		
		public function set spatials(value:Array):void {
			disposeSpatials();
			
			_spatials = value;
			
			setupSpatials();
		}
		
		
		//-------------------------------------
		//  normal
		//-------------------------------------
		
		private var _normal:Point;
		
		public function get normal():Point {
			return _normal;
		}
		
		public function set normal(value:Point):void {
			_normal = value;
			
			if (buoyancyController)
				buoyancyController.normal = new b2Vec2(value.x, value.y);
		}
		
		
		//-------------------------------------
		//  offset
		//-------------------------------------
		
		private var _offset:Number;
		
		public function get offset():Number {
			return _offset;
		}
		
		public function set offset(value:Number):void {
			_offset = value;
			
			if (buoyancyController)
				buoyancyController.offset = value;
		}
		
		
		//-------------------------------------
		//  density
		//-------------------------------------
		
		private var _density:Number;
		
		public function get density():Number {
			return _density;
		}
		
		public function set density(value:Number):void {
			_density = value;
			
			if (buoyancyController)
				buoyancyController.density = value;
		}
		
		
		//-------------------------------------
		//  linearDrag
		//-------------------------------------
		
		private var _linearDrag:Number;
		
		public function get linearDrag():Number {
			return _linearDrag;
		}
		
		public function set linearDrag(value:Number):void {
			_linearDrag = value;
			
			if (buoyancyController)
				buoyancyController.linearDrag = value;
		}
		
		
		//-------------------------------------
		//  angularDrag
		//-------------------------------------
		
		private var _angularDrag:Number;
		
		public function get angularDrag():Number {
			return _angularDrag;
		}
		
		public function set angularDrag(value:Number):void {
			_angularDrag = value;
			
			if (buoyancyController)
				buoyancyController.angularDrag = value;
		}
		
		
		//-------------------------------------
		//  gravity
		//-------------------------------------
		
		private var _gravity:Point;
		
		public function get gravity():Point {
			if (buoyancyController) {
				if (!buoyancyController.useWorldGravity)
					return new Point(buoyancyController.gravity.x, buoyancyController.gravity.y);
			}
			
			return _gravity;
		}
		
		public function set gravity(value:Point):void {
			_gravity = value;
			
			if (buoyancyController) {
				buoyancyController.useWorldGravity = false;
				buoyancyController.gravity = new b2Vec2(value.x, value.y);
			}
		}
		
		
		//-----------------------------------------------------------------------------
		//
		//  Constructor
		//
		//-----------------------------------------------------------------------------
		
		public function Box2DBuoyancyControllerComponent() {
			super();
			
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
			
			super.onRemove();
		}
		
		
		//--------------------------------------
		//
		//  Initialize
		//
		//-------------------------------------
		
		private function initialize():void {
			_spatials = new Array();
			_normal = new Point(0, -1);
			_offset = 0;
			_density = 1;
			_linearDrag = 5;
			_angularDrag = 2;
		}
		
		
		//-------------------------------------
		//
		//  Setup
		//
		//-------------------------------------
		
		private function setup():void {
			if (_spatialManager == null) throw new Error("spatialManager was not assigned");
			
			setupBuoyancyController();
		}
		
		private function dispose():void {
			disposeBuoyancyController();
		}
		
		
		//-------------------------------------
		//  buoyancyController
		//-------------------------------------
		
		private function setupBuoyancyController():void {
			if (buoyancyController)
				disposeBuoyancyController();
			
			buoyancyController = new b2BuoyancyController();
			
			buoyancyController.normal.Set(normal.x, normal.y);
			buoyancyController.offset = offset;
			buoyancyController.density = density;
			buoyancyController.linearDrag = linearDrag;
			buoyancyController.angularDrag = angularDrag;
			
			if (_gravity)
				gravity = gravity;
			
			_spatialManager.addController(buoyancyController);
			
			setupSpatials();
		}
		
		private function disposeBuoyancyController():void {
			disposeSpatials();
			
			_spatialManager.removeController(buoyancyController);
			
			buoyancyController = null;
		}
		
		
		//-------------------------------------
		//  spatials
		//-------------------------------------
		
		private function setupSpatials():void {
			if (buoyancyController == null)
				return;
			
			for each (var spatial:Box2DSpatialComponent in _spatials) {
				buoyancyController.AddBody(spatial.body);
			}
		}
		
		private function disposeSpatials():void {
			if (_spatials == null)
				return;
			
			for each (var spatial:Box2DSpatialComponent in _spatials) {
				buoyancyController.RemoveBody(spatial.body);
			}
		}
		
		
		//-------------------------------------
		//
		//  Box2DBuoyancyControllerComponent
		//
		//-------------------------------------
		
		public function addSpatial(spatial:Box2DSpatialComponent):void {
			_spatials.push(spatial);
			
			if (spatial.body == null)
				return;
			
			if (buoyancyController)
				buoyancyController.AddBody(spatial.body);
		}
		
		public function removeSpatial(spatial:Box2DSpatialComponent):void {
			var index:int = _spatials.indexOf(spatial);
			if (index == -1)
				return;
			
			_spatials.splice(index, 1);
			
			if (buoyancyController)
				buoyancyController.RemoveBody(spatial.body);
		}
	}
}
