package
{
   
   import com.nape.CircleShape;
   import com.nape.CollisionShape;
   import com.nape.NapeBodyComponent;
   import com.nape.NapeDebugDraw;
   import com.nape.NapeSpaceComponent;
   import com.nape.RectangleShape;
   import com.pblabs.engine.core.LevelManager;
   import com.pblabs.engine.PBE;
   import com.pblabs.rendering2D.SimpleShapeRenderer;
   import com.pblabs.rendering2D.spritesheet.CellCountDivider;
   import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
   import com.pblabs.rendering2D.ui.SceneView;
   import com.pblabs.stupidSampleGame.DudeController;
   import com.pblabs.animation.FrameAnimator;
   import com.starling.rendering2D.*;
   import com.pblabs.animation.AnimatorComponent;
   import starling.core.Starling;
    
    import flash.display.Sprite;
	import flash.events.Event;
    import flash.utils.*;
    
    [SWF(width="1280", height="720", frameRate="60")]
    public class NapeDemo extends Sprite
    {        
		
		private var _starling:Starling;
		
			
        public function NapeDemo()
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
			//PBE.registerType(Box2DDebugComponent);
           // PBE.registerType(Box2DManagerComponent);
            //PBE.registerType(Box2DSpatialComponent);
            //PBE.registerType(PolygonCollisionShape);
            //PBE.registerType(CircleCollisionShape);
			
			//Nape
			PBE.registerType(NapeDebugDraw);
			PBE.registerType(NapeSpaceComponent);
			PBE.registerType(NapeBodyComponent);
			PBE.registerType(CollisionShape);
			PBE.registerType(CircleShape);
			PBE.registerType(RectangleShape);
			//PBE.registerType(Polygon);
			
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
			 PBE.registerType(AnimatorComponent);
			 PBE.registerType(FrameAnimator);
			 PBE.registerType(SWFTextureAtlasComponent);
			
			 
			 
			
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
			
			LevelManager.instance.load("../assets/levelDescriptions.xml", 1);
			
		}
		
    }
}
