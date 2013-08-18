package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.FunctionCoreBasicDefine;
   import common.trigger.CoreFunctionDeclarations;
   
   public class FunctionDeclaration_Core extends editor.trigger.FunctionDeclaration
   {
      protected var mFunctionDeclaration_Common:FunctionCoreBasicDefine;
      
      public function FunctionDeclaration_Core (id:int, name:String, description:String = null, 
                                                poemCallingFormat:String = null, traditionalCallingFormat:String = null, 
                                                inputDefinitions:Array = null, returnDefinitions:Array = null, 
                                                showUpInApiMenu:Boolean = true)
      {
         mFunctionDeclaration_Common = CoreFunctionDeclarations.GetCoreFunctionDeclaration (id);
         
         if (inputDefinitions != null)
         {
            var count:int = inputDefinitions.length;
            for (var i:int = 0; i < count; ++ i)
            {
               (inputDefinitions[i] as VariableDefinition).SetDefaultValue (mFunctionDeclaration_Common.GetInputParamDefaultValue (i));
            }
         }
         
         super (id, name, description, inputDefinitions, returnDefinitions, showUpInApiMenu);
         
         ParseAllCallingTextSegments (poemCallingFormat, traditionalCallingFormat);
         
         var result:String = CheckConsistent (mFunctionDeclaration_Common);
         if (result != null)
            throw new Error ("not consistent! id = " + id + ", reaspm: " + result);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_Core;
      }
      
//=================================================================
//
//=================================================================
      
      override public function GetInputNumberTypeDetail (inputId:int):int
      {
         return mFunctionDeclaration_Common.GetInputNumberTypeDetail (inputId);
      }
      
      override public function GetInputNumberTypeUsage (inputId:int):int
      {
         return mFunctionDeclaration_Common.GetInputNumberTypeUsage (inputId);
      }
      
   }
}

