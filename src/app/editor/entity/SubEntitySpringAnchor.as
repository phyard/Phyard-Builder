
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class SubEntitySpringAnchor extends SubEntityJointAnchor 
   {
      private var mRadius:Number = 3;
      
      public function SubEntitySpringAnchor (world:World, mainEntity:Entity, anchorIndex:int)
      {
         super (world, mainEntity, anchorIndex);
         
         UpdateAppearance ();
      }
      
      override public function GetTypeName ():String
      {
         return "Spring Joint Anchor";
      }
      
      override public function GetInfoText ():String
      {
         return "x: " + GetPositionX () + ", y = " + GetPositionY ();
      }
      
      override public function UpdateAppearance ():void
      {
         var borderColor:uint;
         var borderSize :int;
         var filledColor:uint = 0xFFFFFF;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize  = 1;
         }
         
         alpha = 0.7;
         
         GraphicsUtil.ClearAndDrawEllipse (this, - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, borderColor, borderSize, true, filledColor);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle ( GetRotation (), GetPositionX (), GetPositionY (), mRadius );
      }
      
      
   }
}
