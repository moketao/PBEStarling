/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.box2D
{
   import Box2D.Dynamics.b2ContactFilter;
   import Box2D.Dynamics.b2Fixture;

   public class ContactFilter extends b2ContactFilter
   {
      override public function ShouldCollide(shape1:b2Fixture, shape2:b2Fixture):Boolean
      {
         if (!super.ShouldCollide(shape1, shape2))
            return false;
         
         return true;
      }
   }
}