
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Dynamics.*;
   //import Box2D.Common.*;
   import Box2D.Common.*;
   
   
   public class _DestructionListener implements b2DestructionListener
   {
   
      private var mPhysicsEngine:PhysicsEngine;
      
      public function _DestructionListener (phyEngine:PhysicsEngine)
      {
         mPhysicsEngine = phyEngine;
      }
      
//=====================================================================
// v2.10
//=====================================================================

		/// Called when any joint is about to be destroyed due
		/// to the destruction of one of its attached bodies.
		public function SayGoodbye_Joint (joint:b2Joint):void 
		{
         var userdata:Object = joint.GetUserData ();
         
         if (mPhysicsEngine._OnJointRemoved != null)
            mPhysicsEngine._OnJointRemoved (userdata as PhysicsProxyJoint);
		}

		/// Called when any fixture is about to be destroyed due
		/// to the destruction of its parent body.
		public function SayGoodbye_Fixture (fixture:b2Fixture):void 
		{
         var userdata:Object = fixture.GetUserData ();
         
         if (mPhysicsEngine._OnShapeRemoved != null)
            mPhysicsEngine._OnShapeRemoved (userdata as PhysicsProxyShape);
		}
   }
 }

