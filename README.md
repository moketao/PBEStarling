PushButtonEngine + Starling Framework = PBEStarling
===

[PBEStarling](http://github.com/zodouglass/PBEStarling) is a set of wrapper components based on the PBE rendering2D, using Starling to render to Stage3D for hardware acceleration.

[PushButton Engine](https://github.com/PushButtonLabs/PushButtonEngine) is a framework for Flash game development. Build your game 
with reusable gameplay, physics, rendering, and networking components.

[Starling](http://gamua.com/starling/) is a pure ActionScript 3 library that mimics the conventional Flash display list architecture. 
In contrast to conventional display objects, however, all content is rendered directly by the GPU — providing a rendering performance unlike anything before. 
This is made possible by Flash's "Stage3D" technology.

------------
TODO
------------
###StarlingScene###
*   add zoom, minZoom, maxZoom
*   add clipping rectangle (look into - Starling.context.setScissorRectangle )
*   transform to/from world to screen coordinates
*   possibily rename it to DisplayObjectScene to be consistent with pblabs rendering2D
	
###DisplayObjectRenderer ###
*   add zIndex
*   add tint/brightness/contrast/hue properties
*   add blurX/blurY
	
###InputKey ###
*   add support for starling Touch events
	
###Animator###
*   fix PING_PONG_ANIMATION
	
###SimpleShapeRenderer###
*   add SimpleShapeRenderer componenet
	



