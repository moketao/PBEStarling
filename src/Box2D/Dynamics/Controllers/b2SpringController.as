/*
* Copyright (c) 2006-2007 Adam Newgas
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package Box2D.Dynamics.Controllers{

import Box2D.Common.Math.*;
import Box2D.Common.*;
import Box2D.Dynamics.Controllers.b2Controller;
import Box2D.Dynamics.*;


/// Applies Hooke forces between a pair of bodies
public class b2SpringController extends b2Controller
{	
	/// Spring constant
	public var k:Number = 1;
	/// Damping constant
	public var damping:Number = 0;
	/// Natural length of spring
	public var length:Number = 0;
	
	public var m_body1:b2Body;
	public var m_body2:b2Body;
		
	private var m_anchor1:b2Vec2 = new b2Vec2();
	private var m_anchor2:b2Vec2 = new b2Vec2();
	
	/// Get the anchor point on body1 in world coordinates.
	public function GetAnchor1():b2Vec2{
		return m_body1.GetWorldPoint(m_anchor1);
	}
	/// Get the anchor point on body1 in world coordinates.
	public function SetAnchor1(v:b2Vec2):void{
		m_anchor1.SetV(m_body1.GetLocalPoint(v));
	}
	/// Get the anchor point on body2 in world coordinates.
	public function GetAnchor2():b2Vec2{
		return m_body2.GetWorldPoint(m_anchor2);
	}
	/// Set the anchor point on body1 in world coordinates.
	public function SetAnchor2(v:b2Vec2):void{
		m_anchor2.SetV(m_body2.GetLocalPoint(v));
	}
	
	override public function Step(step:b2TimeStep):void{
		//Skip if asleep
		if(!m_body1.IsAwake() && !m_body2.IsAwake())
			return;
		
		var world1:b2Vec2 = m_body1.GetWorldPoint(m_anchor1);
		var world2:b2Vec2 = m_body2.GetWorldPoint(m_anchor2);
		
		var d:b2Vec2 = b2Math.SubtractVV(world2,world1);
		var dlen:Number = d.Normalize();
		
		//Spring force
		var springForce:b2Vec2 = d.Copy();
		springForce.Multiply( (dlen - length) * k );
		m_body1.ApplyForce(springForce, world1);
		m_body2.ApplyForce(springForce.GetNegative(), world2);
		
		//Damping
		if(damping!=0){
			var v1:b2Vec2 = m_body1.GetLinearVelocityFromWorldPoint(world1);
			var v2:b2Vec2 = m_body2.GetLinearVelocityFromWorldPoint(world2);
			var v:b2Vec2 = b2Math.SubtractVV(v2,v1);
			var dampingForce:b2Vec2 = d.Copy();
			dampingForce.Multiply(b2Math.Dot(v,d) * damping);
			m_body1.ApplyForce(dampingForce, world1);
			m_body2.ApplyForce(dampingForce.GetNegative(), world2);
		}
		
	}
	
	/// Draws a spring in a typical zig-zagging fashion
	public override function Draw(debugDraw:b2DebugDraw):void
	{
		//Number of bends the spring makes
		var kinks:Number = 10;
		//Stub at either end that is unkinked
		var stub:Number = 0.05;
		//Kink width, as fraction of length
		var kinkWidth:Number = 0.05;
		//Set kink width s.t. kinks are at right angles at natural length
		kinkWidth = (1-2*stub)/kinks/2;
		//Color of spring
		var color:b2Color = new b2Color(0xB8/255,0x86/255,0x0B/255);
		
		var world1:b2Vec2 = m_body1.GetWorldPoint(m_anchor1);
		var world2:b2Vec2 = m_body2.GetWorldPoint(m_anchor2);
		
		var d:b2Vec2 = b2Math.SubtractVV(world2,world1);
		var dlen:Number = d.Normalize();
		var nX:Number=d.y*kinkWidth*length;
		var nY:Number=-d.x*kinkWidth*length;
		var p2:b2Vec2 = new b2Vec2(world1.x*(1-stub)+world2.x*stub,world1.y*(1-stub)+world2.y*stub);
		debugDraw.DrawSegment(world1,p2,color);
		var prevp:b2Vec2=p2;
		for(var i:int=0;i<=kinks;i++){
			var alt:Number = i%2==0?-1:1;
			var pi:b2Vec2 = new b2Vec2(
							world1.x+d.x*dlen*(stub+(1-2*stub)*i/kinks)+nX*alt,
							world1.y+d.y*dlen*(stub+(1-2*stub)*i/kinks)+nY*alt
						);
			debugDraw.DrawSegment(prevp,pi,color);
			prevp=pi;
		}
		pi = new b2Vec2(world2.x*(1-stub)+world1.x*stub,world2.y*(1-stub)+world1.y*stub);
		debugDraw.DrawSegment(prevp,pi,color);
		debugDraw.DrawSegment(pi,world2,color);
		
		
	}
}

}
