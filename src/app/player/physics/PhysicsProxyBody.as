
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Common.Math.b2Vec2;
   
   public class PhysicsProxyBody extends PhysicsProxy
   {
      
      public var _b2Body:b2Body = null; // used internally
      
      public function PhysicsProxyBody (phyEngine:PhysicsEngine, physicsX:Number = 0, physicsY:Number = 0, rotation:Number = 0, static:Boolean = true, params:Object = null):void
      {
         super (phyEngine);
         
         var bodyDef:b2BodyDef = new b2BodyDef ();
         bodyDef.position.Set (physicsX, physicsY);
         bodyDef.angle = rotation;
         if (! static) bodyDef.massData.mass = 1; // temp value, it will be modified
         _b2Body = mPhysicsEngine._b2World.CreateBody (bodyDef);
         
         _b2Body.SetUserData (this);
      }
      
      
      override public function Destroy ():void
      {
         if (_b2Body != null)
            mPhysicsEngine._b2World.DestroyBody (_b2Body);
      }
      
      public function NotifyDestroyed ():void
      {
         _b2Body = null;
      }
      
      public function UpdateMass ():void
      {
         if (_b2Body != null)
            _b2Body.SetMassFromShapes();
      }
      
      public function GetPosition ():Point
      {
         var point:Point = new Point ();
         
         if (_b2Body != null)
         {
            var vec2:b2Vec2 = _b2Body.GetPosition ();
            point.x = vec2.x;
            point.y = vec2.y;
         }
         else
         {
            point.x = 0;
            point.y = 0;
         }
         
         return point;
      }
      
      public function GetRotation ():Number
      {
         if (_b2Body != null)
            return _b2Body.GetAngle ();
         else
            return 0;
      }
      
      public function IsStatic ():Boolean
      {
         if (_b2Body != null)
            return _b2Body.m_mass == 0;
         else
            return true;
      }
      
      public function SetBullet (bullet:Boolean):void
      {
         if (_b2Body != null)
         {
            _b2Body.SetBullet (bullet);
         }
      }
      
      public function SetLinearVelocity (vel:Point):void
      {
         if (_b2Body != null)
         {
            var vec2:b2Vec2 = new b2Vec2 (vel.x, vel.y);
            _b2Body.SetLinearVelocity (vec2);
         }
      }
      
      public function ApplyBodyForce (force:Point):void
      {
         if (_b2Body != null)
         {
            //_b2Body.ApplyForce ( , GetWorldCenter ());
         }
      }
      
      public function ApplyPointForce (force:Point, point:Point):void
      {
      }
      
//=================================================================
//    
//=================================================================
      
      
      
   }
   
}
