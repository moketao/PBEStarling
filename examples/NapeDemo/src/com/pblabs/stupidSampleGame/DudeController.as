/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.stupidSampleGame
{
	import com.nape.NapeBodyComponent;
    import com.pblabs.box2D.CollisionEvent;
    import com.pblabs.engine.PBE;
    import com.pblabs.engine.components.TickedComponent;
    import com.pblabs.engine.core.InputMap;
    import com.pblabs.engine.entity.EntityComponent;
    import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.animation.AnimatorComponent;
	import com.starling.rendering2D.DisplayObjectRenderer;
	import com.starling.rendering2D.StarlingScene;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.CollisionArbiter;
	import nape.phys.Body;
    
    import flash.geom.Point;
    
    /**
     * Component responsible for translating keyboard input to forces on the
     * player entity.
     */
    public class DudeController extends TickedComponent
    {
        [TypeHint(type="flash.geom.Point")]
        public var velocityReference:PropertyReference;
		
		public var animatorReference:AnimatorComponent;
		public var renderReference:DisplayObjectRenderer;
		 
		public var bodyComponent:NapeBodyComponent;
        
        public function get input():InputMap
        {
            return _inputMap;
        }
        
        public function set input(value:InputMap):void
        {
            _inputMap = value;
            
            if (_inputMap != null)
            {
                _inputMap.mapActionToHandler("GoLeft", _OnLeft);
                _inputMap.mapActionToHandler("GoRight", _OnRight);
                _inputMap.mapActionToHandler("Jump", _OnJump);
                _inputMap.mapActionToHandler("ZoomIn", _OnZoomIn);
                _inputMap.mapActionToHandler("ZoomOut", _OnZoomOut);
				
            }
        }
        
        public override function onTick(tickRate:Number):void
        {
            var move:Number = _right - _left;
            var velocity:Point = owner.getProperty(velocityReference);
            velocity.x = move * 300;
            
            if (_jump > 0)
            {
                PBE.soundManager.play("../Assets/Sounds/testSound.mp3");
                
                velocity.y -= 350;
                _jump = 0;
            }
					
            
            owner.setProperty(velocityReference, velocity);
        }
        
        protected override function onAdd():void
        {
            super.onAdd();

			if ( bodyComponent )
			{
				//TODO - pass platform cbTypes as the option2
				bodyComponent.body.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, bodyComponent.body.cbTypes, CbType.ANY_BODY, onCollisionBegin ));
				bodyComponent.body.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, bodyComponent.body.cbTypes, CbType.ANY_BODY, onCollisionEnd ));
			}
            //owner.eventDispatcher.addEventListener(CollisionEvent.COLLISION_EVENT, _OnCollision);
            //owner.eventDispatcher.addEventListener(CollisionEvent.PRE_COLLISION_EVENT, _OnPreCollision);
            //owner.eventDispatcher.addEventListener(CollisionEvent.COLLISION_STOPPED_EVENT, _OnCollisionEnd);
        }
        
        protected override function onRemove():void
        {
            super.onRemove();
            
            //owner.eventDispatcher.removeEventListener(CollisionEvent.COLLISION_EVENT, _OnCollision);
            //owner.eventDispatcher.removeEventListener(CollisionEvent.PRE_COLLISION_EVENT, _OnPreCollision);
            //owner.eventDispatcher.removeEventListener(CollisionEvent.COLLISION_STOPPED_EVENT, _OnCollisionEnd);
			
        }
		
		private function onCollisionBegin(cb:InteractionCallback):void
		{
			trace("onCollisionBegin");
			var thisBody:Body = cb.int1.castBody; //know it is the first because the cbtypes was passed as option1
			var otherBody:Body = cb.int2.castBody;
			
			trace(cb.arbiters);
			var colArb:CollisionArbiter = cb.arbiters.at(0) as CollisionArbiter; //probably want to loop and find the collisionarbiter
			if ( colArb.normal.y > 0.7 )
				_onGround++;
			
			
			//var colArb:CollisionArbiter = cb.arbite
		}
		private function onCollisionEnd(cb:InteractionCallback):void
		{
			//TODO - check to make sure it ended with a platform, or only listen for when it ends a platform
			_onGround--;
		}
		
		private function _OnPreCollision(event:CollisionEvent):void
        {
			
            if (PBE.objectTypeManager.doesTypeOverlap(event.collidee.collisionType, "Platform"))
            {
                if (event.normal.y < -0.5)
					event.contact.SetEnabled(false);
            }
            
            if (PBE.objectTypeManager.doesTypeOverlap(event.collider.collisionType, "Platform"))
            {
                if (event.normal.y > 0.5)
					event.contact.SetEnabled(false);
            }
        }
		
        
        private function _OnCollision(event:CollisionEvent):void
        {
            if (PBE.objectTypeManager.doesTypeOverlap(event.collidee.collisionType, "Platform"))
            {
                if (event.normal.y > 0.7)
                    _onGround++;
            }
            
            if (PBE.objectTypeManager.doesTypeOverlap(event.collider.collisionType, "Platform"))
            {
                if (event.normal.y < -0.7)
                    _onGround++;
            }
			
        }
        
        private function _OnCollisionEnd(event:CollisionEvent):void
        {
            if (PBE.objectTypeManager.doesTypeOverlap(event.collidee.collisionType, "Platform"))
            {
                if (event.normal.y > 0.7)
                    _onGround--;
            }
            
            if (PBE.objectTypeManager.doesTypeOverlap(event.collider.collisionType, "Platform"))
            {
                if (event.normal.y < -0.7)
                    _onGround--;
            }
			if ( _onGround < 0 )
				_onGround = 0;
        }
        
        private function _OnLeft(value:Number):void
        {
            _left = value;
			
			if ( _left > 0 )
			{
				animatorReference.play( "run" ); 
				
				//flip the renderer
				if ( renderReference != null && renderReference.scale.x > 0)
				{
					renderReference.scale = new Point(renderReference.scale.x * -1, renderReference.scale.y);
				}
			}
			else if ( _right == 0)
				animatorReference.play( "idle" ); 
			
        }
        
        private function _OnRight(value:Number):void
        {
            _right = value;
			
			if ( _right > 0 )
			{
				animatorReference.play( "run" ); 
				
				//flip the renderer
				if ( renderReference != null &&  renderReference.scale.x < 0)
				{
					renderReference.scale = new Point(renderReference.scale.x * -1, renderReference.scale.y);
				}
			}
			else if ( _left == 0)
				animatorReference.play( "idle" ); 
        }
        
        private function _OnZoomOut(value:Number):void
		{
			if( value > 0 )
				(PBE.lookupComponentByName("Scene", "Scene") as StarlingScene).zoom += 0.5;
		}
        private function _OnZoomIn(value:Number):void
		{
			if( value > 0 )
				(PBE.lookupComponentByName("Scene", "Scene") as StarlingScene).zoom -= 0.5;
		}
		
        private function _OnJump(value:Number):void
        {
            if (_onGround > 0)
                _jump = value;
        }

        private var _inputMap:InputMap;
        private var _left:Number = 0;
        private var _right:Number = 0;
        private var _jump:Number = 0;
        private var _onGround:int = 0;
    }
}