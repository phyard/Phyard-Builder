
package editor.entity.dialog {
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.EventPhase;
   
   import flash.utils.Dictionary;
   import flash.utils.ByteArray;
   import flash.system.Capabilities;
   
   import flash.display.LoaderInfo;
   
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Graphics;
   
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import flash.system.System;
   import flash.system.ApplicationDomain;
   
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   //import flash.ui.MouseCursor;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.net.navigateToURL;
   
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.Alert;
   import mx.events.CloseEvent;
   //import mx.events.FlexEvent;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.FpsStat;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.MathUtil;
   import com.tapirgames.util.SystemUtil;
   
   import com.tapirgames.util.Logger;
   
   //import beziercurves.events.BezierEvent;
   //import beziercurves.BezierCurve;
   
   import editor.mode.Mode;
   import editor.mode.ModeCreateRectangle;
   import editor.mode.ModeCreateCircle;
   import editor.mode.ModeCreatePolygon;
   import editor.mode.ModeCreatePolyline;
   
   import editor.mode.ModeCreateJoint;
   
   import editor.mode.ModePlaceCreateEntity;
   
   import editor.mode.ModeRegionSelectEntities;
   import editor.mode.ModeMoveSelectedEntities;
   
   import editor.mode.ModeRotateSelectedEntities;
   import editor.mode.ModeScaleSelectedEntities;
   
   import editor.mode.ModeMoveSelectedVertexControllers;
   
   import editor.mode.ModeMoveWorldScene;
   
   import editor.mode.ModeCreateEntityLink;
   
   import editor.EditorContext;
   import editor.core.KeyboardListener;
   
   import editor.display.sprite.CursorCrossingLine;
   import editor.display.sprite.EditingEffect
   import editor.display.sprite.EffectCrossingAiming;
   import editor.display.sprite.EffectMessagePopup;
   
   import editor.entity.Entity;
   
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeImageModule;
   import editor.entity.EntityShapeImageModuleButton;

   import editor.entity.EntityVectorShape;
   import editor.entity.EntityVectorShapeCircle;
   import editor.entity.EntityVectorShapeRectangle;
   import editor.entity.EntityVectorShapePolygon;
   import editor.entity.EntityVectorShapePolyline;
   import editor.entity.EntityVectorShapeText;
   import editor.entity.EntityVectorShapeTextButton;
   import editor.entity.EntityVectorShapeGravityController;
   
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   import editor.entity.EntityJointWeld;
   import editor.entity.EntityJointDummy;
   
   import editor.entity.SubEntityJointAnchor;
   import editor.entity.SubEntityHingeAnchor;
   import editor.entity.SubEntitySliderAnchor;
   import editor.entity.SubEntityDistanceAnchor;
   import editor.entity.SubEntitySpringAnchor;
   import editor.entity.SubEntityWeldAnchor;
   import editor.entity.SubEntityDummyAnchor;
   
   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   import editor.entity.EntityUtilityPowerSource;
   
   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityInputEntityScriptFilter;
   import editor.trigger.entity.EntityInputEntityPairScriptFilter;
   import editor.trigger.entity.EntityInputEntityRegionSelector;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_TimerWithPrePostHandling;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   import editor.trigger.entity.EntityEventHandler_JointReachLimit;
   import editor.trigger.entity.EntityEventHandler_ModuleLoopToEnd;
   import editor.trigger.entity.EntityEventHandler_GameLostOrGotFocus;
   import editor.trigger.entity.EntityAction;
   
   import editor.trigger.entity.InputEntitySelector;
   
   import editor.trigger.CodeSnippet;
   
   import editor.entity.VertexController;
   
   //import editor.entity.EntityCollisionCategory;
   import editor.ccat.CollisionCategory;
   import editor.ccat.CollisionCategoryManager;
   import editor.ccat.dialog.CollisionCategoryListDialog;
   
   import editor.world.World;
   //import editor.world.CollisionManager;
   import editor.undo.WorldHistoryManager;
   import editor.undo.WorldState;
   
   import editor.world.EntityContainer;
   
   import editor.ccat.CollisionCategoryManager;
   
   import editor.trigger.entity.Linkable;
   
   import editor.trigger.Filters;
   
   //import editor.display.panel.CollisionManagerView;
   //import editor.display.panel.FunctionEditingView;
   import editor.codelib.dialog.CodeLibListDialog;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   import editor.asset.AssetManagerPanel;
   
   import player.world.World;
   
   import viewer.Viewer;
   
   import common.WorldDefine;
   import common.DataFormat;
   import common.DataFormat2;
   import common.DataFormat3;
   import common.Define;
   import common.Config;
   import common.Version;
   import common.ValueAdjuster;
   
   import common.trigger.CoreEventIds;
   import common.KeyCodes;
   
   //import misc.Analytics;
   
   public class WorldView extends AssetManagerPanel // UIComponent implements KeyboardListener
   {
      public static const DefaultWorldWidth:int = Define.DefaultWorldWidth; 
      public static const DefaultWorldHeight:int = Define.DefaultWorldHeight;
      public static const WorldBorderThinknessLR:int = Define.WorldBorderThinknessLR;
      public static const WorldBorderThinknessTB:int = Define.WorldBorderThinknessTB;
      
      public static const BackgroundGridSize:int = 50;
      
      
      private var mEditiingViewContainer:Sprite;
      private var mPlayingViewContainer:Sprite;
      
         public var mViewBackgroundSprite:Sprite = null;
         
         private var mEditorElementsContainer:Sprite;
         
            public var mEditorBackgroundLayer:Sprite = null;
               public var mEntityLinksLayer:Sprite = null;
            public var mContentLayer:Sprite;
            public var mForegroundLayer:Sprite;
               public var mWorldDebugInfoLayer:Sprite;
               private var mEntityIdsLayer:Sprite;
               private var mSelectedEntitiesCenterSprite:Sprite;
            private var mEditingEffectLayer:Sprite;
            public var mCursorLayer:Sprite;
            
         private var mPlayerElementsContainer:Sprite;
         private var mFloatingMessageLayer:Sprite;
         
      //
      
      //
      //public var mCollisionManagerView:CollisionManagerView = null;
      
      //
      //private var EditorContext.GetEditorApp ().GetWorld ():editor.world.World;
      private var mEntityContainer:EntityContainer;
      
         private var mViewCenterWorldX:Number = DefaultWorldWidth * 0.5;
         private var mViewCenterWorldY:Number = DefaultWorldHeight * 0.5;
         private var mEntityContainerZoomScale:Number = 1.0;
         private var mEntityContainerZoomScaleChangedSpeed:Number = 0.0;
         
         private var mViewWidth:Number        = DefaultWorldWidth;
         private var mViewHeight:Number       = DefaultWorldHeight;
      
      private var mWorldHistoryManager:WorldHistoryManager;
      
      private var mDesignPlayer:Viewer = null;
         
      // ...
      private var mAnalyticsDurations:Array = [0.5, 1, 2, 5, 10, 15, 20, 30];
      //private var mAnalytics:Analytics;
      
   //===========================================================================
      
      public function WorldView ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener (Event.RESIZE, OnResize);
         
         //
         mEditiingViewContainer = new Sprite ();
         mPlayingViewContainer = new Sprite ();
         addChild (mEditiingViewContainer);
         addChild (mPlayingViewContainer);
         mPlayingViewContainer.visible = false;
         
         //
         mViewBackgroundSprite = new Sprite ();
         mEditiingViewContainer.addChild (mViewBackgroundSprite);
         
         //
         mEditorElementsContainer = new Sprite ();
         mEditiingViewContainer.addChild (mEditorElementsContainer);
         
         //
         mContentLayer = new Sprite ();
         mEditorElementsContainer.addChild (mContentLayer);
         
         mForegroundLayer = new Sprite ();
         mEditorElementsContainer.addChild (mForegroundLayer);
            
            mWorldDebugInfoLayer = new Sprite ();
            mForegroundLayer.addChild (mWorldDebugInfoLayer);
            
            mEntityIdsLayer = new Sprite ();
            mForegroundLayer.addChild (mEntityIdsLayer);
            
            mSelectedEntitiesCenterSprite = new Sprite ();
            mSelectedEntitiesCenterSprite.alpha = 0.25;
            mSelectedEntitiesCenterSprite.visible = false;
            mSelectedEntitiesCenterSprite.graphics.beginFill(0x000000);
            mSelectedEntitiesCenterSprite.graphics.drawCircle (0, 0, 6);
            mSelectedEntitiesCenterSprite.graphics.endFill ();
            mSelectedEntitiesCenterSprite.graphics.beginFill(0x00FF00);
            mSelectedEntitiesCenterSprite.graphics.drawCircle (0, 0, 5);
            mSelectedEntitiesCenterSprite.graphics.endFill ();
            mSelectedEntitiesCenterSprite.graphics.beginFill(0x000000);
            mSelectedEntitiesCenterSprite.graphics.drawCircle (0, 0, 2);
            mSelectedEntitiesCenterSprite.graphics.endFill ();
            mForegroundLayer.addChild (mSelectedEntitiesCenterSprite);
            
         mEditingEffectLayer = new Sprite ();
         mEditorElementsContainer.addChild (mEditingEffectLayer);
         
         mCursorLayer = new Sprite ();
         mEditorElementsContainer.addChild (mCursorLayer);
         
         //
         mFloatingMessageLayer = new Sprite ();
         mFloatingMessageLayer.visible = true;
         mEditiingViewContainer.addChild (mFloatingMessageLayer);
         
         //
         mPlayerElementsContainer = new Sprite ();
         mPlayingViewContainer.addChild (mPlayerElementsContainer);
         
         //
         mWorldHistoryManager = new WorldHistoryManager ();
         
         //
         BuildContextMenu ();
      }
      
      public function GetEditorWorld ():editor.world.World
      {
         return EditorContext.GetEditorApp ().GetWorld ();
      }
      
      private function RegisterNotifyFunctions ():void
      {
         InputEntitySelector.sNotifyEntityLinksModified = NotifyEntityLinksModified;
      }
      
//============================================================================
//   online save . load
//============================================================================
      
      private var mIsOnlineEditing:Boolean = false;
      
      private var mOriginalFPS:Number = 30;
      
      public function IsOnlineEditing ():Boolean
      {
         return mIsOnlineEditing;
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         //..
         mOriginalFPS = stage.frameRate;
         
         // ...
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         addEventListener (MouseEvent.CLICK, OnMouseClick);
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         addEventListener (MouseEvent.ROLL_OVER, OnMouseOut);
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         // now Put in EditorContext
         //stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
         
         // ...
         UpdateUiButtonsEnabledStatus ();
         
         //
         //mAnalytics = new Analytics (this, mAnalyticsDurations);
         //mAnalytics.TrackPageview (Config.VirtualPageName_EditorJustLoaded);
         
         //
         mIsOnlineEditing = OnlineLoad (true);
      }
      
      private var mContentMaskSprite:Shape = null;
      
      private function OnResize (event:Event):void 
      {
         mViewWidth  = parent.width;
         mViewHeight = parent.height;
         
         mViewBackgroundSprite.graphics.clear ();
         mViewBackgroundSprite.graphics.beginFill(0xFFFFFF);
         mViewBackgroundSprite.graphics.drawRect (0, 0, mViewWidth, mViewHeight);
         mViewBackgroundSprite.graphics.endFill ();
         
         // mask
         {
            if (mContentMaskSprite == null)
               mContentMaskSprite = new Shape ();
            
            mContentMaskSprite.graphics.clear ();
            mContentMaskSprite.graphics.beginFill(0x0);
            mContentMaskSprite.graphics.drawRect (0, 0, mViewWidth, mViewHeight);
            mContentMaskSprite.graphics.endFill ();
            mContentLayer.addChild (mContentMaskSprite);
            
            this.mask = mContentMaskSprite;
         }
         
         //
         UpdateChildComponents ();
         
         // ...
         if ( IsPlaying () )
         {
            UpdateDesignPalyerPosition ();
         }
      }
      
      private var mFpsStat:FpsStat = new FpsStat ();
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function OnEnterFrame (event:Event):void 
      {
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         mFpsStat.Step (mStepTimeSpan.GetLastSpan ());
         
         //
         try
         {
            var newScale:Number;
            
            
            if ( IsPlaying () )
            {
               // mDesignPlayer.Update
               // will call mDesignPlayer.EnterFrame ()
               
               //
               var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld () as player.world.World;
               var playingSteps:int = playerWorld == null ? 0 : playerWorld.GetSimulatedSteps ();
               StatusBar_SetRunningSteps ("Step#" + playingSteps);
               StatusBar_SetRunningFPS ("FPS: " + mFpsStat.GetFps ().toFixed (2));
            }
            else
            {
               if (mEntityContainer.scaleX != mEntityContainerZoomScale)
               {
                  if (mEntityContainer.scaleX < mEntityContainerZoomScale)
                  {
                     if (mEntityContainerZoomScaleChangedSpeed < 0)
                        mEntityContainerZoomScaleChangedSpeed = - mEntityContainerZoomScaleChangedSpeed;
                     
                     newScale = mEntityContainer.scaleX + mEntityContainerZoomScaleChangedSpeed;
                     mEntityContainer.scaleY = mEntityContainer.scaleX = newScale;
                     
                     if (mEntityContainer.scaleX >= mEntityContainerZoomScale)
                     {
                        mEntityContainer.SetZoomScale (mEntityContainerZoomScale);
                        NotifyEntityLinksModified ();
                        NotifyEntityIdsModified ();
                     }
                     
                     if (NotifyEditingScaleChanged != null)
                        NotifyEditingScaleChanged ();
                     
                     UpdateBackgroundAndWorldPosition ();
                  }
                  else if (mEntityContainer.scaleX > mEntityContainerZoomScale)
                  {
                     if (mEntityContainerZoomScaleChangedSpeed > 0)
                        mEntityContainerZoomScaleChangedSpeed = - mEntityContainerZoomScaleChangedSpeed;
                     
                     newScale = mEntityContainer.scaleX + mEntityContainerZoomScaleChangedSpeed;
                     mEntityContainer.scaleY = mEntityContainer.scaleX = newScale;
                     
                     if (mEntityContainer.scaleX <= mEntityContainerZoomScale)
                     {
                        mEntityContainer.SetZoomScale (mEntityContainerZoomScale);
                        NotifyEntityLinksModified ();
                        NotifyEntityIdsModified ();
                     }
                     
                     if (NotifyEditingScaleChanged != null)
                        NotifyEditingScaleChanged ();
                     
                     UpdateBackgroundAndWorldPosition ();
                  }
               }
               
               mEntityContainer.Update (mStepTimeSpan.GetLastSpan ());
               
               RepaintEntityLinks ();
               RepaintEntityIds ();
               
               UpdateEffects ();
            }
         }
         catch (error:Error)
         {
            if (IsPlaying ())
               HandlePlayingError (error);
            else
               HandleEditingError (error);
         }
         
         // ...
         //mAnalytics.TrackTime (Config.VirtualPageName_EditorTimePrefix);
      }
      
      private function SynchronizePositionAndScaleWithEditorWorld (sprite:Sprite):void
      {
            sprite.scaleX = mEntityContainer.scaleX;
            sprite.scaleY = mEntityContainer.scaleY;
            sprite.x = mEntityContainer.x;
            sprite.y = mEntityContainer.y;
      }
      
//==================================================================================
// painted interfaces
//==================================================================================
      
      public function GetViewWidth ():Number
      {
         return mViewWidth;
      }
      
      public function GetViewHeight ():Number
      {
         return mViewHeight;
      }
      
      public function UpdateChildComponents ():void
      {
         UpdateBackgroundAndWorldPosition ();
         //UpdateViewInterface ();
         UpdateSelectedEntityInfo ();
      }
      
      public function UpdateBackgroundAndWorldPosition ():void
      {
         if (mEditorBackgroundLayer == null)
         {
            mEditorBackgroundLayer = new Sprite ();
            mEditorElementsContainer.addChildAt (mEditorBackgroundLayer, 0);
            
            mEntityLinksLayer = new Sprite ();
            mEditorBackgroundLayer.addChild (mEntityLinksLayer);
         }
         
         if (mEntityContainer == null)
            return;
         
         var sceneLeft  :Number;
         var sceneTop   :Number;
         var sceneWidth :Number;
         var sceneHeight:Number;
         
         if (mEntityContainer.IsInfiniteSceneSize ())
         {
            sceneLeft   = -1000000000; // about halft of - 0x7FFFFFFF;
            sceneTop    = - 1000000000; // about half of - 0x7FFFFFFF;
            sceneWidth  = 2000000000; // about half of uint (0xFFFFFFFF);
            sceneHeight = 2000000000; // about half of uint (0xFFFFFFFF);
         }
         else
         {
            sceneLeft   = mEntityContainer.GetWorldLeft ();
            sceneTop    = mEntityContainer.GetWorldTop ();
            sceneWidth  = mEntityContainer.GetWorldWidth ();
            sceneHeight = mEntityContainer.GetWorldHeight ();
         }
         
         var bgColor    :uint = mEntityContainer.GetBackgroundColor ();
         var borderColor:uint = mEntityContainer.GetBorderColor ();
         var drawBorder:Boolean = mEntityContainer.IsBuildBorder ();
         
         if (mViewCenterWorldX < sceneLeft)
            mViewCenterWorldX = sceneLeft;
         if (mViewCenterWorldX > sceneLeft + sceneWidth)
            mViewCenterWorldX = sceneLeft + sceneWidth;
         if (mViewCenterWorldY < sceneTop)
            mViewCenterWorldY = sceneTop;
         if (mViewCenterWorldY > sceneTop + sceneHeight)
            mViewCenterWorldY = sceneTop + sceneHeight;
         
         mEntityContainer.SetCameraCenterX (mViewCenterWorldX);
         mEntityContainer.SetCameraCenterY (mViewCenterWorldY);
         
         //mEntityContainer.SetZoomScale (mEntityContainerZoomScale);
         
         var worldOriginViewX:Number = (0 - mViewCenterWorldX) * mEntityContainer.scaleX + mViewWidth  * 0.5;
         var worldOriginViewY:Number = (0 - mViewCenterWorldY) * mEntityContainer.scaleY + mViewHeight * 0.5;
         var worldViewLeft:Number   = (sceneLeft - mViewCenterWorldX) * mEntityContainer.scaleX + mViewWidth  * 0.5;
         var worldViewTop:Number    = (sceneTop  - mViewCenterWorldY) * mEntityContainer.scaleY + mViewHeight * 0.5;
         var worldViewRight:Number  = worldViewLeft + sceneWidth  * mEntityContainer.scaleX;
         var worldViewBottom:Number = worldViewTop  + sceneHeight * mEntityContainer.scaleY;
         var worldViewWidth:Number  = sceneWidth  * mEntityContainer.scaleX;
         var worldViewHeight:Number = sceneHeight * mEntityContainer.scaleY;
         
         mEntityContainer.x = Math.round (worldOriginViewX);
         mEntityContainer.y = Math.round (worldOriginViewY);
         
         //>>
         var adjustDx:Number = Math.round (worldOriginViewX) - worldOriginViewX;
         var adjustDy:Number = Math.round (worldOriginViewY) - worldOriginViewY;
         
         worldOriginViewX += adjustDx;
         worldOriginViewY += adjustDy;
         worldViewLeft += adjustDx;
         worldViewTop += adjustDy;
         worldViewRight += adjustDx;
         worldViewBottom += adjustDy;
         
         mEntityContainer.x += adjustDx;
         mEntityContainer.y += adjustDy;
         //<<
         
         //SynchrinizePlayerWorldWithEditorWorld ();
         UpdateSelectedEntitiesCenterSprite ();
         
         var bgLeft:Number   = worldViewLeft   < 0           ? 0           : worldViewLeft;
         var bgTop:Number    = worldViewTop    < 0           ? 0           : worldViewTop;
         var bgRight:Number  = worldViewRight  > mViewWidth  ? mViewWidth  : worldViewRight;
         var bgBottom:Number = worldViewBottom > mViewHeight ? mViewHeight : worldViewBottom;
         var bgWidth :Number = bgRight - bgLeft;
         var bgHeight:Number = bgBottom - bgTop;
         
         var gridWidth:Number  = BackgroundGridSize * mEntityContainer.scaleX;
         var gridHeight:Number = BackgroundGridSize * mEntityContainer.scaleY;
         
         var gridX:Number;
         if (bgLeft == worldViewLeft)
            gridX = bgLeft;
         else
            gridX = bgLeft + (gridWidth - (bgLeft - worldViewLeft) % gridWidth);
         var gridY:Number;
         if (bgTop == worldViewTop)
            gridY = bgTop;
         else
            gridY = bgTop  + (gridHeight - (bgTop  - worldViewTop) % gridHeight);
         
      // paint
         
         mEditorBackgroundLayer.graphics.clear ();
         
         mEditorBackgroundLayer.graphics.beginFill(bgColor);
         mEditorBackgroundLayer.graphics.drawRect (bgLeft, bgTop, bgWidth, bgHeight);
         mEditorBackgroundLayer.graphics.endFill ();
         
         mEditorBackgroundLayer.graphics.lineStyle (1, 0xA0A0A0);
         while (gridX <= bgRight)
         {
            mEditorBackgroundLayer.graphics.moveTo (gridX, bgTop);
            mEditorBackgroundLayer.graphics.lineTo (gridX, bgBottom);
            gridX += gridWidth;
         }
         
         while (gridY <= bgBottom)
         {
            mEditorBackgroundLayer.graphics.moveTo (bgLeft, gridY);
            mEditorBackgroundLayer.graphics.lineTo (bgRight, gridY);
            gridY += gridHeight;
         }
         mEditorBackgroundLayer.graphics.lineStyle ();
         
         if (drawBorder)
         {
            var borderThinknessL:Number = mEntityContainer.GetWorldBorderLeftThickness () * mEntityContainer.scaleX;
            var borderThinknessR:Number = mEntityContainer.GetWorldBorderRightThickness () * mEntityContainer.scaleX;
            var borderThinknessT:Number = mEntityContainer.GetWorldBorderTopThickness () * mEntityContainer.scaleY;
            var borderThinknessB:Number = mEntityContainer.GetWorldBorderBottomThickness () * mEntityContainer.scaleY;
            
            mEditorBackgroundLayer.graphics.beginFill(borderColor);
            mEditorBackgroundLayer.graphics.drawRect (worldViewLeft, worldViewTop, borderThinknessL, worldViewHeight);
            mEditorBackgroundLayer.graphics.drawRect (worldViewRight - borderThinknessR, worldViewTop, borderThinknessR, worldViewHeight);
            mEditorBackgroundLayer.graphics.endFill ();
            
            mEditorBackgroundLayer.graphics.beginFill(borderColor);
            mEditorBackgroundLayer.graphics.drawRect (worldViewLeft, worldViewTop, worldViewWidth, borderThinknessT);
            mEditorBackgroundLayer.graphics.drawRect (worldViewLeft, worldViewBottom - borderThinknessB, worldViewWidth, borderThinknessB);
            mEditorBackgroundLayer.graphics.endFill ();
         }
      }
      
      public function UpdateSelectedEntityInfo ():void
      {
         // ...
         if (mLastSelectedEntity != null && ! mEntityContainer.IsEntitySelected (mLastSelectedEntity))
            SetLastSelectedEntities (null);
         
         if (mMainSelectedEntity == null)
         {
            if (StatusBar_SetMainSelectedEntityInfo != null)
               StatusBar_SetMainSelectedEntityInfo (null);
            return;
         }
         
         var mainEntity:Entity = mMainSelectedEntity.GetMainEntity ();
         var typeName:String = mMainSelectedEntity.GetTypeName ();
         var infoText:String = mMainSelectedEntity.GetInfoText ();
         
         if (infoText == null || infoText.length == 0)
            infoText = "</b>";
         else
            infoText = "</b>: " + infoText;
         
         if (mainEntity != mMainSelectedEntity)
         {
            infoText = " (of &lt;" + mEntityContainer.GetEntityCreationId (mainEntity) + "&gt; " + mainEntity.GetTypeName () + ")" + infoText;
         }
         infoText = "<b>&lt;" + mEntityContainer.GetEntityCreationId (mMainSelectedEntity) + "&gt; " + mMainSelectedEntity.GetTypeName () + infoText;
         
         StatusBar_SetMainSelectedEntityInfo (infoText);
      }
      
      private function UpdateMousePointInfo (stagePoint:Point):void
      {
         if (stagePoint == null)
         {
            StatusBar_SetMainDisplayPosition (null);
            StatusBar_SetMainPhysicsPosition (null);
            return;
         }
         
         var px:Number;
         var py:Number;
         var worldPoint:Point;
         
         if ( IsPlaying () )
         {
            if (mDesignPlayer != null)
            {
               var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld () as player.world.World;
               if (playerWorld != null)
               {
                  worldPoint = playerWorld.globalToLocal (new Point (stagePoint.x, stagePoint.y));
                  px = ValueAdjuster.Number2Precision (playerWorld.GetCoordinateSystem ().D2P_PositionX (worldPoint.x), 6);
                  py = ValueAdjuster.Number2Precision (playerWorld.GetCoordinateSystem ().D2P_PositionY (worldPoint.y), 6);
               }
            }
         }
         else
         {
            worldPoint = mEntityContainer.globalToLocal (new Point (Math.round(stagePoint.x), Math.round (stagePoint.y)));
            px = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (worldPoint.x), 6);
            py = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (worldPoint.y), 6);
         }
         
         StatusBar_SetMainDisplayPosition ("(" + worldPoint.x + "px, " + worldPoint.y + "px)");
         StatusBar_SetMainPhysicsPosition ("(" + px.toFixed (2) + "m,  " + py.toFixed (2) + "m)");
      }
      
      private function UpdateSelectedEntitiesCenterSprite ():void
      {
         //var point:Point = DisplayObjectUtil.LocalToLocal (mEntityContainer, this, _SelectedEntitiesCenterPoint );
         var point:Point = DisplayObjectUtil.LocalToLocal (mEntityContainer, mForegroundLayer, _SelectedEntitiesCenterPoint );
         mSelectedEntitiesCenterSprite.x = point.x;
         mSelectedEntitiesCenterSprite.y = point.y;
      }
      
      private var mEntityLinksModified:Boolean = false;
      
      public function NotifyEntityLinksModified ():void
      {
         mEntityLinksModified = true;
      }
      
      private var mShowAllEntityLinks:Boolean = false;
      
      private function RepaintEntityLinks ():void
      {
         if (mEntityLinksModified)
         {
            mEntityLinksModified = false;
            mEntityLinksLayer.graphics.clear ();
            mEntityContainer.DrawEntityLinks (mEntityLinksLayer, mShowAllEntityLinks);
            
            UpdateSelectedEntityInfo ();
         }
         
         if (mEntityLinksLayer.scaleX != mEntityContainer.scaleX)
            mEntityLinksLayer.scaleX = mEntityContainer.scaleX;
         if (mEntityLinksLayer.scaleY != mEntityContainer.scaleY)
            mEntityLinksLayer.scaleY = mEntityContainer.scaleY;
         if ((int (20.0 * mEntityLinksLayer.x)) != (int (20.0 * mEntityContainer.x)))
            mEntityLinksLayer.x = mEntityContainer.x;
         if ((int (20.0 * mEntityLinksLayer.y)) != (int (20.0 * mEntityContainer.y)))
            mEntityLinksLayer.y = mEntityContainer.y;
      }
      
      private var mEntityIdsModified:Boolean = false;
      
      private function NotifyEntityIdsModified ():void
      {
         mEntityIdsModified = true;
      }
      
      private var mShowAllEntityIds:Boolean = false;
      
      private function RepaintEntityIds ():void
      {
         if (mEntityIdsModified)
         {
            mEntityIdsModified = false;
            
            mEntityIdsLayer.visible = mShowAllEntityIds;
            
            if (! mShowAllEntityIds)
               return;
            
            mEntityContainer.DrawEntityIds (mEntityIdsLayer);
         }
         
         if (mEntityIdsLayer.scaleX != mEntityContainer.scaleX)
            mEntityIdsLayer.scaleX = mEntityContainer.scaleX;
         if (mEntityIdsLayer.scaleY != mEntityContainer.scaleY)
            mEntityIdsLayer.scaleY = mEntityContainer.scaleY;
         if ((int (20.0 * mEntityIdsLayer.x)) != (int (20.0 * mEntityContainer.x)))
            mEntityIdsLayer.x = mEntityContainer.x;
         if ((int (20.0 * mEntityIdsLayer.y)) != (int (20.0 * mEntityContainer.y)))
            mEntityIdsLayer.y = mEntityContainer.y;
     }
      
      public function RepaintWorldDebugInfo ():void
      {
         if (Capabilities.isDebugger)// && false)
         {
            mWorldDebugInfoLayer.x = mEntityContainer.x;
            mWorldDebugInfoLayer.y = mEntityContainer.y;
            mWorldDebugInfoLayer.scaleX = mEntityContainer.scaleX;
            mWorldDebugInfoLayer.scaleY = mEntityContainer.scaleY;
            
            while (mWorldDebugInfoLayer.numChildren > 0)
               mWorldDebugInfoLayer.removeChildAt (0);
            
            mEntityContainer.RepaintContactsInLastRegionSelecting (mWorldDebugInfoLayer);
         }
      }
      
      public function UpdateEffects ():void
      {
         // reverse order for some effects will remove itself
         var effect:EditingEffect;
         var i:int;
         
         if (! IsPlaying ())
         {
            for (i = mEditingEffectLayer.numChildren - 1; i >= 0; -- i)
            {
               effect = mEditingEffectLayer.getChildAt (i) as EditingEffect;
               if (effect != null)
               {
                  effect.Update ();
               }
            }
         }
         
         for (i = mFloatingMessageLayer.numChildren - 1; i >= 0; -- i)
         {
            effect = mFloatingMessageLayer.getChildAt (i) as EditingEffect;
            if (effect != null)
            {
               effect.Update ();
            }
         }
         
         EffectMessagePopup.UpdateMessagesPosition (mFloatingMessageLayer);
      }
      
