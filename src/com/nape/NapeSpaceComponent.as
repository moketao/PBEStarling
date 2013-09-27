package com.nape 
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.EntityComponent;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import nape.space.Space;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class NapeSpaceComponent extends TickedComponent 
	{
		public var gravity:Point = new Point(0, 600 );
		
		protected var _space:Space;
		
		public function get space():Space
		{
			return _space;
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			_space = new Space( Vec2.weak(gravity.x, gravity.y));
		}
		
		override public function onTick(deltaTime:Number):void 
		{
			super.onTick(deltaTime);
			
			_space.step(deltaTime);
		}
		
	}

}