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
	import org.recastnavigation._wrap_DT_POLYTYPE_OFFMESH_CONNECTION;
	import org.recastnavigation._wrap_dtStatusFailed;
	import org.recastnavigation.CModule;
	import org.recastnavigation.dtMeshTile;
	import org.recastnavigation.dtNavMesh;
	import org.recastnavigation.dtOffMeshConnection;
	import org.recastnavigation.dtPoly;
	
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
				
				//drawPaths();
			}
		}
		
		private function getTiles():void
		{
			Logger.print(this, "getTiles");
			tiles = manager.getNavMeshTiles();
			if( tiles != null )
				drawNavMesh(tiles);
		}
		
		
		//WIP
		private function drawPaths():void
		{
			if ( !manager || !manager.ready )
				return;
				
			for ( var i:int = 0; i < manager.getAgentCount(); i++ )
			{
				Logger.print(this, "agentCount" + manager.getAgentCount() );
				var npath:int = manager.getAgentPathCount(i );
				if ( npath > 0 )
				{
					var pathPtr:int = manager.getAgentPath(i);
					//trace("Agent path ptr", pathPtr);
					//Logger.print(this, "agent pathPtr " + pathPtr);
					
					var polyRefs:Vector.<int> = CModule.readIntVector(pathPtr, npath );
					
					for ( var j:int = 0; j < polyRefs.length; j++)
					{
						var polyRef:uint = polyRefs[j]; //CModule.read32(pathPtr + (j * 4) ); //+4 bytes, aka 32bits
						
						Logger.print(this, "polyRef " + polyRef);
						
						var navMesh:dtNavMesh = new dtNavMesh();
						navMesh.swigCPtr = manager.sample.getNavMesh();
						
						var offMeshConnectionPtr:int = navMesh.getOffMeshConnectionByRef(polyRef );
						
						
						if ( offMeshConnectionPtr > 0 )
						{
							var offMeshConnection:dtOffMeshConnection = new dtOffMeshConnection();
							offMeshConnection.swigCPtr = offMeshConnectionPtr;
							Logger.print(this, "offMeshConnection " + offMeshConnection.pos );
						
							var ptA:Point = new Point();
							ptA.x = CModule.readFloat( offMeshConnection.pos);
							//_position.y = CModule.readFloat(agentPositionPointer + 4); 
							ptA.y = CModule.readFloat( offMeshConnection.pos + 8); //for 2D grab the z value
							
							var ptB:Point = new Point();
							ptB.x = CModule.readFloat( offMeshConnection.pos +12);
							//_position.y = CModule.readFloat(agentPositionPointer + 16); 
							ptB.y = CModule.readFloat( offMeshConnection.pos + 20 ); //for 2D grab the z value
							
							Logger.print(this, "offMeshConnection " + ptA + " " + ptB);
							
						}
						
						
						/*
						var tile:dtMeshTile = dtMeshTile.create();
						var poly:dtPoly = dtPoly.create();
						
						if ( !navMesh.isValidPolyRef( polyRef ) )
							Logger.error(this, "drawPaths", "not a valid poly ref" );
						
						var tile2:dtMeshTile = new dtMeshTile();
						tile2.swigCPtr = navMesh.getTileByRef(polyRef);
						
						var getTileAndPolyResult:int = navMesh.getTileAndPolyByRef(polyRef, tile.swigCPtr, poly.swigCPtr )
						if ( _wrap_dtStatusFailed( getTileAndPolyResult ) )
							Logger.error(this, "drawPaths", "Failed to getTileAndPolyByRef" );
						
						
						var tst:String = poly.vertCount;
						
						//got the poly, draw that bitch
						var polyTypeStr:String = poly.getType();
						var polyType:Number = polyTypeStr.charCodeAt(0);
						var polyType2:Number = Number(polyTypeStr);
						
						Logger.print(this, "polyType: " +  polyType);
						if ( polyType == _wrap_DT_POLYTYPE_OFFMESH_CONNECTION() )
						{
							Logger.print(this, "is DT_POLYTYPE_OFFMESH_CONNECTION");
						}
						*/
						
					}
				}
			}
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