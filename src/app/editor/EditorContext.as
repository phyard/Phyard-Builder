package editor {
   
   import flash.display.DisplayObject;
   
   import flash.ui.ContextMenuItem;
   import flash.events.ContextMenuEvent;
   
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   import flash.media.SoundMixer;
   
   import mx.core.Application;
   
   import com.tapirgames.util.UrlUtil;
   
   import editor.world.World;
   
   import editor.entity.Entity;
   
   import editor.asset.Asset;
   
   import editor.core.KeyboardListener;
   
   import editor.image.dialog.AssetImageModuleListDialog;
   import editor.image.AssetImageModule;
   import editor.sound.dialog.AssetSoundListDialog;
   import editor.ccat.dialog.CollisionCategoryListDialog;
   import editor.codelib.dialog.CodeLibListDialog;
   
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDefinition;
   
   import editor.trigger.entity.InputEntitySelector;
   
   import common.Define;
   import common.Version;
   
   public class EditorContext
   {
      
//=====================================================================
// static methods
//=====================================================================

   //=====================================================================
   // app
   //=====================================================================

      internal static var sEditorApp:Editor; // set by editor app
      
      public static function GetEditorApp ():Editor
      {
         return EditorContext.sEditorApp;
      }
      
   //=====================================================================
   //
   //=====================================================================
      
      // used in loading editor world
      public static var mPauseCreateShapeProxy:Boolean = false;
      
   //=====================================================================
   // sound
   //=====================================================================
      
      private static var mSoundVolume:Number = 0.5;
      
      public static function GetSoundVolume ():Number
      {
         return mSoundVolume;
      }
      
      public static function SetSoundVolume (volume:Number):void
      {
         if (volume < 0)
            volume = 0;
         if (volume > 1.0)
            volume = 1.0;
         
         mSoundVolume = volume;
      }
      
      public static function StopAllSounds ():void
      {
         SoundMixer.stopAll ();
      }
      
   //=====================================================================
   //
   //=====================================================================

      public static function GetVersionString ():String
      {
         var majorVersion:int = (Version.VersionNumber & 0xFF00) >> 8;
         var minorVersion:Number = (Version.VersionNumber & 0xFF) >> 0;
         
         return majorVersion.toString (16) + (minorVersion < 16 ? ".0" : ".") + minorVersion.toString (16);
      }

      public static function GetAboutContextMenuItem ():ContextMenuItem
      {
         var menuItemAbout:ContextMenuItem = new ContextMenuItem("About Phyard Builder v" + GetVersionString (), true);
         menuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnAbout);
         
         return menuItemAbout;
      }
      
      private static function OnAbout (event:ContextMenuEvent):void
      {
         UrlUtil.PopupPage (Define.AboutUrl);
      }
      
   //=====================================================================
   // singleton
   //=====================================================================
      
      internal static var sEditorContext:EditorContext = null; //
      
      public static function GetSingleton ():EditorContext
      {
         return sEditorContext;
      }
      
//=====================================================================
// non-static methods
//=====================================================================
      
   //=====================================================================
   // 
   //=====================================================================
      /*
      // call this before loading a new world
      public function Cleanup ():void
      {
         SetKeyboardListener (null);
         
         Asset.mNextActionId = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
         Entity.mNextActionId = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
         if (AssetImageModuleListDialog.sAssetImageModuleListDialog != null)
         {
            AssetImageModuleListDialog.HideAssetImageModuleListDialog ();
            AssetImageModuleListDialog.sAssetImageModuleListDialog = null;
         }
         AssetImageModule.mCurrentAssetImageModule = null;
         if (AssetSoundListDialog.sAssetSoundListDialog != null)
         {
            AssetSoundListDialog.HideAssetSoundListDialog ();
            AssetSoundListDialog.sAssetSoundListDialog = null;
         }
         if (CollisionCategoryListDialog.sCollisionCategoryListDialog != null)
         {
            CollisionCategoryListDialog.HideCollisionCategoryListDialog ();
            CollisionCategoryListDialog.sCollisionCategoryListDialog = null;
         }
         if (CodeLibListDialog.sCodeLibListDialog != null)
         {
            CodeLibListDialog.HideCodeLibListDialog ();
            CodeLibListDialog.sCodeLibListDialog = null;
         }
         InputEntitySelector.sNotifyEntityLinksModified = null;
         
         mHasSettingDialogOpened = false;
         mHasInputFocused = false;
         
         mSessionVariablesEditingDialogClosedCallBack = null;
         mGlobalVariablesEditingDialogClosedCallBack = null;
         mEntityVariablesEditingDialogClosedCallBack = null;
         mLocalVariablesEditingDialogClosedCallBack = null;
         mInputVariablesEditingDialogClosedCallBack = null;
         mOutputVariablesEditingDialogClosedCallBack = null;
         
         // ...
         StopAllSounds ();
      }
      */
   //=====================================================================
   //
   //=====================================================================
      
      private static var mDesignFilename:String  = null;
      
      public static function SetRecommandDesignFilename (filename:String):void
      {
         mDesignFilename = filename;
      }
      
      public static function GetTimeStringInFilename ():String
      {
         var date:Date = new Date ();
         return "[" 
               + date.getFullYear () + "-" 
               + (date.getMonth () < 9 ? "0" + (date.getMonth () + 1) : (date.getMonth () + 1)) + "-"
               + (date.getDate () < 10 ? "0" + date.getDate () : date.getDate ())
               + " " + (date.getHours () < 10 ? "0" + date.getHours () : date.getHours ())
               + "." + (date.getMinutes () < 10 ? "0" + date.getMinutes () : date.getMinutes ())
               + "." + (date.getSeconds () < 10 ? "0" + date.getSeconds () : date.getSeconds ())
               + "]";
      }
      
      public static function GetRecommandDesignFilename ():String
      {
         if (mDesignFilename == null)
         {
            mDesignFilename = GetTimeStringInFilename () + " {design name}.phyardx";
         }
         
         return mDesignFilename;
      }
      
      
      private static var mIsMouseButtonHold:Boolean = false;
      
      public static function SetMouseButtonHold (hold:Boolean):void
      {
         mIsMouseButtonHold = hold;
      }
      
      public static function IsMouseButtonHold ():Boolean
      {
         return mIsMouseButtonHold;
      }
      
   //=====================================================================
   //
   //=====================================================================
      
      private static var mHasSettingDialogOpened:Boolean = false;
      
      public static function SetHasSettingDialogOpened (opened:Boolean):void
      {
         mHasSettingDialogOpened = opened;
      }
      
      public static function HasSettingDialogOpened ():Boolean
      {
         return mHasSettingDialogOpened;
      }
      
      private static var mHasInputFocused:Boolean = false;
      
      public static function SetHasInputFocused (has:Boolean):void
      {
         mHasInputFocused = has;
      }
      
      public static function HasInputFocused ():Boolean
      {
         return mHasInputFocused;
      }
      
//=====================================================================
//
//=====================================================================static
      
      public static function OnOpenDialog ():void
      {
         EditorContext.SetHasSettingDialogOpened (true);
         EditorContext.GetSingleton ().StartSettingEntityProperties ();
      }
      
      public static function OnCloseDialog (checkCustomVariablesModifications:Boolean = false):void
      {
         EditorContext.SetHasSettingDialogOpened (false);
         EditorContext.GetEditorApp ().stage.focus = EditorContext.GetEditorApp ().stage;
         
         if (checkCustomVariablesModifications)
         {
            EditorContext.GetSingleton ().CancelSettingEntityProperties ();
         }
      }
      
//=====================================================================
//   key listener
//=====================================================================
      
      public static function OnKeyDown (event:KeyboardEvent):void
      {
         switch (event.keyCode)
         {
            case Keyboard.F3:
               AssetImageModuleListDialog.ShowAssetImageModuleListDialog ();
               break;
            case Keyboard.F4:
               AssetSoundListDialog.ShowAssetSoundListDialog ();
               break;
            case Keyboard.F5:
               CollisionCategoryListDialog.ShowCollisionCategoryListDialog ();
               break;
            case Keyboard.F6:
               CodeLibListDialog.ShowCodeLibListDialog ();
               break;
         }
            
         if (HasSettingDialogOpened ())
            return;
         
         if (HasInputFocused ())
            return;
         
         if (mKeyboardListener == null)
         {
            EditorContext.GetEditorApp ().GetCurrentSceneEditPanel ().OnKeyDown (event);
         }
         else
         {
            mKeyboardListener.OnKeyDown (event);
         }
      }
      
      private static var mKeyboardListener:KeyboardListener = null;
      
      public static function SetKeyboardListener (keyboardListener:KeyboardListener):void
      {
         mKeyboardListener = keyboardListener;
      }
      
      public static function GetKeyboardListener ():KeyboardListener
      {
         return mKeyboardListener;
      }
      
//=====================================================================
//
//=====================================================================
      
      public static var mLongerCodeEditorMenuBar:Boolean = false;
      public static var mPoemCodingFormat:Boolean = false;
      
      public var mSessionVariablesEditingDialogClosedCallBack:Function = null;
      public var mGlobalVariablesEditingDialogClosedCallBack:Function = null;
      public var mEntityVariablesEditingDialogClosedCallBack:Function = null;
      public var mLocalVariablesEditingDialogClosedCallBack:Function = null;
      public var mInputVariablesEditingDialogClosedCallBack:Function = null;
      public var mOutputVariablesEditingDialogClosedCallBack:Function = null;
      
   //=====================================================================
   // todo: use defines instead so that the (static) copied snippet can be used across worlds.
   //=====================================================================
      
      private var mCopiedCodeSnippet:CodeSnippet = null;
      
      public function ClearCopiedCodeSnippet ():void
      {
         mCopiedCodeSnippet = null;
      }
      
      public function HasCopiedCodeSnippet ():Boolean
      {
         return mCopiedCodeSnippet != null;
      }
      
      public function SetCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition, copiedCallings:Array):void
      {
         if (copiedCallings == null || copiedCallings.length == 0)
         {
             ClearCopiedCodeSnippet ();
         }
         else
         {
            var codeSnippet:CodeSnippet =  new CodeSnippet (ownerFunctionDefinition);
            codeSnippet.AssignFunctionCallings (copiedCallings);
            codeSnippet.PhysicsValues2DisplayValues (EditorContext.GetEditorApp ().GetWorld ().GetEntityContainer ().GetCoordinateSystem ());
            
            mCopiedCodeSnippet = codeSnippet.Clone(ownerFunctionDefinition.Clone ());
         }
      }
      
      public function CloneCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition):CodeSnippet
      {
         if (mCopiedCodeSnippet == null)
         {
            return null;
         }
         else
         {
            mCopiedCodeSnippet.ValidateCallings ();
            
            var codeSnippet:CodeSnippet = mCopiedCodeSnippet.Clone (ownerFunctionDefinition);
            codeSnippet.DisplayValues2PhysicsValues (EditorContext.GetEditorApp ().GetWorld ().GetEntityContainer ().GetCoordinateSystem ());
            
            return codeSnippet;
         }
      }
      
   //=====================================================================
   // hooks to detect if any variable definitions are changed
   //=====================================================================
      
      private var mLastSessionVariableSpaceModifiedTimes:int = 0;
      private var mLastGlobalVariableSpaceModifiedTimes:int = 0;
      private var mLastEntityVariableSpaceModifiedTimes:int = 0;
      
      public function StartSettingEntityProperties ():void
      {
         mLastSessionVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetSessionVariableSpace ().GetNumModifiedTimes ();
         mLastGlobalVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes ();
         mLastEntityVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes ();
      }
      
      public function CancelSettingEntityProperties ():void
      {
         var sessionVariableSpaceModified:Boolean = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetSessionVariableSpace ().GetNumModifiedTimes () > mLastSessionVariableSpaceModifiedTimes;
         var globalVariableSpaceModified:Boolean = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes () > mLastGlobalVariableSpaceModifiedTimes;
         var entityVariableSpaceModified:Boolean = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes () > mLastEntityVariableSpaceModifiedTimes;
         
         if (sessionVariableSpaceModified || globalVariableSpaceModified || entityVariableSpaceModified)
         {
            var message:String = "Custom variables (";
            
            var first:Boolean = true;
            if (sessionVariableSpaceModified)
            {
               message = message + "session";
               first = false;
            }
            if (globalVariableSpaceModified)
            {
               message = message + (first ? "global" : (entityVariableSpaceModified ? ", global" : "and global"));
               first = false;
            }
            if (entityVariableSpaceModified)
            {
               message = message + (first ? "entity property" : "and entity property");
               first = false;
            }
            
            message = message + ") are modified";
         }
      }

   }
   
}
