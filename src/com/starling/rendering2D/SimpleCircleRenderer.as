package com.starling.rendering2D 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import starling.display.DisplayObject;
	import starling.display.Image;
	/**
	 * Simple Circle renderer for testing purposes.
	 */
	public class SimpleCircleRenderer extends DisplayObjectRenderer 
	{
		private var drawSprite:Sprite = new Sprite();
		
		public var color:uint = 0xff0000;
		public var fillAlpha:Number = 1.0;
		public var radius:int = 50;
		public var lineColor:uint = 0x0000ff;
		public var lineThickness:int = 2;
		
		override protected function onAdd():void 
		{
			drawSprite.graphics.beginFill(this.color, fillAlpha );
			drawSprite.graphics.lineStyle( lineThickness, lineColor );
			drawSprite.graphics.drawCircle(radius, radius, radius);
			var bd:BitmapData = new BitmapData((radius * 2) + lineThickness * 2, (radius * 2) + lineThickness * 2, true, 0);
			var m:Matrix = new Matrix();
			m.translate(lineThickness, lineThickness);
			bd.draw( drawSprite, m );
			var bitmap:Bitmap = new Bitmap(bd);
			var image:Image = Image.fromBitmap(bitmap);
			
			this.displayObject = image;
			
			super.onAdd();
		}
		
	}

}