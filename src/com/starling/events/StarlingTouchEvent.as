package com.starling.events 
{
	import flash.events.Event;
	
	/**
	 * Intermediate class to convert Starling Events to flash events, in order to play nice with PushButton.
	 * 
	 * TODO - get starling to use flash.events.
	 */
	public class StarlingTouchEvent extends Event 
	{
		
		public static const TOUCH_DOWN:String = "touch_down";
		
		public function StarlingTouchEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}