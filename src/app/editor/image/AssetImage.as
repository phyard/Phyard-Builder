
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
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.ResourceLoader;
   import com.tapirgames.util.ResourceLoadEvent;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import editor.image.dialog.AssetImageDivideDialog;
   
   import common.Transform2D;
   
   import common.Define;
   
   public class AssetImage extends AssetImageBitmapModule //AssetImageModule //Asset
   {
      protected var mAssetImageManager:AssetImageManager;
      
      protected var mAssetImageDivisionManager:AssetImageDivisionManager;
      
      private var mBitmapData:BitmapData = null;
      
      public function AssetImage (assetImageManager:AssetImageManager)
      {
         super (assetImageManager);
         
         mAssetImageManager = assetImageManager;
         
         mAssetImageDivisionManager = new AssetImageDivisionManager (this);
      }
      
      public function GetAssetImageManager ():AssetImageManager
      {
         return mAssetImageManager;
      }
      
      override public function GetImageModuleType ():int
      {  
         return AssetImageModule.ImageModuleType_WholeImage;
      }
      
      public function GetAssetImageDivisionManager ():AssetImageDivisionManager
      {
         return mAssetImageDivisionManager;
      }
      
      override public function ToCodeString ():String
      {
         return "Image#" + GetAppearanceLayerId ();
      }
      
      override public function GetTypeName ():String
      {
         return "Image";
      }
      
//======================================================
// 
//======================================================
      
      override public function Destroy ():void
      {
         super.Destroy ();
         
         mAssetImageDivisionManager.DestroyAllAssets ();
         if (mAssetImageDivideDialog != null)
         {
            mAssetImageDivideDialog.Hide ();
            mAssetImageDivideDialog = null;
         }
      }
      
//=============================================================
//   
//=============================================================
      
      private var mFileData:ByteArray;
         private var _FileData_Temp:ByteArray;
      
      public function CloneBitmapFileData ():ByteArray
      {
         if (mFileData == null)
            return null;
         
         var newByteArray:ByteArray = new ByteArray (); 
         newByteArray.writeBytes (mFileData, 0, mFileData.length);
         
         newByteArray.position = 0;
         return newByteArray;
      }
      
      public function SetBitmapFileData (fileData:ByteArray):void
      {
         mFileData = null;
         _FileData_Temp = fileData;
         
         mBitmapData = null;
         
         if (fileData != null)
         {
            var loader:ResourceLoader = new ResourceLoader ();
            loader.addEventListener (IOErrorEvent.IO_ERROR, OnLoadImageError);
            loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadImageError);
            loader.addEventListener (ResourceLoadEvent.RESOURCE_LOADED, OnLoadImageComplete);
            loader.loadImageFromByteArray (fileData);
         }
      }
      
      private function OnLoadImageComplete (event:Event):void
      {
         //var newBitmap:Bitmap = event.target.content as Bitmap;
         //var newBitmap:Bitmap = ((event.target.content.GetBitmap as Function) ()) as Bitmap;
         var newBitmap:Bitmap = (event as ResourceLoadEvent).resource as Bitmap;
         mBitmapData = newBitmap.bitmapData;
         
         mFileData = _FileData_Temp;
         
         NotifyPixelsChanged ();
      }
      
      // !!! This function is not triggered even if there are some errors in loading.
      // It seems flash doesn't trigger some errors.
      private function OnLoadImageError (event:Object):void
      {
         _FileData_Temp = null;
         
         NotifyPixelsChanged ();
      }
      
      override public function GetBitmapData ():BitmapData
      {
         return mBitmapData;
      }
      
      protected function NotifyPixelsChanged ():void
      {  
         UpdateAppearance ();
         
         mAssetImageDivisionManager.OnAssetImagePixelsChanged ();
         
         NotifyModifiedForReferers ();
      }
      
