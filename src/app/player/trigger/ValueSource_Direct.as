package player.trigger
{
   public class ValueSource_Direct extends ValueSource
   {
      public var mValueObject:Object;
      
      public function ValueSource_Direct (valueObject:Object, next:ValueSource = null)
      {
         super (next);
         
         mValueObject = valueObject;
      }
      
      override public function EvalateValueObject ():Object
      {
         return mValueObject;
      }
   }
}