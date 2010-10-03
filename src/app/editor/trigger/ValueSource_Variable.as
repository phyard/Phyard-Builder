package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Variable implements ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstance:VariableInstance; // should not be null
      
      public function ValueSource_Variable (variableInstacne:VariableInstance)
      {
         SetVariableInstance (variableInstacne);
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
      {
         return mVariableInstance.SourceToCodeString (vd);
      }
      
      public function GetVariableInstance ():VariableInstance
      {
         return mVariableInstance;
      }
      
      public function SetVariableInstance (variableInstacne:VariableInstance):void
      {
         mVariableInstance = variableInstacne;
      }
      
      public function GetVariableSpaceType ():int
      {
         return mVariableInstance.GetSpaceType ();
      }
      
      public function GetVariableIndex ():int
      {
         return mVariableInstance.GetIndex ();
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Variable;
      }
      
      public function GetValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
      
      //public function CloneSource ():ValueSource
      //{
      //   // not a safe clone. Only used in FunctionCallingLineData
      //   return new ValueSource_Variable (mVariableInstance);
      //}
      
      public function CloneSource (triggerEngine:TriggerEngine, targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource
      {
         var variableDefinition:VariableDefinition;;
         
         switch (mVariableInstance.GetSpaceType ())
         {
            case ValueSpaceTypeDefine.ValueSpace_Input:
            {
               variableDefinition = targetFunctionDefinition.GetInputParamDefinitionAt (mVariableInstance.GetIndex ());
               
               if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               else
                  return new ValueSource_Variable (targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
            }
            case ValueSpaceTypeDefine.ValueSpace_Output:
            {
               variableDefinition = targetFunctionDefinition.GetOutputParamDefinitionAt (mVariableInstance.GetIndex ());
               
               if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               else
                  return new ValueSource_Variable (targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
            }
            case ValueSpaceTypeDefine.ValueSpace_Local:
            {
               variableDefinition = targetFunctionDefinition.GetLocalVariableDefinitionAt (mVariableInstance.GetIndex ());
               
               if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               else
                  return new ValueSource_Variable (targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
            }
            default: // global/entity variable
            {
               if (targetFunctionDefinition.IsPure ())
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               else
                  return new ValueSource_Variable (mVariableInstance);
            }
         }
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
   }
}

