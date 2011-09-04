
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.selection.SelectionEngine;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManager extends Sprite 
   {
      public var mCoordinateSystem:CoordinateSystem;
      
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mSelectionList:AssetSelectionList;
      
      protected var mAssetsSortedByCreationId:Array = new Array ();
      
      public function AssetManager ()
      {
         mCoordinateSystem = Define.kDefaultCoordinateSystem;
         
         mSelectionEngine = new SelectionEngine ();
         
         mSelectionList = new AssetSelectionList ();
      }
      
      public function GetSelectionEngine ():SelectionEngine
      {
         return mSelectionEngine;
      }
      
//=================================================================================
//   coordinates
//=================================================================================
      
      public function GetCoordinateSystem ():CoordinateSystem
      {
         return mCoordinateSystem;
      }
      
      public function RebuildCoordinateSystem (originX:Number, originY:Number, scale:Number, rightHand:Boolean):void
      {
         if (scale <= 0)
            scale = 1.0;
         
         mCoordinateSystem = new CoordinateSystem (originX, originY, scale, rightHand);
      }
      
//=================================================================================
//   update
//=================================================================================
      
      public function Update (escapedTime:Number):void
      {
         var numAssets:int = mAssetsSortedByCreationId.length;
         
         for (var i:uint = 0; i < numAssets; ++ i)
         {
            var asset:Asset = GetAssetByCreationId (i);
            
            if (asset != null)
            {
               asset.Update (escapedTime);
            }
         }
      }
      
//=================================================================================
//   destroy assets
//=================================================================================
      
      public function Destroy ():void
      {
         DestroyAllAssets ();
         
         mSelectionEngine.Destroy ();
      }
      
      public function DestroyAllAssets ():void
      {
         while (mAssetsSortedByCreationId.length > 0)
         {
            var asset:Asset = GetAssetByCreationId (0);
            DestroyAsset (asset.GetMainAsset ());
         }
      }
      
      public function DestroyAsset (asset:Asset):void
      {
         mSelectionList.RemoveSelectedAsset (asset);
         
         asset.Destroy ();
         
         if ( contains (asset) )
         {
            removeChild (asset);
         }
         
         if (asset == mCachedLastSelectedAsset)
         {
            mCachedLastSelectedAsset = null;
         }
      }
      
//=================================================================================
//   selection list
//=================================================================================
      
      public function GetSelectedAssets ():Array
      {
         return mSelectionList.GetSelectedAssets ();
      }
      
      public function GetTheFirstSelectedAsset ():Asset
      {
         var assets:Array = mSelectionList.GetSelectedAssets ();
         if (assets != null && assets.length > 0)
         {
            return assets[0] as Asset;
         }
         
         return null;
      }
      
      public function ClearSelectedAssets ():void
      {
         mSelectionList.ClearSelectedAssets ();
      }
      
      public function AddSelectedAssets (assetArray:Array):void
      {
         if (assetArray == null)
            return;
         
         for (var i:uint = 0; i < assetArray.length; ++ i)
         {
            AddSelectedAsset (assetArray[i] as Asset);
         }
      }
      
      public function AddSelectedAsset (asset:Asset):void
      {
         if (asset != null)
         {
            mSelectionList.AddSelectedAsset (asset);
         }
      }
      
      public function RemoveSelectedAssets (assetArray:Array):void
      {
         if (assetArray == null)
            return;
         
         for (var i:uint = 0; i < assetArray.length; ++ i)
         {
            RemovedSelectAsset (assetArray[i] as Asset);
         }
      }
      
      public function RemovedSelectAsset (asset:Asset):void
      {
         if (asset != null)
         {
            mSelectionList.RemoveSelectedAsset (asset)
         }
      }
      
      public function SetSelectedAssets (assetArray:Array):void
      {
         ClearSelectedAssets ();
         
         AddSelectedAssets (assetArray);
      }
      
      public function SetSelectedAsset (asset:Asset):void
      {
         ClearSelectedAssets ();
         
         AddSelectedAsset (asset);
      }
      
      public function IsAssetSelected (asset:Asset):Boolean
      {
         return mSelectionList.IsAssetSelected (asset);
      }
      
      public function ToggleAssetSelected (asset:Asset):void
      {
         if ( IsAssetSelected (asset) )
            mSelectionList.RemoveSelectedAsset (asset);
         else
            mSelectionList.AddSelectedAsset (asset);
      }
      
      public function AreSelectedAssetsContainingPoint (pointX:Number, pointY:Number):Boolean
      {
         return mSelectionList.AreSelectedAssetsContainingPoint (pointX, pointY);
      }
      
//=================================================================================
//   select assets / control points / linkables
//=================================================================================
      
      public function GetObjectAssetAncestor (displayObject:DisplayObject):Asset
      {
         while (displayObject != null)
         {
            if (displayObject is Asset)
               return displayObject as Asset;
            else
               displayObject = displayObject.parent;
         }
         
         return null;
      }
      
      private function Sorter_ByAppearanceOrder (o1:Object, o2:Object):int
      {
         var id1:int = -1;
         var id2:int = -1;
         
         var asset:Asset;
         
         asset = o1 as Asset;
         if (asset != null)
            id1 = asset.GetAppearanceLayerId ();
         else
         {
            asset = GetObjectAssetAncestor (o1 as DisplayObject);
            if (asset != null)
               id1 = asset.GetAppearanceLayerId ();
         }
         
         asset = o2 as Asset;
         if (asset != null)
            id2 = asset.GetAppearanceLayerId ();
         else
         {
            asset = GetObjectAssetAncestor (o2 as DisplayObject);
            if (asset != null)
               id2 = asset.GetAppearanceLayerId ();
         }
         
         if (id1 > id2)
            return -1;
         else if (id1 < id2)
            return 1;
         else
            return 0;
      }
      
      public function GetAssetsIntersectWithRegion (displayX1:Number, displayY1:Number, displayX2:Number, displayY2:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsIntersectWithRegion (displayX1, displayY1, displayX2, displayY2);
         
         return ConvertObjectArrayToAssetArray (objectArray);
      }
      
      private var mCachedLastSelectedAsset:Asset = null; // for asset overlapping cases
      
      public function GetAssetsAtPoint (managerX:Number, managerY:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (managerX, managerY);
         
         var assetArray:Array = ConvertObjectArrayToAssetArray (objectArray);
         assetArray.sort (Sorter_ByAppearanceOrder);
         
         if (mCachedLastSelectedAsset != null)
         {
            for (var i:int = 0; i < assetArray.length - 1; ++ i)
            {
               if (assetArray [i] == mCachedLastSelectedAsset)
               {
                  while (i -- >= 0)
                  {
                     assetArray.push (assetArray.shift ());
                  }
                  
                  break;
               }
            }
         }
         
         if (assetArray.length > 0)
         {
            mCachedLastSelectedAsset = assetArray [0] as Asset;
         }
         
         return assetArray;
      }
      
      public function GetControlPointsAtPoint (displayX:Number, displayY:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
         var controlPointArray:Array = new Array ();
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is ControlPoint)
               controlPointArray.push (objectArray [i]);
         }
         
         return controlPointArray;
      }
      
      private function ConvertObjectArrayToAssetArray (objectArray:Array):Array
      {
         var assetArray:Array = new Array ();
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is Asset && (objectArray [i] as Asset).IsVisibleForEditing ())
            {
               assetArray.push (objectArray [i]);
            }
         }
         
         return assetArray;
      }
      
      public function GetFirstLinkablesAtPoint (displayX:Number, displayY:Number):Linkable
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
         objectArray.sort (Sorter_ByAppearanceOrder);
         var linkable:Linkable = null;
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is Linkable) // && objectArray [i] is DisplayObject)
            {
               if ( (! (objectArray [i] is Asset)) || (objectArray [i] as Asset).IsVisibleForEditing ())
               {
                  linkable = objectArray [i] as Linkable;
                  if (linkable.CanStartCreatingLink (displayX, displayY))
                     return linkable;
                  else
                     return null;
               }
            }
         }
         
         return null;
      }
      
