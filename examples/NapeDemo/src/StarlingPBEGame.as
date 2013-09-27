package  
{
	import starling.events.Event;
	import starling.display.Sprite;
	
	  import com.pblabs.animation.AnimatorComponent;
    import com.pblabs.box2D.Box2DDebugComponent;
    import com.pblabs.box2D.Box2DManagerComponent;
    import com.pblabs.box2D.Box2DSpatialComponent;
    import com.pblabs.box2D.CircleCollisionShape;
    import com.pblabs.box2D.PolygonCollisionShape;
    import com.pblabs.engine.PBE;
    import com.pblabs.engine.core.LevelManager;
    import com.pblabs.engine.resource.Resource;
    import com.pblabs.rendering2D.BasicSpatialManager2D;
    import com.pblabs.rendering2D.DisplayObjectScene;
    import com.pblabs.rendering2D.SimpleSpatialComponent;
    import com.pblabs.rendering2D.SpriteSheetRenderer;
    import com.pblabs.rendering2D.spritesheet.CellCountDivider;
    import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
    import com.pblabs.rendering2D.ui.SceneView;
    import com.pblabs.stupidSampleGame.DudeController;
	
	
	public class StarlingPBEGame extends Sprite 
	{
		
		public function StarlingPBEGame() 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void
		{
			
            // Load the descriptions, and start up level 1.
          //  LevelManager.instance.load("../assets/levelDescriptions.xml", 1);
		}
	}

}