package common.shape
{
   import flash.geom.Point;

   import com.tapirgames.util.GraphicsUtil;

   public class VectorShapePolyline extends VectorShapePath
   {
      public function VectorShapePolyline ()
      {
         SetBodyColor (0x000000);
      }

      protected var mLocalVertexPoints:Array = new Array (); // should not be null, at lesst 2 points

      public function GetLocalVertexPoints ():Array
      {
         //return mLocalVertexPoints;
         return GraphicsUtil.DeepClonePointArray (mLocalVertexPoints);
      }

      public function SetLocalVertexPoints (points:Array):void
      {
         //mLocalVertexPoints = points;
         mLocalVertexPoints = GraphicsUtil.DeepClonePointArray (points);
      }

//==============================================
// for playing
//==============================================

      protected var mLocalVertexPointsInPhysics:Array = new Array (); // should not be null, at lesst 3 points

      public function GetLocalVertexPointsInPhysics ():Array
      {
         //return mLocalVertexPoints;
         return GraphicsUtil.DeepClonePointArray (mLocalVertexPointsInPhysics);
      }

      public function SetLocalVertexPointsInPhysics (points:Array):void
      {
         //mLocalVertexPoints = points;
         mLocalVertexPointsInPhysics = GraphicsUtil.DeepClonePointArray (points);
      }
   }
}
