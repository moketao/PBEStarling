package com.nape 
{
	import nape.shape.Polygon;
	import nape.shape.Shape;
	/**
	 * ...
	 * @author Zo
	 */
	public class RectangleShape extends CollisionShape
	{
		public var width:Number=10;
		public var height:Number=10;
		public var x:Number = 0;
		public var y:Number = 0;
		
		override public function createShape():Shape 
		{
			return new Polygon( Polygon.rect(x, y, width, height));
		}
		
	}

}