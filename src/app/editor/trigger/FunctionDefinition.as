package editor.trigger {
   
   import flash.utils.ByteArray;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionTypeDefine;
   
   public class FunctionDefinition
   {
      public var mFunctionDeclaration:FunctionDeclaration;
      
      public var mInputVariableSpace:VariableSpaceInput;
      
      public var mReturnVariableSpace:VariableSpaceReturn;
      
      public function FunctionDefinition (functionDeclatation:FunctionDeclaration = null)
      {
         mFunctionDeclaration = functionDeclatation;
         
         mInputVariableSpace = new VariableSpaceInput ();
         
         if (mFunctionDeclaration != null)
         {
            var num_inputs:int = mFunctionDeclaration.GetNumInputs ();
            for (var i:int = 0; i < num_inputs; ++ i)
               mInputVariableSpace.CreateVariableInstanceFromDefinition (mFunctionDeclaration.GetParamDefinitionAt (i));
         }
         
         mReturnVariableSpace = new VariableSpaceReturn ();
         
         if (mFunctionDeclaration != null)
         {
            var num_returns:int = mFunctionDeclaration.GetNumReturns ();
            for (var j:int = 0; j < num_returns; ++ j)
               mReturnVariableSpace.CreateVariableInstanceFromDefinition (mFunctionDeclaration.GetReturnDefinitionAt (j));
         }
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function GetFunctionDeclarationId ():int
      {
         if(mFunctionDeclaration == null)
            return -1;
         
         return mFunctionDeclaration.GetID ();
      }
      
      public function GetInputVariableSpace ():VariableSpaceInput
      {
         return mInputVariableSpace;
      }
      
      public function GetReturnVariableSpace ():VariableSpaceReturn
      {
         return mReturnVariableSpace;
      }
      
      public function ValidateValueSources ():void
      {
      }
      
//==============================================================================
// some shortcuts of declaration properties
//==============================================================================
      
      public function GetDeclarationID ():int
      {
         if (mFunctionDeclaration == null)
            return -1;
         
         return mFunctionDeclaration.GetID ();
      }
      
      public function GetFunctionType ():int 
      {
         if (mFunctionDeclaration == null)
            return FunctionTypeDefine.FunctionType_Unknown;
         
         return mFunctionDeclaration.GetType ();
      }
      
      public function GetName ():String
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetName ();
      }
      
      public function GetDescription ():String
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetDescription ();
      }
      
      public function GetNumInputs ():int
      {
         if (mFunctionDeclaration == null)
            return 0;
         
         return mFunctionDeclaration.GetNumInputs ();
      }
      
      public function GetParamDefinitionAt (inputId:int):VariableDefinition
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetParamDefinitionAt (inputId);
      }
      
      public function GetInputValueType (inputId:int):int
      {
         if (mFunctionDeclaration == null)
            return ValueTypeDefine.ValueType_Void;;
         
         return mFunctionDeclaration.GetInputValueType (inputId);
      }
      
      public function HasInputsWithValueTypeOf (valueType:int):Boolean
      {
         if (mFunctionDeclaration == null)
            return false;
         
         return mFunctionDeclaration.HasInputsWithValueTypeOf (valueType);
      }
      
      public function HasInputsCompatibleWith (variableDefinition:VariableDefinition):Boolean
      {
         if (mFunctionDeclaration == null)
            return false;
         
         return mFunctionDeclaration.HasInputsCompatibleWith (variableDefinition);
      }
   }
}
