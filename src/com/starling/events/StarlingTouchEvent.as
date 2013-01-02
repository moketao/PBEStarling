package com.starling.events 
{
	import com.starling.rendering2D.DisplayObjectRenderer;
	import flash.events.Event;
	
	/**
	 * Intermediate class to convert Starling Events to flash events, in order to play nice with PushButton.
	 * 
	 * TODO - get starling to use flash.events.
	 */
	public class StarlingTouchEvent extends Event 
	{
		
		public static const HOVER_OVER:String = "hover_over";
		public static const HOVER_OUT:String = "hover_out";
		public static const CLICK:String = "touch_up";
		//public static const TOUCH_UP:String = "touch_up"; //use click down, click, and release_outside
		public static const DOWN:String = "down";
		public static const DRAG_OUTSIDE:String = "drag_outside";
		public static const RELEASE_OUTSIDE:String = "release_outside";
		public var display:Object;
		
		public function StarlingTouchEvent(type:String, display:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.display = display;
		}
		
	}

}