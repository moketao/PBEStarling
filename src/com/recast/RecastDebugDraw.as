package com.recast 
{
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.PBE;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RecastDebugDraw extends DisplayObjectRenderer 
	{
		public var manager:RecastManager;
		
		public var navMeshDirty:Boolean = true;
		
		protected var tiles:Array;
		
		private var sprite:Sprite = new Sprite();
		
		public function RecastDebugDraw()
		{
			this.displayObject = sprite;
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			Logger.print(this, "RecastDebugDraw onAdd");
			
			//setInterval( getTiles, 2000 );
			
			PBE.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );
			PBE.mainStage.addEventListener(MouseEvent.CLICK, onClick );
		}
		
		protected function onClick(e:MouseEvent):void
		{
			var localPoisition:Point = new Point(PBE.mainClass.mouseX, PBE.mainClass.mouseY );
			
			trace(localPoisition);
			
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			switch( e.keyCode)
			{
				case Keyboard.R: //redraw
					getTiles();
					break;
			}
		}
		
		override public function onFrame(elapsed:Number):void 
		{
			super.onFrame(elapsed);
			
			if ( manager != null )
			{
				if ( navMeshDirty )
				{
					setTimeout(getTiles, 100);
					//getTiles();
					navMeshDirty = false;
				}
			}
		}
		
		private function getTiles():void
		{
			Logger.print(this, "getTiles");
			tiles = manager.getNavMeshTiles();
			if( tiles != null )
				drawNavMesh(tiles);
		}
		
		private function drawNavMesh(tiles:Array):void
		{
			Logger.print(this, "drawNavMesh");
			sprite.graphics.clear();
			
			//draw each nav mesh tile
			for ( var t:int = 0; t < tiles.length; t++)
			{
				var polys:Array = tiles[t].polys;
				//draw each poly
				for ( var p:int = 0; p < polys.length; p++)
				{
					var poly:Object = polys[p];
					//draw each tri in the poly
					var triVerts:Array = poly.verts;
					sprite.graphics.beginFill(0x6796a5, 0.5 );
					//this.graphics.beginFill(0xffffff * Math.random(), 0.5 );
					for ( var i:int = 0; i < poly.triCount; i++)
					{
						//each triangle has 3 vertices
						//each vert has 3 points, xyz
						var p1:Object = {x: triVerts[(i * 9) + 0], y: triVerts[(i * 9) + 1], z: triVerts[(i * 9) + 2]  };
						var p2:Object = {x: triVerts[(i * 9) + 3], y: triVerts[(i * 9) + 4], z: triVerts[(i * 9) + 5]  };
						var p3:Object = {x: triVerts[(i * 9) + 6], y: triVerts[(i * 9) + 7], z: triVerts[(i * 9) + 8]  };
					
						//this.graphics.beginFill(Math.random()* 0xffffff, 0.5 );
						sprite.graphics.lineStyle(0.1, 0x123d4b);
						
						sprite.graphics.moveTo(p1.x, p1.z);
						sprite.graphics.lineTo(p2.x, p2.z);
						sprite.graphics.lineTo(p3.x, p3.z);
						sprite.graphics.lineTo(p1.x, p1.z);
						
					}
					sprite.graphics.endFill();
				}
			}
			
			//draw origin
			sprite.graphics.lineStyle(0.1, 0x00ff00);
			sprite.graphics.moveTo(0, 0);
			sprite.graphics.lineTo(0, 10 );
			sprite.graphics.lineStyle(0.1, 0x0000ff);
			sprite.graphics.moveTo(0, 0);
			sprite.graphics.lineTo(10, 0);
		}
		
	}

}