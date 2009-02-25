package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.entity.VertexController;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   public class ModeMoveSelectedVertexControllers extends Mode
   {
      
      public function ModeMoveSelectedVertexControllers (mainView:WorldView, vertexController:VertexController)
      {
         super (mainView);
         
         mVertexController = vertexController;
      }
      
      private var mVertexController:VertexController;
      
      private var mStartX:Number;
      private var mStartY:Number;
      private var mEndX:Number;
      private var mEndY:Number;
      
      private var mIsStarted:Boolean = false;
      
      override public function Reset ():void
      {
         ResetSession ();
         
         mMainView.SetCurrentEditMode (null);
      }
      
      protected function ResetSession ():void
      {
         if (mIsStarted)
            mVertexController.GetOwnerEntity ().OnEndMovingVertexController (mVertexController);
         
         mIsStarted = false;
      }
      
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession ();
         
         mStartX = startX;
         mStartY = startY;
         
         mIsStarted = true;
         
         mVertexController.GetOwnerEntity ().OnBeginMovingVertexController (mVertexController);
      }
      
      private function UpdateSession (endX:Number, endY:Number):void
      {
         var dx:Number = endX - mStartX;
         var dy:Number = endY - mStartY;
         
         mStartX = endX;
         mStartY = endY;
         
         mMainView.MoveSelectedVertexControllers (dx, dy);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         ResetSession ();
         
         mMainView.CreateUndoPoint ();
         
         mMainView.SetCurrentEditMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         StartSession (mouseX, mouseY);
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (! mIsStarted)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (! mIsStarted)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}