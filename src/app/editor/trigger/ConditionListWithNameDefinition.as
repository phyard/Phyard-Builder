package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.Define;
   
   public class ConditionListWithNameDefinition extends ConditionListDefinition
   {
      protected var mName:String;
      
      public function ConditionListWithNameDefinition (name:String, ownerFunctionDefinition:FunctionDefinition = null)
      {
         super (ownerFunctionDefinition);
         
         mName = name;
      }
      
      public function SetName (newName:String):void
      {
         if (newName == null)
            newName = "";
         
         if (newName.length > Define.MaxLogicComponentNameLength)
            newName = newName.substr (0, Define.MaxLogicComponentNameLength);
         
         mName = newName;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
   }
}
