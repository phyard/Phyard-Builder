
package editor.asset {
   
   public interface Linkable
   {
      function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int;
      function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean;
      function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toAsset:Asset, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean;
   }
}