//==================================================================================
// mode
//==================================================================================
      
      // create mode
      private var mCurrentCreateMode:Mode = null;
      private var mLastSelectedCreateButton:Button = null;
      
      // edit mode
      private var mCurrentEditMode:Mode = null;
      
      // cursors
      private var mCursorCreating:CursorCrossingLine = new CursorCrossingLine ();
      
      
      
      public function SetCurrentCreateMode (mode:Mode):void
      {
         if (mCurrentCreateMode != null)
         {
            mCurrentCreateMode.Destroy ();
            mCurrentCreateMode = null;
         }
         
         if (EditorContext.HasSettingDialogOpened ())
         {
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            return;
         }
         
         mCurrentCreateMode = mode;
         
         if (mCurrentCreateMode != null)
         {
            mIsCreating = true;
            mLastSelectedCreateButton.selected = true;
         }
         else
         {
            mIsCreating = false;
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
         }
         
         UpdateUiButtonsEnabledStatus ();
         
         if (mCurrentCreateMode != null)
            mCurrentCreateMode.Initialize ();
      }
      
      public function CancelCurrentCreatingMode ():void
      {
         if (mCurrentCreateMode != null)
         {
            SetCurrentCreateMode (null);
         }
      }
      
      public function SetCurrentEditMode (mode:Mode):void
      {
         if (mCurrentEditMode != null)
         {
            mCurrentEditMode.Destroy ();
            mCurrentEditMode = null;
         }
         
         if (EditorContext.HasSettingDialogOpened ())
         {
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            return;
         }
         
         mCurrentEditMode = mode;
         
         if (mCurrentEditMode != null)
            mCurrentEditMode.Initialize ();
      }
      
      public function CancelCurrentEditingMode ():void
      {
         if (mCurrentEditMode != null)
         {
            SetCurrentEditMode (null);
         }
      }
      
      private var mIsCreating:Boolean = false;
      
      private var mIsPlaying:Boolean = false;
      
      private function IsCreating ():Boolean
      {
         return ! mIsPlaying && mIsCreating;
      }
      
      private function IsEditing ():Boolean
      {
         return ! mIsPlaying && ! mIsCreating;
      }
      
      public function IsPlaying ():Boolean
      {
         return mIsPlaying;
      }
      
      public function IsPlayingPaused ():Boolean
      {
         return mIsPlaying && mDesignPlayer != null && (! mDesignPlayer.IsPlaying ());
      }
      
//==================================================================================
// outer components
//==================================================================================
      
      //public var mStatusMessageBar:Label;
      
      
      
      public var mButtonCreateBoxMovable:Button;
      public var mButtonCreateBoxStatic:Button;
      public var mButtonCreateBoxBreakable:Button;
      public var mButtonCreateBoxInfected:Button;
      public var mButtonCreateBoxUninfected:Button;
      public var mButtonCreateBoxDontinfect:Button;
      public var mButtonCreateBoxBomb:Button;
      
      public var mButtonCreateBallMovable:Button;
      public var mButtonCreateBallStatic:Button;
      public var mButtonCreateBallBreakable:Button;
      public var mButtonCreateBallInfected:Button;
      public var mButtonCreateBallUninfected:Button;
      public var mButtonCreateBallDontInfect:Button;
      public var mButtonCreateBallBomb:Button;
      
      public var mButtonCreatePolygonStatic:Button;
      public var mButtonCreatePolygonMovable:Button;
      public var mButtonCreatePolygonBreakable:Button;
      public var mButtonCreatePolygonInfected:Button;
      public var mButtonCreatePolygonUninfected:Button;
      public var mButtonCreatePolygonDontinfect:Button;
      
      public var mButtonCreatePolylineStatic:Button;
      public var mButtonCreatePolylineMovable:Button;
      public var mButtonCreatePolylineBreakable:Button;
      public var mButtonCreatePolylineInfected:Button;
      public var mButtonCreatePolylineUninfected:Button;
      public var mButtonCreatePolylineDontinfect:Button;
      
      public var mButtonCreateModuleShape:Button;
      public var mButtonCreateModuleButtonShape:Button;
      
      public var mButtonCreateJointHinge:Button;
      public var mButtonCreateJointSlider:Button;
      public var mButtonCreateJointDistance:Button;
      public var mButtonCreateJointSpring:Button;
      public var mButtonCreateJointWeld:Button;
      public var mButtonCreateJointHingeSlider:Button;
      public var mButtonCreateJointDummy:Button;
      
      public var mButtonCreateBox:Button;
      public var mButtonCreateBall:Button;
      public var mButtonCreatePolygon:Button;
      public var mButtonCreatePolyline:Button;
      public var mButtonCreateTextButton:Button;
      public var mButtonCreateText:Button;
      public var mButtonCreateGravityController:Button;
      public var mButtonCreateCamera:Button;
      
      public var mButtonCreateLinearForce:Button;
      public var mButtonCreateAngularForce:Button;
      public var mButtonCreateLinearImpulse:Button;
      public var mButtonCreateAngularImpulse:Button;
      //public var mButtonCreateAngularAcceleration:Button;
      //public var mButtonCreateAngularVelocity:Button;
      //public var mButtonCreateLinearAcceleration:Button;
      //public var mButtonCreateLinearVelocity:Button;
      
      public var mButtonCreateCondition:Button;
      public var mButtonCreateConditionDoor:Button;
      public var mButtonCreateTask:Button;
      public var mButtonCreateEntityAssigner:Button;
      public var mButtonCreateEntityPairAssigner:Button;
      //public var mButtonCreateEntityRegionSelector:Button;
      public var mButtonCreateEntityFilter:Button;
      public var mButtonCreateEntityPairFilter:Button;
      public var mButtonCreateAction:Button;
      public var mButtonCreateEventHandler0:Button;
      public var mButtonCreateEventHandler1:Button;
      public var mButtonCreateEventHandler2:Button;
      public var mButtonCreateEventHandler3:Button;
      public var mButtonCreateEventHandler5:Button;
      public var mButtonCreateEventHandler6:Button;
      public var mButtonCreateEventHandler7:Button;
      public var mButtonCreateEventHandler8:Button;
      public var mButtonCreateEventHandler59:Button;
      public var mButtonCreateEventHandler50:Button;
      public var mButtonCreateEventHandler51:Button;
      public var mButtonCreateEventHandler52:Button;
      public var mButtonCreateEventHandler53:Button;
      public var mButtonCreateEventHandler56:Button;
      public var mButtonCreateEventHandler57:Button;
      public var mButtonCreateEventHandler58:Button;
      public var mButtonCreateEventHandler66:Button;
      public var mButtonCreateEventHandler67:Button;
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         if (mCurrentCreateMode != null)
         {
            SetCurrentCreateMode (null);
            
            if (mLastSelectedCreateButton == event.target as Button)
            {
               mLastSelectedCreateButton.selected = false;
               mLastSelectedCreateButton = null;
               return;
            }
         }
         
         mLastSelectedCreateButton = (event.target as Button);
         
         switch (event.target)
         {
         // CI boxes
            
            case mButtonCreateBoxMovable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreateBoxStatic:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreateBoxBreakable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, true ) );
               break;
            case mButtonCreateBoxInfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBoxUninfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBoxDontinfect:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBoxBomb:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Bomb, Define.ColorBombObject, false, true, Define.MinBombSquareSideLength, Define.MaxBombSquareSideLength ) );
               break;
               
         // CI balls
            
            case mButtonCreateBallMovable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreateBallStatic:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreateBallBreakable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, false ) );
               break;
            case mButtonCreateBallInfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBallUninfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBallDontInfect:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBallBomb:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Bomb, Define.ColorBombObject, false, Define.MinCircleRadius, Define.MaxBombSquareSideLength * 0.5 ) );
               break;
               
         // CI polygons
            
            case mButtonCreatePolygonMovable:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolygonStatic:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreatePolygonBreakable:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, true ) );
               break;
            case mButtonCreatePolygonInfected:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, false ) );
               break;
            case mButtonCreatePolygonUninfected:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, false ) );
               break;
            case mButtonCreatePolygonDontinfect:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, false ) );
               break;
            
         // CI polylines
            
            case mButtonCreatePolylineMovable:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolylineStatic:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break
            case mButtonCreatePolylineBreakable:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, true ) );
               break;
            case mButtonCreatePolylineInfected:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, true ) );
               break;
            case mButtonCreatePolylineUninfected:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, true ) );
               break;
            case mButtonCreatePolylineDontinfect:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, true ) );
               break;
            
          // general box, ball, polygons, polyline
            
            case mButtonCreateBox:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Unknown, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreateBall:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Unknown, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolygon:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Unknown, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreatePolyline:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Unknown,Define.ColorStaticObject, true ) );
               break;
         
         // image module
         
            case mButtonCreateModuleShape:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateImageModuleShape));
               break;
            case mButtonCreateModuleButtonShape:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateImageModuleButtonShape));
               break;
         
         // joints
            
            case mButtonCreateJointHinge:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateHinge) );
               break;
            case mButtonCreateJointSlider:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateSlider) );
               break;
            case mButtonCreateJointDistance:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateDistance) );
               break;
            case mButtonCreateJointSpring:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateSpring) );
               break;
            case mButtonCreateJointWeld:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateWeldJoint) );
               break;
            case mButtonCreateJointHingeSlider:
               break;
            case mButtonCreateJointDummy:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateDummyJoint) );
               break;
            
         // others
            
            case mButtonCreateText:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateText));
               break;
            case mButtonCreateTextButton:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityTextButton));
               break;
            case mButtonCreateGravityController:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateGravityController));
               break;
            case mButtonCreateCamera:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityCamera));
               break;
            
            case mButtonCreateLinearForce:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_Force}));
               break;
            case mButtonCreateAngularForce:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_Torque}));
               break;
            case mButtonCreateLinearImpulse:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_LinearImpusle}));
               break;
            case mButtonCreateAngularImpulse:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_AngularImpulse}));
               break;
            //case mButtonCreateAngularAcceleration:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_AngularAcceleration}));
            //   break;
            //case mButtonCreateAngularVelocity:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_AngularVelocity}));
            //   break;
            //case mButtonCreateLinearAcceleration:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_LinearAcceleration}));
            //   break;
            //case mButtonCreateLinearVelocity:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_LinearVelocity}));
            //   break;
            
          // logic
          
            case mButtonCreateCondition:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityCondition) );
               break;
            case mButtonCreateConditionDoor:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityConditionDoor) );
               break;
            case mButtonCreateTask:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityTask) );
               break;
            case mButtonCreateAction:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityAction) );
               break;
            case mButtonCreateEntityAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityAssigner) );
               break;
            case mButtonCreateEntityPairAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityPairAssigner) );
               break;
            //case mButtonCreateEntityRegionSelector:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityRegionSelector) );
            //   break;
            case mButtonCreateEntityFilter:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityFilter) );
               break;
            case mButtonCreateEntityPairFilter:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityPairFilter) );
               break;
               
            case mButtonCreateEventHandler0:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldBeforeInitializing, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler1:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldAfterInitialized, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler2:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLWorldBeforeUpdating, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler3:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldAfterUpdated, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler5:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointReachUpperLimit, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler6:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldTimer, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler7:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldKeyDown, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler8:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldMouseClick, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler59:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityCreated, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler50:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityInitialized, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler51:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityUpdated, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler52:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityDestroyed, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler53:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler56:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityPairTimer, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler57:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityTimer, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler58:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityMouseClick, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler66:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnGameActivated, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler67:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnSequencedModuleLoopToEnd, mPotientialEventIds:null}) );
               break;
            
         // ...
            default:
               SetCurrentCreateMode (null);
               break;
         }
         
      }
      
      public var mButtonClone:Button;
      public var mButtonDelete:Button;
      public var mButtonFlipH:Button;
      public var mButtonFlipV:Button;
      public var mButtonGlue:Button;
      public var mButtonBreakApart:Button;
      public var mButtonSetting:Button;
      public var mButtonMoveToTop:Button;
      public var mButtonMoveToBottom:Button;
      public var mButtonUndo:Button;
      public var mButtonRedo:Button;
      public var mButtonMouseCookieMode:Button;
      public var mButtonMouseMoveScene:Button;
      public var mButtonMouseMove:Button;
      public var mButtonMouseRotate:Button;
      public var mButtonMouseScale:Button;
      
      public var mButton_Play:Button;
      public var mButton_Stop:Button;
      
      public var mButtonNewDesign:Button;
      //public var mButtonSaveWorld:Button;
      //public var mButtonLoadWorld:Button;
      
      public var mButtonShowEntityIds:Button;
      public var mButtonShowLinks:Button;
      
      public var mButtonHideInvisibleEntities:Button;
      public var mButtonHideShapesAndJoints:Button;
      public var mButtonHideTriggers:Button;
      
      public var SetBatchSettingMenuItemsEnabled:Function;
      
      private function UpdateUiButtonsEnabledStatus ():void
      {
      // edit
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         
         //mButtonSetting.enabled = selectedEntities.length == 1 && IsEntitySettingable (selectedEntities[0]);
         mButtonSetting.enabled = mLastSelectedEntity != null && IsEntitySettingable (mLastSelectedEntity);
         
         mButtonDelete.enabled = mButtonFlipH.enabled = mButtonFlipV.enabled = 
         mButtonMoveToTop.enabled = mButtonMoveToBottom.enabled = selectedEntities.length > 0;
         mButtonGlue.enabled = mButtonBreakApart.enabled = selectedEntities.length > 1;
         
         mButtonUndo.enabled = mWorldHistoryManager.GetPrevWorldState () != null;
         mButtonRedo.enabled = mWorldHistoryManager.GetNextWorldState () != null;
         
         if (selectedEntities.length == 0)
            mButtonClone.enabled = false;
         else
         {
            var clonedable:Boolean = false;
            
            for (var i:int = 0; i < selectedEntities.length; ++ i)
            {
               if ( (selectedEntities[i] as Entity).IsClonedable () )
               {
                  clonedable = true;
                  break;
               }
            }
            
            mButtonClone.enabled = clonedable;
         }
         
      // creat ...
         
         //mButtonCreateGravityController.enabled = mEntityContainer.GetNumEntities (Filters.IsGravityControllerEntity) == 0;
         //mButtonCreateCamera           .enabled = mEntityContainer.GetNumEntities (Filters.IsCameraEntity) == 0;
         
      // file ...
         
         mButtonNewDesign.enabled = true; //mEntityContainer.numChildren > 0;
         
      // context menu
         
         //mMenuItemExportSelectedsToSystemMemory.enabled = selectedEntities.length > 0;
         
      // context menu of entity setting button
         
         var numEntities:int = 0;
            var numShapes:int = 0;
               var numCircles:int = 0; 
               var numRectanges:int = 0; 
               var numPolylines:int = 0; 
            var numJoints:int = 0;
         
         var entity:Entity;
         for (var j:int = 0; j < selectedEntities.length; ++ j)
         {
            entity = selectedEntities [j];
            if (entity != null)
            {
               ++ numEntities;
               
               //if (entity is EntityVectorShape)
               if (entity is EntityShape)
               {
                  ++ numShapes;
                  
                  if (entity is EntityVectorShapeCircle)
                     ++ numCircles;
                  else if (entity is EntityVectorShapeRectangle)
                     ++ numRectanges;
                  else if (entity is EntityVectorShapePolyline)
                     ++ numPolylines;
               }
               else if (entity is SubEntityJointAnchor)
               {
                  ++ numJoints;
               }
            }
         }
         
         
         SetBatchSettingMenuItemsEnabled (
                              numEntities > 0,
                              
                              numShapes > 0,
                              numShapes > 0,
                              numCircles > 0,
                              numRectanges > 0,
                              numPolylines > 0,
                              
                              numJoints > 0
                              );
      }
      
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
            //case mButtonNewDesign:
            //   ClearAllEntities ();
            //   break;
            //case mButtonSaveWorld:
            //   OpenWorldSavingDialog ();
            //   break;
            //case mButtonLoadWorld:
            //   OpenWorldLoadingDialog ();
            //   break;
            
            case mButtonClone:
               CloneSelectedEntities ();
               break;
            case mButtonDelete:
               DeleteSelectedEntities ();
               break;
            case mButtonFlipH:
               FlipSelectedEntitiesHorizontally ();
               break;
            case mButtonFlipV:
               FlipSelectedEntitiesVertically ();
               break;
            case mButtonGlue:
               GlueSelectedEntities ();
               break;
            case mButtonBreakApart:
               BreakApartSelectedEntities ();
               break;
            case mButtonSetting:
               OpenEntitySettingDialog ();
               break;
            case mButtonMoveToTop:
               MoveSelectedEntitiesToTop ();
               break;
            case mButtonMoveToBottom:
               MoveSelectedEntitiesToBottom ();
               break;
            case mButtonUndo:
               Undo ();
               break;
            case mButtonRedo:
               Redo ();
               break;
            case mButtonMouseMoveScene:
               SetMouseEditModeEnabled (MouseEditMode_MoveWorld, mButtonMouseMoveScene.selected);
               break;
            case mButtonMouseMove:
               SetMouseEditModeEnabled (MouseEditMode_MoveSelecteds, mButtonMouseMove.selected);
               break;
            case mButtonMouseRotate:
               SetMouseEditModeEnabled (MouseEditMode_RotateSelecteds, mButtonMouseRotate.selected);
               break;
            case mButtonMouseScale:
               SetMouseEditModeEnabled (MouseEditMode_ScaleSelecteds, mButtonMouseScale.selected);
               break;
            case mButtonMouseCookieMode:
               SetCookieModeEnabled (mButtonMouseCookieMode.selected);
               break;
            
            case mButton_Play:
               Play_RunRestart ()
               break;
            case mButton_Stop:
               Play_Stop ();
               break;
            
            case mButtonShowEntityIds:
               mShowAllEntityIds = mButtonShowEntityIds.selected;
               NotifyEntityIdsModified ();
               break;
            case mButtonShowLinks:
               mShowAllEntityLinks = mButtonShowLinks.selected;
               NotifyEntityLinksModified ();
               break;
            
            case mButtonHideInvisibleEntities:
               mEntityContainer.SetInvisiblesVisible (! mButtonHideInvisibleEntities.selected);
               OnSelectedEntitiesChanged ();
               break;
            case mButtonHideShapesAndJoints:
               mEntityContainer.SetShapesVisible (! mButtonHideShapesAndJoints.selected);
               mEntityContainer.SetJointsVisible (! mButtonHideShapesAndJoints.selected);
               OnSelectedEntitiesChanged ();
               break;
            case mButtonHideTriggers:
               mEntityContainer.SetTriggersVisible (! mButtonHideTriggers.selected);
               OnSelectedEntitiesChanged ();
               break;
            
            default:
               break;
         }
      }
      
   // status bar
      
      public var StatusBar_SetMainSelectedEntityInfo:Function;
      public var StatusBar_SetMainDisplayPosition:Function;
      public var StatusBar_SetMainPhysicsPosition:Function;
      
      public var StatusBar_SetRunningSteps:Function;
      public var StatusBar_SetRunningFPS:Function;
      
   // context menu
      
      private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
         
         // need flash 10
         //theContextMenu.clipboardMenu = true;
         //var clipboardItems:ContextMenuClipboardItems = theContextMenu.builtInItems;
         //clipboardItems.clear = true;
         //clipboardItems.cut = false;
         //clipboardItems.copy = true;
         //clipboardItems.paste = true;
         //clipboardItems.selectAll = false;
            
         theContextMenu.customItems.push (EditorContext.GetAboutContextMenuItem ());
      }
      
      public function SetEntityContainer (container:EntityContainer, firstTime:Boolean = false):void
      {
         super.SetAssetManager (container);
         
         if (container == mEntityContainer)
            return;
         
         if (mEntityContainer != null && mEntityContainer.parent != null)
         {
            mEntityContainer.parent.removeChild (mEntityContainer);
         }
         
         mEntityContainer = null;
         
         if (container == null)
         {  
            return;
         }
         
         mEntityContainer = container;
         
         NotifyEntityLinksModified ();
         
         ClearAccumulatedModificationsByArrowKeys ();
         
         EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().SetChanged (false);
         //if (mEntityContainer.GetFunctionManager ().IsChanged ())
         //{
         //   mEntityContainer.GetFunctionManager ().UpdateFunctionMenu ();
         //   mEntityContainer.GetFunctionManager ().SetChanged (false)
         //   mEntityContainer.GetFunctionManager ().SetDelayUpdateFunctionMenu (false)
         //}
         if (EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().IsChanged ())
         {
            EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().UpdateFunctionMenu ();
            EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().SetChanged (false)
            EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().SetDelayUpdateFunctionMenu (false)
         }
         
         mEntityContainer.scaleX = mEntityContainer.scaleY = mEntityContainerZoomScale = mEntityContainer.GetZoomScale ();
         
         if (NotifyEditingScaleChanged != null)
            NotifyEditingScaleChanged ();
         
         mContentLayer.addChild (mEntityContainer);
         
         //if (EditorContext.mCollisionCategoryView != null)
         //   EditorContext.mCollisionCategoryView.SetCollisionManager (mEntityContainer.GetCollisionManager ());
         if (CollisionCategoryListDialog.sCollisionCategoryListDialog != null)
         {
            CollisionCategoryListDialog.sCollisionCategoryListDialog.GetCollisionCategoryListPanel ().SetCollisionCategoryManager (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ());
         }
         
         //if (EditorContext.mFunctionEditingView != null)
         //   EditorContext.mFunctionEditingView.SetFunctionManager (mEntityContainer.GetFunctionManager ());
         if (CodeLibListDialog.sCodeLibListDialog != null)
         {
            CodeLibListDialog.sCodeLibListDialog.GetCodeLibListPanel ().SetCodeLibManager (EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ());
         }
         
         if (firstTime)
         {
         
            //
            UpdateChildComponents ();
            
            //
            RegisterNotifyFunctions ();
         
            // 
            CreateUndoPoint ("Startup");
         }
         else
         {
            //
            SetLastSelectedEntities (null);
            mLastSelectedEntities = null;
            
            CalSelectedEntitiesCenterPoint ();
            
            UpdateBackgroundAndWorldPosition ();
         }
      }
      
      public function ScaleEditorWorld (scaleIn:Boolean):Boolean
      {
         var reachLimit:Boolean = false;
         
         if (IsEditing ())
         {
            var newSscale:Number = mEntityContainerZoomScale * (scaleIn ? 2.0 : 0.5);
            if (int (newSscale * 32.0) <= 1)
            {
               newSscale = 1.0 / 32.0;
               reachLimit = true;
            }
            if (int (newSscale) >= 32)
            {
               newSscale = 32.0;
               reachLimit = true;
            }
            
            mEntityContainerZoomScale = newSscale;
            mEntityContainerZoomScaleChangedSpeed = (mEntityContainerZoomScale - mEntityContainer.scaleX) * 0.03;
            
            //UpdateBackgroundAndWorldPosition ();
            
            if (NotifyEditingScaleChanged != null)
               NotifyEditingScaleChanged ();
         }
         
         return reachLimit;
      }
      
      public var NotifyEditingScaleChanged:Function = null;
      
      public function GetEditorWorldZoomScale ():Number
      {
         //return mEntityContainer.GetZoomScale ();
         return mEntityContainer.scaleX;
      }
      
      private function SetDesignPlayer (newPlayer:Viewer):void
      {
         DestroyDesignPlayer ();
         
         mDesignPlayer = newPlayer;
         
         if (mDesignPlayer == null)
            return;
         
         mPlayerElementsContainer.addChild (mDesignPlayer);
         
         UpdateDesignPalyerPosition ();
      }
      
      private function DestroyDesignPlayer():void
      {
         //SystemUtil.TraceMemory ("before DestroyPlayerWorld", true);
         
         if ( mDesignPlayer != null)
         {
            if ( mPlayerElementsContainer.contains (mDesignPlayer) )
               mPlayerElementsContainer.removeChild (mDesignPlayer);
         }
         
         mDesignPlayer = null;
         
         //SystemUtil.TraceMemory ("after DestroyPlayerWorld", true);
      }
      
      public function UpdateDesignPalyerPosition ():void
      {
         if (mDesignPlayer != null)
         {
            //var playerSize:Point = GetViewportSize ();
            //
            //mDesignPlayer.x = Math.round ((mViewWidth - playerSize.x) / 2);
            //mDesignPlayer.y = Math.round ((mViewHeight - playerSize.y) / 2);
            
            // new implemeation be compatible with UniViewer and GamePackager
            mDesignPlayer.OnContainerResized ();
         }
      }
      
      private function HandleEditingError (error:Error):void 
      {
      }
      
