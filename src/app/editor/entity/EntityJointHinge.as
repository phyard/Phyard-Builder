
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Config;
   
   public class EntityJointHinge extends EntityJoint 
   {
      
      public var mAnchor:SubEntityHingeAnchor;
      
      protected var mEnableLimits:Boolean = false;
      protected var mLowerAngle:Number = 0;
      protected var mUpperAngle:Number = 0;
      public var mEnableMotor:Boolean = false;
      public var mMotorSpeed:Number = 0;
      public var mBackAndForth:Boolean = false;
      
      public var mMaxMotorTorque:Number = Define.DefaultHingeMotorTorque; // v1.04
      
      public function EntityJointHinge (world:World)
      {
         super (world);
         
         mAnchor = new SubEntityHingeAnchor (world, this);
         world.addChild (mAnchor);
      }
      
      public function IsLimitsEnabled ():Boolean
      {
         return mEnableLimits;
      }
      
      public function SetLimitsEnabled (enabled:Boolean):void
      {
         mEnableLimits = enabled;
      }
      
      public function SetLimits (lower:Number, upper:Number):void
      {
         mLowerAngle = ValueAdjuster.AdjustSliderTranslation (lower, Config.VersionNumber);
         mUpperAngle = ValueAdjuster.AdjustSliderTranslation (upper, Config.VersionNumber);
         
         UpdateAppearance ();
      }
      
      public function GetLowerLimit ():Number
      {
         return mLowerAngle;
      }
      public function GetUpperLimit ():Number
      {
         return mUpperAngle;
      }
      
      
      override public function Destroy ():void
      {
         mWorld.DestroyEntity (mAnchor);
         
         super.Destroy ();
      }
      
      public function GetAnchor ():SubEntityHingeAnchor
      {
         return mAnchor;
      }
      
      
//====================================================================
//   flip
//====================================================================
      
      override public function FlipHorizontally (mirrorX:Number):void
      {
         FlipOtherParams ();
         
         super.FlipHorizontally (mirrorX);
      }
      
      override public function FlipVertically (mirrorY:Number):void
      {
         FlipOtherParams ();
         
         super.FlipVertically (mirrorY);
      }
      
      private function FlipOtherParams ():void
      {
         SetLimits (- mUpperAngle, - mLowerAngle);
         
         mMotorSpeed = - mMotorSpeed;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointHinge (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var hinge:EntityJointHinge = entity as EntityJointHinge;
         
         hinge.SetLimitsEnabled ( IsLimitsEnabled () );
         hinge.SetLimits (GetLowerLimit (), GetUpperLimit ());
         hinge.mEnableMotor = mEnableMotor;
         hinge.mMotorSpeed = mMotorSpeed;
         hinge.mBackAndForth = mBackAndForth;
         hinge.mMaxMotorTorque = mMaxMotorTorque;
         
         var anchor:SubEntityHingeAnchor = GetAnchor ();
         var newAnchor:SubEntityHingeAnchor = hinge.GetAnchor ();
         
         anchor.SetPropertiesForClonedEntity (newAnchor, displayOffsetX, displayOffsetY);
         
         newAnchor.UpdateAppearance ();
         newAnchor.UpdateSelectionProxy ();
      }
      
      override public function GetSubEntities ():Array
      {
         return [mAnchor];
      }
      
      
   }
}
