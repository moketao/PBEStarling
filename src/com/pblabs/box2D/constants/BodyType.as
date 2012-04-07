package com.pblabs.box2D.constants {
	
	
	import Box2D.Dynamics.b2Body;
	
	
	/**
	 * ...
	 * @author Ben Zabloski
	 */
	public class BodyType {
		
		
		//-----------------------------------------------------------------------------
		//
		//  Properties
		//
		//-----------------------------------------------------------------------------
		
		public static const DYNAMIC:uint = b2Body.b2_dynamicBody;
		public static const KINEMATIC:uint = b2Body.b2_kinematicBody;
		public static const STATIC:uint = b2Body.b2_staticBody;
	}
}
