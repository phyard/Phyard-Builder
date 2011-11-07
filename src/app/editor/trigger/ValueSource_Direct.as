package editor.trigger {
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.DataFormat2;
   
   import editor.entity.Entity;
   import editor.entity.EntityCollisionCategory;
   
   public class ValueSource_Direct implements ValueSource
   {
      
   //========================================================================================================
   // 
   //========================================================================================================
      
      public var mValueObject:Object = null;
      
      public function ValueSource_Direct (valueObject:Object)
      {
         SetValueObject (valueObject);
      }
      
      // this is a shortcut to change the value object quickly without creating a new ValueSource_Direct
      public function SetValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
      {
         if (mValueObject == null)
            return "null";
         
         if (vd is VariableDefinitionString)
         {
            var str:String = mValueObject as String;
            var pattern:RegExp;
            pattern  = /\\/g;
            str = str.replace(pattern, "\\\\");
            pattern = /"/g;
            str = str.replace(pattern, "\\\"");
            
            return "\"" + str + "\"";
         }
         else if (vd is VariableDefinitionNumber)
         {
            var vdn:VariableDefinitionNumber = vd as VariableDefinitionNumber;
            if (vdn.mIsColorValue)
            {
               return DataFormat2.UInt2ColorString (uint (mValueObject));
            }
         }
         
         if (mValueObject.hasOwnProperty ("ToCodeString"))
            return mValueObject.ToCodeString ();
         
         return  mValueObject.toString ();
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Direct;
      }
      
      public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      public function CloneSource (triggerEngine:TriggerEngine, targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource
      {
         if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
         {
            if (mValueObject is Entity)
            {
               return new ValueSource_Direct (null);
            }
            else if (mValueObject is EntityCollisionCategory)
            {
               return new ValueSource_Direct (null);
            }
         }
         
         return new ValueSource_Direct (mValueObject);
      }
      
      public function ValidateSource ():void
      {
         if (mValueObject is Entity)
         {
            var entity:Entity = mValueObject as Entity;
            if (entity.GetCreationOrderId () < 0)
               SetValueObject (null)
         }
         else if (mValueObject is EntityCollisionCategory)
         {
            
         }
      }
      
   }
}

