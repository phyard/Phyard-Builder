
   private var mEnabledInteractiveWhenPaused:Boolean = false;
   
   public function SetInteractiveEnabledWhenPaused (enable:Boolean):void
   {
      mEnabledInteractiveWhenPaused = enable;
         // this is 
   }
   
   public function IsInteractiveEnabledNow ():Boolean
   {
      // not a good ideas:
      // assume: mouse down before fading, release mouse when fading, then make some confused.
      // it is best provide a function IsCameraFading () for user convenience.
      
      if (mIsPaused)
         return mEnabledInteractiveWhenPaused;
      else
         return true;
   }

//=============================================================
//   
//=============================================================

   private var mCurrentMode:Mode = null;
   
   public function SetCurrentMode (mode:Mode):void
   {
      if (mCurrentMode != null)
         mCurrentMode.Destroy ();
      
      mCurrentMode = mode;
      
      if (mCurrentMode != null)
         mCurrentMode.Initialize ();
   }

//=============================================================
//   
//=============================================================

   public static const CachedEventType_General:int = 0;
   public static const CachedEventType_RemoveBombsAndRemovableShapes:int = 1;
   
   private var mCacheSystemEvents:Boolean = true;
   
   // [2013.10.14 v2.05]:
   // seems this function was added from v1.50.
   // for viewer calling only, not exposed as an API.
   // the viewer will call world.SetCacheSystemEvent (world.mShowPlayBar).
   // maybe doing this will be helpful for some cases I forget now.
   //    (maybe for Flash security, for example, Flash only only call ClipBoard.paste in system event handlers)
   // it will bring lags when synchronizing shape visual and physics.
   // to keep the compatibility:
   // - to add a UpdateShapeAppearance API for synchronizing shape visual immediately
   // - in viewer, for v2.xx, don't call world.SetCacheSystemEvent (world.mShowPlayBar)
   // - to add a SetCacheSystemEvent API
   
   public function SetCacheSystemEvent (cache:Boolean):void
   {
      mCacheSystemEvents = cache;
      
      if (! mCacheSystemEvents)
      {
         HandleAllCachedSystemEvents ();
         ClearAllCachedSystemEvents ();
      }
   }
   
   private var mCachedSystemEvents:Array = new Array ();
   
   private function RegisterCachedSystemEvent (eventInfo:Array):void
   {
      if (! mInitialized)
         return;
         
      if (mCacheSystemEvents)
      {
         mCachedSystemEvents.push (eventInfo);
      }
      else
      {
         HandleCachedSystemEvent (eventInfo);
      }
   }
   
   private function HandleAllCachedSystemEvents ():void
   {
      var numEvents:int = mCachedSystemEvents.length;
      
      for (var i:int = 0; i < numEvents; ++ i)
      {
         HandleCachedSystemEvent (mCachedSystemEvents [i] as Array);
      }
   }
   
   private function HandleCachedSystemEvent (eventInfo:Array):void
   {
      if (eventInfo [0] == CachedEventType_RemoveBombsAndRemovableShapes)
      {
         RemoveBombsAndRemovableShapes (eventInfo [1] as Array);
      }
      else
      {
         var handlerElement:ListElement_EventHandler = eventInfo [1] as ListElement_EventHandler;
         var valueSourceList:Parameter = eventInfo [2] as Parameter;
         
         IncStepStage ();
         while (handlerElement != null)
         {
            handlerElement.mEventHandler.HandleEvent (valueSourceList);
            
            handlerElement = handlerElement.mNextListElement;
         }
      }
   }
   
   private function ClearAllCachedSystemEvents ():void
   {
      var numEvents:int = mCachedSystemEvents.length;
      
      if (numEvents > 0)
      {
         mCachedSystemEvents.splice (0, numEvents);
      }
   }