//============================================================================
// playing
//============================================================================
      
      public var OnPlayingStarted:Function;
      public var OnPlayingStopped:Function;
      
      //private function GetWorldDefine ():WorldDefine
      //{
      //   return DataFormat.EditorWorld2WorldDefine ( EditorContext.GetEditorApp ().GetWorld () );
      //}
      
      private function GetWorldBinaryData ():ByteArray
      {
         var byteArray:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine ( EditorContext.GetEditorApp ().GetWorld () ));
         byteArray.position = 0;
         
         return byteArray;
      }
      
      private function GetViewportSize ():Point
      {
         /*
         var viewerUiFlags:int = EditorContext.GetEditorApp ().GetWorld ().GetViewerUiFlags ();
         var viewportWidth:int = EditorContext.GetEditorApp ().GetWorld ().GetViewportWidth ();
         var viewportHeight:int = EditorContext.GetEditorApp ().GetWorld ().GetViewportHeight ();
         
         //if ((viewerUiFlags & Define.PlayerUiFlag_UseDefaultSkin) != 0)
         if ((viewerUiFlags & (Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_UseOverlaySkin)) == Define.PlayerUiFlag_UseDefaultSkin)
         {
            return new Point (viewportWidth, viewportHeight + Define.DefaultPlayerSkinPlayBarHeight);
         }
         else
         {
            return new Point (viewportWidth, viewportHeight);
         }
         */
         
         return new Point (mViewWidth, mViewHeight);
      }
      
      public function Play_RunRestart (keepPauseStatus:Boolean = false):void
      {
         if (EditorContext.HasSettingDialogOpened ())
            return;
         
         EditorContext.SetHasInputFocused (false);
         stage.focus = this;
         
         DestroyDesignPlayer ();
         
         //var useQuickMethod:Boolean;
         //
         //if (Capabilities.isDebugger)
         //{
         //   useQuickMethod = true;
         //}
         //else
         //{
         //   useQuickMethod = false;
         //}
         //
         //if (useQuickMethod)
         //{
         //   SetDesignPlayer (new Viewer ({mParamsFromEditor: {GetWorldDefine:GetWorldDefine, GetWorldBinaryData:null, GetViewportSize:GetViewportSize, mStartRightNow: true, mMaskViewerField: mMaskViewerField}}));
         //}
         //else
         //{
         //   SetDesignPlayer (new Viewer ({mParamsFromEditor: {GetWorldDefine:null, GetWorldBinaryData:GetWorldBinaryData, GetViewportSize:GetViewportSize, mStartRightNow: true, mMaskViewerField: mMaskViewerField}}));
         //}
         
         SetDesignPlayer (new Viewer ({mParamsFromEditor: {mWorldDomain: ApplicationDomain.currentDomain, mWorldBinaryData: GetWorldBinaryData (), GetViewportSize:GetViewportSize, mStartRightNow: true, mMaskViewerField: mMaskViewerField}}));
         
         mIsPlaying = true;
         
         mEditiingViewContainer.visible = false;
         mPlayingViewContainer.visible = true;
         
         if (OnPlayingStarted != null)
            OnPlayingStarted ();
         
         mAlreadySavedWhenPlayingError = false;
      }
      
      public function Play_Stop ():void
      {
         stage.frameRate = mOriginalFPS;
         
         //...
         EditorContext.StopAllSounds ();
         
         //Mouse.show (); // maybe hide in playing. (now put in player.World)
         
         mAlreadySavedWhenPlayingError = false;
         
         DestroyDesignPlayer ();
         
         mIsPlaying = false;
         
         mEditiingViewContainer.visible = true;
         mPlayingViewContainer.visible = false;
         
         if (OnPlayingStopped != null)
            OnPlayingStopped ();
      }
      
      private function SetPlayingSpeed (speed:Number):void
      {
      }
      
      private function HandlePlayingError (error:Error):void
      {
         mDesignPlayer.SetExternalPaused (true);
         
         if (! mAlreadySavedWhenPlayingError)
         {
            QuickSave ("Auto Save when playing error.");
            mAlreadySavedWhenPlayingError = true;
         }
         
         Alert.show (error.message + "\n\nDo you stop the simulation?", "Playing Error! ", 
                     Alert.YES | Alert.NO, 
                     this, 
                     OnPlayingErrorAlertClickHandler
                     );
      }
      
      private var mAlreadySavedWhenPlayingError:Boolean = false;
      
      private function OnPlayingErrorAlertClickHandler (event:CloseEvent):void 
      {
          if (event.detail == Alert.YES)
          {
             Play_Stop ();
          }
          else if (event.detail == Alert.NO)
          {
             mDesignPlayer.SetExternalPaused (false);
          }
      }
      
      public function PlayRestart ():void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayRestart ();
         }
      }
      
      public function PlayRun ():void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayRun ();
         }
      }
      
      public function PlayPause ():void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayPause ();
         }
      }
      
      public function PlayOneStep ():void
      {
         if (IsPlaying ())
         {
            mDesignPlayer.UpdateSingleStep ();
         }
      }
      
      public function PlayFaster (delta:uint):Boolean
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayFaster (delta);
         }
         
         return true;
      }
      
      public function PlaySlower (delta:uint):Boolean
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlaySlower (delta);
         }
         
          return true;
      }
      
      public function GetPlayingSpeedX ():int
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.GetPlayingSpeedX ();
         }
         
         return 0;
      }
      
      public function GetPlayingSimulatedSteps ():int
      {
         if (IsPlaying ())
         {
            var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld () as player.world.World;
            return playerWorld == null ? 0 : playerWorld.GetSimulatedSteps ();
         }
         
         return 0;
      }
      
      public function SetOnSpeedChangedFunction (onSpeed:Function):void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.SetOnSpeedChangedFunction (onSpeed);
         }
      }
      
      public function SetOnPlayStatusChangedFunction (onPlayStatusChanged:Function):void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.SetOnPlayStatusChangedFunction (onPlayStatusChanged);
         }
      }
      
      private static var mMaskViewerField:Boolean = false;
      
      public function IsMaskViewerField ():Boolean
      {
         return mMaskViewerField;
      }
      
      public function SetMaskViewerField (mask:Boolean):void
      {
         mMaskViewerField = mask;
         
         if (IsPlaying ())
         {
            mDesignPlayer.SetMaskViewerField (mMaskViewerField);
         }
      }
      
//============================================================================
//    
//============================================================================
      
      public function OnFinishedCCatEditing ():void
      {
         if (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().IsChanged ())
         {
            EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().SetChanged (false);
            CreateUndoPoint ("Modify collision categories");
         }
         
         EditorContext.SetHasInputFocused (false);
         stage.focus = this;
      }
      
      public function OnFinishedFunctionEditing ():void
      {
         if (EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().IsChanged ())
         {
            EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().SetChanged (false);
            CreateUndoPoint ("Modify functions");
         }
         
         EditorContext.SetHasInputFocused (false);
         stage.focus = this;
      }
      
      
//============================================================================
//    
//============================================================================
      
      public var ShowShapeRectangleSettingDialog:Function = null;
      public var ShowShapeCircleSettingDialog:Function = null;
      public var ShowShapePolygonSettingDialog:Function = null;
      public var ShowShapePolylineSettingDialog:Function = null;
      public var ShowShapeImageModuleSettingDialog:Function = null;
      public var ShowShapeImageModuleButtonSettingDialog:Function = null;
      
      public var ShowHingeSettingDialog:Function = null;
      public var ShowSliderSettingDialog:Function = null;
      public var ShowSpringSettingDialog:Function = null;
      public var ShowDistanceSettingDialog:Function = null;
      public var ShowWeldSettingDialog:Function = null;
      public var ShowDummySettingDialog:Function = null;
      
      public var ShowShapeTextSettingDialog:Function = null;
      public var ShowShapeTextButtonSettingDialog:Function = null;
      public var ShowShapeGravityControllerSettingDialog:Function = null;
      public var ShowCameraSettingDialog:Function = null;
      public var ShowPowerSourceSettingDialog:Function = null;
      
      public var ShowWorldSettingDialog:Function = null;
      public var ShowWorldSavingDialog:Function = null;
      public var ShowWorldLoadingDialog:Function = null;
      public var ShowWorldQuickLoadingDialog:Function = null;
      public var ShowImportSourceCodeDialog:Function = null;
      public var ShowExportSwfFileDialog:Function = null;
      
      //public var ShowCollisionGroupManageDialog:Function = null;
      
      public var ShowPlayCodeLoadingDialog:Function = null;
      
      public var ShowEditorCustomCommandSettingDialog:Function = null;
      
      public var ShowConditionDoorSettingDialog:Function = null;
      public var ShowTaskSettingDialog:Function = null;
      public var ShowConditionSettingDialog:Function = null;
      public var ShowEventHandlerSettingDialog:Function = null;
      public var ShowTimerEventHandlerSettingDialog:Function = null;
      public var ShowTimerEventHandlerWithPreAndPostHandlingSettingDialog:Function = null;
      public var ShowKeyboardEventHandlerSettingDialog:Function = null;
      public var ShowMouseEventHandlerSettingDialog:Function = null;
      public var ShowContactEventHandlerSettingDialog:Function = null;
      public var ShowJointReachLimitEventHandlerSettingDialog:Function = null;
      public var ShowGameLostOrGotFocusEventHandlerSettingDialog:Function = null;
      public var ShowActionSettingDialog:Function = null;
      public var ShowEntityAssignerSettingDialog:Function = null;
      public var ShowEntityPairAssignerSettingDialog:Function = null;
      public var ShowEntityPairFilterSettingDialog:Function = null;
      public var ShowEntityFilterSettingDialog:Function = null;
      
      public function IsEntitySettingable (entity:Entity):Boolean
      {
         if (entity == null)
            return false;
         
         //return entity is EntityVectorShape || entity is SubEntityHingeAnchor || entity is SubEntitySliderAnchor
         //       || entity is SubEntitySpringAnchor // v1.01
         //       || entity is SubEntityDistanceAnchor // v1.02
         //       || entity is EntityBasicCondition // v1.07
         //       || entity is EntityEventHandler // v1.07
         //       ;
         
         return true; // v1.08
      }
      
      protected function RetrieveShapePhysicsProperties (shape:EntityShape, values:Object):void
      {        
         values.mCollisionCategoryIndex = shape.GetCollisionCategoryIndex ();
         values.mCollisionCategoryListDataProvider =  EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryListDataProvider ();
         values.mCollisionCategoryListSelectedIndex = CollisionCategoryManager.CollisionCategoryIndex2SelectListSelectedIndex (shape.GetCollisionCategoryIndex (), values.mCollisionCategoryListDataProvider);
         
         values.mIsPhysicsEnabled = shape.IsPhysicsEnabled ();
         values.mIsSensor = shape.mIsSensor;
         values.mIsStatic = shape.IsStatic ();
         values.mIsBullet = shape.mIsBullet;
         values.mIsHollow = shape.IsHollow ();
         values.mBuildBorder = shape.IsBuildBorder ();
         values.mDensity = ValueAdjuster.Number2Precision (shape.mDensity, 6);
         values.mFriction = ValueAdjuster.Number2Precision (shape.mFriction, 6);
         values.mRestitution = ValueAdjuster.Number2Precision (shape.mRestitution, 6);
         
         values.mLinearVelocityMagnitude = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (shape.GetLinearVelocityMagnitude ()), 6);
         values.mLinearVelocityAngle = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (shape.GetLinearVelocityAngle ()), 6);
         values.mAngularVelocity = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_AngularVelocity (shape.GetAngularVelocity ()), 6);
         values.mLinearDamping = ValueAdjuster.Number2Precision (shape.GetLinearDamping (), 6);
         values.mAngularDamping = ValueAdjuster.Number2Precision (shape.GetAngularDamping (), 6);
         values.mAllowSleeping = shape.IsAllowSleeping ();
         values.mFixRotation = shape.IsFixRotation ();
      }
      
      public function OpenEntitySettingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (EditorContext.HasSettingDialogOpened ())
            return;
         
         //var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         //if (selectedEntities == null || selectedEntities.length != 1)
         //   return;
         if (mMainSelectedEntity == null)
            return;
         
         //var entity:Entity = selectedEntities [0] as Entity;
         var entity:Entity = mMainSelectedEntity;
         
         var values:Object = new Object ();
         
         values.mPosX = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (entity.GetPositionX ()), 12);
         values.mPosY = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (entity.GetPositionY ()), 12);
         values.mAngle = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationRadians (entity.GetRotation ()) * Define.kRadians2Degrees, 6);
         
         values.mIsVisible = entity.IsVisible ();
         values.mAlpha = entity.GetAlpha ();
         values.mIsEnabled = entity.IsEnabled ();
         
         if (entity is EntityLogic)
         {
            if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               event_handler.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = event_handler.GetCodeSnippetName ();
               values.mEventId = event_handler.GetEventId ();
               values.mCodeSnippet  = event_handler.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  values.mRunningInterval = timer_event_handler.GetRunningInterval ();
                  values.mOnlyRunOnce = timer_event_handler.IsOnlyRunOnce ();
                  
                  if (entity is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timer_event_handler_withPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
                     
                     values.mPreCodeSnippet  = timer_event_handler_withPrePostHandling.GetPreCodeSnippet  ().Clone (null);
                     values.mPostCodeSnippet = timer_event_handler_withPrePostHandling.GetPostCodeSnippet ().Clone (null);
                     ShowTimerEventHandlerWithPreAndPostHandlingSettingDialog (values, ConfirmSettingEntityProperties);
                  }
                  else
                  {
                     ShowTimerEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
                  }
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  values.mKeyCodes = keyboard_event_handler.GetKeyCodes ();
                  
                  ShowKeyboardEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  ShowMouseEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  ShowContactEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_JointReachLimit)
               {
                  ShowJointReachLimitEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_GameLostOrGotFocus)
               {
                  ShowGameLostOrGotFocusEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               //else if (entity is EntityEventHandler_ModuleLoopToEnd)
               else
               {
                  ShowEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               condition.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = condition.GetCodeSnippetName ();
               values.mCodeSnippet  = condition.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowConditionSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               action.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = action.GetCodeSnippetName ();
               values.mCodeSnippet  = action.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowActionSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityScriptFilter)
            {
               var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
               
               values.mCodeSnippetName = entityFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = entityFilter.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowEntityFilterSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityPairScriptFilter)
            {
               var pairFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
               
               values.mCodeSnippetName = pairFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = pairFilter.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowEntityPairFilterSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityConditionDoor)
            {
               ShowConditionDoorSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityTask)
            {
               ShowTaskSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityAssigner)
            {
               ShowEntityAssignerSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
               ShowEntityPairAssignerSettingDialog (values, ConfirmSettingEntityProperties);
            }
         }
         else if (entity is EntityVectorShape)
         {
            var vectorShape:EntityVectorShape = entity as EntityVectorShape;
            
            values.mDrawBorder = vectorShape.IsDrawBorder ();
            values.mDrawBackground = vectorShape.IsDrawBackground ();
            values.mBorderColor = vectorShape.GetBorderColor ();
            values.mBorderThickness = vectorShape.GetBorderThickness ();
            values.mBackgroundColor = vectorShape.GetFilledColor ();
            values.mTransparency = vectorShape.GetTransparency ();
            values.mBorderTransparency = vectorShape.GetBorderTransparency ();
            
            values.mAiType = vectorShape.GetAiType ();
            
            if (vectorShape.IsBasicVectorShapeEntity ())
            {
               RetrieveShapePhysicsProperties (vectorShape, values);
               
               //values.mVisibleEditable = true; //vectorShape.GetFilledColor () == Define.ColorStaticObject;
               //values.mStaticEditable = true; //vectorShape.GetFilledColor () == Define.ColorBreakableObject
               //                             || vectorShape.GetFilledColor () == Define.ColorBombObject
               //                      ;
               if (entity is EntityVectorShapeCircle)
               {
                  //values.mRadius = (entity as EntityVectorShapeCircle).GetRadius();
                  values.mRadius = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length ((entity as EntityVectorShapeCircle).GetRadius()), 6);
                  
                  values.mAppearanceType = (entity as EntityVectorShapeCircle).GetAppearanceType();
                  values.mAppearanceTypeListSelectedIndex = (entity as EntityVectorShapeCircle).GetAppearanceType();
                  
                  ShowShapeCircleSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityVectorShapeRectangle)
               {
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfHeight ()), 6);
                  values.mIsRoundCorners = (vectorShape as EntityVectorShapeRectangle).IsRoundCorners ();
                  
                  ShowShapeRectangleSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityVectorShapePolygon)
               {
                  ShowShapePolygonSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityVectorShapePolyline)
               {
                  values.mCurveThickness = (vectorShape as EntityVectorShapePolyline).GetCurveThickness ();
                  values.mIsRoundEnds = (vectorShape as EntityVectorShapePolyline).IsRoundEnds ();
                  values.mIsClosed = (vectorShape as EntityVectorShapePolyline).IsClosed ();
                  
                  ShowShapePolylineSettingDialog (values, ConfirmSettingEntityProperties);
               }
            }
            else // no physics entity
            {
               if (entity is EntityVectorShapeText)
               {
                  values.mText = (vectorShape as EntityVectorShapeText).GetText ();
                  
                  values.mTextColor = (vectorShape as EntityVectorShapeText).GetTextColor ();
                  values.mFontSize = (vectorShape as EntityVectorShapeText).GetFontSize ();
                  values.mIsBold = (vectorShape as EntityVectorShapeText).IsBold ();
                  values.mIsItalic = (vectorShape as EntityVectorShapeText).IsItalic ();
                  
                  values.mIsUnderlined = (vectorShape as EntityVectorShapeText).IsUnderlined ();
                  values.mTextAlign = (vectorShape as EntityVectorShapeText).GetTextAlign ();
                  
                  values.mWordWrap = (vectorShape as EntityVectorShapeText).IsWordWrap ();
                  values.mAdaptiveBackgroundSize = (vectorShape as EntityVectorShapeText).IsAdaptiveBackgroundSize ();
                  
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfHeight ()), 6);
                  
                  if (entity is EntityVectorShapeTextButton)
                  {
                     values.mUsingHandCursor = (vectorShape as EntityVectorShapeTextButton).UsingHandCursor ();
                     
                     var moveOverShape:EntityVectorShape = (vectorShape as EntityVectorShapeTextButton).GetMouseOverShape ();
                     values.mMouseOverValues = new Object ();
                     values.mMouseOverValues.mDrawBorder = moveOverShape.IsDrawBorder ();
                     values.mMouseOverValues.mDrawBackground = moveOverShape.IsDrawBackground ();
                     values.mMouseOverValues.mBorderColor = moveOverShape.GetBorderColor ();
                     values.mMouseOverValues.mBorderThickness = moveOverShape.GetBorderThickness ();
                     values.mMouseOverValues.mBackgroundColor = moveOverShape.GetFilledColor ();
                     values.mMouseOverValues.mTransparency = moveOverShape.GetTransparency ();
                     values.mMouseOverValues.mBorderTransparency = moveOverShape.GetBorderTransparency ();
                     
                     ShowShapeTextButtonSettingDialog (values, ConfirmSettingEntityProperties);
                  }
                  else
                  {
                     ShowShapeTextSettingDialog (values, ConfirmSettingEntityProperties);
                  }
               }
               else if (entity is EntityVectorShapeGravityController)
               {
                  values.mRadius = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length ((entity as EntityVectorShapeCircle).GetRadius()), 6);
                  
                  // removed from v1.05
                  /////values.mIsInteractive = (vectorShape as EntityVectorShapeGravityController).IsInteractive ();
                  values.mInteractiveZones = (vectorShape as EntityVectorShapeGravityController).GetInteractiveZones ();
                  
                  values.mInteractiveConditions = (vectorShape as EntityVectorShapeGravityController).mInteractiveConditions;
                  
                  values.mMaximalGravityAcceleration = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((vectorShape as EntityVectorShapeGravityController).GetMaximalGravityAcceleration ()), 6);
                  
                  values.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((vectorShape as EntityVectorShapeGravityController).GetInitialGravityAcceleration ()), 6);
                  values.mInitialGravityAngle = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees ((vectorShape as EntityVectorShapeGravityController).GetInitialGravityAngle ()), 6);
                  
                  ShowShapeGravityControllerSettingDialog (values, ConfirmSettingEntityProperties);
               }
            }
         }
         else if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            if (entity is EntityShapeImageModule)
            {
               RetrieveShapePhysicsProperties (shape, values);
               
               values.mModule = (entity as EntityShapeImageModule).GetAssetImageModule ();
               
               ShowShapeImageModuleSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityShapeImageModuleButton)
            {
               RetrieveShapePhysicsProperties (shape, values);
               
               values.mModuleUp = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseUp ();
               values.mModuleOver = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseOver ();
               values.mModuleDown = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseDown ();
               
               ShowShapeImageModuleButtonSettingDialog (values, ConfirmSettingEntityProperties);
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            var jointAnchor:SubEntityJointAnchor = entity as SubEntityJointAnchor;
            var joint:EntityJoint = entity.GetMainEntity () as EntityJoint;
            
            var jointValues:Object = new Object ();
            values.mJointValues = jointValues;
            
            jointValues.mCollideConnected = joint.mCollideConnected;
            
            jointValues.mPosX = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (joint.GetPositionX ()), 12);
            jointValues.mPosY = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (joint.GetPositionY ()), 12);
            jointValues.mAngle = ValueAdjuster.Number2Precision (joint.GetRotation () * Define.kRadians2Degrees, 6);
            
            jointValues.mIsVisible = joint.IsVisible ();
            jointValues.mAlpha = joint.GetAlpha ();
            jointValues.mIsEnabled = joint.IsEnabled ();
            
            //>>from v1.02
            jointValues.mShapeListDataProvider = mEntityContainer.GetEntitySelectListDataProviderByFilter (Filters.IsPhysicsShapeEntity, true, "[Auto Select]");
            jointValues.mShapeList1SelectedIndex = EntityContainer.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape1Index (), jointValues.mShapeListDataProvider);
            jointValues.mShapeList2SelectedIndex = EntityContainer.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape2Index (), jointValues.mShapeListDataProvider);
            jointValues.mAnchorIndex = jointAnchor.GetAnchorIndex (); // hinge will modify it below
            //<<
            
            //from v1.08
            jointValues.mIsBreakable = joint.IsBreakable ();
            //<<
            
            if (entity is SubEntityHingeAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var hinge:EntityJointHinge = joint as EntityJointHinge;
               var lowerAngle:Number = mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetLowerLimit ());
               var upperAngle:Number = mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetUpperLimit ());
               if (lowerAngle > upperAngle)
               {
                  var tempAngle:Number = lowerAngle;
                  lowerAngle = upperAngle;
                  upperAngle = tempAngle;
               }
               
               jointValues.mEnableLimit = hinge.IsLimitsEnabled ();
               jointValues.mLowerAngle = ValueAdjuster.Number2Precision (lowerAngle, 6);
               jointValues.mUpperAngle = ValueAdjuster.Number2Precision (upperAngle, 6);
               jointValues.mEnableMotor = hinge.mEnableMotor;
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (hinge.mMotorSpeed), 6);
               jointValues.mBackAndForth = hinge.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorTorque = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Torque (hinge.GetMaxMotorTorque ()), 6);
               //<<
               
               ShowHingeSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = joint as EntityJointSlider;
               
               jointValues.mEnableLimit = slider.IsLimitsEnabled ();
               jointValues.mLowerTranslation = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (slider.GetLowerLimit ()), 6);
               jointValues.mUpperTranslation = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (slider.GetUpperLimit ()), 6);
               jointValues.mEnableMotor = slider.mEnableMotor;
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (slider.mMotorSpeed), 6);
               jointValues.mBackAndForth = slider.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorForce = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_ForceMagnitude (slider.GetMaxMotorForce ()), 6);
               //<<
               
               ShowSliderSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntitySpringAnchor)
            {
               var spring:EntityJointSpring = joint as EntityJointSpring;
               
               jointValues.mStaticLengthRatio = ValueAdjuster.Number2Precision (spring.GetStaticLengthRatio (), 6);
               jointValues.mSpringType = spring.GetSpringType ();
               jointValues.mDampingRatio = ValueAdjuster.Number2Precision (spring.mDampingRatio, 6);
               
               //from v1.08
               jointValues.mFrequencyDeterminedManner = spring.GetFrequencyDeterminedManner ();
               jointValues.mFrequency = ValueAdjuster.Number2Precision (spring.GetFrequency (), 6);
               jointValues.mSpringConstant = ValueAdjuster.Number2Precision (spring.GetSpringConstant () * mEntityContainer.GetCoordinateSystem ().D2P_Length (1.0) / mEntityContainer.GetCoordinateSystem ().D2P_ForceMagnitude (1.0), 6);
               jointValues.mBreakExtendedLength = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (spring.GetBreakExtendedLength ()), 6);
               //<<
               
               ShowSpringSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               jointValues.mBreakDeltaLength = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (distance.GetBreakDeltaLength ()), 6);
               //<<
               
               ShowDistanceSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var weld:EntityJointWeld = joint as EntityJointWeld;
               
               ShowWeldSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               ShowDummySettingDialog (values, ConfirmSettingEntityProperties);
            }
         }
         else if (entity is EntityUtility)
         {
            var utility:EntityUtility = entity as EntityUtility;
            
            if (entity is EntityUtilityCamera)
            {
               var camera:EntityUtilityCamera = utility as EntityUtilityCamera;
               
               //from v1.08
               values.mFollowedTarget = camera.GetFollowedTarget ();
               values.mFollowingStyle = camera.GetFollowingStyle ();
               //<<
               
               ShowCameraSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityUtilityPowerSource)
            {
               var powerSource:EntityUtilityPowerSource = entity as EntityUtilityPowerSource;
               
               values.mEventId = powerSource.GetKeyboardEventId ();
               values.mKeyCodes = powerSource.GetKeyCodes ();
               values.mPowerSourceType = powerSource.GetPowerSourceType ();
               values.mPowerMagnitude = powerSource.GetPowerMagnitude ();
               
               switch (powerSource.GetPowerSourceType ())
               {
                  case Define.PowerSource_Torque:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_Torque (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Torque";
                     break;
                  case Define.PowerSource_LinearImpusle:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_ImpulseMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Linear Impulse";
                     break;
                  case Define.PowerSource_AngularImpulse:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_AngularImpulse (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Impulse";
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_AngularAcceleration (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Acceleration";
                     break;
                  case Define.PowerSource_AngularVelocity:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_AngularVelocity (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Velocity";
                     break;
                  //case Define.PowerSource_LinearAcceleration:
                  //   values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Acceleration";
                  //   break;
                  //case Define.PowerSource_LinearVelocity:
                  //   values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Velocity";
                  //   break;
                  case Define.PowerSource_Force:
                  default:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_ForceMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Force";
                     break;
               }
               values.mPowerMagnitude = ValueAdjuster.Number2Precision (values.mPowerMagnitude, 6);
               
               ShowPowerSourceSettingDialog (values, ConfirmSettingEntityProperties);
            }
         }
      }
      
      
      
      //private function OpenWorldSettingDialog ():void
      //{
      //   if (! IsEditing ())
      //      return;
      //   
      //   if (EditorContext.HasSettingDialogOpened ())
      //      return;
      //   
      //   var values:Object = new Object ();
      //   
      //   values.mAuthorName = mEntityContainer.GetAuthorName ();
      //   values.mAuthorHomepage = mEntityContainer.GetAuthorHomepage ();
      //   
      //   //>>from v1.02
      //   values.mShareSourceCode = mEntityContainer.IsShareSourceCode ();
      //   //<<
      //   
      //   ShowWorldSettingDialog (values, SetWorldProperties);
      //}
      
      public function OpenWorldSavingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (EditorContext.HasSettingDialogOpened ())
            return;
         
         try
         {
            // ...
            var width:int = EditorContext.GetEditorApp ().GetWorld ().GetViewportWidth ();
            var height:int = EditorContext.GetEditorApp ().GetWorld ().GetViewportHeight ();
            //var showPlayBar:Boolean = (EditorContext.GetEditorApp ().GetWorld ().GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0;
            var showPlayBar:Boolean = (EditorContext.GetEditorApp ().GetWorld ().GetViewerUiFlags () & (Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_UseOverlaySkin)) == Define.PlayerUiFlag_UseDefaultSkin;
            var heightWithPlayBar:int = (showPlayBar ? height + Define.DefaultPlayerSkinPlayBarHeight : height);
            
            var fileFormatVersionString:String = DataFormat3.GetVersionHexString (Version.VersionNumber);
            
            var values:Object = new Object ();
            
            //========== source code ========== 
         
            values.mXmlString = DataFormat2.WorldDefine2Xml (DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ()));
            
            //=========== play code ========== 
         
            // before v1.55, depreciated now
            //var playcode:String = DataFormat.WorldDefine2HexString (DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ())); 
            //values.mHexString = playcode;
            
            // new one, from v1.55
            var playcodeBase64:String = DataFormat.WorldDefine2PlayCode_Base64 (DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ()));
            
            values.mHexString = DataFormat3.CreateForumEmbedCode (fileFormatVersionString, width, height, showPlayBar, playcodeBase64);
            
            //======== html embed code ======== 
         
            // before v1.55, depreciated now
            //values.mEmbedCode = "<embed src=\"http://www.phyard.com/uniplayer.swf?app=ci&format=0x" + fileFormatVersionString
            //                  + "\"\n width=\"" + width + "\" height=\"" + heightWithPlayBar + "\"\n"
            //                  + "  FlashVars=\"playcode=" + playcode
            //                  + "\"\n quality=\"high\" allowScriptAccess=\"sameDomain\"\n type=\"application/x-shockwave-flash\"\n pluginspage=\"http://www.macromedia.com/go/getflashplayer\">\n</embed>"
            //                  ;
            
            // new one: add compressformat in FlashVars; change app=ci to app=coin and change format to fileversion in url.
            values.mEmbedCode = "<embed src=\"http://www.phyard.com/uniplayer.swf?app=coin&fileversion=0x" + fileFormatVersionString
                              + "\"\n width=\"" + width + "\" height=\"" + heightWithPlayBar + "\"\n"
                              + "  FlashVars=\"compressformat=" + DataFormat3.CompressFormat_Base64 + "&playcode=" + playcodeBase64
                              + "\"\n quality=\"high\" allowScriptAccess=\"sameDomain\"\n type=\"application/x-shockwave-flash\"\n pluginspage=\"http://www.macromedia.com/go/getflashplayer\">\n</embed>"
                              ;
            
            ShowWorldSavingDialog (values);
         }
         catch (error:Error)
         {
            Alert.show("Sorry, saving error!", "Error");
            
            if (Capabilities.isDebugger)
               throw error;
         }
      }
      
      public function OpenWorldLoadingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (EditorContext.HasSettingDialogOpened ())
            return;
         
         ShowWorldLoadingDialog (LoadEditorWorldFromXmlString);
      }
      
      //private function OpenCollisionGroupManageDialog ():void
      //{
      //   if (! IsEditing ())
      //      return;
      //   
      //   if (EditorContext.HasSettingDialogOpened ())
      //      return;
      //   
      //   ShowCollisionGroupManageDialog (null);
      //}
      
      //private function OpenPlayCodeLoadingDialog ():void
      //{
      //   if (! IsPlaying ())
      //      return;
      //   
      //   if (EditorContext.HasSettingDialogOpened ())
      //      return;
      //   
      //   ShowPlayCodeLoadingDialog (LoadPlayerWorldFromHexString);
      //}
      
      public function OpenImportSourceCodeDialog (importFunctionsOnly:Boolean):void
      {
         if (! IsEditing ())
            return;
         
         if (EditorContext.HasSettingDialogOpened ())
            return;
         
         if (importFunctionsOnly)
            ShowImportSourceCodeDialog (ImportFunctionsFromXmlString);
         else
            ShowImportSourceCodeDialog (ImportAllFromXmlString);
      }
      
