package com.pblabs.box2D.controllers {
	
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Controllers.b2SpringController;
	import com.pblabs.box2D.Box2DManagerComponent;
	import com.pblabs.box2D.Box2DSpatialComponent;
	import com.pblabs.engine.components.TickedComponent;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Ben Zabloski
	 */
	public class Box2DSpringControllerComponent extends TickedComponent {
		
		
		//-----------------------------------------------------------------------------
		//
		//  Properties
		//
		//-----------------------------------------------------------------------------
		
		private var springController:b2SpringController;
		
		
		//-------------------------------------
		//  spatialManager
		//-------------------------------------
		
		private var _spatialManager:Box2DManagerComponent;
		
		public function get spatialManager():Box2DManagerComponent {
			return _spatialManager;
		}
		
		public function set spatialManager(value:Box2DManagerComponent):void {
			_spatialManager = value;
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
		}
		
		
		//-------------------------------------
		//  anchor1
		//-------------------------------------
		
		private var _anchor1:b2Vec2;
		
		public function get anchor1():Point {
			var point:Point = new Point(_anchor1.x, _anchor1.y);
			
			return point;
		}
		
		public function set anchor1(value:Point):void {
			_anchor1 = new b2Vec2(value.x, value.y);
		}
		
		
		//-------------------------------------
		//  anchor2
		//-------------------------------------
		
		private var _anchor2:b2Vec2;
		
		public function get anchor2():Point {
			var point:Point = new Point(_anchor2.x, _anchor2.y);
			
			return point;
		}
		
		public function set anchor2(value:Point):void {
			_anchor2 = new b2Vec2(value.x, value.y);
		}
		
		
		//-------------------------------------
		//  length
		//-------------------------------------
		
		private var _length:Number;
		
		public function get length():Number {
			if (springController)
				return springController.length;
			
			return _length;
		}
		
		public function set length(value:Number):void {
			_length = value;
			
			if (springController)
				springController.length = value;
		}
		
		
		//-------------------------------------
		//  kinetics
		//-------------------------------------
		
		private var _kinetics:Number;
		
		public function get kinetics():Number {
			if (springController)
				return springController.k;
			
			return _kinetics;
		}
		
		public function set kinetics(value:Number):void {
			_kinetics = value;
			
			if (springController)
				springController.k = value;
		}
		
		
		//-------------------------------------
		//  damping
		//-------------------------------------
		
		private var _damping:Number;
		
		public function get damping():Number {
			if (springController)
				return springController.damping;
			
			return _damping;
		}
		
		public function set damping(value:Number):void {
			_damping = value;
			
			if (springController)
				springController.damping = value;
		}
		
		
		//-----------------------------------------------------------------------------
		//
		//  Constructor
		//
		//-----------------------------------------------------------------------------
		
		public function Box2DSpringControllerComponent() {
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
		}
		
		override protected function onRemove():void {
			super.onRemove();
			
			dispose();
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			update(deltaTime);
		}
		
		
		//-------------------------------------
		//
		//  Initialize
		//
		//-------------------------------------
		
		private function initialize():void {
			_anchor1 = new b2Vec2();
			_anchor2 = new b2Vec2();
			_length = 3;
			_damping = 0.5;
			_kinetics = 0.2;
		}
		
		
		//-------------------------------------
		//
		//  Setup
		//
		//-------------------------------------
		
		private function setup():void {
			setupSpringController();
		}
		
		private function dispose():void {
			disposeSpringController();
		}
		
		
		//-------------------------------------
		//  springController
		//-------------------------------------
		
		private function setupSpringController():void {
			springController = new b2SpringController();
			springController.m_body1 = spatial1.body;
			springController.m_body2 = spatial2.body;
			springController.SetAnchor1(_anchor1);
			springController.SetAnchor2(_anchor2);
			springController.length = _length;
			springController.damping = _damping;
			springController.k = _kinetics;
			
			_spatialManager.addController(springController);
		}
		
		private function disposeSpringController():void {
			_spatialManager.removeController(springController);
			
			springController = null;
		}
		
		
		//-------------------------------------
		//
		//  Box2DSpringControllerComponent
		//
		//-------------------------------------
		
		private function update(deltaTime:Number):void {
			springController.Step(deltaTime);
			springController.Draw(spatial1.body.GetWorld().GetDebugDraw());
		}
	}
}
