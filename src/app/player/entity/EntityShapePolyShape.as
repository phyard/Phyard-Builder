package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapePolyShape extends EntityShape
   {
      public function EntityShapePolyShape (world:World)
      {
         super (world);
      }

//=============================================================
//   
//=============================================================

      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         // vertexes
         var numVertexes:int = mLocalDisplayPoints.length;
         var localDeisplayPoints:Array = new Array (numVertexes);
         for (var vId:int = 0; vId < numVertexes; ++ vId)
         {
            var point:Point = mLocalDisplayPoints [vId] as Point;
            localDeisplayPoints [vId] = new Point (point.x, point.y);
         }
         entityDefine.mLocalPoints = localDeisplayPoints;
         
         return null;
      }
      
//=============================================================
//   data
//=============================================================

      protected var mLocalPoints:Array = null;
      protected var mLocalDisplayPoints:Array = null;

      public function GetVertexPointsCount ():int
      {
         if (mLocalPoints == null)
            return 0;
         else
            return mLocalPoints.length;
      }
      
      public function GetLocalVertex (index:int):Point
      {
         if (index < 0 || index >= GetVertexPointsCount ())
            return null;
         
         var localPoint:Point = mLocalPoints [index] as Point;
         return new Point (localPoint.x, localPoint.y);
      }
      
      public function ModifyLocalVertex (vertexIndex:int, localPhysicsX:Number, localPhysicsY:Number, isInsert:Boolean):void
      {
         if (vertexIndex < 0)
            return;
         
         if (isInsert)
         {
            if (mLocalPoints == null) // so mLocalDisplayPoints is also null
            {
               if (vertexIndex > 0)
                  return;
               
               mLocalPoints = new Array ();
               mLocalDisplayPoints = new Array ();
            }
            else if (vertexIndex > GetVertexPointsCount ())
            {
               return;
            }
            
            mLocalPoints.push (new Point (localPhysicsX, localPhysicsY));
            mLocalDisplayPoints.push (new Point (mWorld.GetCoordinateSystem ().P2D_LinearDeltaX (localPhysicsX),
                                                 mWorld.GetCoordinateSystem ().P2D_LinearDeltaY (localPhysicsY)));
         }
         else
         {
            if (vertexIndex >= GetVertexPointsCount ())
               return;
            
            var physicsPoint:Point = mLocalPoints [vertexIndex];
            physicsPoint.x = localPhysicsX;
            physicsPoint.y = localPhysicsY;
            
            var displayPoint:Point = mLocalDisplayPoints [vertexIndex];
            displayPoint.x =  mWorld.GetCoordinateSystem ().P2D_LinearDeltaX (localPhysicsX);
            displayPoint.y =  mWorld.GetCoordinateSystem ().P2D_LinearDeltaY (localPhysicsY);
         }
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance ();
      }
      
      public function DeleteVertex (vertexIndex:int):void
      {
         if (vertexIndex < 0 || vertexIndex >= GetVertexPointsCount ())
            return;
         
         mLocalPoints.splice (vertexIndex, 1);
         mLocalDisplayPoints.splice (vertexIndex, 1);
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance ();
      }
      
      public function SetLocalDisplayVertexPoints (points:Array):void
      {
         var i:int;
         var inputDisplayPoint:Point;
         var displayPoint:Point;
         var physicsPoint:Point;
         if (mLocalPoints == null || mLocalPoints.length != points.length)
         {
            mLocalPoints = new Array (points.length);
            mLocalDisplayPoints = new Array (points.length);
            for (i = 0; i < mLocalPoints.length; ++ i)
            {
               mLocalPoints        [i] = new Point ();
               mLocalDisplayPoints [i] = new Point ();
            }
         }
         
         for (i = 0; i < mLocalPoints.length; ++ i)
         {
            inputDisplayPoint = points [i];

            displayPoint = mLocalDisplayPoints [i];
            displayPoint.x = inputDisplayPoint.x;
            displayPoint.y = inputDisplayPoint.y;

            physicsPoint = mLocalPoints [i];
            physicsPoint.x =  mWorld.GetCoordinateSystem ().D2P_LinearDeltaX (inputDisplayPoint.x);
            physicsPoint.y =  mWorld.GetCoordinateSystem ().D2P_LinearDeltaY (inputDisplayPoint.y);
         }
      }
   }
}