//=============================================================
//   
//=============================================================

   private var mCachedMousePoint:Point = null;
   private var mCurrentMouseX:Number = 0; // generally, use GetCurrentMouseX ()
   private var mCurrentMouseY:Number = 0; // generally, use GetCurrentMouseY ()
   private var mIsMouseButtonDown:Boolean = false;
   
   public function GetCurrentMouseX ():Number
   {
      UpdateMousePosition ();
      
      return mCurrentMouseX;
   }
   
   public function GetCurrentMouseY ():Number
   {
      UpdateMousePosition ();
      
      return mCurrentMouseY;
   }
   
   private function UpdateMousePosition ():void
   {
      var worldDisplayPoint:Point = ThisToContentLayer (new Point (mouseX, mouseY));
      
      if (mCachedMousePoint == null)
      {
         mCachedMousePoint = new Point ();
      }
      else if (mCachedMousePoint.x == worldDisplayPoint.x && mCachedMousePoint.y == worldDisplayPoint.y)
      {
         return;
      }
      
      mCachedMousePoint.x = worldDisplayPoint.x;
      mCachedMousePoint.y = worldDisplayPoint.y;
      
      var point:Point = mCoordinateSystem.DisplayPoint2PhysicsPosition (mCachedMousePoint.x, mCachedMousePoint.y);
      
      mCurrentMouseX = ValueAdjuster.Number2Precision (point.x, 12); // why do this?
      mCurrentMouseY = ValueAdjuster.Number2Precision (point.y, 12);
   }
   
   public function IsMouseButtonDown ():Boolean
   {
      return mIsMouseButtonDown;
   }
   
   public function UpdateMousePositionAndHoldInfo (event:MouseEvent):void
   {
      //var point:Point = new Point (event.stageX, event.stageY);
      //point = globalToLocal (point);
      //point = mCoordinateSystem.DisplayPoint2PhysicsPosition (point.x, point.y);
      //
      //mCurrentMouseX = ValueAdjuster.Number2Precision (point.x, 12);
      //mCurrentMouseY = ValueAdjuster.Number2Precision (point.y, 12);
      
      mIsMouseButtonDown = event.buttonDown;
   }



//=============================================================
//   
//=============================================================

   private var mIsMoreEventHandlersAdded:Boolean = false;
   private function AddMoreMouseEventHandlers ():void
   {
      if (mIsMoreEventHandlersAdded)
         return;
      
      addEventListener (/*MouseEvent.RIGHT_CLICK*/"rightClick", OnMouseRightClick);
      addEventListener (/*MouseEvent.RIGHT_DOWN*/"rightMouseDown", OnMouseRightDown);
      addEventListener (/*MouseEvent.RIGHT_UP*/"rightMouseUp", OnMouseRightUp);
      
      //addEventListener (MouseEvent.RELEASE_OUTSIDE, OnMouseReleaseOutside);
      
      mIsMoreEventHandlersAdded = true;
   }
   
   private function RemoveMoreMouseEventHandlers ():void
   {
      if (mIsMoreEventHandlersAdded)
      {
         removeEventListener (/*MouseEvent.RIGHT_CLICK*/"rightClick", OnMouseRightClick);
         removeEventListener (/*MouseEvent.RIGHT_DOWN*/"rightMouseDown", OnMouseRightDown);
         removeEventListener (/*MouseEvent.RIGHT_UP*/"rightMouseUp", OnMouseRightUp);
         
         //removeEventListener (MouseEvent.RELEASE_OUTSIDE, OnMouseReleaseOutside);
         
         mIsMoreEventHandlersAdded = false;
      }
   }
   
   private function OnAddedToStage (event:Event):void 
   {
      addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
      
      addEventListener (MouseEvent.CLICK, OnMouseLeftClick);
      addEventListener (MouseEvent.MOUSE_DOWN, OnMouseLeftDown);
      addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
      addEventListener (MouseEvent.MOUSE_UP, OnMouseLeftUp);
      //addEventListener (MouseEvent.MOUSE_OVER, OnOtherMouseEvents);
      //addEventListener (MouseEvent.MOUSE_OUT, OnOtherMouseEvents);
      //addEventListener (MouseEvent.ROLL_OVER, OnOtherMouseEvents);
      //addEventListener (MouseEvent.ROLL_OUT, OnOtherMouseEvents);
      //addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
      
      // todo: MouseEvent.RIGHT_UP may be not fired. Now
      //       use Event.MOUSE_LEAVE to fix this problem.
      // addEventListener (Event.MOUSE_LEAVE, );
      
      // useless tips: get the context menu popup point: 
      // > http://stackoverflow.com/questions/18017675/action-script-3-getting-click-location-when-context-menu-opens
      
      if (IsSupportMoreMouseEvents ())
      {
         AddMoreMouseEventHandlers ();
      }
      
      // !!! don't forget to register corresponding event on Viewer.mGesgureSprite
      
      // ...
      stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      stage.addEventListener (KeyboardEvent.KEY_UP, OnKeyUp);
      
      //
      stage.addEventListener (Event.ACTIVATE, OnActivated);
      stage.addEventListener (Event.DEACTIVATE, OnDeactivated);
      
      //
      MoveWorldScene_DisplayOffset (0, 0);
      
      // commented off for exceptions on some latin system
      //IME.enabled = false; // seems no effects
   }
   
   private function OnRemovedFromStage (event:Event):void 
   {
      // 
      //IME.enabled = true;
      
      // must remove this listeners, to avoid memory leak
      
      removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
      
      removeEventListener (MouseEvent.CLICK, OnMouseLeftClick);
      removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseLeftDown);
      removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
      removeEventListener (MouseEvent.MOUSE_UP, OnMouseLeftUp);
      //removeEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
      //removeEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
      //removeEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
      //removeEventListener (MouseEvent.ROLL_OVER, OnRollOver);
      //removeEventListener (MouseEvent.ROLL_OUT, OnRollOut);
      
      if (IsSupportMoreMouseEvents ())
      {
         RemoveMoreMouseEventHandlers ();
      }
      
      // !!! don't forget to unregister corresponding event on Viewer.mGesgureSprite
      
      stage.removeEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      stage.removeEventListener (KeyboardEvent.KEY_UP, OnKeyUp);
      
      //
      stage.removeEventListener (Event.ACTIVATE, OnActivated);
      stage.removeEventListener (Event.DEACTIVATE, OnDeactivated);
   }

