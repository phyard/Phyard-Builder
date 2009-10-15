package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.Entity;
   
   import common.Define;
   
   public class ModePlaceCreateEntitiy extends Mode
   {
      private var mEntityCreatFunction:Function = null;
      private var mEntityCreatOptions:Object = null;
      
      public function ModePlaceCreateEntitiy (mainView:WorldView, createFunc:Function, createOptions:Object = undefined)
      {
         super (mainView);
         
         mEntityCreatFunction = createFunc;
         mEntityCreatOptions = createOptions;
      }
      
      private var mEntity:Entity = null;
      
      override public function Initialize ():void
      {
         StartSession ();
      }
      
      override public function Reset ():void
      {
         ResetSession (true);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled && mEntity != null)
            mMainView.DestroyEntity (mEntity);
         
         mEntity = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         if (mEntityCreatFunction != null)
         {
            mEntity = mEntityCreatFunction (mEntityCreatOptions);
         }
         
         if (mEntity == null)
         {
            Reset ();
            return;
         }
         
         mEntity.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         mEntity.visible = true;
         
         mEntity.SetPosition (posX, posY);
         
         mEntity.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntity.UpdateSelectionProxy ();
         
         ResetSession (false);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         if (mEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (mEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntity == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}