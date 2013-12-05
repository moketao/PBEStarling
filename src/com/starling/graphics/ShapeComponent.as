package com.starling.graphics 
{
	import com.pblabs.engine.debug.Logger;
	import com.starling.rendering2D.DisplayObjectRenderer;
	import com.starling.rendering2D.TextureComponent;
	import flash.geom.Rectangle;
	import starling.display.Shape;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class ShapeComponent extends DisplayObjectRenderer 
	{
		protected var shape:Shape = new Shape();
		
		public function ShapeComponent() 
		{
			this.displayObject = shape;
		}
		
		public function get lineTo():Array { return _lineTo; }
		public function set lineTo(value:Array):void
		{
			_lineTo = value;
			_shapeDirty = true;
			
		}
		public function get radius():Number { return _radius; }
		public function set radius(value:Number):void
		{
			if ( value != _radius )
			{
				_radius = value;
				_shapeDirty = true;
			}
		}
		public function get rect():Rectangle { return _rect; }
		public function set rect(value:Rectangle):void
		{
			if ( value != _rect )
			{
				_rect = value;
				_shapeDirty = true;
			}
		}
		public function get lineTexture():TextureComponent { return _lineTexture; }
		public function set lineTexture(value:TextureComponent):void
		{
			if ( value != _lineTexture )
			{
				_lineTexture = value;
				_shapeDirty = true;
			}
		}
		public function get fillTexture():TextureComponent { return _fillTexture; }
		public function set fillTexture(value:TextureComponent):void
		{
			if ( value != _fillTexture )
			{
				_fillTexture = value;
				_shapeDirty = true;
			}
		}
		public function get fillAlpha():Number { return _fillAlpha; }
		public function set fillAlpha(value:Number):void
		{
			if ( value != _fillAlpha )
			{
				_fillAlpha = value;
				_shapeDirty = true;
			}
		}
		public function get lineAlpha():Number { return _lineAlpha; }
		public function set lineAlpha(value:Number):void
		{
			if ( value != _lineAlpha )
			{
				_lineAlpha = value;
				_shapeDirty = true;
			}
		}
		public function get lineColor():uint { return _lineColor; }
		public function set lineColor(value:uint):void
		{
			if ( value != _lineColor )
			{
				_lineColor = value;
				_shapeDirty = true;
			}
		}
		public function get fillColor():uint { return _fillColor; }
		public function set fillColor(value:uint):void
		{
			if ( value != _fillColor )
			{
				_fillColor = value;
				_shapeDirty = true;
			}
		}
		public function get lineThickness():Number { return _lineThickness; }
		public function set lineThickness(value:Number):void
		{
			if ( value != _lineThickness )
			{
				_lineThickness = value;
				_shapeDirty = true;
			}
		}
		
		override public function onFrame(deltaTime:Number):void 
		{
			super.onFrame(deltaTime);
			
			if ( _shapeDirty )
			{
				drawShape();
			}
		}
		
		private function drawShape():void
		{
			//check if the line or fill textures are loaded
			if ( (lineTexture != null && !lineTexture.isLoaded ) || (fillTexture != null && !fillTexture.isLoaded ) )
				return;
				
			if ( shape )
			{
				shape.graphics.clear();
				
				//setup line style
				if( lineTexture && lineThickness > 0 )
					shape.graphics.lineTexture(lineThickness, lineTexture.texture );
				else
					shape.graphics.lineStyle( lineThickness, lineColor, lineAlpha );
					
				//setup fill
				if ( fillTexture )
					shape.graphics.beginTextureFill( fillTexture.texture );
				else
					shape.graphics.beginFill( fillColor, fillAlpha );
					
				//now draw the rect, circle, or polygon
				if ( rect ) //draw rect
				{
					if( !isNaN(radius) && radius > 0 )
						shape.graphics.drawRoundRect( rect.x, rect.y, rect.width, rect.height, radius );
					else
						shape.graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
				}
				else if ( !isNaN(radius) && radius > 0 ) //draw circle
				{
					shape.graphics.drawCircle(0, 0, radius );
				}
				else if ( lineTo && lineTo.length > 0 )
				{
					//draw poly
					shape.graphics.moveTo( lineTo[0].x, lineTo[0].y );
					for ( var i:int = 1; i < lineTo.length; i++ )
						shape.graphics.lineTo( lineTo[i].x, lineTo[i].y );
					shape.graphics.lineTo( lineTo[0].x, lineTo[0].y );
					
					
				Logger.print(this, 'shape redrawn' + lineTo.length);
				}
				else
				{
					//just drawing a line?
				}
				
				shape.graphics.endFill();
				
				_shapeDirty = false;
				
			}
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			if( shape )
				shape.dispose();
		}
		
		
		private var _lineThickness:Number = -1; //-1 to indicate no line
		private var _lineColor:uint = 0x000000;
		private var _lineAlpha:Number = 1;
		private var _fillAlpha:Number = 1;
		private var _fillColor:uint = 0x000000;
		private var _fillTexture:TextureComponent;
		private var _lineTexture:TextureComponent;
		private var _rect:Rectangle; //for drawRect
		private var _radius:Number; //if rect is defined, this is used for the rounded rect radius, if not, it is used to draw a circle
		private var _lineTo:Array = []; //Array<Point> used to draw line Tos
		
		private var _shapeDirty:Boolean;
		
	}

}