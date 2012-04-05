package
{
   
   import com.pblabs.engine.PBE;
   import com.pblabs.box2D.*;
   import com.pblabs.rendering2D.SimpleShapeRenderer;
   import com.pblabs.rendering2D.spritesheet.CellCountDivider;
   import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
   import com.pblabs.rendering2D.ui.SceneView;
   import com.pblabs.stupidSampleGame.DudeController;
   import com.starling.animation.FrameAnimator;
   import com.starling.rendering2D.*;
   import com.starling.animation.AnimatorComponent;
   import starling.core.Starling;
    
    import flash.display.Sprite;
	import flash.events.Event;
    import flash.utils.*;
    
    [SWF(width="1280", height="720", frameRate="60")]
    public class PBStarlingDemo extends Sprite implements IStarlingApplication
    {        
		
		private var _starling:Starling;
		
			
        public function PBStarlingDemo()
        {            
            
			if ( stage )
				init();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			
        }
		
		private function init(e:Event=null):void
		{
			
			
			// Make sure all the types our XML will use are registered.
			
			//Box2D
			PBE.registerType(Box2DDebugComponent);
            PBE.registerType(Box2DManagerComponent);
            PBE.registerType(Box2DSpatialComponent);
            PBE.registerType(PolygonCollisionShape);
            PBE.registerType(CircleCollisionShape);
			
			//PBE
			PBE.registerType(SpriteSheetComponent);
			 PBE.registerType(CellCountDivider);
			 
			 PBE.registerType(SimpleShapeRenderer); //for b2d debug drawing
			
			//Game classes
            PBE.registerType(DudeController);
            
			//Starling
			 PBE.registerType(StarlingScene);
			 PBE.registerType(ImageRenderer);
			 PBE.registerType(TextureComponent);
			 PBE.registerType(SpriteSheetRenderer );
			 PBE.registerType(MovieClipRenderer );
			 PBE.registerType(AnimatorComponent);
			 PBE.registerType(FrameAnimator);
			
			 
			 
			
			_starling = new Starling(StarlingPBEGame, stage );
			_starling.start();
			
			// Initialize the engine!
            PBE.startup(this);
			
			// Load resources.
            PBE.addResources(new Resources());
			
			var sv:SceneView = new SceneView();
			sv.name = "MainView";
			sv.x = -640;
			sv.y = -360;
			addChild( sv);
			
		}
		
		/**
		 * Return the core Starling
		 */
		public function get starling():Starling
		{
			return _starling;
		}
    }
}