//=================================================================================
//   actions on selected entites
//=================================================================================
      
      
      public function MoveSelectedAssets (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         var assetArray:Array = GetSelectedAssets ();
         
         var asset:Asset;
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            asset.Move (offsetX, offsetY, updateSelectionProxy);
         }
      }
      
      public function DeleteSelectedAssets ():Boolean
      {
         var assetArray:Array = mSelectionList.GetSelectedMainAssets ();
         
         var asset:Asset;
         
         var count:int = 0;
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            DestroyAsset (asset);
            
            ++ count;
         }
         
         return count > 0;
      }
      
      public function MoveSelectedAssetsToTop ():void
      {
         var assetArray:Array = GetSelectedAssets ();
         assetArray.sortOn("mAppearOrderId", Array.NUMERIC);
         
         var asset:Asset;
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i];
            
            //if ( asset.GetMainAsset () != null && contains (asset.GetMainAsset ()) )
            //{
            //   removeChild (asset.GetMainAsset ());
            //   addChild (asset.GetMainAsset ());
            //}
            
            if ( asset != null && contains (asset) )
            {
               removeChild (asset);
               addChild (asset);
            }
         }
      }
      
      public function MoveSelectedAssetsToBottom ():void
      {
         var assetArray:Array = GetSelectedAssets ();
         assetArray.sortOn("mAppearOrderId", Array.NUMERIC);
         
         var asset:Asset;
         
         for (var i:int = assetArray.length - 1; i >= 0; -- i)
         {
            asset = assetArray [i];
            
            if ( asset != null && contains (asset) )
            {
               removeChild (asset);
               addChildAt (asset, 0);
            }
            
            //if ( asset.GetMainAsset () != null && contains (asset.GetMainAsset ()) )
            //{
            //   removeChild (asset.GetMainAsset ());
            //   addChildAt (asset.GetMainAsset (), 0);
            //}
         }
      }
      
