package com.recast 
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Profiler;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceBundle;
	import com.pblabs.engine.resource.ResourceEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import org.recastnavigation.AS3_rcContext;
	import org.recastnavigation.CModule;
	import org.recastnavigation.dtCrowd;
	import org.recastnavigation.dtCrowdAgent;
	import org.recastnavigation.dtCrowdAgentDebugInfo;
	import org.recastnavigation.dtCrowdAgentParams;
	import org.recastnavigation.dtNavMeshQuery;
	import org.recastnavigation.dtObstacleAvoidanceParams;
	import org.recastnavigation.InputGeom;
	import org.recastnavigation.Sample_TempObstacles;
	import org.recastnavigation.util.getTiles;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RecastManager extends TickedComponent 
	{
		public var scale:Number = 1.0;
		public var geometry:DataResource;
		
		public var m_cellSize:Number = 0.3,
			m_cellHeight:Number = 0.2,
			m_agentHeight:Number = 3.0,
			m_agentRadius:Number = 0.6,
			m_agentMaxClimb:Number = 0.9,
			m_agentMaxSlope:Number = 45.0,
			m_regionMinSize:Number = 8,
			m_regionMergeSize:Number = 20,
			m_edgeMaxLen:Number = 12.0,
			m_edgeMaxError:Number = 1.3,
			m_vertsPerPoly:Number = 6.0,
			m_detailSampleDist:Number = 6.0,
			m_detailSampleMaxError:Number = 1.0,
			m_tileSize:Number = 48,
			m_maxObstacles:Number = 128;
		
		public var maxAgents:int = 60;
		
		private var recast:Object; //cLib object
		
		public var ready:Boolean = false;
		
		
		//public var memUser:MemUser = new MemUser();
		
		public function RecastManager() 
		{
			
		}
		
		//WRAPPER METHODS
		
		/** 
		 * Adds an agent to the Detour Crowd. For 2D agents, use the z property for the 2d y-axis
		 * Position and radius are in WORLD coordinates  will be converted to local recast scale
		 * @return idx the agent id returned from detour crowd
		 */
		public function addAgent(x:Number, y:Number, z:Number, paramsSwigCPtr:int):uint
		{
			
			var posPtr:int = CModule.malloc(12);
			CModule.writeFloat(posPtr, x / scale);
			CModule.writeFloat(posPtr + 4, y / scale);
			CModule.writeFloat(posPtr + 8, z / scale);
			
			var idx:int = crowd.addAgent(posPtr, paramsSwigCPtr );
			
			var navquery:dtNavMeshQuery  = new dtNavMeshQuery();
			navquery.swigCPtr =  sample.getNavMeshQuery();

			var targetRef:int = CModule.malloc(4);
			var targetPos:int = CModule.malloc(12);
			
			_numOfAgents ++;
			//trace("num of agents: ", _numOfAgents);
			
			var statusPtr:int = navquery.findNearestPoly(posPtr, crowd.getQueryExtents(), crowd.getFilter(), targetRef, targetPos);
			
			CModule.free(posPtr);
			CModule.free(targetRef);
			CModule.free(targetPos);
			return idx;
		}
		
		private var _numOfAgents:int = 0;
		
		/** 
		 * removes an agent to the Detour Crowd.
		 * @param idx the agent id that was returned from the addAgent method
		 */
		public function removeAgent(idx:uint):void
		{
			//Profiler.enter("removeAgent");
			crowd.removeAgent(idx);
			_numOfAgents--;
			
			//trace("num of agents: ", _numOfAgents);
			//Profiler.exit("removeAgent");
		}
		
		/**
		 * Get the pointer value of the agent's position
		 * @param	idx the agent to retrieve
		 * @return the pointer where the agent's position is stored
		 */
		public function getAgentPosition(idx:uint):uint 
		{
			var agent:dtCrowdAgent = new dtCrowdAgent();
			agent.swigCPtr = crowd.getAgent(idx);
			return agent.npos;
			
			//return recast.getAgentPosition(idx);
		}
		
		public function getAgentVelocity(idx:uint):uint 
		{
			//return recast.getAgentVelocity(idx);
			
			var agent:dtCrowdAgent = new dtCrowdAgent();
			agent.swigCPtr = crowd.getAgent(idx);
			return agent.nvel;
		}
		
		/**
		 * 
		 * @param	idx
		 * @param	x world x position
		 * @param	y world y position
		 * @param	z world x position
		 */
		public function moveAgent(idx:uint, x:Number, y:Number, z:Number):void
		{
			var posPtr:int = CModule.malloc(12);
			CModule.writeFloat(posPtr, x / scale);
			CModule.writeFloat(posPtr + 4, y / scale);
			CModule.writeFloat(posPtr + 8, z / scale);
			
			var navquery:dtNavMeshQuery  = new dtNavMeshQuery();
			navquery.swigCPtr =  sample.getNavMeshQuery();
			
			var targetRef:int = CModule.malloc(4);
			var targetPos:int = CModule.malloc(12);
			
			var status:int = navquery.findNearestPoly(posPtr, crowd.getQueryExtents(), crowd.getFilter(), targetRef, targetPos);
		
			if ( targetRef > 0)
				crowd.requestMoveTarget(idx, targetRef, targetPos);
				
			CModule.free(posPtr);
			CModule.free(targetRef);
			CModule.free(targetPos);
		}
		
		public function setObstacleAvoidanceParams( idx:uint, 	velBias:Number = 0.4, 
																weightDesVel:Number = 2.0, 
																weightCurVel:Number = 0.75, 
																weightSide:Number = 0.75, 
																weightToi:Number = 2.5,  
																horizTime:Number = 2.5, 
																gridSize:Number = 33, 
																adaptiveDivs:Number = 7, 
																adaptiveRings:Number = 2, 
																adaptiveDepth:Number = 5):void
		{
			//recast.setObstacleAvoidanceParams( idx, velBias, weightDesVel, weightCurVel, weightSide, weightToi, horizTime, gridSize, adaptiveDivs, adaptiveRings, adaptiveDepth);
			var params:dtObstacleAvoidanceParams = dtObstacleAvoidanceParams.create();
			params.velBias = velBias;
			params.weightDesVel = weightDesVel;
			params.weightCurVel = weightCurVel;
			params.weightSide = weightSide;
			params.weightToi = weightToi;
			params.horizTime = horizTime;
			params.gridSize = String.fromCharCode(int(gridSize));
			params.adaptiveDivs = String.fromCharCode(int(adaptiveDivs));
			params.adaptiveRings =String.fromCharCode(int(adaptiveRings));
			params.adaptiveDepth = String.fromCharCode(int(adaptiveDepth));
			
			crowd.setObstacleAvoidanceParams(idx, params.swigCPtr);
		}
		
		/**
		 * Adds an obstacle to the nav mesh
		 * @param	x Position of the object in the world.
		 * @param	y
		 * @param	z
		 * @param	radius the radius of the obstacle
		 * @param	height the height of the obstacle
		 * @return The obstacle id
		 */
		public function addObstacle(x:Number, y:Number, z:Number, radius:Number, height:Number):uint
		{
			//trace( "add Obstacle ", x/scale, y/scale, z/scale, radius/scale, height/scale);
			//Profiler.enter("addObstacle");
			//var result:uint = recast.addObstacle(x / scale, y / scale, z / scale, radius / scale, height / scale);
			//Profiler.exit("addObstacle");
			//return result;
			
			if ( !sample )
				return 0;
			
			var posPtr:int = CModule.malloc(12);
			CModule.writeFloat(posPtr, x / scale);
			CModule.writeFloat(posPtr + 4, y / scale);
			CModule.writeFloat(posPtr + 8, z / scale);
			_dirtyTiles = true; //make sure tiles get rebuilt
			var oid:uint = sample.addTempObstacle(posPtr, radius / scale, height / scale);
			
			CModule.free(posPtr);
			
			return oid;
		}
		
		/**
		 * Removes an obstacle from the nav mesh
		 * @param	id The obstacle id returned from addObstacle
		 */
		public function removeObstacle(id:uint):void
		{
			//Profiler.enter("removeObstacle");
			//if( recast != null )
			//	recast.removeObstacle(id);
			//Profiler.exit("removeObstacle");
			if ( sample )
			{
				_dirtyTiles = true;
				sample.removeTempObstacle(id);
			}
		}
		
		//Debug method to get the tiles and polygons for drawing the nav mesh
		//TODO - seperate this from the main recast lib, into a RecastDebug library
		public function getNavMeshTiles():Array
		{
			if ( sample == null )
				return null;
				
			return getTiles( sample.swigCPtr );
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if ( geometry != null && geometry.isLoaded )
			{
				initRecast();
			}
			else if ( geometry != null )
			{
				geometry.addEventListener(ResourceEvent.LOADED_EVENT, initRecast );
			}
		}
		
		protected function initRecast(e:Event=null):void
		{
			/* old alchemy way
			//Profiler.enter("initRecast");
			var loader:CLibInit = new CLibInit;
				
			//1. supply the required geometry .obj file to the c lib before calling init
			loader.supplyFile(geometry.filename, geometry.data);
			
			//2. now init the clib				
			recast = loader.init();
			
			//3. load the geomerty
			var meshLoadSuccess:Boolean = recast.loadMesh( geometry.filename );
			
			//4. set the mesh settings
			recast.meshSettings(m_cellSize, 
								m_cellHeight, 
								m_agentHeight, 
								m_agentRadius, 
								m_agentMaxClimb, 
								m_agentMaxSlope, 
								m_regionMinSize, 
								m_regionMergeSize, 
								m_edgeMaxLen, 
								m_edgeMaxError, 
								m_vertsPerPoly, 
								m_detailSampleDist, 
								m_detailSampleMaxError,
								m_tileSize,
								m_maxObstacles,
								false);
			
			//5. build the mesh
			var startTime:Number = new Date().valueOf();
			var meshBuildSuccess:Boolean = recast.buildMesh( );
			trace("build time", new Date().valueOf() - startTime, "ms");
			trace( "m_maxObstacles " + m_maxObstacles );
			
			//6. init the crowd
			var crowdInitSuccess:Boolean = recast.initCrowd(maxAgents, m_agentRadius);
			
			ready = true;
			owner.eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			//Profiler.exit("initRecast");
			*/
			
			CModule.startAsync(this);
			
			//load the mesh file into recast
			CModule.vfs.addFile(geometry.filename, geometry.data ); //formly CLibInit.supplyFile from Alchemy
			
			var as3LogContext:AS3_rcContext = AS3_rcContext.create();
			_sample = Sample_TempObstacles.create();
			geom = InputGeom.create();
			
			var loadResult:Boolean = geom.loadMesh(as3LogContext.swigCPtr, geometry.filename);
			
			//update mesh settings
			sample.m_cellSize = m_cellSize;
			sample.m_cellHeight = m_cellHeight;
			sample.m_agentHeight = m_agentHeight;
			sample.m_agentRadius = m_agentRadius;
			sample.m_agentMaxClimb = m_agentMaxClimb;
			sample.m_agentMaxSlope = m_agentMaxSlope;
			sample.m_regionMinSize = m_regionMinSize;
			sample.m_regionMergeSize = m_regionMergeSize;
			sample.m_edgeMaxLen = m_edgeMaxLen;
			sample.m_edgeMaxError = m_edgeMaxError;
			sample.m_vertsPerPoly = m_vertsPerPoly;
			sample.m_detailSampleDist = m_detailSampleDist;
			sample.m_detailSampleMaxError = m_detailSampleMaxError;
			sample.m_tileSize = m_tileSize;
			sample.m_maxObstacles = m_maxObstacles;
			
			//build mesh
			sample.setContext(as3LogContext.swigCPtr);
			sample.handleMeshChanged(geom.swigCPtr);
			sample.handleSettings();
			
			var startTime:Number = new Date().valueOf();
			var buildSuccess:Boolean = sample.handleBuild();
			trace("build time", new Date().valueOf() - startTime, "ms");
			
			crowd = new dtCrowd();
			crowd.swigCPtr = sample.getCrowd();
			crowd.init(maxAgents, m_agentRadius, sample.getNavMesh() );
			
			//var debug:dtCrowdAgentDebugInfo = dtCrowdAgentDebugInfo.create();
			//crowdDebugPtr = debug.swigCPtr;
			
			ready = true;
			owner.eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		override public function onTick(deltaTime:Number):void 
		{
			super.onTick(deltaTime);
			//Profiler.enter("recastOnTick");
			//update the crowd
			//if(recast != null)
			//	recast.update(deltaTime);
			//Profiler.exit("recastOnTick");
			
			try{
				if( crowd )
					crowd.update(deltaTime, crowdDebugPtr);
				if ( _sample && _dirtyTiles)	
					_sample.handleUpdate(deltaTime);
			}
			catch (error:Error) {
				trace("RecastManager::onTick", error.message);
			}
		}
		
		
		public function localToWorld(localPosition:Point):Point
		{
			var wp:Point = localPosition.clone()
			wp.x *= this.scale;
			wp.y *= this.scale;
            return wp;
		}
		
		public function worldToLocal(worldPosition:Point):Point
		{
			var lp:Point = worldPosition.clone()
			lp.x /= this.scale;
			lp.y /= this.scale;
            return lp;
		}
		
		public function get inputGeomerty():InputGeom
		{
			return geom;
		}
		
		public function get sample():Sample_TempObstacles
		{
			return _sample;
		}
		
			//recast variables
		private var _sample:Sample_TempObstacles;
		private var geom:InputGeom;
		private var crowd:dtCrowd;
		private var crowdDebugPtr:int;
		private var _dirtyTiles:Boolean = false;
		
	}

}