//==================================================================================
// editing trigger setting
//==================================================================================
      
      //public var mStatusMessageBar:Label;
      
      public var mCustomTriggerButtons:Array;
      
      public function SetCustomTriggerButtons (buttons:Array):void
      {
         mCustomTriggerButtons = buttons;
         
         var button:Button;
         for (var i:int = 0; i < mCustomTriggerButtons.length; ++ i)
         {
            button = mCustomTriggerButtons [i] as Button;
            button.maxWidth = button.width;
            button.percentWidth = NaN;
            
            button.label = "" + ( (i + 1) % 10);
            button.width = button.maxWidth;
            
            button.addEventListener (MouseEvent.CLICK, OnCustomTriggerButtonClick);
         }
      }
      
      private function GetCustomTriggerIdByEventTarget (object:Object):int
      {
         if (mCustomTriggerButtons == null)
            return -1;
         
         return mCustomTriggerButtons.indexOf (object);
      }
      
      private function OnCustomTriggerButtonClick (event:Event):void
      {
         var index:int = GetCustomTriggerIdByEventTarget (event.target);
         if (index < 0)
            return;
         
         Alert.show("Alert", "Button #" + index + " is clicked.");
         
         if (mLastSelectedEntity != null)
         {
            //var func:Function = (mLastSelectedEntity as EntityVectorShape).SetDensity;
            //
            //func.apply (mLastSelectedEntity, [5.0]);
         }
      }
      
      public function OnClickEditorCustomCommand (event:ContextMenuEvent):void
      {
         var index:int = GetCustomTriggerIdByEventTarget (event.contextMenuOwner);
         if (index < 0)
            return;
         
         ShowEditorCustomCommandSettingDialog (null);
      }
      
//=================================================================================
//   coordinates
//=================================================================================
      
      // use the one in DisplayObjectUtil instead
      
      //public static function LocalToLocal (display1:DisplayObject, display2:DisplayObject, point:Point):Point
      //{
      //   //return display2.globalToLocal ( display1.localToGlobal (point) );
      //   
      //   var matrix:Matrix = display2.transform.concatenatedMatrix.clone();
      //   matrix.invert();
      //   return matrix.transformPoint (display1.transform.concatenatedMatrix.transformPoint (point));
      //}
      
      public function ViewToWorld (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (this, mEntityContainer, point);
      }
      
      public function WorldToView (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (mEntityContainer, this, point);
      }
      
      
