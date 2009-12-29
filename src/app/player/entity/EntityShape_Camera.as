
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_Camera extends EntityShape
   {
      public function EntityShape_Camera (world:World)
      {
         super (world);
         
         mAiTypeChangeable = false;
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mFollowedTarget != undefined)
               SetFollowedTarget (entityDefine.mFollowedTarget);
            if (entityDefine.mFollowingStyle != undefined)
               SetFollowingStyle (entityDefine.mFollowingStyle);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mFollowedTarget:int = Define.Camera_FollowedTarget_Brothers; //Camera_FollowedTarget_Self;
      protected var mFollowingStyle:int = Define.Camera_FollowingStyle_Default;
      
      public function SetFollowedTarget (target:int):void
      {
         mFollowedTarget = target;
      }
      
      public function SetFollowingStyle (style:int):void
      {
         mFollowingStyle = style;
      }
      
//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         var targetEntity:Entity = null;
         
         if (mFollowedTarget == Define.Camera_FollowedTarget_Self)
            targetEntity = this;
         else if (mFollowedTarget == Define.Camera_FollowedTarget_Brothers)
            targetEntity = mBody;
         
         if (targetEntity != null)
         {
            if (mFollowingStyle & Define.Camera_FollowingStyle_X == Define.Camera_FollowingStyle_X)
               mWorld.FollowCameraCenterXWithEntity (targetEntity, false);
            if (mFollowingStyle & Define.Camera_FollowingStyle_Y == Define.Camera_FollowingStyle_Y)
               mWorld.FollowCameraCenterYWithEntity (targetEntity, false);
            if (mFollowingStyle & Define.Camera_FollowingStyle_Angle == Define.Camera_FollowingStyle_Angle)
               mWorld.FollowCameraAngleWithEntity (targetEntity, false);
         }
      }
      
   }
   
}
