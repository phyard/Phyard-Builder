package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceGlobal extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceGlobal ()
      {
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Global;
      }
      
      override public function GetSpaceName ():String
      {
         return "Global Variable Space";
      }
      
      override public function GetSpaceShortName ():String
      {
         return "Global";
      }
      
   }
}
