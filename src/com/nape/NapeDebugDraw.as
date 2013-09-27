package com.nape 
{
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import flash.display.Sprite;
	import nape.util.BitmapDebug;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class NapeDebugDraw extends AnimatedComponent 
	{
		protected var debug:BitmapDebug;
		
		public var spaceComponent:NapeSpaceComponent;
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( !spaceComponent )
				throw new Error("must set the spaceComponent property");
			
			debug = new BitmapDebug(PBE.mainStage.stageWidth, PBE.mainStage.stageHeight, 0xcccccc, true);
			
			PBE.mainStage.addChild(debug.display);
		}
		
		override public function onFrame(elapsed:Number):void 
		{
			super.onFrame(elapsed);
			
			if ( debug && spaceComponent)
			{
				debug.clear();
				debug.draw(spaceComponent.space);
				debug.flush();
			}
		}
		
		
	}

}