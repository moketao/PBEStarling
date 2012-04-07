package com.pblabs.box2D.bodies {
	
	
	import Box2D.Dynamics.b2Body;
	import com.pblabs.box2D.Box2DSpatialComponent;
	
	
	/**
	 * ...
	 * @author Ben Zabloski
	 */
	public class Box2DWorldSpatialComponent extends Box2DSpatialComponent {
		
		
		//-----------------------------------------------------------------------------
		//
		//  Properties
		//
		//-----------------------------------------------------------------------------
		
		
		//-------------------------------------
		//  body
		//-------------------------------------
		
		override public function get body():b2Body {
			return spatialManager.world.GetGroundBody();
		}
	}
}