//=============================================================
//   mouse events
//   All moust events are not directly caused by the world sprite itself.
//   They are all caused by some descendants of the world sprite. 
//   So every mouse event will not be triggered twice.
//=============================================================
   
   private var mLastMouseDownEntity:Entity = null;
   public function SetLastMouseDownEntity(entity:Entity):void
   {
      mLastMouseDownEntity = entity;
   }

   public function OnViewerEvent (event:Event):void
   {
      var mouseEvent:MouseEvent = event as MouseEvent;
      if (mouseEvent == null) // only support mouse events now
         return;
      
      // fix for entity event
      
      // although the fix will get back mouse down/up/click for entities, but move/enter/out are still missed,
      
      // this is not a perfect fix.
      // todo: try to use DisplayObjectContianer.getObjectsUnderPoint and dispatchEvent instead

      // for unknown reason, the result of mEntityLayer.getObjectsUnderPoint is always blank.
      // so this fix doesn't work for entities.
      
      /*
      var stagePoint:Point = new Point (mouseEvent.stageX, mouseEvent.stageY);
      //var locaPoint:Point = StageToContentLayer (stagePoint);
      //var childrenUnderPoint:Array = mContentLayer.getObjectsUnderPoint (locaPoint); // bug
      var childrenUnderPoint:Array;
      var count:int;
      var layerContainer:DisplayObjectContainer;
      if (mIsBorderAtTopLayer)
      {
         childrenUnderPoint = mBorderLayer.getObjectsUnderPoint (stagePoint);
         count = childrenUnderPoint == null ? 0 : childrenUnderPoint.length;
trace ("aaa childrenUnderPoint = " + childrenUnderPoint);
         if (count != 0)
         {
            layerContainer = mBorderLayer;
         }
         else
         {
            layerContainer = mEntityLayer;
            childrenUnderPoint = mEntityLayer.getObjectsUnderPoint (stagePoint);
            count = childrenUnderPoint == null ? 0 : childrenUnderPoint.length;
trace ("bbb count = " + count + ", childrenUnderPoint = " + childrenUnderPoint);
         }
      }
      else
      {
         childrenUnderPoint = mEntityLayer.getObjectsUnderPoint (stagePoint);
         count = childrenUnderPoint == null ? 0 : childrenUnderPoint.length;
trace ("ccc count = " + count);
         if (count != 0)
         {
            layerContainer = mEntityLayer;
         }
         else
         {
            layerContainer = mBorderLayer;
            childrenUnderPoint = mBorderLayer.getObjectsUnderPoint (stagePoint);
            count = childrenUnderPoint == null ? 0 : childrenUnderPoint.length;
         }
trace ("ddd count = " + count);
      }
      
      var child:DisplayObject;
      var childIndex:int;
      var toppestChild:EntitySprite = null;
      var toppestChildIndex:int = -1;
      var p:DisplayObjectContainer;
      var entitySprite:EntitySprite;
      for (var i:int = count - 1; i >= 0; -- i)
      {
trace ("eee childrenUnderPoint [" + i + "] = " + childrenUnderPoint [i]);

         child = childrenUnderPoint [i] as DisplayObject;
         p = child;
         entitySprite = null;
         while (p != layerContainer)
         {
            entitySprite = p as EntitySprite;
            if (entitySprite != null)
               break;
         }
         
         if (entitySprite != null)
         {
            childIndex = mContentLayer.getChildIndex (entitySprite);
            if (childIndex > toppestChildIndex)
            {
               toppestChild = entitySprite;
            }
         }
      }
      
      if (toppestChild != null)
      {
         //locaPoint = toppestChild.globalToLocal (stagePoint);
         //
         //var newMouseEvent:MouseEvent = new MouseEvent (mouseEvent.type, mouseEvent.bubbles, mouseEvent.cancelable, 
         //                                               locaPoint.x, locaPoint.y, toppestChild as InteractiveObject,
         //                                               mouseEvent.ctrlKey, mouseEvent.altKey, mouseEvent.shiftKey,
         //                                               mouseEvent.buttonDown, mouseEvent.delta);
         //toppestChild.dispatchEvent (newMouseEvent);
         
         // no needs to calculate the locaPoint, it is never used.
         
         var toppestShape:EntityShape = toppestChild.GetEntity () as EntityShape;
         
         if (toppestShape != null)
         {
            switch (mouseEvent.type)
            {
               //case MouseEvent.CLICK: // will fire in the following MOUSE_UP case block.
               //   toppestShape.OnMouseClick (mouseEvent);
               //   break;
               case MouseEvent.MOUSE_DOWN:
                  toppestShape.OnMouseDown (mouseEvent);
                  break;
               case MouseEvent.MOUSE_MOVE:
                  toppestShape.OnMouseMove (mouseEvent);
                  break;
               case MouseEvent.MOUSE_UP:
               {
                  var isMouseDownEntity:Boolean = toppestChild.GetEntity () == mLastMouseDownEntity;
                  
                  toppestShape.OnMouseUp (mouseEvent);
                  
                  if (isMouseDownEntity)
                  {
                     toppestShape.OnMouseClick (mouseEvent);
                  }
                  
                  break;
               }
            }
         }
      }
      */
      
      // fix for world events
      
      switch (mouseEvent.type)
      {
         //case MouseEvent.CLICK: // will fire in the following MOUSE_UP case block.
         //   OnMouseLeftClick (mouseEvent);
         //   break;
         case MouseEvent.MOUSE_DOWN:
            OnMouseLeftDown (mouseEvent);
            break;
         case MouseEvent.MOUSE_MOVE:
            OnMouseMove (mouseEvent);
            break;
         case MouseEvent.MOUSE_UP:
         {
            var isMouseDown:Boolean = IsKeyHold (KeyCodes.LeftMouseButton); 
                  // should NOT use mouseEvent.buttonDown.
                  // the two values may be different.
            
            OnMouseLeftUp (mouseEvent);
            
            if (isMouseDown)
            {
               // this "if" may cause a little incompatibility. Old version has not this line.
               OnMouseLeftClick (mouseEvent);
            }
            
            break;
         }
      }
   }
   
   public function OnMouseLeftClick (event:MouseEvent):void
   {
      OnMouseClick (event, true);
      
      SetLastMouseDownEntity (null);
   }
   
   public function OnMouseRightClick (event:MouseEvent):void
   {
      OnMouseClick (event, false);
   }
   
   public function OnMouseLeftDown (event:MouseEvent):void
   {
      OnMouseDown (event, true);
   }
   
   public function OnMouseRightDown (event:MouseEvent):void
   {
      OnMouseDown (event, false);
   }
   
   public function OnMouseLeftUp (event:MouseEvent):void
   {
      OnMouseUp (event, true);
   }
   
   public function OnMouseRightUp (event:MouseEvent):void
   {
      OnMouseUp (event, false);
   }
   
   public function OnMouseClick (event:MouseEvent, isLeft:Boolean):void
   {
      UpdateMousePositionAndHoldInfo (event);
      
      if (IsInteractiveEnabledNow ())
      {
         // ...
         RegisterMouseEvent (event, mEventHandlersByTypes [isLeft ? CoreEventIds.ID_OnWorldMouseClick : CoreEventIds.ID_OnWorldMouseRightClick]);
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   private var _KeyboardDownEvent:KeyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
   private var _KeyboardUpEvent:KeyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_UP);
   
   public function OnMouseDown (event:MouseEvent, isLeft:Boolean):void
   {
      // moved to update ()
      //if ((stage.focus is TextField) && (! (event.target is TextField)) && (stage.focus != stage))
      //   stage.focus = stage;
      
      // ...
      
      // todo: add scene option: support moving scene with mouse.
      if (isLeft)
      {
         if (mCurrentMode != null)
         {
            mCurrentMode.OnMouseUp (event.stageX, event.stageY);
            mCurrentMode = null;
         }
         
         SetCurrentMode (new ModeMoveWorldScene (this));
         
         if (mCurrentMode != null)
            mCurrentMode.OnMouseDown (event.stageX, event.stageY);
      }
      
      UpdateMousePositionAndHoldInfo (event);
      
      // ...
      
      if (IsInteractiveEnabledNow ())
      {
         var mouseButtonKeyCode:int = isLeft ? KeyCodes.LeftMouseButton : KeyCodes.RightMouseButton;
         
         // sometimes, user release mouse out of world, ...
         if (IsKeyHold (mouseButtonKeyCode))
         {
            if (isLeft)
            {
               OnMouseLeftUp (event);
            }
            else
            {
               OnMouseRightUp (event);
            }
         }
         
         KeyPressed (mouseButtonKeyCode, 0);
         
         // as a key
         _KeyboardDownEvent.keyCode = mouseButtonKeyCode;
         _KeyboardDownEvent.charCode = 0;
         _KeyboardDownEvent.ctrlKey = event.ctrlKey;
         _KeyboardDownEvent.shiftKey = event.shiftKey;
         _KeyboardDownEvent.altKey = event.altKey;
         //HandleKeyEventByKeyCode (_KeyboardDownEvent, true);
         RegisterKeyboardEvent (mouseButtonKeyCode, _KeyboardDownEvent, mKeyDownEventHandlerLists);
         
         // ...
         RegisterMouseEvent (event, mEventHandlersByTypes [isLeft ? CoreEventIds.ID_OnWorldMouseDown : CoreEventIds.ID_OnWorldMouseRightDown]);
         
         // ...
            
         HandlePhysicsShapeMouseEvents (event, true, isLeft);
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   public function OnMouseUp (event:MouseEvent, isLeft:Boolean):void
   {
      // currently, mouse up events will not be fired if mouse down events are not registered.
      // (key events also). 
   
      // ...
      if (isLeft)
      {
         if (mCurrentMode != null)
         {
            mCurrentMode.OnMouseUp (event.stageX, event.stageY);
            mCurrentMode = null;
         }
      }
      
      UpdateMousePositionAndHoldInfo (event);
      
      // ...
      
      // unlike mouseDown, this "if" is commented off here to avoid event losing.
      //if (IsInteractiveEnabledNow ())
      {
         var mouseButtonKeyCode:int = isLeft ? KeyCodes.LeftMouseButton : KeyCodes.RightMouseButton;
         
         if (IsKeyHold (mouseButtonKeyCode))
         {
            // moved to bottom
            //KeyReleased (mouseButtonKeyCode, 0);
            
            // moved from bottom again.
            KeyReleased (mouseButtonKeyCode, 0);
            
            // since v2.08, moved from below to here. For symmetry.
            RegisterMouseEvent (event, mEventHandlersByTypes [isLeft ? CoreEventIds.ID_OnWorldMouseUp : CoreEventIds.ID_OnWorldMouseRightUp]);
            
            // as a key
            _KeyboardUpEvent.keyCode = mouseButtonKeyCode;
            _KeyboardUpEvent.charCode = 0;
            _KeyboardUpEvent.ctrlKey = event.ctrlKey;
            _KeyboardUpEvent.shiftKey = event.shiftKey;
            _KeyboardUpEvent.altKey = event.altKey;
            //HandleKeyEventByKeyCode (_KeyboardUpEvent, false);
            RegisterKeyboardEvent (mouseButtonKeyCode, _KeyboardUpEvent, mKeyUpEventHandlerLists);
            
            // since v2.08,  moved above to handle before the simulated key event.
            //RegisterMouseEvent (event, mEventHandlersByTypes [isLeft ? CoreEventIds.ID_OnWorldMouseUp : CoreEventIds.ID_OnWorldMouseRightUp]);
            
            // ...
            
            HandlePhysicsShapeMouseEvents (event, false, isLeft);
            
            // since v2.08, move to above again, for IsKeyHold (mosueButton) should return false in KeyUp and MouseRelease event handler.
            // KeyReleased (mouseButtonKeyCode, 0);
         }
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   private function HandlePhysicsShapeMouseEvents (event:MouseEvent, isMouseDown:Boolean, isLeft:Boolean):void
   {
      var tryToRemovePinks:Boolean = (isMouseDown == IsRemovePinksOnMouseDown ());
      var leftMouseEventId :int = isMouseDown ? CoreEventIds.ID_OnPhysicsShapeMouseDown      : CoreEventIds.ID_OnPhysicsShapeMouseUp;
      var rightMouseEventId:int = isMouseDown ? CoreEventIds.ID_OnPhysicsShapeMouseRightDown : CoreEventIds.ID_OnPhysicsShapeMouseRightUp;
      
      var shapeArray:Array = null;
      
      while (tryToRemovePinks
              ||
            mEventHandlersByTypes [leftMouseEventId] != null
              ||
            mEventHandlersByTypes [rightMouseEventId] != null
           )
      {
         // ...
         //var worldDisplayPoint:Point = globalToLocal (new Point (event.stageX, event.stageY));
         var worldDisplayPoint:Point = StageToContentLayer (new Point (event.stageX, event.stageY));
         var physicsPoint:Point = mCoordinateSystem.DisplayPoint2PhysicsPosition (worldDisplayPoint.x, worldDisplayPoint.y);
         shapeArray = mPhysicsEngine.GetShapesAtPoint (physicsPoint.x, physicsPoint.y);
         if (shapeArray.length == 0)
         {
            shapeArray = null;
            break;
         }
         
         // ...
         var shape:EntityShape;
         var num:int = shapeArray.length;
         var i:int;
         if (isLeft)
         {
            if (mEventHandlersByTypes [leftMouseEventId] == null)
               break;
            
            if (isMouseDown)
            {
               for (i = 0; i < num; ++ i)
               {
                  shape = shapeArray [i] as EntityShape;
                  shape.OnPhysicsShapeMouseDown (event);
               }
            }
            else
            {
               for (i = 0; i < num; ++ i)
               {
                  shape = shapeArray [i] as EntityShape;
                  shape.OnPhysicsShapeMouseUp (event);
               }
            }
         }
         else
         {
            if (mEventHandlersByTypes [rightMouseEventId] == null)
               break;
            
            if (isMouseDown)
            {
               for (i = 0; i < num; ++ i)
               {
                  shape = shapeArray [i] as EntityShape;
                  shape.OnPhysicsShapeMouseRightDown (event);
               }
            }
            else
            {
               for (i = 0; i < num; ++ i)
               {
                  shape = shapeArray [i] as EntityShape;
                  shape.OnPhysicsShapeMouseRightUp (event);
               }
            }
         }
         
         break;
      }
      
      if (tryToRemovePinks && shapeArray != null)
      {
         //RemoveBombsAndRemovableShapes (shapeArray);
         RegisterCachedSystemEvent ([CachedEventType_RemoveBombsAndRemovableShapes, shapeArray]);
      }
   }
   
   public function OnMouseMove (event:MouseEvent):void
   {
      //if (Mouse.supportsNativeCursor) // this is for setup custom sprite cursor
      if (Mouse.supportsCursor)
      {
         event.updateAfterEvent(); 
            // this line will make mouse following more smoothly.
            // but it also decrease fps, especially on mobile devices.
            // so this line is only apply on PC with cursor supported.
      }
      
      // ...
      if (mCurrentMode != null)
         mCurrentMode.OnMouseMove (event.stageX, event.stageY, event.buttonDown);
      
      UpdateMousePositionAndHoldInfo (event);
      
      if (IsInteractiveEnabledNow ())
      {
         //
         RegisterMouseEvent (event, mEventHandlersByTypes [CoreEventIds.ID_OnWorldMouseMove]);
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   //public function OnMouseReleaseOutside (event:MouseEvent):void
   //{
   //}
   
   public function OnOtherMouseEvents (event:MouseEvent):void
   {
      // ...
      if (mCurrentMode != null)
         mCurrentMode.OnMouseMove (event.stageX, event.stageY, event.buttonDown);
      
      UpdateMousePositionAndHoldInfo (event);
      
      if (IsInteractiveEnabledNow ())
      {
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   public function RegisterMouseEvent (event:MouseEvent, handlerList:ListElement_EventHandler, shape:EntityShape = null):void
   {
      if (handlerList == null)
         return;
      
      var valueSource7:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kBooleanClassDefinition, false, null); // is overlapped by some entities
      var valueSource6:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kBooleanClassDefinition, false, valueSource7); // alt down
      var valueSource5:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kBooleanClassDefinition, false, valueSource6); // shift down
      var valueSource4:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kBooleanClassDefinition, false, valueSource5); // ctrl down
      var valueSource3:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kBooleanClassDefinition, false, valueSource4); // button down
      var valueSource2:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition, 0, valueSource3); // world physics y
      var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition, 0, valueSource2); // world physics x
      
      valueSource1.mValueObject = GetCurrentMouseX ();
      valueSource2.mValueObject = GetCurrentMouseY ();
      valueSource3.mValueObject = event.buttonDown;
      valueSource4.mValueObject = event.ctrlKey;
      valueSource5.mValueObject = event.shiftKey;
      valueSource6.mValueObject = event.altKey;
      
      if (shape == null)
      {
         valueSource7.mValueObject = IsContentLayerContains (event.target as DisplayObject); // for world event only
         RegisterCachedSystemEvent ([CachedEventType_General, handlerList, valueSource1]);
      }
      else
      {
         var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kEntityClassDefinition, null, valueSource1); // entity
         valueSource0.mValueObject = shape;
         RegisterCachedSystemEvent ([CachedEventType_General, handlerList, valueSource0]);
      }
   }

//=============================================================
//   keyboard events
//=============================================================

   public function OnKeyDown (event:KeyboardEvent):void
   {
      if (Viewer_mLibAppp.IsCurrentViewer ())
      {
         // event handling can't be run simutaniously with PhysicsEngine.Step ().
         // in flash, this is not a problem. Be careful when porting to other platforms.
         
         if (IsInteractiveEnabledNow ())
         {
            var exactKeyCode:int = GetExactKeyCode (event);
            
            // now ignore it if the general key is already hold.
            // "release it then rehold it" is another implementation, 
            // this is adopted for mouse buttons but not for general keys now.
            
            if (IsKeyHold (exactKeyCode))
               return;
            
            KeyPressed (exactKeyCode, event.charCode);
            RegisterKeyboardEvent (exactKeyCode, event, mKeyDownEventHandlerLists);
            //HandleKeyEventByKeyCode (event, true);
         }
         
         //trace ("Pressed: " + String.fromCharCode (event.charCode));
      }
   }
   
   public function OnKeyUp (event:KeyboardEvent):void
   {
      if (Viewer_mLibAppp.IsCurrentViewer ())
      {
         // event handling can't be run simutaniously with PhysicsEngine.Step ().
         // in flash, this is not a problem. Be careful when porting to other platforms.
         
         // unlike keyDown, this "if" is commented off here.
         // if (IsInteractiveEnabledNow ())
         {
            var exactKeyCode:int = GetExactKeyCode (event);
            
            if (! IsKeyHold (exactKeyCode))
               return;
            
            //HandleKeyEventByKeyCode (event, false);
            RegisterKeyboardEvent (exactKeyCode, event, mKeyUpEventHandlerLists);
            KeyReleased (exactKeyCode, event.charCode);
         }
         
         //trace ("Released: " + String.fromCharCode (event.charCode));
      }
   }
   
   private function GetExactKeyCode (event:KeyboardEvent):int
   {
      // seems flash has bug in distinguishing the left and right ctrl
      
      //if (event.keyCode == Keyboard.CONTROL)
      //{
      //   if (event.keyLocation == KeyLocation.RIGHT)
      //   {
      //      return KeyCodes.ControlRight;
      //   }
      //   else
      //   {
      //      return KeyCodes.ControlLeft;
      //   }
      //}
      //if (event.keyCode == Keyboard.SHIFT)
      //{
      //   if (event.keyLocation == KeyLocation.RIGHT)
      //   {
      //      return KeyCodes.ShiftRight;
      //   }
      //   else
      //   {
      //      return KeyCodes.ShiftLeft;
      //   }
      //}
      
      return event.keyCode;
   }
   
   public function RegisterKeyboardEvent (exactKeyCode:int, event:KeyboardEvent, handleListArray:Array):void
   {
      if (exactKeyCode < 0 || exactKeyCode >= KeyCodes.kNumKeys)
         return;
      
      // special for ctrl and shift
      
      var handlerList:ListElement_EventHandler = handleListArray [exactKeyCode];
      if (handlerList == null)
         return;
      
      var valueSource4:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition, 0, null);
      var valueSource3:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kBooleanClassDefinition, false, valueSource4);
      var valueSource2:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kBooleanClassDefinition, false, valueSource3);
      var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition, 0, valueSource2);
      var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition, 0, valueSource1);
      
      valueSource0.mValueObject = exactKeyCode;
      valueSource1.mValueObject = event.charCode;
      valueSource2.mValueObject = event.ctrlKey;
      valueSource3.mValueObject = event.shiftKey;
      valueSource4.mValueObject = mKeyHoldInfo [exactKeyCode][KeyHoldInfo_Ticks];
      
      RegisterCachedSystemEvent ([CachedEventType_General, handlerList, valueSource0]);
   }