//==================================================================================
// key modifiers and mouse modes
//==================================================================================
      
      private var _mouseEventCtrlDown:Boolean = false;
      private var _mouseEventShiftDown:Boolean = false;
      private var _mouseEventAltDown:Boolean = false;
      
      private var _isZeroMove:Boolean = false;
      
      private function CheckModifierKeys (event:MouseEvent):void
      {
         _mouseEventCtrlDown   = event.ctrlKey;
         _mouseEventShiftDown = event.shiftKey;
         _mouseEventAltDown     = event.altKey;
      }
      
      public static const MouseEditMode_None:int = -1;
      public static const MouseEditMode_MoveWorld:int = 0;
      public static const MouseEditMode_MoveSelecteds:int = 1;
      public static const MouseEditMode_RotateSelecteds:int = 2;
      public static const MouseEditMode_ScaleSelecteds:int = 3;
      
      public var mCurrentMouseEditMode:int = MouseEditMode_MoveSelecteds;
      public var mLastMouseEditMode:int = MouseEditMode_MoveSelecteds;
      
      private var mCookieModeEnabled:Boolean = false;
      
      public function SetCookieModeEnabled (enabled:Boolean):void
      {
         mCookieModeEnabled = enabled;
      }
      
      public function SetMouseEditModeEnabled (mode:int, modeEnabled:Boolean = false):void
      {
         if (modeEnabled)
            mCurrentMouseEditMode = mode;
         else
            mCurrentMouseEditMode = MouseEditMode_None;
         
         if (modeEnabled)
            mLastMouseEditMode = mCurrentMouseEditMode;
         
         mButtonMouseMoveScene.selected = false;
         mButtonMouseMove.selected = false;
         mButtonMouseRotate.selected = false;
         mButtonMouseScale.selected = false;
         
         if (modeEnabled)
         {
            if (mCurrentMouseEditMode == MouseEditMode_MoveWorld)
            {
               mButtonMouseMoveScene.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_MoveSelecteds)
            {
               mButtonMouseMove.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_RotateSelecteds)
            {
               mButtonMouseRotate.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_ScaleSelecteds)
            {
               mButtonMouseScale.selected = true;
            }
         }
      }
      
      private function ToggleMouseEditLocked ():void
      {
         if (mCurrentMouseEditMode != MouseEditMode_None)
            SetMouseEditModeEnabled (MouseEditMode_None, false);
         else if (mLastMouseEditMode != MouseEditMode_None)
            SetMouseEditModeEnabled (mLastMouseEditMode, true);
      }
      
      private function IsEntityMouseMoveEnabled ():Boolean
      {
         return mCurrentMouseEditMode != MouseEditMode_MoveWorld && mCurrentMouseEditMode == MouseEditMode_MoveSelecteds;
      }
      
      private function IsEntityMouseRotateEnabled ():Boolean
      {
         if (_mouseEventShiftDown && ! IsEntityMouseEditLocked ())
            return true;
         
         return mCurrentMouseEditMode != MouseEditMode_MoveWorld && mCurrentMouseEditMode == MouseEditMode_RotateSelecteds;
      }
      
      private function IsEntityMouseScaleEnabled ():Boolean
      {
         if (_mouseEventCtrlDown && ! IsEntityMouseEditLocked ())
            return true;
         
         return mCurrentMouseEditMode != MouseEditMode_MoveWorld && mCurrentMouseEditMode == MouseEditMode_ScaleSelecteds;
      }
      
      private function IsEntityMouseEditLocked ():Boolean
      {
         return mCurrentMouseEditMode == MouseEditMode_MoveWorld || mCurrentMouseEditMode == MouseEditMode_None;
      }
      
      private function StartMouseEditMode (worldPointX:Number, worldPointY:Number):void
      {
         if (_mouseEventShiftDown && _mouseEventCtrlDown)
         {
         }
         else
         {
            if (IsEntityMouseRotateEnabled ())
            {
               SetCurrentEditMode (new ModeRotateSelectedEntities (this));
            }
            else if (IsEntityMouseScaleEnabled ())
            {
               SetCurrentEditMode (new ModeScaleSelectedEntities (this));
            }
            else if (IsEntityMouseMoveEnabled ())
            {
               SetCurrentEditMode (new ModeMoveSelectedEntities (this));
            }
         }
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      public function OnMouseClick (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         CheckModifierKeys (event);
         
         if (IsEditing ())
         {
         }
      }
      
      public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         EditorContext.SetHasInputFocused (false);
         EditorContext.SetKeyboardListener (this);
         stage.focus = this;
         
         CheckModifierKeys (event);
         _isZeroMove = true;
         
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, EditorContext.GetEditorApp ().GetWorld (), new Point (event.localX, event.localY) );
         var worldPoint:Point = mEntityContainer.globalToLocal (new Point (Math.round(event.stageX), Math.round (event.stageY)));
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseDown (worldPoint.x, worldPoint.y);
            }
         }
         
         if (IsEditing ())
         {
            var entityArray:Array = mEntityContainer.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
            
         // move scene
            
            if (mCurrentMouseEditMode == MouseEditMode_MoveWorld || (_mouseEventShiftDown && entityArray.length == 0))
            {
               SetCurrentEditMode (new ModeMoveWorldScene (this));
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               _isZeroMove = false; // to prevent somecallings in OnMouseUp ()
               
               return;
            }
            
         // vertex controllers
            var vertexControllers:Array = mEntityContainer.GetVertexControllersAtPoint (worldPoint.x, worldPoint.y);
            
            if (vertexControllers.length > 0)
            {
               mEntityContainer.SetSelectedVertexController (vertexControllers[0]);
               SetCurrentEditMode (new ModeMoveSelectedVertexControllers (this, vertexControllers[0]));
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               return;
            }
            
            mEntityContainer.SetSelectedVertexController (null);
            
         // create / break logic link
            
            var linkable:Linkable = mEntityContainer.GetFirstLinkablesAtPoint (worldPoint.x, worldPoint.y);
            if (linkable != null && linkable.CanStartCreatingLink (worldPoint.x, worldPoint.y))
            {
               SetCurrentEditMode (new ModeCreateEntityLink (this, linkable));
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               return;
            }
            
         // entities
            
            var entity:Entity;
            
            // move selecteds, first time
            {
               if (mEntityContainer.AreSelectedEntitiesContainingPoint (worldPoint.x, worldPoint.y))
               {
                  StartMouseEditMode (worldPoint.x, worldPoint.y);
                   
                  if (mCurrentEditMode != null)
                     mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                  
                   return;
               }
            }
            
            // point select, ctrl not down.
            // for the situation: press on an unselected entity and move it
            if (entityArray.length > 0)
            {
               entity = (entityArray[0] as Entity);
               
               if ( (! _mouseEventCtrlDown) && ((! mCookieModeEnabled)) )
               {
                  SetTheOnlySelectedEntity (entity);
                  
                  _isZeroMove = false;
               }
            }
            
            // move selecteds, 2nd time
            {
               if (mEntityContainer.AreSelectedEntitiesContainingPoint (worldPoint.x, worldPoint.y))
               {
                  StartMouseEditMode (worldPoint.x, worldPoint.y);
                   
                  if (mCurrentEditMode != null)
                     mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                  
                  return;
               }
            }
            
            if (_mouseEventCtrlDown || mCookieModeEnabled)
               mLastSelectedEntities = mEntityContainer.GetSelectedEntities ();
            else
            {
               mEntityContainer.ClearSelectedEntities ();
               OnSelectedEntitiesChanged ();
            }
            
            // region select
            {
               //var entityArray:Array = mEntityContainer.GetEntityAtPoint (worldPoint.x, worldPoint.y, null);
               if (entityArray.length == 0)
               {
                  //_isZeroMove = false;
                  
                  SetCurrentEditMode (new ModeRegionSelectEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               }
            }
         }
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         UpdateMousePointInfo (new Point (event.stageX, event.stageY));
         
         var viewPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         
         var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         
         if ( ! rect.containsPoint (viewPoint) )
         {
            // wired: sometimes, moust out event can't be captured, so create a fake mouse out event here. (but, still not always work)
            OnMouseOut (event);
            return;
         }
         
         _isZeroMove = false;
         
         if (mCursorCreating.visible)
         {
            mCursorCreating.x = viewPoint.x;
            mCursorCreating.y = viewPoint.y;
         }
         
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, EditorContext.GetEditorApp ().GetWorld (), new Point (event.localX, event.localY) );
         var worldPoint:Point = mEntityContainer.globalToLocal (new Point (Math.round(event.stageX), Math.round (event.stageY)));
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseMove (worldPoint.x, worldPoint.y);
            }
         }
         
         
         if (IsEditing ())
         {
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.OnMouseMove (worldPoint.x, worldPoint.y);
            }
         }
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, EditorContext.GetEditorApp ().GetWorld (), new Point (event.localX, event.localY) );
         var worldPoint:Point = mEntityContainer.globalToLocal (new Point (Math.round(event.stageX), Math.round (event.stageY)));
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseUp (worldPoint.x, worldPoint.y);
               
               return;
            }
         }
         
         
         if (IsEditing ())
         {
            if ( _isZeroMove && ! (mCurrentEditMode is ModeRegionSelectEntities) )
            {
               var vertexControllerArray:Array = mEntityContainer.GetSelectedVertexControllers ();
               if (vertexControllerArray.length > 0 && vertexControllerArray [0].ContainsPoint (worldPoint.x, worldPoint.y))
               {
               }
               else
               {
                  var entityArray:Array = mEntityContainer.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
                  var entity:Entity;
                  
                  // point select, ctrl down
                  if (entityArray.length > 0)
                  {
                     entity = (entityArray[0] as Entity);
                     
                     if ( _mouseEventCtrlDown || mCookieModeEnabled )
                     {
                        ToggleEntitySelected (entity);
                     }
                     else 
                     {
                        SetTheOnlySelectedEntity (entity);
                     }
                     
                     _isZeroMove = false; // weird? just to avoid the following calling
                  }
               }
            }
            
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.OnMouseUp (worldPoint.x, worldPoint.y);
            }
            
            if (_isZeroMove && (! _mouseEventCtrlDown) && mCookieModeEnabled)
            {
               mEntityContainer.ClearSelectedEntities ();
               OnSelectedEntitiesChanged ();
            }
         }
      }
      
      public function OnMouseOut (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         UpdateMousePointInfo (null);
         
         CheckModifierKeys (event);
         
         //var point:Point = DisplayObjectUtil.LocalToLocal ( (event.target as DisplayObject).parent, this, new Point (event.localX, event.localY) );
         var point:Point = globalToLocal ( new Point (event.stageX, event.stageY) );
         
         if ( new Rectangle (1, 1, width - 1, height - 1).containsPoint (point) )
            return;
         
         /*
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               CancelCurrentCreatingMode ();
               UpdateUiButtonsEnabledStatus ();
               CalSelectedEntitiesCenterPoint ();
            }
         }
         */
         
         if (IsEditing ())
         {
            if (mCurrentEditMode != null)
            {
               CancelCurrentEditingMode ();
               UpdateUiButtonsEnabledStatus ();
               CalSelectedEntitiesCenterPoint ();
            }
         }
      }
      
      public function OnMouseWheel (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         CheckModifierKeys (event);
         
         if (IsEditing ())
         {
         }
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         //trace ("event.keyCode = " + event.keyCode + ", event.charCode = " + event.charCode);
         
         if (IsPlaying ()) // playing
         {
            switch (event.keyCode)
            {
               case 70: // F
               //case Keyboard.SPACE: // cancelled from v1.55
                  mDesignPlayer.UpdateSingleStep (); 
                  break;
               default:
                  break;
            }
         }
         else if (IsCreating ())
         {
            switch (event.keyCode)
            {
               case Keyboard.ESCAPE:
                  if (mCurrentCreateMode != null)
                  {
                     CancelCurrentCreatingMode ();
                  }
                  break;
               default:
                  break;
            }
         }
         else if (IsEditing ())
         {
            switch (event.keyCode)
            {
               case Keyboard.ESCAPE:
                  //if (mCurrentCreateMode != null)
                  //{
                  //   CancelCurrentEditingMode ();
                  //}
                  //else
                  {
                     mEntityContainer.ClearSelectedEntities ();
                     OnSelectedEntitiesChanged ();
                  }
                  break;
               case Keyboard.SPACE:
                  OpenEntitySettingDialog ();
                  break;
               case Keyboard.DELETE:
                  if (event.ctrlKey)
                     DeleteSelectedVertexController ();
                  else
                     DeleteSelectedEntities ();
                  break;
               case Keyboard.INSERT:
                  if (event.ctrlKey)
                     InsertVertexController ();
                  else
                     CloneSelectedEntities ();
                  break;
               case 68: // D
                  DeleteSelectedEntities ();
                  break;
               case 67: // C
                  CloneSelectedEntities ();
                  break;
               case Keyboard.PAGE_UP:
               case 88: // X
                  FlipSelectedEntitiesHorizontally ();
                  break;
               case Keyboard.PAGE_DOWN:
               case 89: // Y
                  FlipSelectedEntitiesVertically ();
                  break;
               case 85: // U
                  Undo ();
                  break;
               case 82: // R
                  Redo ();
                  break;
               case 80: // P
                  if (event.ctrlKey && event.shiftKey)
                     ExportSwfFile ();
                  break;
               case 83: // S
                  if (event.ctrlKey && event.shiftKey)
                     QuickSave ();
                  break;
               //case 76: // L // cancelled
               //   OpenPlayCodeLoadingDialog ();
               //   break;
               case 76: // L // cancelled
                  if (event.ctrlKey && event.shiftKey)
                     QuickLoad ();
                  break;
               //case 71: // G // cancelled
               //   GlueSelectedEntities ();
               //   break;
               //case 66: // B // cancelled
               //   BreakApartSelectedEntities ();
               //   break;
               case 192: // ~
                  ToggleMouseEditLocked ();
                  break;
               case Keyboard.LEFT:
                  if (event.shiftKey)
                     RotateSelectedEntities (- 0.5 * Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (-1, 0, true, false);
                  break;
               case Keyboard.RIGHT:
                  if (event.shiftKey)
                     RotateSelectedEntities (0.5 * Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (1, 0, true, false);
                  break;
               case Keyboard.UP:
                  if (event.shiftKey)
                     RotateSelectedEntities (- 5 * Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (0, -1, true, false);
                  break;
               case Keyboard.DOWN:
                  if (event.shiftKey)
                     RotateSelectedEntities (5* Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (0, 1, true, false);
                  break;
               case 187:// +
               case Keyboard.NUMPAD_ADD:
                  AlignCenterSelectedEntities ();
                  break;
               case 189:// -
               case Keyboard.NUMPAD_SUBTRACT:
                  RoundPositionForSelectedEntities ();
                  break;
               default:
                  break;
            }
         }
      }
      
//============================================================================
//    
//============================================================================
      
//============================================================================
//    
//============================================================================
      
      public function DestroyEntity (entity:Entity):void
      {
         mEntityContainer.DestroyEntity (entity);
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function SetShapeInitialProperties (shape:EntityVectorShape):void
      {
         //shape.SetPhysicsEnabled (EditorContext.mShape_EnablePhysics);
         //shape.SetStatic (EditorContext.mShape_IsStatic);
         //shape.SetAsSensor (EditorContext.mShape_IsSensor);
         //shape.SetDrawBackground (EditorContext.mShape_DrawBackground);
         //shape.SetFilledColor (EditorContext.mShape_BackgroundColor);
         //shape.SetDrawBorder (EditorContext.mShape_DrawBorder);
         //shape.SetBorderColor (EditorContext.mShape_BorderColor);
      }
      
      public function CreateCircle (centerX:Number, centerY:Number, radius:Number, filledColor:uint, isStatic:Boolean):EntityVectorShapeCircle
      {
         var centerPoint:Point = new Point (centerX, centerY);
         var edgePoint  :Point = new Point (centerX + radius, centerY);
         
         radius = Point.distance (centerPoint, edgePoint);
         
         var circle:EntityVectorShapeCircle = mEntityContainer.CreateEntityVectorShapeCircle ();
         if (circle == null)
            return null;
         
         circle.SetPosition (centerX, centerY);
         circle.SetRadius (radius);
         
         circle.SetFilledColor (filledColor);
         circle.SetStatic (isStatic);
         circle.SetDrawBorder (filledColor != Define.ColorStaticObject);
         circle.SetBuildBorder (circle.IsDrawBorder ());
         
         SetTheOnlySelectedEntity (circle);
         
         SetShapeInitialProperties (circle);
         
         return circle;
      }
      
      public function CreateRectangle (left:Number, top:Number, right:Number, bottom:Number, filledColor:uint, isStatic:Boolean):EntityVectorShapeRectangle
      {
         var startPoint:Point = new Point (left, top);
         var endPoint  :Point = new Point (right,bottom);
         
         var centerX:Number = (startPoint.x + endPoint.x) * 0.5;
         var centerY:Number = (startPoint.y + endPoint.y) * 0.5;
         
         var halfWidth :Number = (startPoint.x - endPoint.x) * 0.5; if (halfWidth  < 0) halfWidth  = - halfWidth;
         var halfHeight:Number = (startPoint.y - endPoint.y) * 0.5; if (halfHeight < 0) halfHeight = - halfHeight;
         
         var rect:EntityVectorShapeRectangle = mEntityContainer.CreateEntityVectorShapeRectangle ();
         if (rect == null)
            return null;
         
         rect.SetPosition (centerX, centerY);
         rect.SetHalfWidth  (halfWidth);
         rect.SetHalfHeight (halfHeight);
         
         rect.SetFilledColor (filledColor);
         rect.SetStatic (isStatic);
         rect.SetDrawBorder (filledColor != Define.ColorStaticObject);
         rect.SetBuildBorder (rect.IsDrawBorder ());
         
         SetTheOnlySelectedEntity (rect);
         
         SetShapeInitialProperties (rect);
         
         return rect;
      }
      
      public function CreatePolygon (filledColor:uint, isStatic:Boolean):EntityVectorShapePolygon
      {
         var polygon:EntityVectorShapePolygon = mEntityContainer.CreateEntityVectorShapePolygon ();
         if (polygon == null)
            return null;
         
         polygon.SetFilledColor (filledColor);
         polygon.SetStatic (isStatic);
         polygon.SetDrawBorder (filledColor != Define.ColorStaticObject);
         polygon.SetBuildBorder (polygon.IsDrawBorder ());
         polygon.SetBorderThickness (0);
         
         SetTheOnlySelectedEntity (polygon);
         
         SetShapeInitialProperties (polygon);
         
         return polygon;
      }
      
      public function CreatePolyline (filledColor:uint, isStatic:Boolean):EntityVectorShapePolyline
      {
         var polyline:EntityVectorShapePolyline = mEntityContainer.CreateEntityVectorShapePolyline ();
         if (polyline == null)
            return null;
         
         polyline.SetFilledColor (filledColor);
         polyline.SetStatic (isStatic);
         polyline.SetDrawBorder (filledColor != Define.ColorStaticObject);
         polyline.SetBuildBorder (polyline.IsDrawBorder ());
         
         SetTheOnlySelectedEntity (polyline);
         
         SetShapeInitialProperties (polyline);
         
         return polyline;
      }
      
      public function CreateHinge ():EntityJointHinge
      {
         var hinge:EntityJointHinge = mEntityContainer.CreateEntityJointHinge ();
         if (hinge == null)
            return null;
            
         SetTheOnlySelectedEntity (hinge.GetAnchor ());
         
         return hinge;
      }
      
      public function CreateDistance ():EntityJointDistance
      {
         var distaneJoint:EntityJointDistance = mEntityContainer.CreateEntityJointDistance ();
         if (distaneJoint == null)
            return null;
         
         SetTheOnlySelectedEntity (distaneJoint.GetAnchor2 ());
         
         return distaneJoint;
      }
      
      public function CreateSlider ():EntityJointSlider
      {
         var slider:EntityJointSlider = mEntityContainer.CreateEntityJointSlider ();
         if (slider == null)
            return null;
         
         SetTheOnlySelectedEntity (slider.GetAnchor2 ());
         
         return slider;
      }
      
      public function CreateSpring ():EntityJointSpring
      {
         var spring:EntityJointSpring = mEntityContainer.CreateEntityJointSpring ();
         if (spring == null)
            return null;
         
         SetTheOnlySelectedEntity (spring.GetAnchor2 ());
         
         return spring;
      }
      
      public function CreateWeldJoint ():EntityJointWeld
      {
         var weld:EntityJointWeld = mEntityContainer.CreateEntityJointWeld ();
         if (weld == null)
            return null;
         
         SetTheOnlySelectedEntity (weld.GetAnchor ());
         
         return weld;
      }
      
      public function CreateDummyJoint ():EntityJointDummy
      {
         var dummy:EntityJointDummy = mEntityContainer.CreateEntityJointDummy ();
         if (dummy == null)
            return null;
         
         SetTheOnlySelectedEntity (dummy.GetAnchor2 ());
         
         return dummy;
      }
      
      public function CreateText (options:Object = null):EntityVectorShapeText
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var shapeText:EntityVectorShapeText = mEntityContainer.CreateEntityVectorShapeText ();
            if (shapeText == null)
               return null;
            
            var halfWidth :Number = 50;
            var halfHeight:Number = 25;
            
            shapeText.SetHalfWidth  (halfWidth);
            shapeText.SetHalfHeight (halfHeight);
            
            shapeText.SetFilledColor (Define.ColorTextBackground);
            shapeText.SetStatic (true);
            
            SetTheOnlySelectedEntity (shapeText);
            
            SetShapeInitialProperties (shapeText);
            
            return shapeText;
         }
      }
      
      public function CreateEntityTextButton (options:Object = null):EntityVectorShapeTextButton
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var button:EntityVectorShapeTextButton = mEntityContainer.CreateEntityVectorShapeTextButton ();
            if (button == null)
               return null;
            
            button.SetStatic (true);
            
            SetTheOnlySelectedEntity (button);
            
            SetShapeInitialProperties (button);
            
            return button;
         }
      }
      
      public function CreateImageModuleShape (options:Object = null):EntityShapeImageModule
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var imageModule:EntityShapeImageModule = mEntityContainer.CreateEntityShapeImageModule ();
            if (imageModule == null)
               return null;
            
            imageModule.ChangeToCurrentAssetImageModule ();
            
            SetTheOnlySelectedEntity (imageModule);
            
            return imageModule;
         }
      }
      
      public function CreateImageModuleButtonShape (options:Object = null):EntityShapeImageModuleButton
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var imageModuleButton:EntityShapeImageModuleButton = mEntityContainer.CreateEntityShapeImageModuleButton ();
            if (imageModuleButton == null)
               return null;
            
            imageModuleButton.ChangeToCurrentAssetImageModule ();
            
            SetTheOnlySelectedEntity (imageModuleButton);
            
            return imageModuleButton;
         }
      }
      
      public function CreateGravityController (options:Object = null):EntityVectorShapeGravityController
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var gController:EntityVectorShapeGravityController = mEntityContainer.CreateEntityVectorShapeGravityController ();
            if (gController == null)
               return null;
            
            var radius:Number = 50;
            
            gController.SetRadius (radius);
            
            gController.SetStatic (true);
            
            SetTheOnlySelectedEntity (gController);
            
            return gController;
         }
      }
      
      public function CreateEntityUtilityCamera (options:Object = null):EntityUtilityCamera
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var camera:EntityUtilityCamera = mEntityContainer.CreateEntityUtilityCamera ();
            if (camera == null)
               return null;
            
            SetTheOnlySelectedEntity (camera);
            
            return camera;
         }
      }
      
      public function CreateEntityUtilityPowerSource (options:Object = null):EntityUtilityPowerSource
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var power_source:EntityUtilityPowerSource = mEntityContainer.CreateEntityUtilityPowerSource ();
            if (power_source == null)
               return null;
            
            power_source.SetPowerSourceType (options.mPowerSourceType);
            
            SetTheOnlySelectedEntity (power_source);
            
            return power_source;
         }
      }
      
      public function CreateEntityCondition (options:Object = null):EntityBasicCondition
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var condition:EntityBasicCondition = mEntityContainer.CreateEntityCondition ();
            if (condition == null)
               return null;
            
            SetTheOnlySelectedEntity (condition);
            
            return condition;
         }
      }
      
      public function CreateEntityConditionDoor (options:Object = null):EntityConditionDoor
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var condition_door:EntityConditionDoor = mEntityContainer.CreateEntityConditionDoor ();
            if (condition_door == null)
               return null;
            
            SetTheOnlySelectedEntity (condition_door);
            
            return condition_door;
         }
      }
      
      public function CreateEntityTask (options:Object = null):EntityTask
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var task:EntityTask = mEntityContainer.CreateEntityTask ();
            if (task == null)
               return null;
            
            SetTheOnlySelectedEntity (task);
            
            return task;
         }
      }
      
      public function CreateEntityInputEntityAssigner (options:Object = null):EntityInputEntityAssigner
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityAssigner).SetInternalComponentsVisible (true);
            return null;
         }
         else
         {
            var entity_assigner:EntityInputEntityAssigner = mEntityContainer.CreateEntityInputEntityAssigner ();
            if (entity_assigner == null)
               return null;
            
            SetTheOnlySelectedEntity (entity_assigner);
            
            return entity_assigner;
         }
      }
      
      public function CreateEntityInputEntityPairAssigner (options:Object = null):EntityInputEntityPairAssigner
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityPairAssigner).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_pair_assigner:EntityInputEntityPairAssigner = mEntityContainer.CreateEntityInputEntityPairAssigner ();
         if (entity_pair_assigner == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_pair_assigner);
         
         return entity_pair_assigner;
      }
      
      public function CreateEntityInputEntityRegionSelector (options:Object = null):EntityInputEntityRegionSelector
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityRegionSelector).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_region_selector:EntityInputEntityRegionSelector = mEntityContainer.CreateEntityInputEntityRegionSelector ();
         if (entity_region_selector == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_region_selector);
         
         return entity_region_selector;
      }
      
      public function CreateEntityInputEntityFilter (options:Object = null):EntityInputEntityScriptFilter
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityScriptFilter).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_filter:EntityInputEntityScriptFilter = mEntityContainer.CreateEntityInputEntityScriptFilter ();
         if (entity_filter == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_filter);
         
         return entity_filter;
      }
      
      public function CreateEntityInputEntityPairFilter (options:Object = null):EntityInputEntityPairScriptFilter
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityPairScriptFilter).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_pair_filter:EntityInputEntityPairScriptFilter = mEntityContainer.CreateEntityInputEntityPairScriptFilter ();
         if (entity_pair_filter == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_pair_filter);
         
         return entity_pair_filter;
      }
      
      public function CreateEntityEventHandler (options:Object = null):EntityEventHandler
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var handler:EntityEventHandler
            
            switch (options.mDefaultEventId)
            {
               case CoreEventIds.ID_OnWorldTimer:
                  handler = mEntityContainer.CreateEntityEventHandler_Timer (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnEntityTimer:
               case CoreEventIds.ID_OnEntityPairTimer:
                  handler = mEntityContainer.CreateEntityEventHandler_TimerWithPrePostHandling (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnPhysicsShapeMouseDown:
               case CoreEventIds.ID_OnPhysicsShapeMouseUp:
               case CoreEventIds.ID_OnEntityMouseClick:
               case CoreEventIds.ID_OnEntityMouseDown:
               case CoreEventIds.ID_OnEntityMouseUp:
               case CoreEventIds.ID_OnEntityMouseMove:
               case CoreEventIds.ID_OnEntityMouseEnter:
               case CoreEventIds.ID_OnEntityMouseOut:
               case CoreEventIds.ID_OnWorldMouseClick:
               case CoreEventIds.ID_OnWorldMouseDown:
               case CoreEventIds.ID_OnWorldMouseUp:
               case CoreEventIds.ID_OnWorldMouseMove:
                  handler = mEntityContainer.CreateEntityEventHandler_Mouse (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnWorldKeyDown:
               case CoreEventIds.ID_OnWorldKeyUp:
               case CoreEventIds.ID_OnWorldKeyHold:
                  handler = mEntityContainer.CreateEntityEventHandler_Keyboard (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting:
               case CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting:
               case CoreEventIds.ID_OnTwoPhysicsShapesEndContacting:
                  handler = mEntityContainer.CreateEntityEventHandler_Contact (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnJointReachLowerLimit:
               case CoreEventIds.ID_OnJointReachUpperLimit:
                  handler = mEntityContainer.CreateEntityEventHandler_JointReachLimit (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnSequencedModuleLoopToEnd:
                  handler = mEntityContainer.CreateEntityEventHandler_ModuleLoopToEnd (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnGameActivated:
               case CoreEventIds.ID_OnGameDeactivated:
                  handler = mEntityContainer.CreateEntityEventHandler_GameLostOrGotFocus (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               default:
                  handler = mEntityContainer.CreateEntityEventHandler (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
            }
            
            if (handler == null)
               return null;
            
            SetTheOnlySelectedEntity (handler);
            
            return handler;
         }
      }
      
      public function CreateEntityAction (options:Object = null):EntityAction
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var action:EntityAction = mEntityContainer.CreateEntityAction ();
            if (action == null)
               return null;
            
            SetTheOnlySelectedEntity (action);
            
            return action;
         }
      }
      
//============================================================================
//    
//============================================================================
      
      private var mMainSelectedEntity:Entity = null;
      
      private var mLastSelectedEntity:Entity = null;
      private var mLastSelectedEntities:Array = null;
      
      private var _SelectedEntitiesCenterPoint:Point = new Point ();
      
      public function SetLastSelectedEntities (entity:Entity):void
      {
         mLastSelectedEntity = entity;
         
         
         if (mLastSelectedEntity != null && EditorContext.GetEditorApp ().GetWorld () != null && mEntityContainer.IsEntitySelected (mLastSelectedEntity))
         {
            mLastSelectedEntity.SetInternalComponentsVisible (true);
            //mLastSelectedEntity.SetInternalComponentsVisible (mEntityContainer.GetNumSelectedEntities () == 1);
            
            mMainSelectedEntity = mLastSelectedEntity;
         }
         else
         {
            mMainSelectedEntity = EditorContext.GetEditorApp ().GetWorld () == null ? null : mEntityContainer.GetMainSelectedEntity ();
         }
         
         UpdateUiButtonsEnabledStatus ();
         UpdateSelectedEntityInfo ();
         
         NotifyEntityLinksModified ();
      }
      
      public function SetTheOnlySelectedEntity (entity:Entity):void
      {
         if (entity == null)
            return;
         
         mEntityContainer.ClearSelectedEntities ();
         UpdateSelectedEntityInfo ();
         
         if (mEntityContainer.GetSelectedEntities ().length != 1 || mEntityContainer.GetSelectedEntities () [0] != entity)
            mEntityContainer.SetSelectedEntity (entity);
         
         if (mEntityContainer.GetSelectedEntities ().length != 1)
            return;
         
         SetLastSelectedEntities (entity);
         
         if ((! mCookieModeEnabled))
            mEntityContainer.SelectGluedEntitiesOfSelectedEntities ();
         
         //CalSelectedEntitiesCenterPoint ();
         OnSelectedEntitiesChanged ();
      }
      
      public function ToggleEntitySelected (entity:Entity):void
      {
         mEntityContainer.ToggleEntitySelected (entity);
         
         if (mEntityContainer.IsEntitySelected (entity))
         {
            if (mLastSelectedEntity != null)
               mLastSelectedEntity.SetInternalComponentsVisible (false);
            
            entity.SetInternalComponentsVisible (true);
         }
         else
         {
            entity.SetInternalComponentsVisible (false);
         }
         
         SetLastSelectedEntities (entity);
         
         // to make selecting part of a glued possible
         // mEntityContainer.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         SelectedEntities (mEntityContainer.GetEntitiesIntersectWithRegion (left, top, right, bottom), true, ! mCookieModeEnabled);
      }
      
      public function SelectedEntities (entities:Array, clearOlds:Boolean, selectBorthers:Boolean):void
      {
         // the original implementation is far too slow.
         /*
         if (clearOlds)
         {
            mEntityContainer.ClearSelectedEntities ();
         }
         
         if (_mouseEventCtrlDown || mCookieModeEnabled)
         {
            if (mLastSelectedEntities != null)
               mEntityContainer.SelectEntities (mLastSelectedEntities);
            
            //mEntityContainer.SelectEntities (entities);
            for (var i:int = 0; i < entities.length; ++ i)
            {
               mEntityContainer.ToggleEntitySelected (entities [i]);
            }
         }
         else
            mEntityContainer.SelectEntities (entities);
         
         if (selectBorthers)
         {
            mEntityContainer.SelectGluedEntitiesOfSelectedEntities ();
         }
         
         OnSelectedEntitiesChanged ();
         */
         
         // new implementation
         
         if (selectBorthers)
         {
            entities = mEntityContainer.GetAllGluedEntities (entities);
         }
         
         if ((_mouseEventCtrlDown || mCookieModeEnabled) && (mLastSelectedEntities != null))
         {
            if (mEntityContainer.SelectEntitiesByToggleTwoEntityArrays (mLastSelectedEntities, entities))
            {
               OnSelectedEntitiesChanged ();
            }
         }
         else
         {
            if (mEntityContainer.SetSelectedEntities (entities, clearOlds))
            {
               OnSelectedEntitiesChanged ();
            }
         }
      }
      
      public function OnSelectedEntitiesChanged ():void
      {
         CalSelectedEntitiesCenterPoint ();
         
         var selecteds:Array = mEntityContainer.GetSelectedEntities ();
         if (selecteds.length > 0)
         {
            SetLastSelectedEntities (selecteds [0]);
         }
         else
         {
            SetLastSelectedEntities (null);
         }
      }
      
      public function GetSelectedEntitiesCenterX ():Number
      {
         return _SelectedEntitiesCenterPoint.x;
      }
      
      public function GetSelectedEntitiesCenterY ():Number
      {
         return _SelectedEntitiesCenterPoint.y;
      }
      
      public function CalSelectedEntitiesCenterPoint ():void
      {
         var centerX:Number = 0;
         var centerY:Number = 0;
         
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         var count:uint = 0;
         
         for (var i:uint = 0; i < selectedEntities.length; ++ i)
         {
            var entity:Entity = selectedEntities[i] as Entity;
            
            if (entity != null)
            {
               centerX += entity.GetPositionX ();
               centerY += entity.GetPositionY ();
               ++ count;
            }
         }
         
         if (count > 0)
         {
            centerX /= count;
            centerY /= count;
            
            _SelectedEntitiesCenterPoint.x = centerX;
            _SelectedEntitiesCenterPoint.y = centerY;
            
            UpdateSelectedEntitiesCenterSprite ();
         }
         
         var showCenter:Boolean = count > 1;
         
         if (count == 1)
         {
            entity = selectedEntities [0];
            if (entity is EntityVectorShapePolygon)
               showCenter = true;
            else
               showCenter = false;
         }
         
         mSelectedEntitiesCenterSprite.visible = showCenter;
         
         UpdateUiButtonsEnabledStatus ();
         
         UpdateSelectedEntityInfo ();
         
         NotifyEntityLinksModified ();
         
         NotifyEntityIdsModified ();
      }
      
      protected var mAccumulatedCausedByArrowKeys_MovementX:Number = 0;
      protected var mAccumulatedCausedByArrowKeys_MovementY:Number = 0;
      protected function TryCreateUndoPointCausedByArrowKeys_Movement ():void
      {
         if (mAccumulatedCausedByArrowKeys_MovementX != 0 || mAccumulatedCausedByArrowKeys_MovementY != 0)
         {
            mAccumulatedCausedByArrowKeys_MovementX = 0;
            mAccumulatedCausedByArrowKeys_MovementY = 0;
            CreateUndoPoint ("Move entities by arrow keys", null, null, false);
         }
      }
      
      protected var mAccumulatedCausedByArrowKeys_Rotation:Number = 0;
      protected function TryCreateUndoPointCausedByArrowKeys_Rotation ():void
      {
         if (mAccumulatedCausedByArrowKeys_Rotation != 0)
         {
            mAccumulatedCausedByArrowKeys_Rotation = 0;
            CreateUndoPoint ("Rotate entities by arrow keys", null, null, false);
         }
      }
      
      protected function ClearAccumulatedModificationsByArrowKeys ():void
      {
         mAccumulatedCausedByArrowKeys_MovementX = 0;
         mAccumulatedCausedByArrowKeys_MovementY = 0;
         mAccumulatedCausedByArrowKeys_Rotation = 0;
      }
      
      // at any time, most one delayed undo point exists.
      protected function TryCreateDelayedUndoPoint ():void
      {
         TryCreateUndoPointCausedByArrowKeys_Movement ();
         TryCreateUndoPointCausedByArrowKeys_Rotation ();
      }
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseMoveEnabled () )
            return;
         
         mEntityContainer.MoveSelectedEntities (offsetX, offsetY, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
         
         TryCreateUndoPointCausedByArrowKeys_Rotation (); // right! rotate
         if (! byMouse)
         {
            mAccumulatedCausedByArrowKeys_MovementX += offsetX;
            mAccumulatedCausedByArrowKeys_MovementY += offsetY;
         }
      }
      
      public function RotateSelectedEntities (dAngle:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseRotateEnabled () )
            return;
         
         mEntityContainer.RotateSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), dAngle, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
         
         TryCreateUndoPointCausedByArrowKeys_Movement (); // right! move
         if (! byMouse)
         {
            mAccumulatedCausedByArrowKeys_Rotation += dAngle;
         }
      }
      
      public function ScaleSelectedEntities (ratio:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseScaleEnabled () )
            return;
         
         mEntityContainer.ScaleSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), ratio, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
         
         if ((! byMouse) && (ratio != 1.0))
         {
            CreateUndoPoint ("Scale entities");
         }
      }
      
      public function DeleteSelectedEntities ():void
      {
         if (mEntityContainer.DeleteSelectedEntities ())
         {
            CreateUndoPoint ("Delete");
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function CloneSelectedEntities ():void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         
         var clonedable:Boolean = false;
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            if ( (selectedEntities[i] as Entity).IsClonedable () )
            {
               clonedable = true;
               break;
            }
         }
         if (! clonedable)
            return;
         
         mEntityContainer.CloneSelectedEntities (Define.BodyCloneOffsetX, Define.BodyCloneOffsetY);
         
         selectedEntities = mEntityContainer.GetSelectedEntities ();
         if (selectedEntities.length == 1)
         {
            SetLastSelectedEntities (selectedEntities [0]);
         }
         
         CreateUndoPoint ("Clone");
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function FlipSelectedEntitiesHorizontally ():void
      {
         mEntityContainer.FlipSelectedEntitiesHorizontally (GetSelectedEntitiesCenterX ());
         
         CreateUndoPoint ("Horizontal flip");
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function FlipSelectedEntitiesVertically ():void
      {
         mEntityContainer.FlipSelectedEntitiesVertically (GetSelectedEntitiesCenterY ());
         
         CreateUndoPoint ("Vertical flip");
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function GlueSelectedEntities ():void
      {
         mEntityContainer.GlueSelectedEntities ();
         
         CreateUndoPoint ("Make brothers");
      }
      
      public function BreakApartSelectedEntities ():void
      {
         mEntityContainer.BreakApartSelectedEntities ();
         
         CreateUndoPoint ("Break brothers");
      }
      
      public function ClearAllEntities (showAlert:Boolean = true, resetScene:Boolean = false):void
      {
         if (showAlert)
            Alert.show("Do you want to clear all objects?", "Clear All", 3, this, resetScene ? OnCloseClearAllAndResetSceneAlert : OnCloseClearAllAlert, null, Alert.NO);
         else
         {
            if (resetScene)
            {
               EditorContext.GetEditorApp ().SetWorld (new editor.world.World ());
               mViewCenterWorldX = DefaultWorldWidth * 0.5;
               mViewCenterWorldY = DefaultWorldHeight * 0.5;
               mEntityContainerZoomScale = 1.0;
               
               mShowAllEntityLinks = false;
               mShowAllEntityIds = false;
               
               UpdateChildComponents ();
               
               if (NotifyEditingScaleChanged != null)
                  NotifyEditingScaleChanged ();
            }
            else
            {
               mEntityContainer.DestroyAllEntities ();
            }
            
            CreateUndoPoint ("Clear world");
            
            CalSelectedEntitiesCenterPoint ();
            
            //EditorContext.mCollisionCategoryView.UpdateFriendLinkLines ();
            if (CollisionCategoryListDialog.sCollisionCategoryListDialog != null)
            {
               CollisionCategoryListDialog.sCollisionCategoryListDialog.GetCollisionCategoryListPanel ().UpdateAssetLinkLines ();
            }
            //EditorContext.mFunctionEditingView.UpdateEntityLinkLines ();
            if (CodeLibListDialog.sCodeLibListDialog != null)
            {
               CodeLibListDialog.sCodeLibListDialog.GetCodeLibListPanel ().UpdateFriendLinkLines ();
            }
            
            EditorContext.SetRecommandDesignFilename (null);
         }
      }
      
      private function OnCloseClearAllAlert (event:CloseEvent):void 
      {
         if (event == null || event.detail==Alert.YES)
         {
            ClearAllEntities (false, false);
         }
      }
      
      private function OnCloseClearAllAndResetSceneAlert (event:CloseEvent):void 
      {
         if (event == null || event.detail==Alert.YES)
         {
            ClearAllEntities (false, true);
         }
      }
      
      public function MoveSelectedEntitiesToTop ():void
      {
         mEntityContainer.MoveSelectedEntitiesToTop ();
         
         CreateUndoPoint ("Move entities to the most top layer");
         
         UpdateSelectedEntityInfo ();
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
         mEntityContainer.MoveSelectedEntitiesToBottom ();
         
         CreateUndoPoint ("Move entities to the most bottom layer");
         
         UpdateSelectedEntityInfo ();
      }
      
      public function AlignCenterSelectedEntities ():void
      {
         // try to find the largest circle and set its position as target position, 
         // if no circle found, set the first joint anchor as target position,
         // 
         
         var entities:Array = mEntityContainer.GetSelectedEntities ();
         var entity:Entity;
         var i:int;
         var centerX:Number;
         var centerY:Number;
         var maxArea:Number = 0;
         var area:Number;
         var numShapes:int = 0;
         var circleRadius:Number;
         var numAnchors:int = 0;
         for (i = 0; i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            if (entity is EntityVectorShapeCircle)
            {
               ++ numShapes;
               circleRadius = (entity as EntityVectorShapeCircle).GetRadius ();
               area = Math.PI * circleRadius * circleRadius;
               if ( area > maxArea )
               {
                  maxArea = area;
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
            }
            else if (entity is EntityVectorShapeRectangle)
            {
               ++ numShapes;
               area = 4 * (entity as EntityVectorShapeRectangle).GetHalfWidth () * (entity as EntityVectorShapeRectangle).GetHalfHeight ();
               if ( area > maxArea )
               {
                  maxArea = area;
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
            }
            else if (entity is SubEntityJointAnchor)
            {
               if (numShapes == 0 && numAnchors == 0)
               {
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
               
               ++ numAnchors;
            }
         }
         
         if (numShapes + numAnchors > 1)
         {
            for (i = 0; i < entities.length; ++ i)
            {
               entity = entities [i] as Entity;
               if (entity is EntityVectorShapeCircle || entity is EntityVectorShapeRectangle || entity is SubEntityJointAnchor)
                  entity.Move (centerX - entity.GetPositionX (), centerY - entity.GetPositionY (), true);
            }
            
            CreateUndoPoint ("Coincide entity centers");
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function RoundPositionForSelectedEntities ():void
      {
         var entities:Array = mEntityContainer.GetSelectedEntities ();
         var entity:Entity;
         var i:int;
         var posX:Number;
         var posY:Number;
         for (i = 0; i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            posX = Math.round (entity.GetPositionX ());
            posY = Math.round (entity.GetPositionY ());
            entity.SetPosition (posX, posY);
         }
         
         if (entities.length > 0)
            CalSelectedEntitiesCenterPoint ();
      }
      
//============================================================================
//    vertex controllers
//============================================================================
      
      public function MoveSelectedVertexControllers (offsetX:Number, offsetY:Number):void
      {
         if (mEntityContainer.GetSelectedVertexControllers ().length > 0)
         {
            mEntityContainer.MoveSelectedVertexControllers (offsetX, offsetY);
         }
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function DeleteSelectedVertexController ():void
      {
         if (mEntityContainer.GetSelectedVertexControllers ().length > 0)
         {
            mEntityContainer.DeleteSelectedVertexControllers ();
            
            CreateUndoPoint ("Delete a vertex");
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function InsertVertexController ():void
      {
         if (mEntityContainer.GetSelectedVertexControllers ().length > 0)
         {
            mEntityContainer.InsertVertexControllerBeforeSelectedVertexControllers ();
            
            CreateUndoPoint ("Insert a vertex");
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
//=================================================================================
//   set properties
//=================================================================================
      
      protected function UpdateShapePhysicsProperties (shape:EntityShape, params:Object):void
      {        
         shape.SetCollisionCategoryIndex (params.mCollisionCategoryIndex);
         
         shape.SetPhysicsEnabled (params.mIsPhysicsEnabled);
         shape.SetAsSensor (params.mIsSensor);
         shape.SetStatic (params.mIsStatic);
         shape.SetAsBullet (params.mIsBullet);
         shape.SetHollow (params.mIsHollow);
         shape.SetBuildBorder (params.mBuildBorder);
         shape.SetDensity (params.mDensity);
         shape.SetFriction (params.mFriction);
         shape.SetRestitution (params.mRestitution);
         
         if (params.mLinearVelocityMagnitude < 0)
         {
            params.mLinearVelocityMagnitude = -params.mLinearVelocityMagnitude;
            params.mLinearVelocityAngle = 360.0 - params.mLinearVelocityAngle;
         }
         shape.SetLinearVelocityMagnitude (mEntityContainer.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mLinearVelocityMagnitude));
         shape.SetLinearVelocityAngle (mEntityContainer.GetCoordinateSystem ().P2D_RotationDegrees (params.mLinearVelocityAngle));
         shape.SetAngularVelocity (mEntityContainer.GetCoordinateSystem ().P2D_AngularVelocity (params.mAngularVelocity));
         shape.SetLinearDamping (params. mLinearDamping);
         shape.SetAngularDamping (params.mAngularDamping);
         shape.SetAllowSleeping (params.mAllowSleeping);
         shape.SetFixRotation (params.mFixRotation);
      }
      
      public function ConfirmSettingEntityProperties (params:Object):void
      {
         //var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         //if (selectedEntities == null || selectedEntities.length != 1)
         //   return;
         if (mMainSelectedEntity == null)
            return;
         
         //var entity:Entity = selectedEntities [0] as Entity;
         var entity:Entity = mMainSelectedEntity;
         
         var newPosX:Number = mEntityContainer.GetCoordinateSystem ().P2D_PositionX (params.mPosX);
         var newPosY:Number = mEntityContainer.GetCoordinateSystem ().P2D_PositionY (params.mPosY);
         if (! mEntityContainer.IsInfiniteSceneSize ())
         {
            //todo: seems this is not essential
            newPosX = MathUtil.GetClipValue (newPosX, mEntityContainer.GetWorldLeft () - Define.WorldFieldMargin, mEntityContainer.GetWorldRight () + Define.WorldFieldMargin);
            newPosY = MathUtil.GetClipValue (newPosY, mEntityContainer.GetWorldTop () - Define.WorldFieldMargin, mEntityContainer.GetWorldBottom () + Define.WorldFieldMargin);
         }
         
         entity.SetPosition (newPosX, newPosY);
         entity.SetRotation (mEntityContainer.GetCoordinateSystem ().P2D_RotationRadians (params.mAngle * Define.kDegrees2Radians));
         entity.SetVisible (params.mIsVisible);
         entity.SetAlpha (params.mAlpha);
         entity.SetEnabled (params.mIsEnabled);
         
         if (entity is EntityLogic)
         {
            var logic:EntityLogic = entity as EntityLogic;
            
            var code_snippet:CodeSnippet;
            
            if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               
               code_snippet = event_handler.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEntityContainer.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  timer_event_handler.SetRunningInterval (params.mRunningInterval);
                  timer_event_handler.SetOnlyRunOnce (params.mOnlyRunOnce);
                  
                  if (entity is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timer_event_handler_withPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
                     
                     var pre_code_snippet:CodeSnippet = timer_event_handler_withPrePostHandling.GetPreCodeSnippet ();
                     pre_code_snippet.AssignFunctionCallings (params.mReturnPreFunctionCallings);
                     pre_code_snippet.PhysicsValues2DisplayValues (mEntityContainer.GetCoordinateSystem ());
                     
                     var post_code_snippet:CodeSnippet = timer_event_handler_withPrePostHandling.GetPostCodeSnippet ();
                     post_code_snippet.AssignFunctionCallings (params.mReturnPostFunctionCallings);
                     post_code_snippet.PhysicsValues2DisplayValues (mEntityContainer.GetCoordinateSystem ());
                  }
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  //keyboard_event_handler.ChangeKeyboardEventId (params.mEventId);
                  keyboard_event_handler.SetKeyCodes (params.mKeyCodes);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  var mouse_event_handler:EntityEventHandler_Mouse = entity as EntityEventHandler_Mouse;
                  
                  //mouse_event_handler.ChangeMouseEventId (params.mEventId);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  var contact_event_handler:EntityEventHandler_Contact = entity as EntityEventHandler_Contact;
                  
                  //contact_event_handler.ChangeContactEventId (params.mEventId);
               }
               else if (entity is EntityEventHandler_JointReachLimit)
               {
                   var jointReachLimit_event_handler:EntityEventHandler_JointReachLimit = entity as EntityEventHandler_JointReachLimit;
               }
               else if (entity is EntityEventHandler_GameLostOrGotFocus)
               {
                   var gameLostOrGotFocus_event_handler:EntityEventHandler_GameLostOrGotFocus = entity as EntityEventHandler_GameLostOrGotFocus;
               }
               else if (entity is EntityEventHandler_ModuleLoopToEnd)
               {
                  //
               }
               
               if (params.mEventId != event_handler.GetEventId ())
               {
                  event_handler.ChangeToIsomorphicEventId (params.mEventId );
               }
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               
               condition.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = condition.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEntityContainer.GetCoordinateSystem ());
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               
               action.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = action.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEntityContainer.GetCoordinateSystem ());
            }
            else if (entity is EntityInputEntityScriptFilter)
            {
               var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
               
               entityFilter.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = entityFilter.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEntityContainer.GetCoordinateSystem ());
            }
            else if (entity is EntityInputEntityPairScriptFilter)
            {
               var pairFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
               
               pairFilter.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = pairFilter.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEntityContainer.GetCoordinateSystem ());
            }
            else if (entity is EntityConditionDoor)
            {
            }
            else if (entity is EntityTask)
            {
            }
            else if (entity is EntityInputEntityAssigner)
            {
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
            }
            
            logic.UpdateAppearance ();
            logic.UpdateSelectionProxy ();
         }
         else if (entity is EntityVectorShape)
         {
            var vectorShape:EntityVectorShape = entity as EntityVectorShape;
            
            vectorShape.SetDrawBorder (params.mDrawBorder);
            vectorShape.SetTransparency (params.mTransparency);
            vectorShape.SetBorderColor (params.mBorderColor);
            vectorShape.SetBorderThickness (params.mBorderThickness);
            vectorShape.SetDrawBackground (params.mDrawBackground);
            vectorShape.SetFilledColor (params.mBackgroundColor);
            vectorShape.SetBorderTransparency (params.mBorderTransparency);
            
            vectorShape.SetAiType (params.mAiType);

            if (vectorShape.IsBasicVectorShapeEntity ())
            {
               UpdateShapePhysicsProperties (vectorShape, params);
               
               if (entity is EntityVectorShapeCircle)
               {
                  (vectorShape as EntityVectorShapeCircle).SetRadius (mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mRadius));
                  (vectorShape as EntityVectorShapeCircle).SetAppearanceType (params.mAppearanceType);
               }
               else if (entity is EntityVectorShapeRectangle)
               {
                  (vectorShape as EntityVectorShapeRectangle).SetHalfWidth (0.5 * mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mWidth));
                  (vectorShape as EntityVectorShapeRectangle).SetHalfHeight (0.5 * mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mHeight));
                  (vectorShape as EntityVectorShapeRectangle).SetRoundCorners (params.mIsRoundCorners);
               }
               else if (entity is EntityVectorShapePolygon)
               {
               }
               else if (entity is EntityVectorShapePolyline)
               {
                  (vectorShape as EntityVectorShapePolyline).SetCurveThickness (params.mCurveThickness);
                  (vectorShape as EntityVectorShapePolyline).SetRoundEnds (params.mIsRoundEnds);
                  (vectorShape as EntityVectorShapePolyline).SetClosed (params.mIsClosed);
               }
            }
            else // no physics entity
            {
               if (entity is EntityVectorShapeText)
               {
                  if (entity is EntityVectorShapeTextButton)
                  {
                     (vectorShape as EntityVectorShapeTextButton).SetUsingHandCursor (params.mUsingHandCursor);
                     
                     var moveOverShape:EntityVectorShape = (vectorShape as EntityVectorShapeTextButton).GetMouseOverShape ();
                     moveOverShape.SetDrawBorder (params.mMouseOverValues.mDrawBorder);
                     moveOverShape.SetTransparency (params.mMouseOverValues.mTransparency);
                     moveOverShape.SetDrawBorder (params.mMouseOverValues.mDrawBorder);
                     moveOverShape.SetBorderColor (params.mMouseOverValues.mBorderColor);
                     moveOverShape.SetBorderThickness (params.mMouseOverValues.mBorderThickness);
                     moveOverShape.SetDrawBackground (params.mMouseOverValues.mDrawBackground);
                     moveOverShape.SetFilledColor (params.mMouseOverValues.mBackgroundColor);
                     moveOverShape.SetBorderTransparency (params.mMouseOverValues.mBorderTransparency);
                   }
                  else
                  {
                  }
                  
                  (vectorShape as EntityVectorShapeText).SetWordWrap (params.mWordWrap);
                  (vectorShape as EntityVectorShapeText).SetAdaptiveBackgroundSize (params.mAdaptiveBackgroundSize);
                  
                  (vectorShape as EntityVectorShapeText).SetUnderlined (params.mIsUnderlined);
                  (vectorShape as EntityVectorShapeText).SetTextAlign (params.mTextAlign);
                  
                  (vectorShape as EntityVectorShapeText).SetText (params.mText);
                  (vectorShape as EntityVectorShapeText).SetTextColor (params.mTextColor);
                  (vectorShape as EntityVectorShapeText).SetFontSize (params.mFontSize);
                  (vectorShape as EntityVectorShapeText).SetBold (params.mIsBold);
                  (vectorShape as EntityVectorShapeText).SetItalic (params.mIsItalic);
                  
                  (vectorShape as EntityVectorShapeRectangle).SetHalfWidth (0.5 * mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mWidth));
                  (vectorShape as EntityVectorShapeRectangle).SetHalfHeight (0.5 * mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mHeight));
               }
               else if (entity is EntityVectorShapeGravityController)
               {
                  (vectorShape as EntityVectorShapeCircle).SetRadius (mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mRadius));
                  
                  //(vectorShape as EntityVectorShapeGravityController).SetInteractive (params.mIsInteractive);
                  (vectorShape as EntityVectorShapeGravityController).SetInteractiveZones (params.mInteractiveZones);
                  
                  (vectorShape as EntityVectorShapeGravityController).mInteractiveConditions = params.mInteractiveConditions;
                  
                  if (params.mInitialGravityAcceleration < 0)
                  {
                     params.mInitialGravityAcceleration = -params.mInitialGravityAcceleration;
                     params.mInitialGravityAngle = 360.0 - params.mInitialGravityAngle;
                  }
                  
                  (vectorShape as EntityVectorShapeGravityController).SetMaximalGravityAcceleration (mEntityContainer.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mMaximalGravityAcceleration));
                  (vectorShape as EntityVectorShapeGravityController).SetInitialGravityAcceleration (mEntityContainer.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mInitialGravityAcceleration));
                  (vectorShape as EntityVectorShapeGravityController).SetInitialGravityAngle (mEntityContainer.GetCoordinateSystem ().P2D_RotationDegrees (params.mInitialGravityAngle));
               }
            }
            
            vectorShape.UpdateAppearance ();
            vectorShape.UpdateSelectionProxy ();
            
            if (vectorShape is EntityVectorShapeRectangle)
            {
               (vectorShape as EntityVectorShapeRectangle).UpdateVertexControllers (true);
            }
         }
         else if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            if (entity is EntityShapeImageModule)
            {
               var moduleShape:EntityShapeImageModule = entity as EntityShapeImageModule;
               
               UpdateShapePhysicsProperties (moduleShape, params);
               
               moduleShape.SetAssetImageModule (params.mModule);
               
               moduleShape.UpdateAppearance ();
               moduleShape.UpdateSelectionProxy ();
            }
            else if (entity is EntityShapeImageModuleButton)
            {
               var moduleShapeButton:EntityShapeImageModuleButton = entity as EntityShapeImageModuleButton;
               
               UpdateShapePhysicsProperties (moduleShapeButton, params);
               
               moduleShapeButton.SetAssetImageModuleForMouseUp (params.mModuleUp);
               moduleShapeButton.SetAssetImageModuleForMouseOver (params.mModuleOver);
               moduleShapeButton.SetAssetImageModuleForMouseDown (params.mModuleDown);
               
               moduleShapeButton.UpdateAppearance ();
               moduleShapeButton.UpdateSelectionProxy ();
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            var jointAnchor:SubEntityJointAnchor = entity as SubEntityJointAnchor;
            var joint:EntityJoint = jointAnchor.GetMainEntity () as EntityJoint;
            
            var jointParams:Object = params.mJointValues;
            
            joint.mCollideConnected = jointParams.mCollideConnected;
            
            newPosX = mEntityContainer.GetCoordinateSystem ().P2D_PositionX (jointParams.mPosX);
            newPosY = mEntityContainer.GetCoordinateSystem ().P2D_PositionY (jointParams.mPosY);
            if (! mEntityContainer.IsInfiniteSceneSize ())
            {
               newPosX = MathUtil.GetClipValue (newPosX, mEntityContainer.GetWorldLeft (), mEntityContainer.GetWorldRight ());
               newPosY = MathUtil.GetClipValue (newPosY, mEntityContainer.GetWorldTop (), mEntityContainer.GetWorldBottom ());
            }
            joint.SetPosition (newPosX, newPosY);
            joint.SetRotation (mEntityContainer.GetCoordinateSystem ().P2D_RotationRadians (jointParams.mAngle * Define.kDegrees2Radians));
            joint.SetVisible (jointParams.mIsVisible);
            joint.SetAlpha (jointParams.mAlpha);
            joint.SetEnabled (jointParams.mIsEnabled);
            
            //>> from v1.02
            joint.SetConnectedShape1Index (jointParams.mConntectedShape1Index);
            joint.SetConnectedShape2Index (jointParams.mConntectedShape2Index);
            //<<
            
            //from v1.08
            joint.SetBreakable (jointParams.mIsBreakable);
            //<<
            
            if (entity is SubEntityHingeAnchor)
            {
               var hinge:EntityJointHinge = joint as EntityJointHinge;
               
               hinge.SetLimitsEnabled (jointParams.mEnableLimit);
               hinge.SetLimits (mEntityContainer.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mLowerAngle), mEntityContainer.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mUpperAngle));
               hinge.mEnableMotor = jointParams.mEnableMotor;
               hinge.mMotorSpeed = mEntityContainer.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mMotorSpeed);
               hinge.mBackAndForth = jointParams.mBackAndForth;
               
               //>>from v1.04
               hinge.SetMaxMotorTorque (mEntityContainer.GetCoordinateSystem ().P2D_Torque (jointParams.mMaxMotorTorque));
               //<<
               
               // 
               hinge.GetAnchor ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = joint as EntityJointSlider;
               
               slider.SetLimitsEnabled (jointParams.mEnableLimit);
               slider.SetLimits (mEntityContainer.GetCoordinateSystem ().P2D_Length (jointParams.mLowerTranslation), mEntityContainer.GetCoordinateSystem ().P2D_Length (jointParams.mUpperTranslation));
               slider.mEnableMotor = jointParams.mEnableMotor;
               slider.mMotorSpeed = mEntityContainer.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (jointParams.mMotorSpeed);
               slider.mBackAndForth = jointParams.mBackAndForth;
               
               //>>from v1.04
               slider.SetMaxMotorForce (mEntityContainer.GetCoordinateSystem ().P2D_ForceMagnitude (jointParams.mMaxMotorForce));
               //<<
               
               // 
               slider.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               slider.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntitySpringAnchor)
            {
               var spring:EntityJointSpring = joint as EntityJointSpring;
               
               spring.SetStaticLengthRatio (jointParams.mStaticLengthRatio);
               spring.SetSpringType (jointParams.mSpringType);
               spring.mDampingRatio = jointParams.mDampingRatio;
               
               //from v1.08
               spring.SetFrequencyDeterminedManner (jointParams.mFrequencyDeterminedManner);
               spring.SetFrequency (jointParams.mFrequency);
               spring.SetSpringConstant (jointParams.mSpringConstant * mEntityContainer.GetCoordinateSystem ().P2D_Length (1.0) / mEntityContainer.GetCoordinateSystem ().P2D_ForceMagnitude (1.0));
               spring.SetBreakExtendedLength (mEntityContainer.GetCoordinateSystem ().P2D_Length (jointParams.mBreakExtendedLength));
               //<<
               
               // 
               spring.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               spring.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               distance.SetBreakDeltaLength (mEntityContainer.GetCoordinateSystem ().P2D_Length (jointParams.mBreakDeltaLength));
               //<<
               
               // 
               distance.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               distance.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               var weld:EntityJointWeld = joint as EntityJointWeld;
               
               // 
               weld.GetAnchor ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               // 
               dummy.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               dummy.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            
            jointAnchor.GetMainEntity ().UpdateAppearance ();
            jointAnchor.UpdateSelectionProxy ();
         }
         else if (entity is EntityUtility)
         {
            var utility:EntityUtility = entity as EntityUtility;
            
            if (entity is EntityUtilityCamera)
            {
               var camera:EntityUtilityCamera = utility as EntityUtilityCamera;
               
               //from v1.08
               camera.SetFollowedTarget (params.mFollowedTarget);
               camera.SetFollowingStyle (params.mFollowingStyle);
               //<<
            }
            else if (entity is EntityUtilityPowerSource)
            {
               var powerSource:EntityUtilityPowerSource = entity as EntityUtilityPowerSource;
               
               powerSource.SetKeyboardEventId (params.mEventId);
               powerSource.SetKeyCodes (params.mKeyCodes);
               
               switch (powerSource.GetPowerSourceType ())
               {
                  case Define.PowerSource_Torque:
                     params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_Torque (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_LinearImpusle:
                     params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_ImpulseMagnitude (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularImpulse:
                     params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_AngularImpulse (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_AngularAcceleration (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularVelocity:
                     params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_AngularVelocity (params.mPowerMagnitude);
                     break;
                  //case Define.PowerSource_LinearAcceleration:
                  //   params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mPowerMagnitude);
                  //   break;
                  //case Define.PowerSource_LinearVelocity:
                  //   params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mPowerMagnitude);
                  //   break;
                  case Define.PowerSource_Force:
                  default:
                     params.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().P2D_ForceMagnitude (params.mPowerMagnitude);
                     break;
               }
               powerSource.SetPowerMagnitude (params.mPowerMagnitude);
            }
            
            utility.UpdateAppearance ();
            utility.UpdateSelectionProxy ();
         }
         
         if (entity != null)
         {
            CreateUndoPoint ("The properties of entity [" + entity.GetTypeName ().toLowerCase () + "] are changed", null, entity);
            
            UpdateSelectedEntityInfo ();
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function OnBatchModifyEntityCommonProperties (params:Object):void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         var entity:Entity;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            entity = selectedEntities [i];
            
            if (entity != null)
            {
               if (params.mToModifyAngle)
                  entity.SetRotation (mEntityContainer.GetCoordinateSystem ().P2D_RotationRadians (params.mAngle * Define.kDegrees2Radians));
               if (params.mToModifyAlpha)
                  entity.SetAlpha (params.mAlpha);
               if (params.mToModifyVisible)
                  entity.SetVisible (params.mIsVisible);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify common proeprties for " + selectedEntities.length + " entities", null, null);
      }
      
      public function OnBatchModifyShapeCircleProperties (params:Object):void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         var circle:EntityVectorShapeCircle;
         
         var numCircles:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            circle = selectedEntities [i] as EntityVectorShapeCircle;
            
            if (circle != null)
            {
               ++ numCircles;
               
               if (params.mToModifyAppearanceType)
                  circle.SetAppearanceType (params.mAppearanceType);
               if (params.mToModifyRadius)
                  circle.SetRadius (mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mRadius));
               
               circle.UpdateAppearance ();
               circle.UpdateSelectionProxy ();
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify proeprties for " + numCircles + " circles", null, null);
      }
      
      public function OnBatchModifyShapeRectangleProperties (params:Object):void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         var rect:EntityVectorShapeRectangle;
         
         var numRectangles:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            rect = selectedEntities [i] as EntityVectorShapeRectangle;
            
            if (rect != null)
            {
               ++ numRectangles;
            
               if (params.mToModifyRoundCorners)
                  rect.SetRoundCorners (params.mIsRoundCorners);
               if (params.mToModifyWidth)
                  rect.SetHalfWidth (0.5 * mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mWidth));
               if (params.mToModifyHeight)
                  rect.SetHalfHeight (0.5 * mEntityContainer.GetCoordinateSystem ().P2D_Length (params.mHeight));
            
               rect.UpdateAppearance ();
               rect.UpdateSelectionProxy ();
               rect.UpdateVertexControllers (true);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify proeprties for " + numRectangles + " rectangles", null, null);
      }
      
      public function OnBatchModifyShapePolylineProperties (params:Object):void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         var polyline:EntityVectorShapePolyline;
         
         var numPolylines:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            polyline = selectedEntities [i] as EntityVectorShapePolyline;
            
            if (polyline != null)
            {
               ++  numPolylines;
            
               if (params.mToModifyCurveThickness)
                  polyline.SetCurveThickness (params.mCurveThickness);
               if (params.mToModifyRoundEnds)
                  polyline.SetRoundEnds (params.mIsRoundEnds);
               if (params.mToModifyClosed)
                  polyline.SetClosed (params.mIsClosed);
            
               polyline.UpdateAppearance ();
               polyline.UpdateSelectionProxy ();
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify proeprties for " +  numPolylines + " polylines", null, null);
      }
      
      public function OnBatchModifyShapeAppearanceProperties (params:Object):void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         
         var numShapes:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            var shape:EntityVectorShape = selectedEntities [i] as EntityVectorShape;
            
            if (shape != null)
            {
               ++ numShapes;
               
               if (shape.IsBasicVectorShapeEntity ())
               {
                  if (params.mToModifyAiType)
                     shape.SetAiType (params.mAiType);
               }
               
               if (params.mToModifyDrawBackground)
                  shape.SetDrawBackground (params.mDrawBackground);
               if (params.mToModifyTransparency)
                  shape.SetTransparency (params.mTransparency);
               if (params.mToModifyBackgroundColor)
                  shape.SetFilledColor (params.mBackgroundColor);
               if (params.mToModifyDrawBorder)
                  shape.SetDrawBorder (params.mDrawBorder);
               if (params.mToModifyBorderColor)
                  shape.SetBorderColor (params.mBorderColor);
               if (params.mToModifyBorderThickness)
                  shape.SetBorderThickness (params.mBorderThickness);
               if (params.mToModifyBorderTransparency)
                  shape.SetBorderTransparency (params.mBorderTransparency);
            }
            
            shape.UpdateAppearance ();
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify appearances proeprties for " + numShapes + " shapes", null, null);
      }
      
      public function OnBatchModifyShapePhysicsProperties (params:Object):void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         
         var numShapes:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            //var shape:EntityVectorShape = selectedEntities [i] as EntityVectorShape;
            var shape:EntityShape = selectedEntities [i] as EntityShape;
            
            if (shape != null)
            {
               ++ numShapes;
               
               // flags
               if (params.mToModifyEnablePhysics)
                  shape.SetPhysicsEnabled (params.mIsPhysicsEnabled);
               if (params.mToModifyStatic)
                  shape.SetStatic (params.mIsStatic);
               if (params.mToModifyBullet)
                  shape.SetAsBullet (params.mIsBullet);
               if (params.mToModifySensor)
                  shape.SetAsSensor (params.mIsSensor);
               if (params.mToModifyHollow)
                  shape.SetHollow (params.mIsHollow);
               if (params.mToModifyBuildBorder)
                  shape.SetBuildBorder (params.mBuildBorder);
               if (params.mToModifAllowSleeping)
                  shape.SetAllowSleeping (params.mAllowSleeping);
               if (params.mToModifyFixRotation)
                  shape.SetFixRotation (params.mFixRotation);
               
               // ccat
               if (params.mToModifyCCat)
                  shape.SetCollisionCategoryIndex (params.mCollisionCategoryIndex);
               
               // velocity
               if (params.mToModifyLinearVelocityMagnitude)
                  shape.SetLinearVelocityMagnitude (mEntityContainer.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mLinearVelocityMagnitude));
               if (params.mToModifyLinearVelocityAngle)
                  shape.SetLinearVelocityAngle (mEntityContainer.GetCoordinateSystem ().P2D_RotationDegrees (params.mLinearVelocityAngle));
               if (params.mToModifyAngularVelocity)
                  shape.SetAngularVelocity (mEntityContainer.GetCoordinateSystem ().P2D_AngularVelocity (params.mAngularVelocity));
               
               // fixture
               if (params.mToModifyDensity)
                  shape.SetDensity (params.mDensity);
               if (params.mToModifyFriction)
                  shape.SetFriction (params.mFriction);
               if (params.mToModifyRestitution)
                  shape.SetRestitution (params.mRestitution);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify physics proeprties for " + numShapes + " shapes", null, null);
      }
      
      public function OnBatchModifyJointCollideConnectedsProperty (params:Object):void
      {
         var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
         var joint:EntityJoint;
         var anchor:SubEntityJointAnchor;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            anchor = selectedEntities [i] as SubEntityJointAnchor;
            
            if (anchor != null)
            {
               joint = anchor.GetMainEntity () as EntityJoint;
               
               if (joint != null)
               {
                  joint.mCollideConnected = params.mCollideConnected;
               }
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify collid-connected proeprty for " + selectedEntities.length + " joints", null, null);
      }
      
//=================================================================================
//   world settings
//=================================================================================
      
      public function GetCurrentWorldDesignInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mShareSoureCode = EditorContext.GetEditorApp ().GetWorld ().IsShareSourceCode ();
         info.mPermitPublishing = EditorContext.GetEditorApp ().GetWorld ().IsPermitPublishing ();
         info.mAuthorName = EditorContext.GetEditorApp ().GetWorld ().GetAuthorName ();
         info.mAuthorHomepage = EditorContext.GetEditorApp ().GetWorld ().GetAuthorHomepage ();
         
         return info;
      }
      
      public function SetCurrentWorldDesignInfo (info:Object):void
      {
         EditorContext.GetEditorApp ().GetWorld ().SetShareSourceCode (info.mShareSoureCode);
         EditorContext.GetEditorApp ().GetWorld ().SetPermitPublishing (info.mPermitPublishing);
         EditorContext.GetEditorApp ().GetWorld ().SetAuthorName (info.mAuthorName);
         EditorContext.GetEditorApp ().GetWorld ().SetAuthorHomepage (info.mAuthorHomepage);
         
         CreateUndoPoint ("Author info is modified");
      }
      
      public function GetCurrentWorldCoordinateSystemInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mIsRightHand = mEntityContainer.GetCoordinateSystem ().IsRightHand ();
         info.mScale = mEntityContainer.GetCoordinateSystem ().GetScale ();
         info.mOriginX = mEntityContainer.GetCoordinateSystem ().GetOriginX ();
         info.mOroginY = mEntityContainer.GetCoordinateSystem ().GetOriginY ();
         
         return info;
      }
      
      public function SetCurrentWorldCoordinateSystemInfo (info:Object):void
      {
         mEntityContainer.RebuildCoordinateSystem (
                  info.mOriginX,
                  info.mOroginY,
                  info.mScale,
                  info.mIsRightHand
               );
         
         UpdateSelectedEntityInfo ();
         
         CreateUndoPoint ("Coordinate system is modified");
      }
      
      public function GetCurrentWorldLevelRulesInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mIsPauseOnFocusLost = EditorContext.GetEditorApp ().GetWorld ().IsPauseOnFocusLost ();
         info.mIsCiRulesEnabled = mEntityContainer.IsCiRulesEnabled ();
         
         return info;
      }
      
      public function SetCurrentWorldLevelRulesInfo (info:Object):void
      {  
         EditorContext.GetEditorApp ().GetWorld ().SetPauseOnFocusLost (info.mIsPauseOnFocusLost);
         mEntityContainer.SetCiRulesEnabled (info.mIsCiRulesEnabled);
         
         CreateUndoPoint ("World rules are changed");
      }
      
      public function GetCurrentWorldPhysicsyInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mPreferredFPS = mEntityContainer.GetPreferredFPS ();
         info.mPhysicsSimulationEnabled = mEntityContainer.IsPhysicsSimulationEnabled ();
         info.mPhysicsSimulationStepTimeLength = mEntityContainer.GetPhysicsSimulationStepTimeLength ();
         info.mVelocityIterations = mEntityContainer.GetPhysicsSimulationVelocityIterations ();
         info.mPositionIterations = mEntityContainer.GetPhysicsSimulationPositionIterations ();
         info.mCheckTimeOfImpact = mEntityContainer.IsCheckTimeOfImpact ();
         info.mInitialSpeedX = mEntityContainer.GetInitialSpeedX ();
         info.mAutoSleepingEnabled = mEntityContainer.IsAutoSleepingEnabled ();
         info.mDefaultGravityAccelerationMagnitude = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (mEntityContainer.GetDefaultGravityAccelerationMagnitude ()), 6);
         info.mDefaultGravityAccelerationAngle = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (mEntityContainer.GetDefaultGravityAccelerationAngle ()), 6);
         
         return info;
      }
      
      public function SetCurrentWorldPhysicsInfo (info:Object):void
      {
         mEntityContainer.SetPreferredFPS (info.mPreferredFPS);
         mEntityContainer.SetPhysicsSimulationEnabled (info.mPhysicsSimulationEnabled);
         mEntityContainer.SetPhysicsSimulationStepTimeLength (info.mPhysicsSimulationStepTimeLength);
         mEntityContainer.SetPhysicsSimulationIterations (info.mVelocityIterations, info.mPositionIterations);
         mEntityContainer.SetCheckTimeOfImpact (info.mCheckTimeOfImpact);
         mEntityContainer.SetInitialSpeedX (info.mInitialSpeedX);
         mEntityContainer.SetAutoSleepingEnabled (info.mAutoSleepingEnabled);
         mEntityContainer.SetDefaultGravityAccelerationMagnitude (mEntityContainer.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (info.mDefaultGravityAccelerationMagnitude));
         mEntityContainer.SetDefaultGravityAccelerationAngle (mEntityContainer.GetCoordinateSystem ().P2D_RotationDegrees (info.mDefaultGravityAccelerationAngle));
         
         CreateUndoPoint ("World physics settings are changed");
      }
      
      public function GetCurrentWorldAppearanceInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mIsInfiniteSceneSize = mEntityContainer.IsInfiniteSceneSize ();
         info.mWorldLeft = mEntityContainer.GetWorldLeft ();
         info.mWorldTop = mEntityContainer.GetWorldTop ();
         info.mWorldWidth = mEntityContainer.GetWorldWidth ();
         info.mWorldHeight = mEntityContainer.GetWorldHeight ();
         
         info.mBackgroundColor = mEntityContainer.GetBackgroundColor ();
         info.mBorderColor = mEntityContainer.GetBorderColor ();
         info.mIsBuildBorder = mEntityContainer.IsBuildBorder ();
         info.mIsBorderAtTopLayer = mEntityContainer.IsBorderAtTopLayer ();
         info.mWorldBorderLeftThickness = mEntityContainer.GetWorldBorderLeftThickness ();
         info.mWorldBorderTopThickness = mEntityContainer.GetWorldBorderTopThickness ();
         info.mWorldBorderRightThickness  = mEntityContainer.GetWorldBorderRightThickness ();
         info.mWorldBorderBottomThickness = mEntityContainer.GetWorldBorderBottomThickness ();
         
         info.mViewportWidth = EditorContext.GetEditorApp ().GetWorld ().GetViewportWidth ();
         info.mViewportHeight = EditorContext.GetEditorApp ().GetWorld ().GetViewportHeight ();
         
         return info;
      }
      
      public function SetCurrentWorldAppearanceInfo (info:Object):void
      {
         mEntityContainer.SetInfiniteSceneSize (info.mIsInfiniteSceneSize);
         mEntityContainer.SetWorldLeft (info.mWorldLeft);
         mEntityContainer.SetWorldTop (info.mWorldTop);
         mEntityContainer.SetWorldWidth (info.mWorldWidth);
         mEntityContainer.SetWorldHeight (info.mWorldHeight);
         
         mEntityContainer.SetBackgroundColor (info.mBackgroundColor);
         mEntityContainer.SetBorderColor (info.mBorderColor);
         mEntityContainer.SetBuildBorder (info.mIsBuildBorder);
         mEntityContainer.SetBorderAtTopLayer (info.mIsBorderAtTopLayer);
         mEntityContainer.SetWorldBorderLeftThickness (info.mWorldBorderLeftThickness);
         mEntityContainer.SetWorldBorderTopThickness (info.mWorldBorderTopThickness);
         mEntityContainer.SetWorldBorderRightThickness (info.mWorldBorderRightThickness);
         mEntityContainer.SetWorldBorderBottomThickness (info.mWorldBorderBottomThickness);
         
         UpdateChildComponents ();
         
         CreateUndoPoint ("World appearance is changed");
      }
      
      public function GetViewportInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mViewerUiFlags = EditorContext.GetEditorApp ().GetWorld ().GetViewerUiFlags ();
         info.mPlayBarColor = EditorContext.GetEditorApp ().GetWorld ().GetPlayBarColor ();
         
         info.mViewportWidth = EditorContext.GetEditorApp ().GetWorld ().GetViewportWidth ();
         info.mViewportHeight = EditorContext.GetEditorApp ().GetWorld ().GetViewportHeight ();
         
         info.mCameraRotatingEnabled = mEntityContainer.IsCameraRotatingEnabled ();
         
         return info;
      }
      
      public function SetViewportInfo (info:Object):void
      {
         EditorContext.GetEditorApp ().GetWorld ().SetViewerUiFlags (info.mViewerUiFlags);
         EditorContext.GetEditorApp ().GetWorld ().SetPlayBarColor (info.mPlayBarColor);
         
         EditorContext.GetEditorApp ().GetWorld ().SetViewportWidth (info.mViewportWidth);
         EditorContext.GetEditorApp ().GetWorld ().SetViewportHeight (info.mViewportHeight);
         
         mEntityContainer.SetCameraRotatingEnabled (info.mCameraRotatingEnabled);
         
         EditorContext.GetEditorApp ().GetWorld ().ValidateViewportSize ();
         
         CreateUndoPoint ("World appearance is changed");
      }
      