//=================================================================================
// appearance and creation order
//=================================================================================
      
      override public function addChild(child:DisplayObject):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         return super.addChild(child);
      }
      
      override public function addChildAt(child:DisplayObject, index:int):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         return super.addChildAt(child, index);
      }
      
      override public function removeChild(child:DisplayObject):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         var asset:Asset = child as Asset;
         if (asset != null)
         {
            asset.SetAppearanceLayerId (-1);
         }
         
         return super.removeChild(child);
      }
      
      override public function removeChildAt(index:int):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         var child:DisplayObject = super.removeChildAt(index);
         var asset:Asset = child as Asset;
         if (asset != null)
         {
            asset.SetAppearanceLayerId (-1);
         }
         
         return child;
      }
      
      override public function setChildIndex(child:DisplayObject, index:int):void
      {
         mNeedToCorrectAssetAppearanceIds = true;
         
         super.setChildIndex(child, index);
      }
      
      override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
      {
         mNeedToCorrectAssetAppearanceIds = true;
         
         super.swapChildren(child1, child2);
      }
      
      override public function swapChildrenAt(index1:int, index2:int):void
      {
         mNeedToCorrectAssetAppearanceIds = true;
         
         super.swapChildrenAt(index1, index2);
      }
      
      protected var mNeedToCorrectAssetAppearanceIds:Boolean = false;
      
      public function CorrectAssetAppearanceIds ():void
      {
         if ( mNeedToCorrectAssetAppearanceIds)
         {
            mNeedToCorrectAssetAppearanceIds = false;
            
            var asset:Asset;
            var i:int = 0;
            for (i = 0; i < numChildren; ++ i)
            {
               asset = getChildAt (i) as Asset;
               if (asset != null)
                  asset.SetAppearanceLayerId (i);
            }
         }
      }
      
      public function GetAssetByAppearanceId (appearanceId:int):Asset
      {
         CorrectAssetAppearanceIds ();
         
         if (appearanceId < 0 || appearanceId >= numChildren)
            return null;
         
         return getChildAt (appearanceId) as Asset;
      }
      
      public function OnAssetCreated (asset:Asset):void
      {
         mNeedToCorrectAssetCreationIds = true;
         
         if (mIsCreationArrayOpened)
         {
            if (mAssetsSortedByCreationId.indexOf (asset) < 0)
               mAssetsSortedByCreationId.push (asset);
         }
      }
      
      final public function OnAssetDestroyed (asset:Asset):void
      {
         mNeedToCorrectAssetCreationIds = true;
         
         if (mIsCreationArrayOpened)
         {
            var index:int = mAssetsSortedByCreationId.indexOf (asset);
            if (index >= 0)
            {
               mAssetsSortedByCreationId.splice (index, 1);
               asset.SetCreationOrderId (-1);
            }
         }
      }
      
      private var mNeedToCorrectAssetCreationIds:Boolean = false;
      
      public function CorrectAssetCreationIds ():void
      {
         if (mNeedToCorrectAssetCreationIds)
         {
            mNeedToCorrectAssetCreationIds = false;
            
            var numAssets:int = mAssetsSortedByCreationId.length;
            for (var i:int = 0; i < numAssets; ++ i)
            {
               (mAssetsSortedByCreationId [i] as Asset).SetCreationOrderId (i);
            }
         }
      }
      
      public function GetAssetByCreationId (creationId:int):Asset
      {
         CorrectAssetCreationIds ();
         
         if (creationId < 0 || creationId >= mAssetsSortedByCreationId.length)
            return null;
         
         return mAssetsSortedByCreationId [creationId];
      }
      
      // for loading into editor
      private var mIsCreationArrayOpened:Boolean = true;
      public function SetCreationAssetArrayLocked (locked:Boolean):void
      {
         mIsCreationArrayOpened = ! locked;
      }
      
      public function AddAssetToCreationArray (asset:Asset):void
      {
         mNeedToCorrectAssetCreationIds = true;
         
         if (mIsCreationArrayOpened)
            mAssetsSortedByCreationId.push (asset);
      }
      
