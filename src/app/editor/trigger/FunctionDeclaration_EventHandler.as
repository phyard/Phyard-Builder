package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.FunctionTypeDefine;
   
   // todo: change name to FunctionDeclaration_EventHandler
   public class FunctionDeclaration_EventHandler extends FunctionDeclaration
   {
      
      public function FunctionDeclaration_EventHandler (id:int, name:String, paramDefines:Array = null, description:String = null):void
      {
         super (id, name, paramDefines, description);
         
         if ( ! CheckConsistent (TriggerEngine.GetCoreEventHandlerDeclarationById (id) ) )
            throw new Error ("not consistent!");
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_EventHandler;
      }
      
      override public function CanBeCalledInConditionList ():Boolean
      {
         return false;
      }
      
   }
}