//=================================================================================
//   move scene
//=================================================================================
      
      public function MoveWorldScene (dx:Number, dy:Number):void
      {
         var sceneLeft  :int = mEntityContainer.GetWorldLeft ();
         var sceneTop   :int = mEntityContainer.GetWorldTop ();
         var sceneRight :int = sceneLeft + mEntityContainer.GetWorldWidth ();
         var sceneBottom:int = sceneTop  + mEntityContainer.GetWorldHeight ();
         
         mViewCenterWorldX -= dx;
         mViewCenterWorldY -= dy;
         
         UpdateBackgroundAndWorldPosition ();
      }
      
      public function GoToEntity (entityIds:Array):void
      {
         var first:Boolean = true;
         
         for each (var entityId:int in entityIds)
         {
            if (entityId < 0 || entityId >= mEntityContainer.GetNumEntities ())
               continue;
            
            var entity:Entity = mEntityContainer.GetEntityByCreationId (entityId);
            
            var posX:Number = entity.GetPositionX ();
            var posY:Number = entity.GetPositionY ();
            
            var viewPoint:Point = DisplayObjectUtil.LocalToLocal (mEntityContainer, this, new Point (posX, posY) );
            if (viewPoint.x >= 0 && viewPoint.x < mViewWidth)
               posX = mViewCenterWorldX;
            if (viewPoint.y>= 0 && viewPoint.y < mViewHeight)
               posY = mViewCenterWorldY;
            
            var dx:Number = mViewCenterWorldX - posX;
            var dy:Number = mViewCenterWorldY - posY;
            
            if (first)
            {
               first = false;
               
               if (dx != 0 || dy != 0)
               {
                  MoveWorldScene (dx, dy);
               }
            }
            
            // aiming effect
            mEditingEffectLayer.addChild (new EffectCrossingAiming (entity));
         }
      }
      
      public function SelectEntityByIds (entityIds:Array, clearOldSelecteds:Boolean = true, selectBoothers:Boolean = false):void
      {
         if (entityIds == null)
            return;
         
         var entites:Array = new Array ();
         
         for each (var entityId:int in entityIds)
         {
            if (entityId < 0 || entityId >= mEntityContainer.GetNumEntities ())
               continue;
            
            var entity:Entity = mEntityContainer.GetEntityByCreationId (entityId);
            
            var posX:Number = entity.GetPositionX ();
            var posY:Number = entity.GetPositionY ();
            
            var viewPoint:Point = DisplayObjectUtil.LocalToLocal (mEntityContainer, this, new Point (posX, posY) );
            if (viewPoint.x >= 0 && viewPoint.x < mViewWidth)
               posX = mViewCenterWorldX;
            if (viewPoint.y>= 0 && viewPoint.y < mViewHeight)
               posY = mViewCenterWorldY;
            
            var dx:Number = mViewCenterWorldX - posX;
            var dy:Number = mViewCenterWorldY - posY;
            
            // aiming effect
            mEditingEffectLayer.addChild (new EffectCrossingAiming (entity));
            
            //if (entity is EntityJoint)
            //{
            //   var subEntities:Array = (entity as EntityJoint).GetSubEntities ();
            //   for each (var subEntity:Entity in subEntities)
            //   {
            //      entites.push (subEntity);
            //   }
            //}
            //else
            //{
            //   entites.push (entity);
            //}
            var selectableEntites:Array =  entity.GetSelectableEntities ();
            for each (var selectableEntity:Entity in selectableEntites)
            {
                entites.push (selectableEntity);
            }
         }
         
         SelectedEntities (entites, clearOldSelecteds, selectBoothers);
      }
      
