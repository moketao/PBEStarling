package com.starling.ui 
{
	import com.pblabs.engine.serialization.TypeUtility;
	import com.starling.rendering2D.DisplayObjectRenderer;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import starling.animation.Transitions;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class ScreenNavigatorComponent extends DisplayObjectRenderer 
	{
		public function get screenNavigator():ScreenNavigator 
		{
			return _screenNavigator;
		}
		protected var _screenNavigator:ScreenNavigator = new ScreenNavigator();
		
		protected var transitionManager:ScreenSlidingStackTransitionManager;
		
		/**
		 * array of screen class names
		 */
		public var screens:Array = [];
		
		override protected function onAdd():void 
		{
			this.displayObject = _screenNavigator;
			super.onAdd();
			
			if (screens.length > 0 )
			{
				for ( var i:int = 0; i < screens.length; i++ )
				{
					var screenClass:Class = TypeUtility.getClassFromName(screens[i]);
					if( screenClass != null )
						_screenNavigator.addScreen(screens[i], new ScreenNavigatorItem(screenClass));
				}
				
				//TODO - move this into a opublic var that can be set in XML
				transitionManager = new ScreenSlidingStackTransitionManager(_screenNavigator);
				transitionManager.duration = 0.4;
				transitionManager.ease = Transitions.EASE_IN_OUT;
				
				_screenNavigator.showScreen(screens[0]);
			}
			
		}
		
	}

}