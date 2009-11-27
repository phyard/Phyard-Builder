
package common {
   
   import flash.utils.ByteArray;
   
   import player.global.Global;
   import player.world.World;
   import player.entity.Entity;
   import player.trigger.IPropertyOwner;
   
   import common.trigger.CoreFunctionIds;
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition;
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.FunctionDefinition_Logic;
   import player.trigger.FunctionInstance;
   import player.trigger.CodeSnippet;
   import player.trigger.FunctionCalling;
   import player.trigger.FunctionCalling_Return;
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Null;
   import player.trigger.ValueSource_Direct;
   import player.trigger.ValueSource_Variable;
   import player.trigger.ValueTarget;
   import player.trigger.ValueTarget_Null;
   import player.trigger.ValueTarget_Variable;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   
   import common.trigger.FunctionDeclaration;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionCallingDefine;
   import common.trigger.define.ValueSourceDefine;
   import common.trigger.define.ValueSourceDefine_Null;
   import common.trigger.define.ValueSourceDefine_Direct;
   import common.trigger.define.ValueSourceDefine_Variable;
   import common.trigger.define.ValueTargetDefine;
   import common.trigger.define.ValueTargetDefine_Null;
   import common.trigger.define.ValueTargetDefine_Variable;
   
   public class TriggerFormatHelper2
   {
      
//==============================================================================================
// define -> definition (player)
//==============================================================================================
      
      public static function CreateCodeSnippet (parentFunctionInstance:FunctionInstance, playerWorld:World, codeSnippetDefine:CodeSnippetDefine):CodeSnippet
      {
         var calling_list_head:FunctionCalling = null;
         var calling:FunctionCalling = null;
         
         for (var i:int = codeSnippetDefine.mNumCallings - 1; i >= 0; -- i)
         {
            calling = FunctionCallingDefine2FunctionCalling (parentFunctionInstance, playerWorld, codeSnippetDefine.mFunctionCallingDefines [i]);
            
            calling.SetNextCalling (calling_list_head);
            calling_list_head = calling;
         }
         
         var code_snippet:CodeSnippet = new CodeSnippet (calling_list_head);
         
         return code_snippet;
      }
      
      public static function FunctionCallingDefine2FunctionCalling (parentFunctionInstance:FunctionInstance, playerWorld:World, funcCallingDefine:FunctionCallingDefine):FunctionCalling
      {
         if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
         {
            var function_id:int = funcCallingDefine.mFunctionId;
            var core_func_definition:FunctionDefinition_Core = TriggerEngine.GetCoreFunctionDefinition (function_id);
            var core_func_declaration:FunctionDeclaration = core_func_definition.GetFunctionDeclaration ();
            
            var value_source_list:ValueSource = null;
            var value_source:ValueSource;
            var i:int;
            for (i = funcCallingDefine.mNumInputs - 1; i >= 0; -- i)
            {
               value_source = ValueSourceDefine2InputValueSource (parentFunctionInstance, playerWorld, funcCallingDefine.mInputValueSourceDefines [i], core_func_declaration.GetInputValueType (i));
               value_source.mNextValueSourceInList = value_source_list;
               value_source_list = value_source;
            }
            
            var value_target_list:ValueTarget = null;
            var value_target:ValueTarget;
            for (i = funcCallingDefine.mNumReturns - 1; i >= 0; -- i)
            {
               value_target = ValueTargetDefine2ReturnValueTarget (parentFunctionInstance, playerWorld, funcCallingDefine.mReturnValueTargetDefines [i], core_func_declaration.GetReturnValueType (i));
               value_target.mNextValueTargetInList = value_target_list;
               value_target_list = value_target;
            }
            
            var calling:FunctionCalling;
            if (CoreFunctionIds.IsReturnCalling (function_id))
            {
               calling = new FunctionCalling_Return (core_func_definition, value_source_list, value_target_list, function_id);
            }
            else
            {
               calling = new FunctionCalling (core_func_definition, value_source_list, value_target_list);
            }
            
            return calling;
         }
         else
         {
            return null;
         }
      }
      
      public static function ValueSourceDefine2InputValueSource (parentFunctionInstance:FunctionInstance, playerWorld:World, valueSourceDefine:ValueSourceDefine, valueType:int):ValueSource
      {
         var value_source:ValueSource = null;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            //assert (valueType == direct_source_define.mValueType);
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as Boolean);
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as Number);
                  break;
               case ValueTypeDefine.ValueType_String:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as String);
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  value_source = new ValueSource_Direct (playerWorld.GetEntityByCreationId (direct_source_define.mValueObject as int));
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as int);
                  break;
               default:
                  break;
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var value_space_type:int = variable_source_define.mSpaceType;
            var variable_index:int   = variable_source_define.mVariableIndex;
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = Global.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = parentFunctionInstance.GetInputVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Return:
                  variable_instance = parentFunctionInstance.GetReturnVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  break;
               default:
                  break;
            }
            
            if (variable_instance != null)
            {
               value_source = new ValueSource_Variable (variable_instance);
            }
         }
         
         if (value_source == null)
         {
            //value_source = new ValueSource_Null ();
            //trace ("Error: source is null");
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_source = new ValueSource_Direct (false);
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_source = new ValueSource_Direct (0);
                  break;
               case ValueTypeDefine.ValueType_String:
                  value_source = new ValueSource_Direct (null);
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  value_source = new ValueSource_Direct (null);
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_source = new ValueSource_Direct (Define.CollisionCategoryId_HiddenCategory);
                  break;
               default:
                  value_source = new ValueSource_Null ();
                  trace ("Error: source is null");
                  break;
            }
         }
         
         return value_source;
      }
      
      public static function ValueTargetDefine2ReturnValueTarget (parentFunctionInstance:FunctionInstance, playerWorld:World, valueTargetDefine:ValueTargetDefine, valueType:int):ValueTarget
      {
         var value_target:ValueTarget = null;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Null)
         {
            value_target = new ValueTarget_Null ();
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            var value_space_type:int = variable_target_define.mSpaceType;
            var variable_index:int   = variable_target_define.mVariableIndex;
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = Global.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = parentFunctionInstance.GetInputVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Return:
                  variable_instance = parentFunctionInstance.GetReturnVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  break;
               default:
                  break;
            }
            
            if (variable_instance != null)
            {
               value_target = new ValueTarget_Variable (variable_instance);
            }
         }
         
         if (value_target == null)
         {
            value_target = new ValueTarget_Null ();
            
            //trace ("Error: target is null");
         }
         
         return value_target;
      }
      
//==============================================================================================
// byte array -> define
//==============================================================================================
      
      public static function ByteArray2CommandListDefine (byteArray:ByteArray):CodeSnippetDefine
      {
         return null;
      }
      
      public static function ByteArray2FunctionCallingDefine (byteArray:ByteArray):FunctionCallingDefine
      {
         return null;
      }
      
      public static function ByteArray2ValueSourceDefine (byteArray:ByteArray):ValueSourceDefine
      {
         return null;
      }
      
//==============================================================================================
// define -> xml
//==============================================================================================
      
      public static function CommandListDefine2Xml (codeSnippetDefine:CodeSnippetDefine):XML
      {
         return null;
      }
      
      public static function FunctionCallingDefine2Xml (funcCallingDefine:FunctionCallingDefine):XML
      {
         return null;
      }
      
      public static function ValueSourceDefine2Xml (valueSourceDefine:ValueSourceDefine):XML
      {
         return null;
      }
      
   }
}
