package player.entity {
   
   import flash.geom.Point;
   import flash.display.Sprite;
   
   import flash.events.MouseEvent;
   
   import flash.utils.Dictionary;
   
   import player.world.World;
   import player.world.EntityList;
   import player.world.CollisionCategory;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   
   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;
   import player.trigger.data.ListElement_EntityShape;
   
   import common.DataFormat2;
   import common.CoordinateSystem;
   import common.Transform2D;
   import common.Define;
   import common.WorldDefine;
   import common.SceneDefine;
   import common.trigger.CoreEventIds;
   
   // The shape class includes many types. Generally, if a entity has position and rotation and can be glued with other entities, then the entity can be viewed as a shape.
   // Yes, certainly, for many special shapes, many memeber properties are meaningless.
   
   public class EntityShape extends Entity
   {
      include "EntityShape_APIs.as";
      
//=============================================================
//   
//=============================================================
      
      private var mContactProxyId:int = -1;
      
      public function GetContactProxyId ():int
      {
         return mContactProxyId;
      } 
      
      public function EntityShape (world:World)
      {
         super (world);
         
         mContactProxyId = mWorld.ApplyContactProxyId ();
         
         SetBorderThickness (mWorld.GetCoordinateSystem ().D2P_Length (1.0));
         
         SetCollisionCategoryById (Define.CCatId_Hidden); // default
         
         mPhysicsShapePotentially = false; // to override
         
         mWorld.AddChildToEntityLayer (mAppearanceObjectsContainer);
         mAppearanceObject = mAppearanceObjectsContainer;
         
         mWorld.RegisterShapeAiType (mOriginalAiType, mAiType);
      }
      
      public function IsVisualShape ():Boolean
      {
         return true;
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            // > from 1.02
            var catId:int;
            if (entityDefine.mCollisionCategoryIndex != undefined)
               catId = entityDefine.mCollisionCategoryIndex;
            else
               catId = Define.CCatId_Hidden;
            
            SetCollisionCategoryById (catId);
            //<<
            
            //>>from v1.07
            if (entityDefine.mFriendGroupIndex != undefined)
               mFriendGroupIndex = entityDefine.mFriendGroupIndex;
            //<<
            
            if (entityDefine.mAiType != undefined)
            {
               SetOriginalShapeAiType (entityDefine.mAiType);
               SetShapeAiType (entityDefine.mAiType);
            }
            
            if (entityDefine.mIsPhysicsEnabled != undefined)
               SetPhysicsEnabled (entityDefine.mIsPhysicsEnabled);
            
            if (entityDefine.mDensity != undefined)
               SetDensity (entityDefine.mDensity);
            if (entityDefine.mFriction != undefined)
               SetFriction (entityDefine.mFriction);
            if (entityDefine.mRestitution != undefined)
               SetRestitution (entityDefine.mRestitution);
            
            if (entityDefine.mIsStatic != undefined)
               SetStatic (entityDefine.mIsStatic);
            if (entityDefine.mIsBullet != undefined)
               SetAsBullet (entityDefine.mIsBullet);
            
            // >> from v1.02
            if (entityDefine.mDrawBorder != undefined)
               SetDrawBorder (entityDefine.mDrawBorder);
            if (entityDefine.mDrawBackground != undefined)
               SetDrawBackground (entityDefine.mDrawBackground);
            
            if (entityDefine.mIsSensor != undefined)
               SetAsSensor (entityDefine.mIsSensor);
            //<<
            
            // >> from v1.04
            if (entityDefine.mBorderColor != undefined)
               SetBorderColor ( entityDefine.mBorderColor);
            if (entityDefine.mBorderThickness != undefined)
               SetBorderThickness (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mBorderThickness));
            if (entityDefine.mBackgroundColor != undefined)
               SetFilledColor (entityDefine.mBackgroundColor);
            if (entityDefine.mTransparency != undefined)
               SetTransparency (entityDefine.mTransparency);
            //<<
            
            // >> from v1.05
            if (entityDefine.mBorderTransparency != undefined)
               SetBorderTransparency (entityDefine.mBorderTransparency);
            if (entityDefine.mIsHollow != undefined)
               SetHollow (entityDefine.mIsHollow);
            //<<
            
            //>> from v1.08
            if (entityDefine.mBuildBorder != undefined)
               SetBuildBorder (entityDefine.mBuildBorder)
            
            if (entityDefine.mLinearVelocityMagnitude != undefined && entityDefine.mLinearVelocityAngle != undefined)
            {
               SetLinearVelocityByMagnitudeAndAngle (mWorld.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (entityDefine.mLinearVelocityMagnitude), 
                                 mWorld.GetCoordinateSystem ().D2P_RotationRadians (entityDefine.mLinearVelocityAngle * Define.kDegrees2Radians));
            }
            if (entityDefine.mAngularVelocity != undefined)
               SetAngularVelocity (mWorld.GetCoordinateSystem ().D2P_RotationRadians (entityDefine.mAngularVelocity * Define.kDegrees2Radians));
            
            if (entityDefine.mIsSleepingAllowed != undefined)
               SetSleepingAllowed (entityDefine.mIsSleepingAllowed);
            if (entityDefine.mIsRotationFixed != undefined)
               SetRotationFixed (entityDefine.mIsRotationFixed);
            //<<
            
            if (Define.IsBreakableShape (mAiType) && mAlpha > 0.8)
            {
               SetAlpha (0.8);
            }
         }
         else if (createStageId == 2)
         {
            UpdatelLocalTransform ();
            
            if (mAiType == Define.ShapeAiType_Bomb)
            {
               mAiTypeChangeable = false;
            }
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         // > from 1.02
         entityDefine.mCollisionCategoryIndex = GetCollisionCategory ().GetIndexInEditor ();
         //<<
         
         //>>from v1.07
         //mFriendGroupIndex = entityDefine.mFriendGroupIndex;
         //<<
         
         entityDefine.mAiType = GetOriginalShapeAiType ();
         entityDefine.mAiType = GetShapeAiType ();
         
         entityDefine.mIsPhysicsEnabled = mPhysicsEnabled;
         
         entityDefine.mDensity = GetDensity ();
         entityDefine.mFriction = GetFriction ();
         entityDefine.mRestitution = GetRestitution ();
         
         entityDefine.mIsStatic = IsStatic ();
         entityDefine.mIsBullet = IsBullet ();
         
         // >> from v1.02
         entityDefine.mDrawBorder = IsDrawBorder ();
         entityDefine.mDrawBackground = IsDrawBackground ();
         
         entityDefine.mIsSensor = IsSensor ();
         //<<
         
         // >> from v1.04
         entityDefine.mBorderColor = mBorderColor;
         entityDefine.mBorderThickness = mWorld.GetCoordinateSystem ().P2D_Length (GetBorderThickness ());
         entityDefine.mBackgroundColor = mFilledColor;
         entityDefine.mTransparency = mTransparency;
         //<<
         
         // >> from v1.05
         entityDefine.mBorderTransparency = GetBorderTransparency ();
         entityDefine.mIsHollow = IsHollow ();
         //<<
         
         //>> from v1.08
         entityDefine.mBuildBorder = IsBuildBorder ()
         
         var vx:Number = mWorld.GetCoordinateSystem ().P2D_LinearVelocityX (GetLinearVelocityX ());
         var vy:Number = mWorld.GetCoordinateSystem ().P2D_LinearVelocityY (GetLinearVelocityY ());
         entityDefine.mLinearVelocityMagnitude = Math.sqrt (vx * vx + vy * vy);
         entityDefine.mLinearVelocityAngle = mWorld.GetCoordinateSystem ().P2D_RotationRadians (Math.atan2 (vy, vx)) * Define.kRadians2Degrees;
         entityDefine.mAngularVelocity = mWorld.GetCoordinateSystem ().D2P_RotationRadians (GetAngularVelocity ()) * Define.kRadians2Degrees;
         
         entityDefine.mIsSleepingAllowed = IsSleepingAllowed ();
         entityDefine.mIsRotationFixed = IsRotationFixed ();
         //<<
         
         return null;
      }
      
//=============================================================
//   
//=============================================================
      
      public var mCollisionCategory:CollisionCategory;
      public var mFriendGroupIndex:int = -1;
      
      public function SetCollisionCategoryById (ccatId:int):void
      {
         mCollisionCategory = mWorld.GetCollisionCategoryById (ccatId);
         if (mCollisionCategory == null)
            SetCollisionCategoryById (Define.CCatId_Hidden);
      }
      
      public function SetCollisionCategory (ccat:CollisionCategory):void
      {
         if (ccat == null)
            SetCollisionCategoryById (Define.CCatId_Hidden);
         else
            mCollisionCategory = ccat;
         
         if (mPhysicsProxy != null)
         {
            mPhysicsShapeProxy.FlagForFilteringForAllContacts ();
         }
      }
      
      public function GetCollisionCategory ():CollisionCategory
      {
         return mCollisionCategory;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mOriginalAiType:int = Define.ShapeAiType_Unknown;
      protected var mAiType:int = Define.ShapeAiType_Unknown;
      
      protected var mIsStatic:Boolean = false;
      protected var mIsBullet:Boolean = false;
      
      protected var mDensity:Number = 1.0;
      protected var mFriction:Number = 0.1;
      protected var mRestitution:Number = 0.2;
      
      //>>from v1.02
      protected var mDrawBorder:Boolean = true;
      protected var mDrawBackground:Boolean = true;
      //<<
      
      //>> form v1.04
      protected var mBorderColor:uint = 0x0;
      protected var mBorderThickness:Number = 1;
      protected var mFilledColor:uint = 0xFFFFFFFF;
      protected var mTransparency:uint = 100; // opacity in fact
      //<<
      
      //>> form v1.05
      protected var mBorderTransparency:uint = 100; // opacity in fact
      //<<
      
      //>> form v1.04
      protected var mPhysicsEnabled:Boolean = false;
      protected var mIsSensor:Boolean = false;
      //<<
      
      //>> form v1.05
      protected var mIsHollow:Boolean = false; // always == ! mBuildInterior
      //<<
      
      //>> from v1.07
      protected var mBuildInterior:Boolean = true; // always == ! mIsHollow
      protected var mBuildBorder:Boolean = true;
      
      protected var mLinearVelocityX:Number = 0.0;
      protected var mLinearVelocityY:Number = 0.0;
      
      protected var mAngularVelocity:Number = 0.0;
      
      protected var mLinearDamping:Number = 0.0;
      protected var mAngularDamping:Number = 0.0;
      
      protected var mSleepingAllowed:Boolean = true;
      
      protected var mRotationFixed:Boolean = false;
      //<<
      
      public function SetOriginalShapeAiType (aiType:int):void
      {
         if (mOriginalAiType != aiType)
         {
            mWorld.ChangeShapeOriginalAiType (mOriginalAiType, aiType, mAiType);
            mOriginalAiType = aiType;
         }
      }
      
      public function GetOriginalShapeAiType ():int
      {
         return mOriginalAiType;
      }
      
      public function SetShapeAiType (aiType:int):void
      {
         if (mAiType != aiType)
         {
            mWorld.ChangeShapeAiType (mOriginalAiType, mAiType, aiType);
            mAiType = aiType;
         }
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance ();
      }
      
      public function GetShapeAiType ():int
      {
         return mAiType;
      }
      
      public function SetStatic (static:Boolean):void
      {
         mIsStatic = static;
      }
      
      public function IsStatic ():Boolean
      {
         return mIsStatic; // this value may be different with mBody.IsStatic ()
      }
      
      public function IsBodyStatic ():Boolean
      {
         if (mBody != null)
            return mBody.IsStatic ();
         else
            return IsStatic ();
      }
      
      public function SetAsBullet (bullet:Boolean):void
      {
         mIsBullet = bullet;
      }
      
      public function IsBullet ():Boolean
      {
         return mIsBullet;
      }
      
      public function SetHollow (hollow:Boolean):void
      {
         if (mIsHollow != hollow)
         {
            mIsHollow = hollow;
            mBuildInterior = ! mIsHollow;
         }
      }
      
      public function IsHollow ():Boolean
      {
         return mIsHollow;
      }
      
      public function IsBuildInterior ():Boolean
      {
         return mBuildInterior;
      }
      
      public function SetBuildBorder (buildBorder:Boolean):void
      {
         if (mBuildBorder != buildBorder)
         {
            mBuildBorder = buildBorder;
         }
      }
      
      public function IsBuildBorder ():Boolean
      {
         return mBuildBorder;
      }
      
      public function SetDensity (density:Number):void
      {
         mDensity = density;
      }
      
      public function GetDensity ():Number
      {
         return mDensity;
      }
      
      public function SetFriction (friction:Number):void
      {
         mFriction = friction;
      }
      
      public function GetFriction ():Number
      {
         return mFriction;
      }
      
      public function SetRestitution (restitution:Number):void
      {
         mRestitution = restitution;
      }
      
      public function GetRestitution ():Number
      {
         return mRestitution;
      }
      
      public function SetDrawBackground (draw:Boolean):void
      {
         if (mAiType >= 0)
            return;
         
         mDrawBackground = draw;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function IsDrawBackground ():Boolean
      {
         if (mAiType >= 0)
            return true;
         
         return mDrawBackground;
      }
      
      public function SetFilledColor (color:uint):void
      {
         if (mAiType >= 0)
            return;
         
         mFilledColor = color;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance ();
      }
      
      public function GetFilledColor ():uint
      {
         if (mAiType >= 0)
            return Define.GetShapeFilledColor (mAiType);
         
         return mFilledColor;
      }
      
      public function SetDrawBorder (drawBorder:Boolean):void
      {
         mDrawBorder = drawBorder;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function IsDrawBorder ():Boolean
      {
         return mDrawBorder;
      }
      
      public function SetBorderColor (color:uint):void
      {
         mBorderColor = color;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetBorderColor ():uint
      {
         if (mAiType >= 0)
            return Define.ColorObjectBorder;
         
         return mBorderColor;
      }
      
      public function SetBorderThickness (thinkness:Number):void
      {
         mBorderThickness = thinkness;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetBorderThickness ():Number
      {
         return mBorderThickness;
      }
      
      // the background transparency
      public function SetTransparency (transparency:uint):void
      {
         if (mAiType >= 0)
            return;
         
         mTransparency = transparency;
         
         mNeedUpdateAppearanceProperties = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetTransparency ():uint
      {
         if (mAiType >= 0)
            return 100;
         
         return mTransparency;
      }
      
      public function SetBorderTransparency (transparency:uint):void
      {
         mBorderTransparency = transparency;
         
         mNeedUpdateAppearanceProperties = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetBorderTransparency ():uint
      {
         return mBorderTransparency;
      }
      
      public function SetAsSensor (sensor:Boolean):void
      {
         if (mIsSensor != sensor)
         {
            mIsSensor = sensor;
            
            if (mPhysicsShapeProxy != null)
               mPhysicsShapeProxy.SetSensor (sensor);
         }
      }
      
      public function IsSensor ():Boolean
      {
         return mIsSensor;
      }
      
      // here, for shapes, the SetVelocity will not not change the mass of the body of shape,
      // also not call shape.UpdateLocalPosition.
      // Those functions must be called mannually if needed.
      
      public function SetLinearVelocityX (vx:Number):void
      {
         mLinearVelocityX = vx;
      }
      
      public function GetLinearVelocityX ():Number
      {
         SynchronizeVelocityAndWorldCentroid ();
         
         return mLinearVelocityX;
      }
      
      public function SetLinearVelocityY (vy:Number):void
      {
         mLinearVelocityY = vy;
      }
      
      public function GetLinearVelocityY ():Number
      {
         SynchronizeVelocityAndWorldCentroid ();
         
         return mLinearVelocityY;
      }
      
      public function SetLinearVelocityByMagnitudeAndAngle (magnitude:Number, angle:Number):void
      {
         SetLinearVelocityX (magnitude *  Math.cos (angle));
         SetLinearVelocityY (magnitude *  Math.sin (angle));
      }
      
      public function SetAngularVelocity (av:Number):void
      {
         mAngularVelocity = av;
      }
      
      public function GetAngularVelocity ():Number
      {
         SynchronizeAngularVelocityAndWorldCentroid ();
         
         return mAngularVelocity;
      }
      
      public function SetLinearDamping (damping:Number):void
      {
         mLinearDamping = damping;
      }
      
      public function GetLinearDamping ():Number
      {
         return mLinearDamping;
      }
      
      public function SetAngularDamping (damping:Number):void
      {
         mAngularDamping = damping;
      }
      
      public function GetAngularDamping ():Number
      {
         return mAngularDamping;
      }
      
      public function SetSleepingAllowed (allowSleeping:Boolean):void
      {
         mSleepingAllowed = allowSleeping;
      }
      
      public function IsSleepingAllowed ():Boolean
      {
         return mSleepingAllowed;
      }
      
      public function SetRotationFixed (fixed:Boolean):void
      {
         mRotationFixed = fixed;
      }
      
      public function IsRotationFixed ():Boolean
      {
         return mRotationFixed;
      }
      
//=============================================================
//   mouse event handlers
//=============================================================
      
      private var mPhyicsShapeMouseDownEventHandlerList:ListElement_EventHandler = null;
      private var mPhyicsShapeMouseUpEventHandlerList:ListElement_EventHandler = null;
      private var mMouseClickEventHandlerList:ListElement_EventHandler = null;
      private var mMouseDownEventHandlerList:ListElement_EventHandler = null;
      private var mMouseUpEventHandlerList:ListElement_EventHandler = null;
      private var mMouseMoveEventHandlerList:ListElement_EventHandler = null;
      private var mMouseEnterEventHandlerList:ListElement_EventHandler = null;
      private var mMouseOutEventHandlerList:ListElement_EventHandler = null;
      
      override public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         super.RegisterEventHandler (eventId, eventHandler);
         
         switch (eventId)
         {
            case CoreEventIds.ID_OnPhysicsShapeMouseDown:
               mPhyicsShapeMouseDownEventHandlerList = RegisterEventHandlerToList (mPhyicsShapeMouseDownEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnPhysicsShapeMouseUp:
               mPhyicsShapeMouseUpEventHandlerList = RegisterEventHandlerToList (mPhyicsShapeMouseUpEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseClick:
               mMouseClickEventHandlerList = RegisterEventHandlerToList (mMouseClickEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseDown:
               mMouseDownEventHandlerList = RegisterEventHandlerToList (mMouseDownEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseUp:
               mMouseUpEventHandlerList = RegisterEventHandlerToList (mMouseUpEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseMove:
               mMouseMoveEventHandlerList = RegisterEventHandlerToList (mMouseMoveEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseEnter:
               mMouseEnterEventHandlerList = RegisterEventHandlerToList (mMouseEnterEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseOut:
               mMouseOutEventHandlerList = RegisterEventHandlerToList (mMouseOutEventHandlerList, eventHandler);
               break;
            default:
               break;
         }
      }
      
   // for physics shapes, called by world
      
      public function OnPhysicsShapeMouseDown (event:MouseEvent):void
      {
         HandleMouseEvent (event, mPhyicsShapeMouseDownEventHandlerList, false);
      }
      
      public function OnPhysicsShapeMousUp (event:MouseEvent):void
      {
         HandleMouseEvent (event, mPhyicsShapeMouseUpEventHandlerList, false);
      }
      
   // for all shape, called by flex framework
      
      protected function OnMouseClick (event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseClickEventHandlerList);
      }
      
      protected function OnMouseDown(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseDownEventHandlerList);
      }
      
      protected function OnMouseUp(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseUpEventHandlerList);
      }
      
      protected function OnMouseMove(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseMoveEventHandlerList);
      }
      
      protected function OnMouseEnter (event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseEnterEventHandlerList);
      }
      
      protected function OnMouseOut(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseOutEventHandlerList);
      }
      
      private function HandleMouseEvent (event:MouseEvent, listElement:ListElement_EventHandler, updateWorldMouseInfo:Boolean = true):void
      {
         if (updateWorldMouseInfo)
         {
            mWorld.UpdateMousePositionAndHoldInfo (event);
         }
         
         if (mWorld.IsInteractiveEnabledNow ())
         {
            mWorld.RegisterMouseEvent (event, listElement, this);
         }
      }
      
   // these function will be override by some subclasses. Subclasses should call add/removeEventListener in their class body.
      
      protected function GetMouseClickListener ():Function
      {
         return mMouseClickEventHandlerList == null ? null : OnMouseClick;
      }
      
      protected function GetMouseDownListener ():Function
      {
         return mMouseDownEventHandlerList == null ? null : OnMouseDown;
      }
      
      protected function GetMouseUpListener ():Function
      {
         return mMouseUpEventHandlerList == null ? null : OnMouseUp;
      }
      
      protected function GetMouseMoveListener ():Function
      {
         return mMouseMoveEventHandlerList == null ? null : OnMouseMove;
      }
      
      protected function GetMouseEnterListener ():Function
      {
         return mMouseEnterEventHandlerList == null ? null : OnMouseEnter;
      }
      
      protected function GetMouseOutListener ():Function
      {
         return mMouseOutEventHandlerList == null ? null : OnMouseOut;
      }
      
//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         DelayUpdateAppearance ();
         
         mAppearanceObjectsContainer.mouseChildren = false; // import, otherwise sometimes a mouse event will be triggered twice.
         if (GetMouseClickListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.CLICK, GetMouseClickListener ());
         if (GetMouseDownListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_DOWN, GetMouseDownListener ());
         if (GetMouseUpListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_UP, GetMouseUpListener ());
         if (GetMouseMoveListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_MOVE, GetMouseMoveListener ());
         if (GetMouseEnterListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_OVER, GetMouseEnterListener ());
         if  (GetMouseOutListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_OUT, GetMouseOutListener ());
      }
      
      // call this function after calling mBody.OnPhysicsShapeListChanged () so that mBody.mPosition is the centroid of mBody.
      internal function AddSelfMomentumToBody ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         if (IsStatic ())
            return;
         
         AddLinearMomentum (mLinearVelocityX, mLinearVelocityY, true, false);
         AddAngularMomentum (mAngularVelocity, true);
      }
      
      // call this function before removing this shape from mBody or before being changed to static
      // This function has a bug: mass and inertia should be also removed.
      // NOTICE: Before calling this function, the mass of old body must be re-calculated.
      //internal function RemoveSelfMomentumFromBody ():void
      //{
      //   if (mPhysicsProxy == null)
      //      return;
      //   
      //   if (IsStatic ())
      //      return;
      //   
      //   AddLinearMomentum (-mLinearVelocityX, -mLinearVelocityY, true, false);
      //   AddAngularMomentum (-mAngularVelocity, true);
      //}
      
//=============================================================
//   destroy
//=============================================================
      
      // if to destroy many shapes, don't use this function, because OnPhysicsShapeListChanged is some time-consuming
      // this function is for signle destroying.
      override public function DestroyEntity ():void
      {
         var body:EntityBody = mBody; // backup
         
         super.DestroyEntity ();
         
         body.OnShapeListChanged (IsPhysicsShape ());
      }
      
      override protected function DestroyInternal ():void
      {
         mWorld.UnregisterShapeAiType (mOriginalAiType, mAiType);
         
         RemoveAppearanceObjects ();
         
         BreakAllJoints ();
         
         SetBody (null);
         
         mWorld.ReleaseContactProxyId (mContactProxyId);         
         
         if (GetMouseClickListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.CLICK, GetMouseClickListener ());
         if (GetMouseDownListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_DOWN, GetMouseDownListener ());
         if (GetMouseUpListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_UP, GetMouseUpListener ());
         if (GetMouseMoveListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_MOVE, GetMouseMoveListener ());
         if (GetMouseEnterListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_OVER, GetMouseEnterListener ());
         if  (GetMouseOutListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_OUT, GetMouseOutListener ());
      }
      
      // for border shapes, this fucntions need to be overrode
      protected function RemoveAppearanceObjects ():void
      {
         mWorld.RemoveChildFromEntityLayer (mAppearanceObjectsContainer);
      }
      
//=============================================================
//   update position rotation
//=============================================================
      
      /*
         Not like the velocity, the FlagPositionSynchronized () function.
         The physics proxy position and this entity postion should be always synchronized.
      */
      
      override public function SynchronizeWithPhysicsProxy ():void
      {
         if (mAlreadyDestroyed)
            return;
         
         //if (mBody != null) // should no be null
         //{
            //mBody.UpdateSinCos ();
            
            //mPositionX = mBody.mPositionX + mLocalPositionX * mBody.mCosRotation - mLocalPositionY * mBody.mSinRotation;
            //mPositionY = mBody.mPositionY + mLocalPositionX * mBody.mSinRotation + mLocalPositionY * mBody.mCosRotation;
            //SetRotation (mBody.mPhysicsRotation + mRelativeRotation);
            Transform2D.CombineTransforms (mBody.GetTransform (), mLocalTransform, mTransform);
         //}

         ApplyTransformOnAppearanceObjectsContainer ();
      }
      
      public function ApplyTransformOnAppearanceObjectsContainer ():void
      {
         var newX:Number = mWorld.GetCoordinateSystem ().P2D_PositionX (GetPositionX ());
         var newY:Number = mWorld.GetCoordinateSystem ().P2D_PositionY (GetPositionY ());
         var newR:Number = mWorld.GetCoordinateSystem ().P2D_RotationRadians (GetRotationInTwoPI ()) * Define.kRadians2Degrees;
         
         if (mBody.IsStatic () || mBody.IsSleeping ()) // special optimize for potiential static shapes. Maybe here can be more optimized. (call nothing here but when the shape position are manually changed, this function needs also be called.)
         {
            if ( (int(mAppearanceObjectsContainer.x * 20.0)) != (int (newX * 20.0)) )
            {
               //trace ("xxxxxx mCreationId = " + mCreationId + ", mAppearanceObjectsContainer.x = " + mAppearanceObjectsContainer.x + ", newX = " + newX);
               //trace ("   (int(mAppearanceObjectsContainer.x * 20.0)) = " + (int(mAppearanceObjectsContainer.x * 20.0)) + ", (int (newX * 20.0)) = " + (int (newX * 20.0)) );
               mAppearanceObjectsContainer.x = newX;
            }
            if ( (int(mAppearanceObjectsContainer.y * 20.0)) != (int (newY * 20.0)) )
            {
               //trace ("yyyyyy mCreationId = " + mCreationId + ", mAppearanceObjectsContainer.y = " + mAppearanceObjectsContainer.y + ", newY = " + newY);
               //trace ("   (int(mAppearanceObjectsContainer.y * 20.0)) = " + (int(mAppearanceObjectsContainer.y * 20.0)) + ", (int (newY * 20.0)) = " + (int (newY * 20.0)) );
               mAppearanceObjectsContainer.y = newY;
            }
         }
         else
         {
            mAppearanceObjectsContainer.x = newX;
            mAppearanceObjectsContainer.y = newY;
         }
         
         mAppearanceObjectsContainer.rotation = newR;
         
         //mAppearanceObjectsContainer.scaleX = mFlipped ? - mScale : mScale;
         //mAppearanceObjectsContainer.scaleY = mScale;
         
         mAppearanceObjectsContainer.scaleX = GetScale ();
         mAppearanceObjectsContainer.scaleY = GetScale ();
         
         if (IsFlipped ())
         {
            mAppearanceObjectsContainer.scaleX = - mAppearanceObjectsContainer.scaleX;
            mAppearanceObjectsContainer.rotation = - mAppearanceObjectsContainer.rotation;
         }
      }
      
//=============================================================
//   mass, interia, centroid 
//=============================================================
      
      // Not like the velocity, there is no the FlagMassSynchronized () function.
      // The mass and local centroid should be always synchronized.
      
      internal var mMass:Number = 0.0;
      internal var mInertia:Number = 0.0;
      
      internal var mLocalCentroidX:Number = 0.0; // in body space
      internal var mLocalCentroidY:Number = 0.0; // in body space
      
      private var mLocalCentroidXInShapeSpace:Number = 0.0; // in self space
      private var mLocalCentroidYInShapeSpace:Number = 0.0;
      
   // the following setter functions should be only called by mPhysicsShapeProxy
      
      public function SetMass (mass:Number):void
      {
         if (mPhysicsProxy == null)
            return;
         
         mMass = mass;
      }
      
      public function GetMass ():Number
      {
         if (mPhysicsProxy == null)
            return 0.0;
         
         return mMass;
      }
      
      public function SetInertia (inertia:Number):void
      {
         if (mPhysicsProxy == null)
            return;
         
         mInertia = inertia;
      }
      
      public function GetInertia ():Number
      {
         if (mPhysicsProxy == null)
            return 0.0;
         
         return mInertia;
      }
      
      // local centroid should be always synchronized.
      // or SynchronizeCentroid From BodySpace To ShapeSpace
      public function SetCentroidInBodySpace (centroidX:Number, centroidY:Number):void
      {
         if (mPhysicsProxy == null)
            return;
         
         mLocalCentroidX = centroidX;
         mLocalCentroidY = centroidY;
         
         var shpeLocalCentroid:Point = new Point ();
         
         //SynchronizeWorldCentroid ();
         //
         //WorldPoint2LocalPoint (mWorldCentroidX, mWorldCentroidY, shpeLocalCentroid);
         // from v1.59 (may cause a little incompatiblilities)
         mLocalTransform.InverseTransformPointXY (mLocalCentroidX, mLocalCentroidY, shpeLocalCentroid);
         
         mLocalCentroidXInShapeSpace = shpeLocalCentroid.x;
         mLocalCentroidYInShapeSpace = shpeLocalCentroid.y;
      }
      
      // this function is called in flip APIs
      public function SynchronizeCentroidFromShapeSpaceToBodySpace ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         var bodyLocalCentroid:Point = new Point ();
         
         mLocalTransform.TransformPointXY (mLocalCentroidXInShapeSpace, mLocalCentroidYInShapeSpace, bodyLocalCentroid);
         
         mLocalCentroidX = bodyLocalCentroid.x;
         mLocalCentroidY = bodyLocalCentroid.y;
      }
      
      public function GetLocalCentroidXInShapeSpace ():Number
      {
         return mLocalCentroidXInShapeSpace;
      }
      
      public function GetLocalCentroidYInShapeSpace ():Number
      {
         return mLocalCentroidYInShapeSpace;
      }
      
      public function UpdateMassAndInertiaAndLocalCentroid ():void
      {
         if (mPhysicsProxy != null)
         {
            mPhysicsShapeProxy.UpdateMass (); // which will call SetMass, SetInertia and SetCentroidInBodySpace. Seems not a good design. Better to pass these function in?
         }
         else
         {
            mMass = 0.0;
            mInertia = 0.0;
            //mLocalCentroidX = mLocalPositionX;
            //mLocalCentroidY = mLocalPositionY;
            mLocalCentroidX = mLocalTransform.mOffsetX;
            mLocalCentroidY = mLocalTransform.mOffsetY;
            mLocalCentroidXInShapeSpace = 0.0;
            mLocalCentroidYInShapeSpace = 0.0;
         }
      }
      
//=============================================================
//   synchronize velocity, world, centroid
//=============================================================
      
      // for judging if this condition is evaluated already in current step.
      private var mLastWorldCentroidUpdatedStep:int = -1;
      
      // ..
      internal var mWorldCentroidX:Number = 0.0;
      internal var mWorldCentroidY:Number = 0.0;
      
      public function GetWorldCentroidX ():Number
      {
         SynchronizeWorldCentroid ();
         
         return mWorldCentroidX;
      }
      
      public function GetWorldCentroidY ():Number
      {
         SynchronizeWorldCentroid ();
         
         return mWorldCentroidY;
      }
      
      internal function FlagWorldCentroidSynchronized (syned:Boolean = true):void
      {
         mLastWorldCentroidUpdatedStep = syned ? mWorld.GetSimulatedSteps () : -1;
      }
      
      // this function is separated from SynchronizeVelocityAndWorldCentroid is for initializing
      internal function SynchronizeWorldCentroid ():void
      {
         if (mBody.mMovedManually)
         {
            mBody.NotifyShapesWorldCentroidChanged ();
         }
         
         if (mLastWorldCentroidUpdatedStep < mWorld.GetSimulatedSteps ())
         {
            FlagWorldCentroidSynchronized (true);
            
            var worldLocalCentroidX:Number = mLocalCentroidX * mBody.mCosRotation - mLocalCentroidY * mBody.mSinRotation;
            var worldLocalCentroidY:Number = mLocalCentroidX * mBody.mSinRotation + mLocalCentroidY * mBody.mCosRotation;
            
            mWorldCentroidX = mBody.GetPositionX () + worldLocalCentroidX;
            mWorldCentroidY = mBody.GetPositionY () + worldLocalCentroidY;
         }
      }
      
      // for judging if this condition is evaluated already in current step.
      private var mLastVelocityUpdatedTimes:int = -1;
      
      internal function FlagVelocitySynchronized (syned:Boolean):void
      {
         mLastVelocityUpdatedTimes = syned ? mWorld.GetSimulatedSteps () : -1;
         
         FlagAngularVelocitySynchronized (syned);
      }
      
      internal function SynchronizeVelocityAndWorldCentroid ():void
      {
         if (mBody.mVelocityChangedManually)
         {
            mBody.NotifyShapesVelocityChanged ();
         }
         
         if (mLastVelocityUpdatedTimes < mWorld.GetSimulatedSteps ())
         {
            FlagVelocitySynchronized (true);
            
            var worldLocalCentroidX:Number = mLocalCentroidX * mBody.mCosRotation - mLocalCentroidY * mBody.mSinRotation;
            var worldLocalCentroidY:Number = mLocalCentroidX * mBody.mSinRotation + mLocalCentroidY * mBody.mCosRotation;
            
            mAngularVelocity = mBody.GetAngularVelocity ();
            // this vector cross bug is fixed in v1.56
            //mLinearVelocityX = mBody.mLinearVelocityX - mAngularVelocity * worldLocalCentroidX;
            //mLinearVelocityY = mBody.mLinearVelocityY + mAngularVelocity * worldLocalCentroidY;
            mLinearVelocityX = mBody.GetLinearVelocityX () - mAngularVelocity * worldLocalCentroidY;
            mLinearVelocityY = mBody.GetLinearVelocityY () + mAngularVelocity * worldLocalCentroidX;
            
            // btw also SynchronizeWorldCentroid
            
            if (mBody.mMovedManually)
            {
               mBody.NotifyShapesWorldCentroidChanged ();
            }
            
            FlagWorldCentroidSynchronized (true);
            
            mWorldCentroidX = mBody.GetPositionX () + worldLocalCentroidX;
            mWorldCentroidY = mBody.GetPositionY () + worldLocalCentroidY;
         }
      }
      
      // for judging if this condition is evaluated already in current step.
      private var mLastAngularVelocityUpdatedTimes:int = -1;

      internal function FlagAngularVelocitySynchronized (syned:Boolean):void
      {
         mLastAngularVelocityUpdatedTimes = syned ? mWorld.GetSimulatedSteps () : -1;
      }
      
      internal function SynchronizeAngularVelocityAndWorldCentroid ():void
      {
         if (mBody.mVelocityChangedManually)
         {
            mBody.NotifyShapesVelocityChanged ();
         }
         
         if (mLastAngularVelocityUpdatedTimes < mWorld.GetSimulatedSteps ())
         {
            FlagAngularVelocitySynchronized (true);
            
            mAngularVelocity = mBody.GetAngularVelocity ();
         }
      }
      
//=============================================================
//   update
//=============================================================
      
      //override protected function UpdateInternal (dt:Number):void
      //{
      //}
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mNeedUpdateAppearanceProperties:Boolean = true;
      protected var mNeedRebuildAppearanceObjects:Boolean = true;
      
      protected var mAppearanceObjectsContainer:Sprite = new Sprite ();
      
//=============================================================
//   body
//=============================================================
      
      // for a physics shape, the body must not be null
      internal var mBody:EntityBody = null;
      
      internal var mPrevShapeInBody:EntityShape = null;
      internal var mNextShapeInBody:EntityShape = null;
      internal var mPrevPhysicsShapeInBody:EntityShape = null;
      internal var mNextPhysicsShapeInBody:EntityShape = null;
      
      // relative to mBody (only valid when mBody is not null)
      //protected var mLocalPositionX:Number;
      //protected var mLocalPositionY:Number;
      //protected var mRelativeRotation:Number;
      protected var mLocalTransform:Transform2D = new Transform2D (); // from v1.58
      
      public function GetBody ():EntityBody
      {
         return mBody;
      }
      
      public function SetBody (body:EntityBody):void
      {
         if (mBody != body)
         {
            if (mBody != null)
            {
               DestroyPhysicsProxy ();
                  
               mBody.RemoveShape (this);
            }
            
            if (body != null)
            {
               body.AddShape (this); // mBody will be the input body here
               
               // here not rebuild physics automatically.
            }
            
            UpdatelLocalTransform ();
         }
      }
      
      // the local position should be always synchronized
      public function UpdatelLocalTransform ():void
      {
         if (mBody != null)
         {
            //var tempX:Number = (mPositionX - mBody.GetPositionX ());
            //var tempY:Number = (mPositionY - mBody.GetPositionY ());
            //mLocalPositionX =   tempX * mBody.mCosRotation + tempY * mBody.mSinRotation;
            //mLocalPositionY = - tempX * mBody.mSinRotation + tempY * mBody.mCosRotation;
            //mRelativeRotation  = mPhysicsRotation  - mBody.GetRotation  ();
            Transform2D.CombineInverseTransformAndTransform (mBody.GetTransform (), mTransform, mLocalTransform);
         }
      }
      
      public function IsTheOnlyShapeInBody ():Boolean
      {
         return mBody.mNumShapes == 1 && mBody.mShapeListHead == this;
      }
      
      public function IsTheOnlyPhysicsShapeInBody ():Boolean
      {
         return mBody.mNumPhysicsShapes == 1 && mBody.mPhysicsShapeListHead == this;
      }
      
//=============================================================
//   step accumulated values, before world.Step (), these accumlated values will be applied on body
//=============================================================
      
      // need knowing mass
      private var mAccumulatedForce:Number = 0.0;
      private var mAccumulatedTorque:Number = 0.0;
      
//=============================================================
//   connected joints
//=============================================================
     
      internal var mJointAnchorListHead:SubEntityJointAnchor = null;
      
      internal function AttachJointAnchor (jointAnchor:SubEntityJointAnchor):void
      {
         if (jointAnchor.mShape != null)
         {
            if (jointAnchor.mShape == this)
               return;
            
            jointAnchor.mShape.DetachJointAnchor (jointAnchor);
         }
         
         jointAnchor.mShape = this;
         
         if (mJointAnchorListHead != null)
            mJointAnchorListHead.mPrevAnchor = jointAnchor;
         
         jointAnchor.mNextAnchor = mJointAnchorListHead;
         mJointAnchorListHead = jointAnchor;
      }
      
      internal function DetachJointAnchor (jointAnchor:SubEntityJointAnchor):void
      {
         if (jointAnchor.mShape != this)
            return;
         
         var prev:SubEntityJointAnchor = jointAnchor.mPrevAnchor;
         var next:SubEntityJointAnchor = jointAnchor.mNextAnchor;
         
         if (prev != null)
         {
            prev.mNextAnchor = next;
         }
         else // (mJointAnchorListHead == jointAnchor)
         {
            mJointAnchorListHead = next;
         }
         
         if (next != null)
         {
            next.mPrevAnchor = prev;
         }
         
         jointAnchor.mShape = null;
      }
      
      internal function ReconnectJoints ():void
      {
         var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
         while (jointAnchor != null)
         {
            jointAnchor.mJoint.GetPhysicsProxyJoint ().ReconncetShape (this, jointAnchor.mAnchorIndex == 0);
            
            jointAnchor = jointAnchor.mNextAnchor;
         }
      }
      
      internal function NotifyJointAnchorLocalPositionsChanged ():void
      {
         var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
         while (jointAnchor != null)
         {
            var worldPoint:Point = new Point ();
            //LocalPoint2WorldPoint (jointAnchor.mLocalPositionX, jointAnchor.mLocalPositionY, worldPoint);
            LocalPoint2WorldPoint (jointAnchor.mLocalTransform.mOffsetX, jointAnchor.mLocalTransform.mOffsetY, worldPoint);
            
            jointAnchor.mJoint.GetPhysicsProxyJoint ().ModifyAnchorPosition (worldPoint.x, worldPoint.y, jointAnchor.mAnchorIndex == 0);
            jointAnchor.SynchronizeWithPhysicsProxy ();
            jointAnchor.mJoint.SynchronizeAnchorWithPhysicsProxy (jointAnchor.mAnchorIndex);
            
            jointAnchor = jointAnchor.mNextAnchor;
         }
      }
      
      internal function ScaleJointAnchorPositions (scaleX:Number, scaleY:Number):void
      {
         var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
         while (jointAnchor != null)
         {
            //jointAnchor.mLocalPositionX *= scaleX;
            //jointAnchor.mLocalPositionY *= scaleY;
            jointAnchor.mLocalTransform.mOffsetX *= scaleX;
            jointAnchor.mLocalTransform.mOffsetY *= scaleY;
            
            jointAnchor = jointAnchor.mNextAnchor;
         }
         
         NotifyJointAnchorLocalPositionsChanged ();
      }
      
      public function PutConnectedShapesInArray (shapes:Array):void
      {
         var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
         var hashtable:Dictionary = new Dictionary ();
         var anotherAnchor:SubEntityJointAnchor;
         while (jointAnchor != null)
         {
            anotherAnchor = jointAnchor.mAnotherJointAnchor;
            if (anotherAnchor != null) // should not
            {
               if (anotherAnchor.mShape != null)
               {
                  if (hashtable [anotherAnchor.mShape] == null)
                  {
                     hashtable [anotherAnchor.mShape] = 1;
                     shapes.push (anotherAnchor.mShape);
                  }
               }
            }
            
            jointAnchor = jointAnchor.mNextAnchor;
         }
      }
      
      // "shape == null" means ground
      public function IsConnectedWith (shape:EntityShape):Boolean
      {
         var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
         var anotherAnchor:SubEntityJointAnchor;
         while (jointAnchor != null)
         {
            anotherAnchor = jointAnchor.mAnotherJointAnchor;
            if (anotherAnchor != null) // should not
            {
               if (anotherAnchor.mShape == shape)
                  return true;
            }
            
            jointAnchor = jointAnchor.mNextAnchor;
         }
         
         return false;
      }
      
//=============================================================
//   contacted shapes
//=============================================================
     
      protected var mContactedShapeList:ListElement_EntityShape = null;
      
      // make sure newListElement is new
      public function AddContactedShape (newListElement:ListElement_EntityShape):void
      {
         newListElement.mNextListElement = mContactedShapeList;
         newListElement.mPrevListElement = null;
         if (mContactedShapeList != null)
            mContactedShapeList.mPrevListElement = newListElement;
         mContactedShapeList = newListElement;
      }
      
      // make sure oldListElement is old and in mContactedShapeList
      public function RemoveContactedShape (oldListElement:ListElement_EntityShape):void
      {
         if (oldListElement.mPrevListElement != null)
            oldListElement.mPrevListElement.mNextListElement = oldListElement.mNextListElement;
         if (oldListElement.mNextListElement != null)
            oldListElement.mNextListElement.mPrevListElement = oldListElement.mPrevListElement;
         
         if (oldListElement == mContactedShapeList)
            mContactedShapeList = oldListElement.mNextListElement;
         
         oldListElement.mNextListElement = null;
         oldListElement.mPrevListElement = null;
      }
      
      public function PutContactedShapesInArray (shapes:Array):void
      {
         var listElement:ListElement_EntityShape = mContactedShapeList;
         while (listElement != null)
         {
            if (shapes.indexOf (listElement.mEntityShape) < 0) // may be not efficient
               shapes.push (listElement.mEntityShape);
            
            listElement = listElement.mNextListElement;
         }
      }
      
      public function IsContactedWith (shape:EntityShape):Boolean
      {
         var listElement:ListElement_EntityShape = mContactedShapeList;
         while (listElement != null)
         {
            if (listElement.mEntityShape == shape)
               return true;
            
            listElement = listElement.mNextListElement;
         }
         
         return false;
      }
      
//=============================================================
//   local <-> world, for SubEntityJointAnchors and other general uses
//=============================================================
     
      //internal var mCosRotation:Number = 1.0;
      //internal var mSinRotation:Number = 0.0;
      //private  var mLastRotation:Number = 0.0; // last rotation -> sin, cos
      //
      //// before use sin and cos, call this function.
      //internal function UpdateSinCos ():void
      //{
      //   if (mPhysicsRotation != mLastRotation)
      //   {
      //      mLastRotation = mPhysicsRotation;
      //      
      //      mCosRotation = Math.cos (mPhysicsRotation);
      //      mSinRotation = Math.sin (mPhysicsRotation);
      //   }
      //}
      
      public function LocalPoint2WorldPoint (localX:Number, localY:Number, worldPoint:Point):void
      {
         //UpdateSinCos ();
         //
         //localX *= (mFlipped ? - mScale : mScale);
         //localY *= mScale;
         //
         //worldPoint.x = mPositionX + localX * mCosRotation - localY * mSinRotation;
         //worldPoint.y = mPositionY + localX * mSinRotation + localY * mCosRotation;
         mTransform.TransformPointXY (localX, localY, worldPoint);
      }
      
      public function WorldPoint2LocalPoint (worldX:Number, worldY:Number, localPoint:Point):void
      {
         //UpdateSinCos ();
         //
         //worldX -= mPositionX;
         //worldY -= mPositionY;
         //
         //localPoint.x =   worldX * mCosRotation + worldY * mSinRotation;
         //localPoint.y = - worldX * mSinRotation + worldY * mCosRotation;
         //
         //if (mScale != 0)
         //{
         //   localPoint.x /= (mFlipped ? - mScale : mScale);
         //   localPoint.y /= mScale;
         //}
         mTransform.InverseTransformPointXY (worldX, worldY, localPoint);
      }
      
      public function LocalVector2WorldVector (localVX:Number, localVY:Number, worldVector:Point):void
      {
         //UpdateSinCos ();
         //
         //worldVector.x = localVX * mCosRotation - localVY * mSinRotation;
         //worldVector.y = localVX * mSinRotation + localVY * mCosRotation;
         mTransform.TransformVectorXY (localVX, localVY, worldVector);
      }
      
      public function WorldVector2LocalVector (worldVX:Number, worldlVY:Number, localVector:Point):void
      {
         //UpdateSinCos ();
         //
         //localVector.x =   worldVX * mCosRotation + worldlVY * mSinRotation;
         //localVector.y = - worldVX * mSinRotation + worldlVY * mCosRotation;
         mTransform.InverseTransformVectorXY (worldVX, worldlVY, localVector);
      }
      
//=============================================================
//   physics proxy
//=============================================================
     
      protected var mPhysicsShapePotentially:Boolean = false;
      
      protected var mPhysicsShapeProxy:PhysicsProxyShape = null;
      
      //>> from v1.07
      protected var mPhysicsValuesValidFlags:int = 0x7FFFFFFF;
      
      protected static const kValidFlag_LinearVelocity:int = 1 << 0;
      protected static const kValidFlag_AngularVelocity:int = 1 << 0;
      //<<
      
      public function IsPhysicsShape ():Boolean
      {
         return mPhysicsShapePotentially && mPhysicsEnabled;
      }
      
      public function SetPhysicsEnabled (enabled:Boolean):void
      {
         if (mBody == null) // generally, mBody should not be null. It is null only when the shape is not initilized totally.
         {
            mPhysicsEnabled = enabled;
         }
         else
         {
            //var oldIsPhysics:Boolean = IsPhysicsShape ();
            //mPhysicsEnabled = enabled;
            //var newIsPhysics:Boolean = IsPhysicsShape ();
            //
            //if (newIsPhysics != oldIsPhysics)
            //{
            //   mBody.RemoveShape (this);
            //   mBody.AddShape (this);
            //   
            //   // todo, reset mass, if body.isPhysics changes, break/built joints, else if this shape physics enabled is changed, break/built joints
            //}
         }
      }
      
      override public function DestroyPhysicsProxy ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         mPhysicsShapeProxy = null;
         
         super.DestroyPhysicsProxy (); // will set mPhysicsProxy null
      }
      
      final public function RebuildShapePhysics ():void
      {
         if (mAlreadyDestroyed)
            return;
         
         DestroyPhysicsProxy ();
         
         if (! IsPhysicsShape ())
            return;
         
         //if (mBody == null) // should not be null
         //   return;
         
         if (! mBody.IsPhysicsBuilt ())
         {
            mBody.RebuildBodyPhysics ();
         }
         
         if (mPhysicsShapeProxy == null)
         {
            mPhysicsShapeProxy = new PhysicsProxyShape (mBody.mPhysicsProxy as PhysicsProxyBody, this);
            //mPhysicsProxy.SetUserData (this);
            
            mPhysicsProxy = mPhysicsShapeProxy;
         }
         
      // ...
         RebuildShapePhysicsInternal ();
         
      // ...
      }

      protected function RebuildShapePhysicsInternal ():void
      {
         // to override
      }

      // when detaching, someinfo must be saved
      internal function SaveShapeStatus ():void
      {
         
      }

//=============================================================
//   some functions
//=============================================================
      
      protected var mAiTypeChangeable:Boolean = true; // if it is false, subclass must overwrite it
      
      final public function IsAiTypeChangeable ():Boolean
      {
         return mAiTypeChangeable;
      }
   }
}
