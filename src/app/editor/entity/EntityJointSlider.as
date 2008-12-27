
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class EntityJointSlider extends EntityJoint 
   {
      
      public var mAnchor1:SubEntitySliderAnchor;
      public var mAnchor2:SubEntitySliderAnchor;
      
      protected var mEnableLimits:Boolean = true;
      protected var mLowerTranslation:Number = -20;
      protected var mUpperTranslation:Number = 20;
      public var mEnableMotor:Boolean = true;
      public var mMotorSpeed:Number = 30;
      public var mBackAndForth:Boolean = true;
      
      
      
      private var mRangeBarHalfHeight:Number = 3;
      
      public function EntityJointSlider (world:World)
      {
         super (world);
         
         mAnchor1 = new SubEntitySliderAnchor (world, this, false);
         world.addChild (mAnchor1);
         mAnchor2 = new SubEntitySliderAnchor (world, this, true);
         world.addChild (mAnchor2);
      }
      
      public function IsLimitsEnabled ():Boolean
      {
         return mEnableLimits;
      }
      
      public function SetLimitsEnabled (enabled:Boolean):void
      {
         mEnableLimits = enabled;
         
         UpdateAppearance ();
      }
      
      public function SetLimits (lower:Number, upper:Number):void
      {
         mLowerTranslation = lower;
         mUpperTranslation = upper;
         
         UpdateAppearance ();
      }
      
      public function GetLowerLimit ():Number
      {
         return mLowerTranslation;
      }
      public function GetUpperLimit ():Number
      {
         return mUpperTranslation;
      }
      
      override public function Destroy ():void
      {
         SetVertexControllersVisible (false);
         
         mWorld.DestroyEntity (mAnchor1);
         mWorld.DestroyEntity (mAnchor2);
         
         super.Destroy ();
      }
      
      override public function UpdateAppearance ():void
      {
         alpha = 0.7;
         
         var x1:Number = mAnchor1.x;
         var y1:Number = mAnchor1.y;
         var x2:Number = mAnchor2.x;
         var y2:Number = mAnchor2.y;
         
         var dx:Number = x2 - x1;
         var dy:Number = y2 - y1;
         var distance:Number = Math.sqrt (dx * dx + dy * dy);
         
         SetRotation (Math.atan2 (dy, dx));
         SetPosition (x1, y1);
         
         //GraphicsUtil.ClearAndDrawLine (this, x1, y1, x2, y2);
         GraphicsUtil.ClearAndDrawLine (this, 0, 0, distance * 1.5, 0);
         
         
         if (distance < 0.01)
            return;
         
         
         //var lowerX:Number = x2 - mLowerTranslation * dx / distance;
         //var lowerY:Number = y2 - mLowerTranslation * dy / distance;
         //var upperX:Number = x2 - mUpperTranslation * dx / distance;
         //var upperY:Number = y2 - mUpperTranslation * dy / distance;
         
         //GraphicsUtil.DrawLine (this, lowerX, lowerY, upperX, upperY, 0x808080, 5);
         
         if ( IsLimitsEnabled () )
            GraphicsUtil.DrawLine (this,distance +  mLowerTranslation, 0, distance + mUpperTranslation, 0, 0x808080, 5);
         
         //var dxHalfHeight:Number = - mRangeBarHalfHeight * dy / distance;
         //var dyHalfHeight:Number =   mRangeBarHalfHeight * dx / distance;
         
         //GraphicsUtil.DrawPolygon (this, );
         
         if (mVertexControllerLower != null)
         {
            mVertexControllerLower.SetPosition (distance + mLowerTranslation, 0);
            mVertexControllerLower.UpdateSelectionProxy ();
            
            mVertexControllerLower.SetSelectable (IsLimitsEnabled ());
            mVertexControllerLower.visible = IsLimitsEnabled ();
         }
         
         if (mVertexControllerUpper != null)
         {
            mVertexControllerUpper.SetPosition (distance + mUpperTranslation, 0);
            mVertexControllerUpper.UpdateSelectionProxy ();
            
            mVertexControllerUpper.SetSelectable (IsLimitsEnabled ());
            mVertexControllerUpper.visible = IsLimitsEnabled ();
         }
      }
      
      public function GetAnchor1 ():SubEntitySliderAnchor
      {
         return mAnchor1;
      }
      
      public function GetAnchor2 ():SubEntitySliderAnchor
      {
         return mAnchor2;
      }
      
      public function SetLowerTranslation (lowerTranslation:Number):void
      {
         if (lowerTranslation > mUpperTranslation)
            lowerTranslation = mUpperTranslation;
         
         mLowerTranslation = lowerTranslation;
      }
      
      public function SetUpperTranslation (upperTranslation:Number):void
      {
         if ( upperTranslation < mLowerTranslation)
            upperTranslation = mLowerTranslation;
         
         mUpperTranslation = upperTranslation;
      }
      
      public function GetLowerTranslation ():Number
      {
         return mLowerTranslation;
      }
      
      public function GetUpperTranslation ():Number
      {
         return mUpperTranslation;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointSlider (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var slider:EntityJointSlider = entity as EntityJointSlider;
         
         slider.SetLowerTranslation ( GetLowerTranslation () );
         slider.SetUpperTranslation ( GetUpperTranslation () );
         
         var anchor1:SubEntitySliderAnchor = GetAnchor1 ();
         var anchor2:SubEntitySliderAnchor = GetAnchor2 ();
         var newAnchor1:SubEntitySliderAnchor = slider.GetAnchor1 ();
         var newAnchor2:SubEntitySliderAnchor = slider.GetAnchor2 ();
         
         anchor1.SetPropertiesForClonedEntity (newAnchor1, displayOffsetX, displayOffsetY);
         anchor2.SetPropertiesForClonedEntity (newAnchor2, displayOffsetX, displayOffsetY);
         
         newAnchor1.UpdateAppearance ();
         newAnchor1.UpdateSelectionProxy ();
         newAnchor2.UpdateAppearance ();
         newAnchor2.UpdateSelectionProxy ();
         
         slider.UpdateAppearance ();
      }
      
      override public function GetSubEntities ():Array
      {
         return [mAnchor1, mAnchor2];
      }
      
      
      
      
      
//========================================================================
// vertex controllers
//========================================================================
      
      private var mVertexControllerLower:VertexController = null;
      private var mVertexControllerUpper:VertexController = null;
      
      override public function SetVertexControllersVisible (visible:Boolean):void
      {
         // mVertexControlPointsVisible = visible;
         super.SetVertexControllersVisible (visible);
         
      // create / destroy controllers
         
         if ( AreVertexControlPointsVisible () )
         {
            if (mVertexControllerLower == null)
            {
               mVertexControllerLower = new VertexController (mWorld, this);
               addChild (mVertexControllerLower);
            }
            
            if (mVertexControllerUpper == null)
            {
               mVertexControllerUpper = new VertexController (mWorld, this);
               addChild (mVertexControllerUpper);
            }
            
            UpdateAppearance ();
         }
         else
         {
            if (mVertexControllerLower != null)
            {
               mVertexControllerLower.Destroy ();
               if (contains (mVertexControllerLower))
                  removeChild (mVertexControllerLower);
               
               mVertexControllerLower = null;
            }
            
            if (mVertexControllerUpper != null)
            {
               mVertexControllerUpper.Destroy ();
               if (contains (mVertexControllerUpper))
                  removeChild (mVertexControllerUpper);
               
               mVertexControllerUpper = null;
            }
         }
      }
      
      override public function OnMovingVertexController (vertexController:VertexController, localOffsetX:Number, localOffsetY:Number):void
      {
      // ...
         
         if (vertexController == mVertexControllerLower)
         {
            if (mLowerTranslation + localOffsetX <= mUpperTranslation)
            {
               mLowerTranslation = mLowerTranslation + localOffsetX;
               if (mLowerTranslation > 0)
                  mLowerTranslation = 0;
            }
         }
         else if (vertexController == mVertexControllerUpper)
         {
            if (mUpperTranslation + localOffsetX >= mLowerTranslation)
            {
               mUpperTranslation = mUpperTranslation + localOffsetX;
               if (mUpperTranslation < 0)
                  mUpperTranslation = 0;
            }
         }
         
         
      // ...
         
         UpdateAppearance ();
      }
      
      
      
   }
}
