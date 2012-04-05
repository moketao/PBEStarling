package com.starling.input 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.PBE;
	import com.starling.rendering2D.IStarlingApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class ThumbAnalogInputComponent extends EntityComponent 
	{
		private var touchArea:Quad;
		
		private var startMarker:Image;
		private var currentMarker:Image;
		
		private var touchAreaRectangle:Rectangle = new Rectangle(0, 0, 300, 250);
		
		public var horizontalAlign:String = "left"; //left, middle, right
		public var verticalAlign:String = "bottom"; //top, center, bottom
		/**
		 * if true, the origin of the analog control is locked to its starting position
		 * If lockOrigin is false, the origin will move to where touch location within the touch area (assuming the touch area is larger than the marker radius
		 */
		public var lockOrigin:Boolean = false; 
		
		/**
		 * How far you can drag the control from the origin
		 * @default 0 No limit
		 */
		public var radius:Number = 0; 
		
		private var radiusSquared:Number; //private var fr squared radius to faster calculations
		
		/**
		 * How far from the analog origin the touch location is along the X axis
		 */
		public function get xAxis():Number
		{
			if ( radius > 0 )
				return (currentMarker.x - startMarker.x) / radius;
			return currentMarker.x - startMarker.x;
		}
		
		/**
		 * How far from the analog origin the touch location is along the Y axis
		 */
		public function get yAxis():Number
		{
			if ( radius > 0 )
				return (currentMarker.y - startMarker.y) / radius;
			return currentMarker.y - startMarker.y;
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			radiusSquared = radius * radius;
			
			//add the thumb control to the starling stage (Not the PBE StarlingScene)
			
			var stage:Stage = (PBE.mainClass as IStarlingApplication).starling.stage;
			
			var paddingX:int = 30;
			var paddingY:int = 20;
			touchArea = new Quad(touchAreaRectangle.width, touchAreaRectangle.height);
			touchArea.color = 0xcccccc;
			touchArea.alpha = 0.2; //set to alpha 1 to see the hit area
			
			//bottom left
			switch( horizontalAlign )
			{
				case "left":
					touchArea.x = paddingX;
					break;
				case "middle":
				case "center":
					touchArea.x = stage.stageWidth / 2 - touchArea.width / 2;
					break;
				case "right":
					touchArea.x = stage.stageWidth - touchArea.width - paddingX;
					break;
			}
			
			switch( verticalAlign )
			{
				case "top":
					touchArea.y = paddingY;
					break;
				case "middle":
				case "center":
					touchArea.y = stage.stageHeight / 2 - touchArea.height / 2;
					break;
				case "bottom":
					touchArea.y = stage.stageHeight - touchArea.height - paddingY;
					break;
			}
			
			
			//center
			//
			//
			
			touchArea.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.addChild( touchArea );
			
			
			//targets
			startMarker = createTouchMarker(0xcccccc, 0.3, radius);
			startMarker.x  = touchArea.x + (touchArea.width / 2);
			startMarker.y  = touchArea.y + (touchArea.height / 2);
			stage.addChild(startMarker);
			
			currentMarker = createTouchMarker(0xffffff, 0.5, 40);
			currentMarker.x = startMarker.x;
			currentMarker.y = startMarker.y;
			stage.addChild(currentMarker);
			
		}
		
		private function createTouchMarker(color:uint=0xff0000, alpha:Number=0.5, radius:Number=30):Image
		{
			var result:Image;
			var marker:Sprite = new Sprite();
			marker.graphics.beginFill(color, alpha );
			marker.graphics.lineStyle( 2, 0xffffff, 0.6);
			marker.graphics.drawCircle(radius, radius, radius );
			marker.graphics.endFill();
			
			var bmd:BitmapData = new BitmapData(radius * 2, radius * 2,true, color);
			bmd.draw(marker);
			
			var touchMarkerTexture:Texture = Texture.fromBitmapData(bmd);
			
			result =  new Image(touchMarkerTexture);
			
			result.pivotX = result.width/2;
			result.pivotY = result.height / 2;
			result.touchable = false;
			return result;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch;
			if (e.getTouches(touchArea, TouchPhase.BEGAN).length > 0)
			{
				//trace('touches began on leftThumb');
				touch = e.getTouches(touchArea, TouchPhase.BEGAN)[0];
				
				handleTouchBegin(touch);
			}
			
			if ( e.getTouches(touchArea, TouchPhase.MOVED).length > 0)
			{
				touch = e.getTouches(touchArea, TouchPhase.MOVED)[0];
				
				handleTouchMove(touch);
			}
			if (e.getTouches(touchArea, TouchPhase.ENDED).length > 0)
			{
				//	trace('touches ended on leftThumb');
				handleTouchEnd();
			}
		}
		
		private function handleTouchBegin(touch:Touch=null):void
		{
			if ( touch == null )
				return;
				
			//when the touch begins, center the start marker and current marker at the location, while offsetting for radius
			if ( !lockOrigin )
			{
				startMarker.x = Math.max(touchArea.x + radius, Math.min(touch.globalX, touchArea.x + touchArea.width - radius ) );
				startMarker.y = Math.max(touchArea.y + radius, Math.min(touch.globalY, touchArea.y + touchArea.height - radius ) );
			
			
				currentMarker.x = startMarker.x;
				currentMarker.y = startMarker.y;
			}
			else
			{
				handleTouchMove(touch); //if it isnt lock origin, move the current marker to the touch location
			}
		}
		
		private function handleTouchMove(touch:Touch=null):void
		{
			//as the finger moves, update the current marker
				
			//TODO - make sure it is within the analog radius
			//TODO - update xAxis and yAxis values
			var tempX:Number = touch.globalX;
			var tempY:Number = touch.globalY;
			
			//get the a and b sides of the triangle to calulate the radius
			var dx:Number = tempX - startMarker.x;
			var dy:Number = tempY - startMarker.y;
			
			//use pythagorean theorem to determine if it extended the limit
			if (radius > 0 && (dx * dx) + (dy * dy) > radiusSquared ) //if r^2 > a^2 + b^2
			{
				var theta:Number = Math.atan2(dx, dy);
				var opposite:Number = Math.sin(theta) * radius;
				var adjacent:Number = Math.cos(theta) * radius;
				
				tempX = startMarker.x + opposite;
				tempY = startMarker.y + adjacent;
			}
			currentMarker.x = tempX;
			currentMarker.y = tempY;
		}
		
		private function handleTouchEnd(touch:Touch=null):void
		{
			//when it ends, return the currentMarker to the start
			currentMarker.x = startMarker.x;
			currentMarker.y = startMarker.y;
		}
		
	}

}