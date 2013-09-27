package com.nape 
{
	import nape.shape.Circle;
	import nape.shape.Shape;
	/**
	 * ...
	 * @author Zo
	 */
	public class CircleShape extends CollisionShape
	{
		public var radius:Number;
		
		override public function createShape():Shape 
		{
			
			return new Circle(radius);
		}
	}

}