package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.ValueAdjuster;
   import common.CoordinateSystem;
   
   public class FunctionCalling
   {
      public var mTriggerEngine:TriggerEngine;
      
      public var mFunctionDeclaration:FunctionDeclaration;
      
      public var mInputValueSources:Array;
      public var mOutputValueTargets:Array;
      
      protected var mCommentedOff:Boolean = false;
      
      public function FunctionCalling (triggerEngine:TriggerEngine, functionDeclatation:FunctionDeclaration, createDefaultSourcesAndTargets:Boolean = true)
      {
         mTriggerEngine = triggerEngine;
         
         mFunctionDeclaration = functionDeclatation;
         
         var variable_def:VariableDefinition;
         var i:int;
         
         var num_inputs:int = mFunctionDeclaration.GetNumInputs ();
         mInputValueSources = new Array (num_inputs);
         
         var num_returns:int = mFunctionDeclaration.GetNumOutputs ();
         mOutputValueTargets = new Array (num_returns);
         
         if (createDefaultSourcesAndTargets)
         {
            for (i = 0; i < num_inputs; ++ i)
            {
               variable_def = mFunctionDeclaration.GetInputParamDefinitionAt (i);
               mInputValueSources [i] = variable_def.GetDefaultValueSource (mTriggerEngine);
            }
            
            for (i = 0; i < num_returns; ++ i)
            {
               variable_def = mFunctionDeclaration.GetOutputParamDefinitionAt (i);
               mOutputValueTargets [i] = variable_def.GetDefaultValueTarget ();
            }
         }
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function GetFunctionType ():int
      {
         return mFunctionDeclaration.GetType ();
      }
      
      public function GetFunctionId ():int
      {
         return mFunctionDeclaration.GetID ();
      }
      
      public function GetNumInputs ():int
      {
         return mFunctionDeclaration.GetNumInputs ();
      }
      
      public function AssignInputValueSources (valueSources:Array):void
      {
         mInputValueSources = valueSources; // best to clone
         
         mSourcesOrTargetsChanged = true;
      }
      
      public function GetInputValueSource (inputId:int):ValueSource
      {
         return mInputValueSources [inputId];
      }
      
      public function GetNumOutputs ():int
      {
         return mFunctionDeclaration.GetNumOutputs ();
      }
      
      public function AssignOutputValueTargets (valueTargets:Array):void
      {
         mOutputValueTargets = valueTargets; // best to clone
         
         mSourcesOrTargetsChanged = true;
      }
      
      public function GetOutputValueTarget (returnId:int):ValueTarget
      {
         return mOutputValueTargets [returnId];
      }
      
      public function ValidateValueSourcesAndTargets ():void
      {
         var i:int;
         
         var value_source:ValueSource;
         for (i = 0; i < mInputValueSources.length; ++ i)
         {
            value_source = mInputValueSources [i] as ValueSource;
            
            value_source.ValidateSource ();
         }
         
         var value_target:ValueTarget;
         for (i = 0; i < mOutputValueTargets.length; ++ i)
         {
            value_target = mOutputValueTargets [i] as ValueTarget;
            
            value_target.ValidateTarget ();
         }
      }
      
      // return true if can't be validated
      public function Validate ():Boolean
      {
         return false; // to override
      }
      
      public function IsCommentedOff ():Boolean
      {
         return mCommentedOff;
      }
      
      public function SetCommentedOff (commentedOff:Boolean):void
      {
         mCommentedOff = commentedOff;
      }
      
//====================================================================
// 
//====================================================================
      
      private var mSourcesOrTargetsChanged:Boolean = true;
      private var mCacheCodeString:String = null;
      public function ToCodeString ():String
      {
         if (mSourcesOrTargetsChanged)
         {
            mSourcesOrTargetsChanged = false;
            
            mCacheCodeString = mFunctionDeclaration.CreateFormattedCallingText (mInputValueSources, mOutputValueTargets);
         }
         
         return mCacheCodeString;
      }
      
//====================================================================
// 
//====================================================================
      
      protected function CloneShell ():FunctionCalling
      {
         return null; // to override
      }
      
      public function Clone (targetFunctionDefinition:FunctionDefinition):FunctionCalling
      {
         var calling:FunctionCalling = new FunctionCalling (mTriggerEngine, mFunctionDeclaration, false);
         
         var i:int;
         var vi:VariableInstance;
         
         var numInputs:int = mInputValueSources.length;
         var sourcesArray:Array = new Array (numInputs);
         var source:ValueSource;
         
         for (i = 0; i < numInputs; ++ i)
         {
            source = mInputValueSources [i] as ValueSource;
            
            if (source is ValueSource_Property)
            {
               sourcesArray [i] = (source as ValueSource_Property).ClonePropertySource (mTriggerEngine, targetFunctionDefinition, mFunctionDeclaration, i);
            }
            else if (source is ValueSource_Variable)
            {
               sourcesArray [i] = (source as ValueSource_Variable).CloneVariableSource (mTriggerEngine, targetFunctionDefinition, mFunctionDeclaration, i);
            }
            else // direct
            {
               sourcesArray [i] = source.CloneSource ();
            }
         }
         
         calling.AssignInputValueSources (sourcesArray);
         
         var numOutputs:int = mOutputValueTargets.length;
         var targetsArray:Array = new Array (numOutputs);
         var target:ValueTarget;
         
         for (i = 0; i < numOutputs; ++ i)
         {
            target = mOutputValueTargets [i] as ValueTarget;
            
            if (target is ValueTarget_Property)
            {
               targetsArray [i] = (target as ValueTarget_Property).ClonePropertyTarget (mTriggerEngine, targetFunctionDefinition, mFunctionDeclaration, i);
            }
            else if (target is ValueTarget_Variable)
            {
               targetsArray [i] = (target as ValueTarget_Variable).CloneVariableTarget (mTriggerEngine, targetFunctionDefinition, mFunctionDeclaration, i);
            }
            else // direct
            {
               targetsArray [i] = target.CloneTarget ();
            }
         }
         
         calling.AssignOutputValueTargets (targetsArray);
         
         return calling;
      }
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var numInputs:int = mInputValueSources.length;
         var source:ValueSource;
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberUsage:int;
         for (i = 0; i < numInputs; ++ i)
         {
            valueType = mFunctionDeclaration.GetInputParamValueType (i);
            source = mInputValueSources [i] as ValueSource;
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.GetValueObject ());
               numberUsage = mFunctionDeclaration.GetInputNumberTypeUsage (i);
               
               directSource.SetValueObject (coordinateSystem.D2P (directValue, numberUsage));
            }
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var numInputs:int = mInputValueSources.length;
         var source:ValueSource;
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberUsage:int;
         for (i = 0; i < numInputs; ++ i)
         {
            valueType = mFunctionDeclaration.GetInputParamValueType (i);
            source = mInputValueSources [i] as ValueSource;
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.GetValueObject ());
               numberUsage = mFunctionDeclaration.GetInputNumberTypeUsage (i);
               
               directSource.SetValueObject (coordinateSystem.P2D (directValue, numberUsage));
            }
         }
      }
      
      public function AdjustNumberPrecisions ():void
      {
         var i:int;
         var numInputs:int = mInputValueSources.length;
         var source:ValueSource;
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberDetail:int;
         for (i = 0; i < numInputs; ++ i)
         {
            source = mInputValueSources [i] as ValueSource;
            valueType = mFunctionDeclaration.GetInputParamValueType (i);
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.GetValueObject ());
               numberDetail = mFunctionDeclaration.GetInputNumberTypeDetail (i);
               
               switch (numberDetail)
               {
                  case ValueTypeDefine.NumberTypeDetail_Single:
                     directValue = ValueAdjuster.Number2Precision (directValue, 6);
                     break;
                  case ValueTypeDefine.NumberTypeDetail_Integer:
                     directValue = Math.round (directValue);
                     break;
                  case ValueTypeDefine.NumberTypeDetail_Double:
                  default:
                     directValue = ValueAdjuster.Number2Precision (directValue, 12);
                     break;
               }
               
               directSource.SetValueObject (directValue);
            }
         }
      }
   }
}
