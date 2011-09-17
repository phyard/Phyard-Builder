
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.geom.Rectangle;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
         
   import flash.net.FileReference;
   import flash.net.FileFilter;
   import flash.events.IOErrorEvent;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.LocalImageLoader;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import editor.image.dialog.AssetImageDivideDialog;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImagePureModule extends AssetImageModule
   {
      protected var mAssetImagePureModuleManager:AssetImagePureModuleManager;
      protected var mImageDivision:AssetImageDivision;
      
      public function AssetImagePureModule (assetImagePureModuleManager:AssetImagePureModuleManager, imageDivision:AssetImageDivision)
      {
         super (assetImagePureModuleManager);
         
         mAssetImagePureModuleManager = assetImagePureModuleManager;
         mImageDivision = imageDivision;
         mImageDivision.SetImagePureModule (this);
      }
      
      public function GetAssetImagePureModuleManager ():AssetImagePureModuleManager
      {
         return mAssetImagePureModuleManager;
      }
      
      public function GetImageDivision ():AssetImageDivision
      {
         return mImageDivision;
      }
      
      override public function ToCodeString ():String
      {
         return "Image Module#" + mCreationOrderId;
      }
      
      override public function GetTypeName ():String
      {
         return "Image Module";
      }
      
//=============================================================
//   
//=============================================================
      
      public function OnDivisionChanged ():void
      {
         UpdateAppearance ();
         
         NotifyModifiedForReferers ();
      }
      
//=============================================================
//   
//=============================================================
      
      override public function CreateModuleSprite ():DisplayObject
      {
         if (mImageDivision == null)
            return null;
         
         return mImageDivision.CreateSpriteForImagePureModule ();
      }
      
      override public function GetModuleBoundingRectangle ():Rectangle
      {
         if (mImageDivision == null)
            return null;
         
         return mImageDivision.GetBoundingRectangleForImagePureModule ();
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemEditModule:ContextMenuItem = new ContextMenuItem("Edit ...");
         
         menuItemEditModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_EditModule);
         
         customMenuItemsStack.push (menuItemEditModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_EditModule (event:ContextMenuEvent):void
      {
         if (mImageDivision != null)
         {
            AssetImageDivideDialog.ShowAssetImageDivideDialog (mImageDivision.GetAssetImageDivisionManager ().GetAssetImage ());
            mImageDivision.GetAssetImageDivisionManager ().SetSelectedAsset (mImageDivision);
            mAssetImagePureModuleManager.SetSelectedAsset (this);
         }
      }
      
  }
}