//============================================================================
// utils
//============================================================================
      
      public function GetNumAssets (filterFunc:Function = null):int
      {
         var numAssets:int = mAssetsSortedByCreationId.length;
         if ( filterFunc == null)
            return numAssets;
         
         var count:int = 0;
         var asset:Asset;
         for (var i:int = 0; i < numAssets; ++ i)
         {
            asset = GetAssetByCreationId (i);
            if (filterFunc (asset))
               ++ count;
         }
         
         return count;
      }
      
      public function GetAssetAppearanceId (asset:Asset):int
      {
         if (asset == null)
            return -1;
         
         // for speed, commented off
         //if (asset.GetContainer () != this)
         //   return -1;
         
         return asset.GetAppearanceLayerId ();
      }
      
      public function GetAssetCreationId (asset:Asset):int
      {
         if (asset == null)
            return -1;
         
         // for speed, commented off
         //if (asset.GetContainer () != this)
         //   return -1;
         
         return asset.GetCreationOrderId ();
      }
      
      public function AssetArray2AssetCreationIdArray (assets:Array):Array
      {
         if (assets == null)
            return null;
         
         var ids:Array = new Array (assets.length);
         for (var i:int = 0; i < assets.length; ++ i)
         {
            ids [i] = GetAssetCreationId (assets [i] as Asset);
         }
         
         return ids;
      }
      
      public function AssetCreationIdArray2AssetArray (ids:Array):Array
      {
         if (ids == null)
            return null;
         
         var assets:Array = new Array (ids.length);
         for (var i:int = 0; i < ids.length; ++ i)
         {
            assets [i] = GetAssetByCreationId (int (ids [i]));
         }
         
         return assets;
      }
      
//====================================================================
//   properties
//====================================================================
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
      
//====================================================================
//   interfaces between manager and UI
//====================================================================
      
      private var mAssetLinksChangedCallback:Function = null;
      
      public function SetAssetLinksChangedCallback (assetLinksChangedCallback:Function):void
      {
         mAssetLinksChangedCallback = assetLinksChangedCallback;
      } 
      
      public function GetAssetLinksChangedCallback ():Function
      {
         return mAssetLinksChangedCallback;
      }
   }
}
