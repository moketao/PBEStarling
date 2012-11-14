package com.starling.rendering2D 
{
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.engine.PBUtil;
	import com.starling.events.StarlingTouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class DisplayObjectRenderer extends EntityComponent implements IAnimatable 
	{
		/**
		 * The StarlingScene in which to add the DisplayObjectRenderer component to.
		 */
		public var scene:StarlingScene;
		
		/**
         * If set, the layer index is gotten from this property every frame.
         */
        public var layerIndexProperty:PropertyReference;
        
        /**
         * If set, our z-index is gotten from this property every frame.
         */
        public var zIndexProperty:PropertyReference;
		
		/*
		 * scrollFactor property for paralax effect
		 * 0.1 to 1 = forground, fast scrolling
		 * 1 = fixed position
		 * 1.1 to 1.5 = background, slow scrolling
		 */
		public var scrollFactor:Point = new Point(1, 1); 
		
		/**
         * If set, position is gotten from this property every frame.
         */
        public var positionProperty:PropertyReference;
		
		/**
         * If set, rotation is gotten from this property every frame.
         */
        public var rotationProperty:PropertyReference;
		
		/**
         * If set, scale is gotten from this property every frame.
         */
        public var scaleProperty:PropertyReference;
		
		/**
         * If set, alpha is gotten from this property every frame.
         */
        public var alphaProperty:PropertyReference;
		
		
		/**
         * if set this to false, positions will be handeled with numbers insteed of integers
         * makes slow movement smoother for example
         */
        public var snapToNearestPixels:Boolean = true;
		
		//Protected variables
		protected var basePosition:Point; //used for scroll factor
		protected var _displayObject:DisplayObject;
		protected var _layerIndex:int = 0;
		protected var _layerIndexDirty:Boolean = true;
		protected var _zIndex:int = 0;
        protected var _zIndexDirty:Boolean = true;
		protected var _transformDirty:Boolean = true;
		protected var _transformMatrix:Matrix = new Matrix();
		protected var _position:Point = new Point();
		protected var _scale:Point = new Point(1,1);
		protected var _rotation:Number = 0;
		protected var _rotationOffset:Number = 0;
		protected var _alpha:Number = 1;
		protected var _positionOffset:Point = new Point();
		protected var _registrationPoint:Point = new Point();
		protected var _touchable:Boolean = false;
		protected var _visible:Boolean = false;
		
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		public function set displayObject(value:DisplayObject):void
		{
			_displayObject = value;
			
			if ( _displayObject != null )
			{
				if ( touchable )
					displayObject.addEventListener(TouchEvent.TOUCH, onTouch );
			}
		}
		
		/**
		 * Starlings implementation of the IAnimatable class.  Called very frame.
		 * @param	deltaTime
		 */
		public function advanceTime(deltaTime:Number):void 
		{			
			if (!displayObject)
                return;
            
            updateProperties();
			
			// Now that we've read all our properties, apply them to our transform.
            if (_transformDirty)
                updateTransform();
		}
		
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			Starling.juggler.add(this); //add to the starling juggler, calling advanceTime every frame
			
			if ( displayObject != null && scene != null && scene.sceneView != null )
				scene.add( this );
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			Starling.juggler.remove(this);
			
			if ( displayObject != null && scene != null && scene.sceneView != null )
				scene.remove( this );
				//scene.sceneView.removeChild( displayObject );
		}
		
		protected function updateProperties():void
        {
            if(!owner)
                return;
				
			// Sync our zIndex.
            if (zIndexProperty)
                zIndex = owner.getProperty(zIndexProperty, zIndex);
            
            // Sync our layerIndex.
            if (layerIndexProperty)
                layerIndex = owner.getProperty(layerIndexProperty, layerIndex);
            
            // Maybe we were in the right layer, but have the wrong zIndex.
            if (_zIndexDirty && scene)
            {
                scene.getLayer(_layerIndex, true).markDirty();
                _zIndexDirty = false;
            }
                        
            // Position.
            var pos:Point = owner.getProperty(positionProperty) as Point;
            if (pos)
            {
                position = pos;
            }
            
            // Scale.
            var scale:Point = owner.getProperty(scaleProperty) as Point;
            if (scale)
            {
                this.scale = scale;
            }
			
			//alpha
			if ( alphaProperty != null )
			{
				this.alpha = owner.getProperty(alphaProperty) as Number;
			}
            
            
            // Rotation.
            if (rotationProperty)
            {
                var rot:Number = owner.getProperty(rotationProperty) as Number;
                this.rotation = rot;
            }
			
			
			if ( scrollFactor.x != 1 || scrollFactor.y != 1 )
				_transformDirty = true;
		}
		
		/**
		 * Indicates if this object (and its children) will receive starling touch events.
		 * @default false
		 */
		public function get touchable():Boolean
		{
			return _touchable;
		}
		
		public function set touchable(value:Boolean):void
		{
			_touchable = value;
			_transformDirty = true;
		}
		
        public function get layerIndex():int
        {
            return _layerIndex;
        }
        
        /**
         * In what layer of the scene is this renderer drawn?
         */
        public function set layerIndex(value:int):void
        {
            if (_layerIndex == value)
                return;
            
            _layerIndex = value;
            _layerIndexDirty = true;
        }
        
        public function get zIndex():int
        {
            return _zIndex;
        }
        
        /**
         * By default, layers are sorted based on the z-index, from small
         * to large.
         * @param value Z-index to set.
         */
        public function set zIndex(value:int):void
        {
            if (_zIndex == value)
                return;
            
            _zIndex = value;
            _zIndexDirty = true;
        }
		
		
        public function get position():Point
        {
            return _position.clone();
        }
        
        /**
         * Position of the renderer in scene space.
         *
         * @see worldPosition
         */
        public function set position(value:Point):void
        {
            var posX:Number;
            var posY:Number;
            
            if (snapToNearestPixels)
            {
                posX = int(value.x);
                posY = int(value.y);
            }
            else
            {
                posX = value.x;
                posY = value.y;
            }
            
            if (posX == _position.x && posY == _position.y)
                return;
            
            _position.x = posX;
            _position.y = posY;
			_transformDirty = true;
        }
		
		
        public function get registrationPoint():Point
        {
            return _registrationPoint.clone();
        }
        
        /**
         * The registration point can be used to offset the sprite
         * so that rotation and scaling work properly.
         *
         * @param value Position of the "center" of the sprite.
         */
        public function set registrationPoint(value:Point):void
        {
            var intX:int = int(value.x);
            var intY:int = int(value.y);
            
            if (intX == _registrationPoint.x && intY == _registrationPoint.y)
                return;
            
            _registrationPoint.x = intX;
            _registrationPoint.y = intY;
            _transformDirty = true;
        }
		
		
        public function get scale():Point
        {
            return _scale.clone();
        }
        
        /**
         * You can scale things on the X and Y axes.
         */
        public function set scale(value:Point):void
        {
            if (value.x == _scale.x && value.y == _scale.y)
                return;
            
            _scale.x = value.x;
            _scale.y = value.y;
			
            _transformDirty = true;
        }
		
		/**
         * Rotation in degrees
         */
        public function get rotation():Number
        {
            return PBUtil.getDegreesFromRadians(_rotation);
        }
        
        /**
         * Rotation in degrees
         */
        public function set rotation(value:Number):void
        {
			value = PBUtil.getRadiansFromDegrees(value);
            if (value == _rotation)
                return;
            
            _rotation = value;
            _transformDirty = true;
        }
		
		public function get alpha():Number
        {
            return _alpha;
        }
        
        /**
         * alpha of the display object
         */
        public function set alpha(value:Number):void
        {
            if (value == _alpha)
                return;
            
            _alpha = value;
            _transformDirty = true;
        }
		
		
		
		public function get positionOffset():Point
		{
			return _positionOffset.clone();
		}
		
		/**
		 * Sets a position offset that will offset the sprite.
		 * 
		 * Please note: This is unaffected by rotation.
		 */
		public function set positionOffset(value:Point):void
		{
			if (value.x == _positionOffset.x && value.y == _positionOffset.y)
				return;
			
			_positionOffset.x = value.x;
			_positionOffset.y = value.y;
			
			_transformDirty = true;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			if ( _visible != value )
			{
				_visible = value;
				alpha = _visible ? 1 : 0;
			}
			
		}
		
		
        /**
         * Rotation offset applied to the child DisplayObject. Used if, for instance,
         * your art is rotated 90deg off from where you want it.
         *
         * @return Number Offset Rotation angle in degrees
         */
        public function get rotationOffset():Number 
        {
            return PBUtil.getDegreesFromRadians(_rotationOffset);
        }
        
        /**
         * Rotation offset applied to the child DisplayObject.
         *
         * @param value Offset Rotation angle in degrees
         */
        public function set rotationOffset(value:Number):void 
        {
            _rotationOffset = PBUtil.unwrapRadian(PBUtil.getRadiansFromDegrees(value));
        }
		
		 /**
         * Update the object's transform based on its current state. Normally
         * called automatically, but in some cases you might have to force it
         * to update immediately.
         * @param updateProps Read fresh values from any mapped properties.
         */
        public function updateTransform(updateProps:Boolean = false):void
        {
            if(!displayObject)
                return;
            
            if(updateProps)
                updateProperties();
			
			
			displayObject.pivotX = _positionOffset.x;
			displayObject.pivotY = _positionOffset.y;
			
			if( displayObject.touchable != _touchable )
				displayObject.touchable = _touchable;
			
			//update position with scrollFactor
			if ( scrollFactor.x != 1 || scrollFactor.y != 1 )
			{
				
				if( basePosition == null )
					basePosition = position;
					
				var screenPosition:Point = new Point(scene.sceneView.x, scene.sceneView.y);
				
				//adjust for scroll factor
				_position.x = basePosition.x - (screenPosition.x  - (screenPosition.x * (scrollFactor.x ) ) );
				_position.y = basePosition.y - (screenPosition.y  - (screenPosition.y * (scrollFactor.y ) ) );
				
			}
			
			//position
			displayObject.x = _position.x;
			displayObject.y = _position.y;
			
			//scale
			displayObject.scaleX = _scale.x;
			displayObject.scaleY = _scale.y;
			
			//alpha
			displayObject.alpha = _alpha;
			
			//rotation
			displayObject.rotation = _rotation;
			
            _transformDirty = false;
        }
		
		
		protected function onTouch(e:TouchEvent):void
		{
			//TODO - dispatch events for hover, and up
			
			var touch:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.BEGAN );
			
			if ( touch != null ) //touch down
			{
				var se:StarlingTouchEvent = new StarlingTouchEvent(StarlingTouchEvent.TOUCH_DOWN );
				
				owner.eventDispatcher.dispatchEvent(se);
			}
		}
	}

}