//=================================================================================
//   offline load (xml)
//=================================================================================
      
      public function LoadEditorWorldFromXmlString (params:Object):void
      {
         var newWorld:editor.world.World = null;
         
         EditorContext.GetEditorApp ().CloseWorld ();
         
         try
         {
            var codeString:String = params.mXmlString;
            
            var newWorldDefine:WorldDefine = null;
            
            if (codeString != null)
            {
         //trace ("111");
               const Text_PlayCode:String = "playcode";
               if (codeString.length > Text_PlayCode.length && codeString.substring (0, Text_PlayCode.length) == Text_PlayCode)
               {
                  var Text_OldCodeStarting:String = "434F494E";
                  var offset:int = codeString.indexOf (Text_OldCodeStarting, Text_PlayCode.length);
                  if (offset > 0) // old playcode
                  {
         //trace ("222");
                     newWorldDefine = DataFormat2.HexString2WorldDefine (codeString.substring (offset));
                  }
                  else // new base64 playcode
                  {
         //trace ("333");
                     offset = Text_PlayCode.length;
                     var Text_CompressFormat:String = "compressformat=base64";
                     offset = codeString.indexOf (Text_CompressFormat, offset);
                     if (offset > 0)
                     {
         //trace ("aaa");
                        offset += Text_CompressFormat.length;
                        var Text_PlayCode2:String = "playcode=";
                        offset = codeString.indexOf (Text_PlayCode2, offset);
                        if (offset > 0)
                        {
         //trace ("bbb");
                           offset += Text_PlayCode2.length;
                           var offset2:int = codeString.indexOf ("@}", offset);
                           if (offset2 > 0)
                           {
         //trace ("ccc");
                              newWorldDefine = DataFormat2.PlayCode2WorldDefine_Base64 (codeString.substring (offset, offset2));
                           }
                        }
                     }
                  }
               }
               else
               {
                  var xml:XML = new XML (codeString);
                  
                  newWorldDefine = DataFormat.Xml2WorldDefine (xml);
               }
            }
            
            if (newWorldDefine == null)
               throw new Error ("newWorldDefine == null !!!");
            
            newWorld = DataFormat.WorldDefine2EditorWorld (newWorldDefine);
            
            EditorContext.GetEditorApp ().SetWorld (newWorld);
            
            //mWorldHistoryManager.ClearHistories ();
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Offline loading succeeded", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
            
            CreateUndoPoint ("Offline loading");
         }
         catch (error:Error)
         {
            if (Capabilities.isDebugger)
               throw error;
            
            //Alert.show ("Error: " + error + "\n " + error.getStackTrace ());
            
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
            
            //EditorContext.GetEditorApp ().SetWorld (new editor.world.World ());
            
            //Alert.show("Sorry, loading error!", "Error");
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Offline loading failed", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
         }
      }
      
      public function ExportSelectedsToSystemMemory ():void
      {
         var newWorld:editor.world.World = null;
         
         try
         {
            var worldDefine:WorldDefine = DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ());
            newWorld = DataFormat.WorldDefine2EditorWorld (worldDefine);
            
            var selectedEntities:Array = mEntityContainer.GetSelectedEntities ();
            
            if (selectedEntities.length == 0)
               return;
            
            var numEntities:int = selectedEntities.length;
            var i:int;
            var index:int;
            var entity:Entity;
            for (i = 0; i < numEntities; ++ i)
            {
               //trace ("selectedEntities[i] = " + selectedEntities[i]);
               //trace ("selectedEntities[i].parent = " + selectedEntities[i].parent);
               
               index = mEntityContainer.GetEntityCreationId (selectedEntities[i]);
               entity = newWorld.GetEntityContainer ().GetEntityByCreationId (index);
               
               entity = entity.GetMainEntity ();
               newWorld.GetEntityContainer ().SelectEntity (entity);
               newWorld.GetEntityContainer ().SelectEntities (entity.GetSelectableEntities ());
            }
            
            i = 0;
            //numEntities = newWorld.GetEntityContainer ().GetNumEntities (); // this is bug
            while (i < newWorld.GetEntityContainer ().GetNumEntities ()) // numEntities)
            {
               entity = newWorld.GetEntityContainer ().GetEntityByCreationId (i);
               if ( entity.IsSelected () ) // generally should use world.IsEntitySelected instead, this one is fast but only for internal uses
               {
                  ++ i;
               }
               else
               {
                  newWorld.GetEntityContainer ().DestroyEntity (entity);
               }
            }
            
            /*
            var cm:CollisionCManager = newWorld.GetCollisionManager ();
            var ccId:int;
            numEntities = newWorld.GetEntityContainer ().GetNumEntities ();
            
            for (i = 0; i < numEntities; ++ i)
            {
               entity = newWorld.GetEntityContainer ().GetEntityByCreationId (i);
               if (entity is EntityVectorShape)
               {
                  ccId = (entity as EntityVectorShape).GetCollisionCategoryIndex ();
                  if (ccId >= 0)
                     cm.SelectEntity (cm.GetCollisionCategoryByIndex (ccId));
               }
            }
            
            ccId = 0;
            //var numCats:int = cm.GetNumCollisionCategories ();// this is bug
            while (ccId < cm.GetNumCollisionCategories ()) //numCats)
            {
               entity = cm.GetCollisionCategoryByIndex (ccId);
               if ( entity.IsSelected () ) // generally should use world.IsEntitySelected instead, this one is fast but only for internal uses
               {
                  ++ ccId;
               }
               else
               {
                  cm.DestroyEntity (entity);
               }
            }
            */
            
            var cm:CollisionCategoryManager = newWorld.GetCollisionCategoryManager ();
            cm.ClearAssetSelections ();
            var ccId:int;
            numEntities = newWorld.GetEntityContainer ().GetNumEntities ();
            
            for (i = 0; i < numEntities; ++ i)
            {
               entity = newWorld.GetEntityContainer ().GetEntityByCreationId (i);
               if (entity is EntityVectorShape)
               {
                  ccId = (entity as EntityVectorShape).GetCollisionCategoryIndex ();
                  if (ccId >= 0)
                     cm.AddAssetSelection (cm.GetCollisionCategoryByIndex (ccId));
               }
            }
            
            var ccat:CollisionCategory;
            ccId = 0;
            //var numCats:int = cm.GetNumCollisionCategories ();// this is bug
            while (ccId < cm.GetNumCollisionCategories ()) //numCats)
            {
               ccat = cm.GetCollisionCategoryByIndex (ccId);
               if ( ccat.IsSelected () ) // generally should use world.IsEntitySelected instead, this one is fast but only for internal uses
               {
                  ++ ccId;
               }
               else
               {
                  cm.DestroyAsset (ccat);
               }
            }
            
            System.setClipboard(DataFormat2.WorldDefine2Xml (DataFormat.EditorWorld2WorldDefine (newWorld)));
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Export succeeded", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, export  error!", "Error");
            
            if (Capabilities.isDebugger)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Export failed", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
         }
         //finally // comment off for bug of secureSWF 
         {
            if (newWorld != null)
               newWorld.Destroy ();
         }
      }
      
      public function ImportFunctionsFromXmlString (params:Object):void
      {
         ImportFromXmlString (params, false, true);
      }
      
      public function ImportAllFromXmlString (params:Object):void
      {
         ImportFromXmlString (params, true, true);
      }
      
      public function ImportFromXmlString (params:Object, importEntities:Boolean, importFunctions:Boolean):void
      {
         var xmlString:String = params.mXmlString;
         var mergeVariablesWithSameNames:Boolean = params.mMergeVariablesWithSameNames;
         var centerNewEntitiesInScreen:Boolean = params.mCenterNewEntitiesInScreen;         
         
         var xml:XML = new XML (xmlString);
         
         try
         {
            var oldEntitiesCount:int = mEntityContainer.GetNumEntities ();
            var oldCategoriesCount:int = EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetNumCollisionCategories ();
            
            var worldDefine:WorldDefine = DataFormat.Xml2WorldDefine (xml);
            
            if (oldEntitiesCount + worldDefine.mEntityDefines.length > Define.MaxEntitiesCount)
               return;
            
            if (oldCategoriesCount + worldDefine.mCollisionCategoryDefines.length > Define.MaxCCatsCount)
               return;
            
            DataFormat.WorldDefine2EditorWorld (worldDefine, true, EditorContext.GetEditorApp ().GetWorld (), mergeVariablesWithSameNames);
            
            if (EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().IsChanged ())
            {
               EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().UpdateFunctionMenu ();
               EditorContext.GetEditorApp ().GetWorld ().GetCodeLibManager ().SetChanged (false)
            }
            
            if (oldEntitiesCount == mEntityContainer.numChildren)
               return;
            
            mEntityContainer.ClearSelectedEntities ();
            
            var i:int;
            var j:int;
            var entity:Entity;
            var entities:Array;
            var centerX:Number = 0;
            var centerY:Number = 0;
            var numSelecteds:int = 0;
            
            var newEntitiesCount:int = mEntityContainer.GetNumEntities ();
            
            var entitiesToSelect:Array = new Array ();
            for (i = oldEntitiesCount; i < newEntitiesCount; ++ i)
            {
               entities = (mEntityContainer.GetEntityByCreationId (i) as Entity).GetSelectableEntities ();
               entitiesToSelect = entitiesToSelect.concat (entities);
               
               for (j = 0; j < entities.length; ++ j)
               {
                  entity = entities [j] as Entity;
                  centerX += entity.GetPositionX ();
                  centerY += entity.GetPositionY ();
                  ++ numSelecteds;
               }
            }
            
            SelectedEntities (entitiesToSelect, true, false);

            if (centerNewEntitiesInScreen && numSelecteds > 0)
            {
               centerX /= numSelecteds;
               centerY /= numSelecteds;
               
               MoveSelectedEntities (mViewCenterWorldX - centerX, mViewCenterWorldY - centerY, true, false);
            }
            
            UpdateUiButtonsEnabledStatus ();
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Import succeeded", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
            
            CreateUndoPoint ("Import");
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, import error!", "Error");
            
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Import failed", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
            
            if (Capabilities.isDebugger)
               throw error;
         }
      }
      