//=============================================================
//   
//=============================================================

      override public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         if (mBitmapData == null)
            return;
         
         var bitmap:Bitmap = new Bitmap (mBitmapData);
         
         if (transform != null)
            transform.TransformUntransformedDisplayObject (bitmap);
         
         container.addChild (bitmap);
      }
      
      override public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
      }
      
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         if (mBitmapData == null)
            return;
         
         selectionProxy.AddRectangleShape (0, 0, mBitmapData.width, mBitmapData.height, transform);
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemLoadImage:ContextMenuItem = new ContextMenuItem("(Re)load Local Image ...");
         //var menuItemClearImage:ContextMenuItem = new ContextMenuItem("Clear Image ...");
         var menuItemDivideImage:ContextMenuItem = new ContextMenuItem("Free Divide ...");
         //var menuItemDivideImage_TileSet:ContextMenuItem = new ContextMenuItem("Tile Set Divide ...");
         
         menuItemLoadImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_LoadImage);
         menuItemDivideImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_DivideImage);

         customMenuItemsStack.push (menuItemLoadImage);
         //customMenuItemsStack.push (menuItemClearImage);
         customMenuItemsStack.push (menuItemDivideImage);
         //customMenuItemsStack.push (menuItemDivideImage_TileSet);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_LoadImage (event:ContextMenuEvent):void
      {
         OpenLocalImageFileDialog ();
      }
      
      private function OnContextMenuEvent_DivideImage (event:ContextMenuEvent):void
      {
         AssetImageDivideDialog.ShowAssetImageDivideDialog (this);
      }
      
//=============================================================
//   
//=============================================================
      
      private var mAssetImageDivideDialog:AssetImageDivideDialog;
      
      public function SetAssetImageDivideDialog (assetImageDivideDialog:AssetImageDivideDialog):void
      {
         mAssetImageDivideDialog = assetImageDivideDialog;
      }
      
      public function GetAssetImageDivideDialog ():AssetImageDivideDialog
      {
         return mAssetImageDivideDialog;
      }
      
      public static const kFileFilter:Array = [new FileFilter("Image File (*.jpg;*.png;*.gif)", "*.jpg;*.jpeg;*.png;*.gif")];
      
      private var mFileReference:FileReference = null; 
      
      private function OpenLocalImageFileDialog ():void
      {
         mFileReference = new FileReference();
         mFileReference.addEventListener(Event.SELECT, OnSelectFileToLoad);
         mFileReference.addEventListener(Event.CANCEL, OnSelectFileCancelled);
         mFileReference.browse (kFileFilter);
      }
      
      private function OnSelectFileCancelled (event:Event):void
      {
         mFileReference = null;
      }
         
      private function OnSelectFileToLoad (event:Event):void
      {
         //var fileReference:FileReference = (event.target as FileReference); // flash bug: DON'T use this variable as a local variable, otherwise, the complete event will not fire.
         var fileReference:FileReference = mFileReference;
         fileReference.addEventListener(Event.COMPLETE, OnFileLoadComplete);
         fileReference.addEventListener(IOErrorEvent.IO_ERROR, OnFileLoadError);
         fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnFileLoadError);
         fileReference.load();
      }
      
      private function OnFileLoadError (event:Event):void
      {
         mFileReference = null;
      }
      
      public function OnFileLoadComplete (event:Event):void
      {
         //var fileReference:FileReference = (event.target as FileReference); // fuck, in brower, this doesn't work. But it is ok in standlone player.
         var fileReference:FileReference = mFileReference;
         try
         {
            var clonedImageData:ByteArray = new ByteArray ();
            clonedImageData.length = fileReference.data.length;
            
            fileReference.data.position = 0;
            clonedImageData.writeBytes (fileReference.data, 0, fileReference.data.length);
            
            OnLoadLocalImageFinished (clonedImageData, fileReference.name);
         }
         catch (e:Error)
         {
            trace ("local loading image error");
            trace (e.getStackTrace ());
         }
         fileReference.data.clear ();
         
         mFileReference = null;
      }
      
      public function OnLoadLocalImageFinished (imageData:ByteArray, imageFileName:String):void
      {
         SetBitmapFileData (imageData);
         if (mName == null || mName.length == 0)
         {
            SetName (imageFileName);
         }
      }

  }
}