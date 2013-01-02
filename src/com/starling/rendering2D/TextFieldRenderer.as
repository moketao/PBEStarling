package com.starling.rendering2D 
{
	import com.pblabs.engine.entity.PropertyReference;
	import com.starling.rendering2D.DisplayObjectRenderer;
	import starling.display.DisplayObject;
	import starling.text.TextField;
	
	/**
	 * Static text field, rendered to the GPU.  Once the text is set, either through the text property or the textReference, it cannot be changed.
	 */
	public class TextFieldRenderer extends DisplayObjectRenderer 
	{
		public var textReference:PropertyReference;
		public var text:String;
		public var fontName:String = "Verdana";
		public var fontSize:uint = 12;
		public var bold:Boolean = false;
		public var color:uint = 0x000000;
		public var textWidth:int = 200;
		public var textHeight:int = 30;
		public var autoScale:Boolean = false;
		public var border:Boolean = false;
		
		public var textField:TextField;
		
		override protected function onAdd():void 
		{
			if ( text != null )
				addTextField(text);
			
			super.onAdd();
		}
		
		override public function onFrame(deltaTime:Number):void 
		{
			if ( textReference != null && owner.getProperty(textReference) as String != text)
			{
				addTextField(owner.getProperty(textReference) as String);
			}
			super.onFrame(deltaTime);
		}
		
		private function addTextField(_text:String):void
		{
			text = _text;
			textField = new TextField( textWidth, textHeight, text, fontName, fontSize, color, bold );
			textField.autoScale = autoScale;
			textField.border = border;
			if ( this.displayObject != null ) //remove old text
				scene.remove(this);
				
			this.displayObject = textField as DisplayObject;
			scene.add( this );
		}
		
	}

}