package com.starling.animation
{
	import com.pblabs.engine.entity.EntityComponent;
    import com.pblabs.engine.entity.PropertyReference;
    import flash.utils.Dictionary;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	
    /**
	 * Conversion of com.pblabs.animation.AnimatorComponent to use Starling juggler
	 */
    public class AnimatorComponent extends EntityComponent implements IAnimatable
    {
        /**
         * A list of all the animation that can be played by this component.
         */
        [TypeHint(type="com.pblabs.animation.Animator")]
        public var animations:Dictionary = null;

        /**
         * Whether or not to start the animation when the component is registered.
         */
        [EditorData(defaultValue="true")]
        public var autoPlay:Boolean = true;

        /**
         * The name of the animation to automatically start playing when the component
         * is registered.
         */
        public var defaultAnimation:String = "Idle";
		
        /**
         * A reference to the property that will be animated.
         */
        public var reference:PropertyReference = null;

        private var _currentAnimation:Animator = null;
		
		public function get currentAnimation():Animator { return _currentAnimation; }
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			Starling.juggler.add( this );
		}
		
		override protected function onRemove():void 
		{
			super.onRemove();
			
			Starling.juggler.remove( this );
		}

		/**
         * 
         */
        public function advanceTime(elapsed:Number):void
        {
            if (_currentAnimation)
            {
                _currentAnimation.animate(elapsed);                               
                owner.setProperty(reference, _currentAnimation.currentValue);
            }
        }

        /**
         * Plays an animation that is on this component.
         *
         * @param animation The name of the animation in the Animations dictionary
         * to play.
         * @param startValue The value to start at. If this is null (the default), the
         * start value won't be changed.
         */
        public function play(animation:String, startValue:* = null):void
        {
        	if (_currentAnimation && _currentAnimation.isAnimating)
        		   _currentAnimation.stop();
        	
            _currentAnimation = animations[animation];
            if (!_currentAnimation)
                return;

            if (startValue)
                _currentAnimation.startValue = startValue;

            _currentAnimation.reset();
            _currentAnimation.play();
        }

        /**
         * @inheritDoc
         */
        override protected function onReset():void
        {
            if (!autoPlay || _currentAnimation)
                return;

            play(defaultAnimation);
        }
    }

}