//============================================================================
// undo / redo 
//============================================================================
      
      public function CreateUndoPoint (description:String, editActions:Array = null, targetEntity:Entity = null, tryCreateDelayedUndoPoints:Boolean = true):void
      {
         if (EditorContext.GetEditorApp ().GetWorld () == null)
            return;
         
         if (tryCreateDelayedUndoPoints)
         {
            TryCreateDelayedUndoPoint ();
         }
         
         var worldState:WorldState = new WorldState (description, editActions);
         
         var object:Object = new Object ();
         worldState.mUserData = object;
         
         object.mWorldDefine = DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ());
         
         var entityArray:Array = mEntityContainer.GetSelectedEntities ();
         
         object.mSelectedEntityCreationIds = new Array (entityArray.length);
         object.mMainSelectedEntityId = -1;
         object.mSelectedVertexControllerId = -1;
         object.mViewCenterWorldX = mViewCenterWorldX;
         object.mViewCenterWorldY = mViewCenterWorldY;
         //object.mEntityContainerZoomScale = mEntityContainerZoomScale;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            var entity:Entity = entityArray [i] as Entity;
            object.mSelectedEntityCreationIds [i] = mEntityContainer.GetEntityCreationId (entity);
            if (entity.AreInternalComponentsVisible ())
            {
               object.mMainSelectedEntityId = object.mSelectedEntityCreationIds [i];
               
               var vertexControllerArray:Array = mEntityContainer.GetSelectedVertexControllers ();
               if (vertexControllerArray.length > 0)
                  object.mSelectedVertexControllerId = entity.GetVertexControllerIndex (vertexControllerArray [0]);
            }
         }
         
         mWorldHistoryManager.AddHistory (worldState);
         
         var msgX:Number;
         var msgY:Number;
         
         if (targetEntity == null)
         {
            msgX =  mViewWidth * 0.5;
            msgY = mViewHeight * 0.5;
         }
         else
         {
            var viewPoint:Point = DisplayObjectUtil.LocalToLocal (mEntityContainer, mFloatingMessageLayer, new Point (targetEntity.GetLinkPointX (), targetEntity.GetLinkPointY ()));
            
            msgX = viewPoint.x;
            msgY = viewPoint.y;
         }
         
         mFloatingMessageLayer.addChild (new EffectMessagePopup ("Undo point created (" + description + ")", EffectMessagePopup.kBgColor_General, 0x000000, 0.5 * GetViewWidth ()));
      }
      
      private function RestoreWorld (worldState:WorldState):void
      {
         if (worldState == null)
         {
            OnCloseClearAllAndResetSceneAlert (null);
            return;
         }
         
         SetLastSelectedEntities (null);
         mLastSelectedEntities = null;
         
         var object:Object = worldState.mUserData;
         
         var currentWorld:Number = mEntityContainerZoomScale;
         
         var newEditorWorld:editor.world.World = DataFormat.WorldDefine2EditorWorld (object.mWorldDefine, false);
         EditorContext.GetEditorApp ().SetWorld (newEditorWorld);
         
         mViewCenterWorldX = object.mViewCenterWorldX;
         mViewCenterWorldY = object.mViewCenterWorldY;
         
         //mEntityContainerZoomScale = object.mEntityContainerZoomScale;
         mEntityContainerZoomScale = currentWorld;
         mEntityContainer.SetZoomScale (mEntityContainerZoomScale);
         
         var numEntities:int = mEntityContainer.GetNumEntities ();
         var entityId:int;
         var entity:Entity;
         
         for (var i:int = 0; i < object.mSelectedEntityCreationIds.length; ++ i)
         {
            entityId = object.mSelectedEntityCreationIds [i];
            if (entityId >= 0 && entityId < numEntities)
            {
               entity = mEntityContainer.GetEntityByCreationId (entityId);
               mEntityContainer.SelectEntity (entity);
               
               if (entityId == object.mMainSelectedEntityId)
               {
                  //entity.SetInternalComponentsVisible (true);
                  SetLastSelectedEntities (entity);
                  
                  if (object.mSelectedVertexControllerId >= 0)
                  {
                     var vertexController:VertexController = entity.GetVertexControllerByIndex (object.mSelectedVertexControllerId);
                     if (vertexController != null)
                        mEntityContainer.SetSelectedVertexController (vertexController);
                  }
               }
            }
         }
         
         UpdateChildComponents ();
      }
      
      public function Undo ():void
      {
         if (EditorContext.GetEditorApp ().GetWorld () == null)
            return;
         
         TryCreateDelayedUndoPoint ();
         
         var worldState:WorldState = mWorldHistoryManager.UndoHistory ();
         
         if (worldState == null)
         {
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("No undo points available", EffectMessagePopup.kBgColor_General, 0x000000, 0.5 * GetViewWidth ()));
            return;
         }
         
         RestoreWorld (worldState);
         
         worldState = worldState.GetNextWorldState ();
         if (worldState != null) // should not
         {
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Undo (" + worldState.GetDescription () + ")", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
         }
      }
      
      public function Redo ():void
      {
         if (EditorContext.GetEditorApp ().GetWorld () == null)
            return;
         
         var worldState:WorldState = mWorldHistoryManager.RedoHistory ();
         
         if (worldState == null)
         {
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("No redo points available", EffectMessagePopup.kBgColor_General, 0x000000, 0.5 * GetViewWidth ()));
            return;
         }
         
         RestoreWorld (worldState);
         
         mFloatingMessageLayer.addChild (new EffectMessagePopup ("Redo (" + worldState.GetDescription () + ")", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
      }
      
      public var mUndoButtonContextMenu:ContextMenu = new ContextMenu ();
      public var mRedoButtonContextMenu:ContextMenu = new ContextMenu ();
      
//============================================================================
// quick save and load 
//============================================================================
      
      private var mUniEditorCallback:Function = null;
      public function SetUniEditorCallback (callback:Function):void
      {
         mUniEditorCallback = callback;
      }
      
      public function UniEditorCallback (command:String, params:Object):void
      {
         if (mUniEditorCallback != null)
         {
            mUniEditorCallback (command, params);
         }
      }
      
      public static const kQuickSaveFileName:String = "cieditor-quicksave";
      public static const kAutoSaveName:String = "quick save";
      public static const kMaxQickSaveFileSize:uint = 1000000; // 1M bytes
      
      public function QuickSave (saveName:String = null):void
      {
         var so:SharedObject;
         try
         {
            so = SharedObject.getLocal(kQuickSaveFileName);
            
            var designDataForEditing:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ()));
            designDataForEditing.compress ();
            designDataForEditing.position = 0;
            
            if (saveName == null)
               saveName = kAutoSaveName;
            
            var timeText:String = new Date ().toLocaleString ();
            
            var theSave:Object = {mName: saveName, mTime: timeText, mData: designDataForEditing};
            
            if (so.data.mQuickSaves == null)
               so.data.mQuickSaves = [theSave];
            else
               so.data.mQuickSaves.unshift (theSave);
            
            while (so.size > kMaxQickSaveFileSize && so.data.mQuickSaves.length > 1)
            {
               so.data.mQuickSaves.pop ();
            }
            
            var flushStatus:String = so.flush ();
            if (flushStatus != null) 
            {
                //switch (flushStatus) {
                //    case SharedObjectFlushStatus.PENDING:
                //        output.appendText("Requesting permission to save object...\n");
                //        mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                //        break;
                //    case SharedObjectFlushStatus.FLUSHED:
                //        output.appendText("Value flushed to disk.\n");
                //        break;
                //}
            }
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick save", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, quick saving error! " + error, "Error");
            
            if (Capabilities.isDebugger)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick save failed", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
         }
      }
      
      public function QuickLoad ():void
      {
         var values:Object = new Object ();
         
         try
         {
            var so:SharedObject = SharedObject.getLocal(kQuickSaveFileName);
            
            values.mQuickSaves = so.data.mQuickSaves;
         }
         catch (error:Error)
         {
            values.mQuickSaves = null;
         }
         
         if (values.mQuickSaves == null)
         {
            values.mQuickSaves = new Array ();
         }
         
         ShowWorldQuickLoadingDialog (values, OnLoadQuickSaveData);
      }
      
      public function OnLoadQuickSaveData (params:Object):void
      {
         if (params.mLoadQuickSaveId == undefined || params.mLoadQuickSaveId < 0 || params.mLoadQuickSaveId >= params.mQuickSaves.length)
            return;
         
         try
         {
            var quickSave:Object = params.mQuickSaves [params.mLoadQuickSaveId];
            var designDataForEditing:ByteArray = new ByteArray ();
            quickSave.mData.readBytes (designDataForEditing, 0, quickSave.mData.length);
            
            designDataForEditing.position = 0;
            designDataForEditing.uncompress ();
            
            var newEditorWorld:editor.world.World = DataFormat.WorldDefine2EditorWorld (DataFormat2.ByteArray2WorldDefine (designDataForEditing));
            
            //mWorldHistoryManager.ClearHistories ();
            
            EditorContext.GetEditorApp ().SetWorld (newEditorWorld);
            
            CreateUndoPoint ("Quick save data is loaed");
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick load succeeded", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
         }
         catch (error:Error)
         {
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());

            if (Capabilities.isDebugger)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick load failed", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
         }
      }
      
      public function ExportSwfFile ():void
      {
         if (! IsOnlineEditing ())
            return;
         
         var urlParams:Object = GetFlashParams ();
         
         var viewportWidth:int = EditorContext.GetEditorApp ().GetWorld ().GetViewportWidth ();
         var viewportHeight:int = EditorContext.GetEditorApp ().GetWorld ().GetViewportHeight ();
         //var showPlayBar:Boolean = (mEntityContainer.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0;
         var showPlayBar:Boolean = (EditorContext.GetEditorApp ().GetWorld ().GetViewerUiFlags () & (Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_UseOverlaySkin)) == Define.PlayerUiFlag_UseDefaultSkin;
         var heightWithPlayBar:int = (showPlayBar ? viewportHeight + Define.DefaultPlayerSkinPlayBarHeight : viewportHeight);

         var levelData:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ()));
         levelData.compress ();

         var values:Object = new Object ();
         values.mVersionString = EditorContext.GetVersionString ();
         
         values.mAuthor = urlParams.mAuthorName;
         values.mSlotId = urlParams.mSlotID;
         values.mWorldDataFormatVersion = Version.VersionNumber;
         values.mWorldBinaryData = levelData;
         values.mViewportWidth = viewportWidth;
         values.mViewportHeight = viewportHeight;
         values.mShowPlayBar = showPlayBar;
         values.mViewerWidth = viewportWidth;
         values.mViewerHeight = heightWithPlayBar;
         
         ShowExportSwfFileDialog (values);
      }
      
//============================================================================
// online save / open 
//============================================================================

      public function GetFlashParams ():Object
      {
         //try 
         //{
            var loadInfo:LoaderInfo = LoaderInfo(stage.root.loaderInfo);
            
            var params:Object = new Object ();
            
            params.mRootUrl = UrlUtil.GetRootUrl (loaderInfo.url);
            
            var flashVars:Object = loaderInfo.parameters;
            if (flashVars != null)
            {
               if (flashVars.action != null)
                  params.mAction = flashVars.action;
               if (flashVars.author != null)
                  params.mAuthorName = flashVars.author;
               if (flashVars.slot != null)
                  params.mSlotID = flashVars.slot;
               if (flashVars.revision != null)
                  params.mRevisionID = flashVars.revision;
            }
            
            return params;
         //} 
         //catch (error:Error) 
         //{
         //    Logger.Trace ("Parse flash vars error." + error);
         //}
         //
         //return null;
      }
      
      public function OnlineSave (options:Object = null):void
      {
         //
         var isImportant:Boolean = false;
         var revisionComment:String = "";
         if (options != null)
         {
            isImportant = options.mIsImportant;
            revisionComment = options.mRevisionComment.substr (0, 100);
         }
         var designDataRevisionComment:ByteArray = new ByteArray ();
         //designDataRevisionComment.writeMultiByte (revisionComment, "utf-8"); // has bug on linux
         designDataRevisionComment.writeUTFBytes (revisionComment);
         designDataRevisionComment.position = 0;
         
         //
         var params:Object = GetFlashParams ();
         
         //trace ("params.mRootUrl = " + params.mRootUrl)
         //trace ("params.mSlotID = " + params.mSlotID)
         
         if (params.mRootUrl == null || params.mAuthorName == null || params.mSlotID == null)
            return;
         
         var designDataForEditing:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ()));
         designDataForEditing.compress ();
         designDataForEditing.position = 0;
         
         var designDataForPlaying:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine (EditorContext.GetEditorApp ().GetWorld ()));
         designDataForPlaying.compress ();
         designDataForPlaying.position = 0;
         
         var designDataAll:ByteArray = new ByteArray ();
         
         designDataAll.writeInt (Version.VersionNumber);
         
         //>> from v1.07 (in fact, the code added in v0110 r003)
         var shareSourceCode:Boolean = EditorContext.GetEditorApp ().GetWorld ().IsShareSourceCode ();
         designDataAll.writeShort (EditorContext.GetEditorApp ().GetWorld ().GetViewportWidth ()); // view width
         designDataAll.writeShort (EditorContext.GetEditorApp ().GetWorld ().GetViewportHeight ()); // view height
         //designDataAll.writeByte  ((EditorContext.GetEditorApp ().GetWorld ().GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0 ? 1 : 0); // show play bar?
         designDataAll.writeByte  ((EditorContext.GetEditorApp ().GetWorld ().GetViewerUiFlags () & (Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_UseOverlaySkin)) == Define.PlayerUiFlag_UseDefaultSkin ? 1 : 0);
         designDataAll.writeByte  (shareSourceCode ? 1 : 0); // share source code?
         //<<
         
         //
         
         designDataAll.writeByte (isImportant ? 1 : 0);
         
         designDataAll.writeInt (designDataRevisionComment.length);
         designDataAll.writeInt (designDataForEditing.length);
         //designDataAll.writeInt (shareSourceCode ? 0 : designDataForPlaying.length);
         designDataAll.writeInt (0); // !! currently, playing data is totally same as editing data
         
         designDataAll.writeBytes (designDataRevisionComment);
         designDataAll.writeBytes (designDataForEditing);
         if (! shareSourceCode)
         {
            //designDataAll.writeBytes (designDataForPlaying); // !! currently, playing data is totally same as editing data
         }
         
//infoString =  designDataForEditing[0] + ", " + designDataForEditing[1] + ", " + designDataForEditing[2]
//      + ", ..., " + designDataForEditing [designDataForEditing.length - 3]
//           + ", " + designDataForEditing [designDataForEditing.length - 2]
//           + ", " + designDataForEditing [designDataForEditing.length - 1];
//      + "  |||  " + designDataForPlaying[0] + ", " + designDataForPlaying[1] + ", " + designDataForPlaying[2]
//      + ", ..., " + designDataForPlaying [designDataForPlaying.length - 3]
//           + ", " + designDataForPlaying [designDataForPlaying.length - 2]
//           + ", " + designDataForPlaying [designDataForPlaying.length - 1];
         
         //trace ("designDataForEditing.length = " + designDataForEditing.length)
         //trace ("designDataForPlaying.length = " + designDataForPlaying.length)
         
         var designSaveUrl:String = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/save";
         var request:URLRequest = new URLRequest (designSaveUrl);
         request.contentType = "application/octet-stream";
         request.method = URLRequestMethod.POST;
         request.data = designDataAll;
         
         //trace ("designSaveUrl = " + designSaveUrl)
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
            
            //loader.addEventListener (Event.OPEN, openHandler);
            //loader.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
         
         //loader.addEventListener (ProgressEvent.PROGRESS, OnOnlineSaveProgress); // will not be triggered
         
         loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnOnlineSaveError);
         loader.addEventListener (IOErrorEvent.IO_ERROR, OnOnlineSaveError);

         loader.addEventListener(Event.COMPLETE, OnOnlineSaveCompleted);
         
         loader.load ( request );
         //navigateToURL ( request )
         
         mOnlineSavingPopup = new EffectMessagePopup ("Saving ... (Please don't close the editor!)", EffectMessagePopup.kBgColor_Special, 0x000000, 0.5 * GetViewWidth ());
         mOnlineSavingPopup.SetAutoFade (false);
         mFloatingMessageLayer.addChild (mOnlineSavingPopup);
      }
      
// to debug a bug. seems there is a bug in ByteArray.compress () on linux
//private var infoString:String = "";
      
      private var mOnlineSavingPopup:EffectMessagePopup = null;
      
      //private function OnOnlineSaveProgress (event:ProgressEvent):void
      //{
      //   if (mOnlineSavingPopup != null)
      //      mOnlineSavingPopup.Rebuild ("Saving ... (" + Math.floor(100 * event.bytesLoaded / event.bytesTotal) + "%)", EffectMessagePopup.kBgColor_Special, 0x000000, 0.5 * GetViewWidth ());
      //} 
      
      private function OnOnlineSaveError (event:Event):void
      {
         if (mOnlineSavingPopup != null)
            mOnlineSavingPopup.SetAutoFade (true);
         
         mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online save error", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
      } 
      
      private function OnOnlineSaveCompleted(event:Event):void 
      {
         if (mOnlineSavingPopup != null)
            mOnlineSavingPopup.SetAutoFade (true);
         
         var loader:URLLoader = URLLoader(event.target);
         
         try
         {
            var data:ByteArray = ByteArray (loader.data);
            
            var returnCode:int = data.readByte ();
            var returnMessage:String = null;
            if (data.length > data.position)
            {
               var length:int = data.readInt ();
               returnMessage = data.readUTFBytes (length);
            }
            
            if (returnCode == Define.k_ReturnCode_Successed)
            {
               mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online save succeeded", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
            }
            else
            {
               //Alert.show("Some errors in saving! returnCode = " + returnCode + ", returnMessage = " + returnMessage, "Error");
               var errorMessage:String = "Online save failed,  returnCode = " + returnCode + ",  returnMessage = " + returnMessage;
               mFloatingMessageLayer.addChild (new EffectMessagePopup (errorMessage, EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
            }
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, online saving error! " + loader.data + " " + error, "Error");
            
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
            
            if (Capabilities.isDebugger)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online save error", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
         }
      }
      
      // return: online or not
      public function OnlineLoad (isFirstTime:Boolean = false):Boolean
      {
         var params:Object = GetFlashParams ();
         
         //trace ("params.mRootUrl = " + params.mRootUrl)
         //trace ("params.mSlotID = " + params.mSlotID)
         
         if (params.mRootUrl == null || params.mAction == null || params.mAuthorName == null || params.mSlotID == null || params.mRevisionID == null)
            return false;
         
         EditorContext.SetRecommandDesignFilename (EditorContext.GetTimeStringInFilename () + " " + params.mAuthorName + "-" + params.mSlotID + "-" + params.mRevisionID + ".phyardx");
         
         if (isFirstTime && params.mAction == "create")
            return true;
         
         var designLoadUrl:String;
         if (isFirstTime)
         {
            designLoadUrl = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/revision/" + params.mRevisionID + "/loadsc";
         }
         else
         {
            designLoadUrl = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/revision/latest/loadsc";
            //var isNameRevision:Boolean = isNaN (parseInt (params.mRevisionID)); // "latest", "published"
            //if (isNameRevision)
            //{
               designLoadUrl = designLoadUrl + "?time=" + (new Date ().getTime ()); // avoid browser cache
            //}
         }
         var request:URLRequest = new URLRequest (designLoadUrl);
         request.method = URLRequestMethod.GET;
         
         //trace ("designLoadUrl = " + designLoadUrl);
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener (ProgressEvent.PROGRESS, OnOnlineLoadProgress);
         
         loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnOnlineSaveError);
         loader.addEventListener (IOErrorEvent.IO_ERROR, OnOnlineLoadError);
         
         loader.addEventListener(Event.COMPLETE, OnOnlineLoadCompleted);
         
         loader.load ( request );
         
         mOnlineLoadingPopup = new EffectMessagePopup ("Loading ...", EffectMessagePopup.kBgColor_Special, 0x000000, 0.5 * GetViewWidth ());
         mOnlineLoadingPopup.SetAutoFade (false);
         mFloatingMessageLayer.addChild (mOnlineLoadingPopup);
         
         return true;
      }
      
      private var mOnlineLoadingPopup:EffectMessagePopup = null;
      
      private function OnOnlineLoadProgress (event:ProgressEvent):void
      {
         if (mOnlineLoadingPopup != null)
            mOnlineLoadingPopup.Rebuild ("Loading ... (" + Math.floor (100 * event.bytesLoaded / event.bytesTotal) + "%)", EffectMessagePopup.kBgColor_Special, 0x000000);
      } 
      
      private function OnOnlineLoadError (event:Event):void
      {
         if (mOnlineLoadingPopup != null)
            mOnlineLoadingPopup.SetAutoFade (true);
         
         mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online load error", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
      } 
      
      private function OnOnlineLoadCompleted(event:Event):void 
      {
         if (mOnlineLoadingPopup != null)
            mOnlineLoadingPopup.SetAutoFade (true);
         
         var loader:URLLoader = URLLoader(event.target);
         
         var returnCode:int = Define.k_ReturnCode_UnknowError;
         
         var data:ByteArray = ByteArray (loader.data);
         
         returnCode = data.readByte ();
         
         if (returnCode != Define.k_ReturnCode_Successed)
         {
            //Alert.show("Some errors in loading! returnCode = " + returnCode, "Error");
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online load error,  returnCode = " + returnCode, EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
         }
         else
         {
            EditorContext.GetEditorApp ().CloseWorld ();
            
            try
            {
               var designDataForEditing:ByteArray = new ByteArray ();
               
               var newEditorWorld:editor.world.World;
               
               if (data.length > data.position)
               {
                  data.readBytes (designDataForEditing);
                  designDataForEditing.uncompress ();
                  
                  newEditorWorld = DataFormat.WorldDefine2EditorWorld (DataFormat2.ByteArray2WorldDefine (designDataForEditing));
               }
               else
               {
                  newEditorWorld = new editor.world.World ();
               }
               
               //mWorldHistoryManager.ClearHistories ();
               
               EditorContext.GetEditorApp ().SetWorld (newEditorWorld);
               
               CreateUndoPoint ("Online data is loaded");
               
               //Alert.show("Loading Succeeded!", "Succeeded");
               mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online load succeeded", EffectMessagePopup.kBgColor_OK, 0x000000, 0.5 * GetViewWidth ()));
            }
            catch (error:Error)
            {
               RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
               
               if (Capabilities.isDebugger)
                  throw error;
               
               //Alert.show("Sorry, online loading error!", "Error");
               
               mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online load error", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetViewWidth ()));
            }
         }
      }
      
      
      
   }
}