//=============================================================
//   focus events
//=============================================================

   // todo: the 2 event handlers should put in Viewer.
   //       for when switching scens or the world is not inited, there would be problems.
   
   public function OnActivated (event:Event):void
   {
      if (GetBuildingStatus () > 0) // todo: may be not a perfect fix
      {
         HandleEventById (CoreEventIds.ID_OnGameActivated, null);
      }
   }
   
   public function OnDeactivated (event:Event):void
   {
      // 
      ClearKeyHoldInfo (true);
      
      // todo: also a ClearMouseHoldInfo () ? This needs tracking the mouse position.
      
      // ...
      if (GetBuildingStatus () > 0) // todo: may be not a perfect fix
      {
         HandleEventById (CoreEventIds.ID_OnGameDeactivated, null);
      }
   }
   
//=============================================================
//   system back
//=============================================================
   
   //public function HasSystemBackEventHandlers ():Boolean
   //{
   //   var handler_element:ListElement_EventHandler = mEventHandlersByTypes [CoreEventIds.ID_OnSystemBack];
   //   
   //   while (handler_element != null)
   //   {
   //      if (handler_element.mEventHandler.IsEnabled ())
   //         return true;
   //      
   //      handler_element = handler_element.mNextListElement;
   //   }
   //   
   //   return false;
   //}
   
   // return 1 for handled by world self.
   // return 0 to let Viewer handle the event.
   public function OnSystemBackEvent ():int
   {
      var handled:Boolean = false;
      
      var valueTarget:Parameter_DirectMutable = Parameter_DirectMutable.CreateCoreClassDirectMutable (
                                                            CoreClassIds.ValueType_Boolean,
                                                            false
                                                          ); 
                                                         //new Parameter_DirectMutable (null);
      
      var handler_element:ListElement_EventHandler = mEventHandlersByTypes [CoreEventIds.ID_OnSystemBack];
      
      while (handler_element != null)
      {
         valueTarget.mValueObject = false;
         handler_element.mEventHandler.HandleEvent (null, valueTarget);
         
         handled = handled || Boolean (valueTarget.EvaluateValueObject ());
   
         handler_element = handler_element.mNextListElement;
      }
      
      return handled ? 1 : 0;
   }

