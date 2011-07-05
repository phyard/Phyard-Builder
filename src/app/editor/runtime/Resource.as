package editor.runtime {
   
   import flash.utils.Dictionary;
   import flash.display.Bitmap;
   
   import common.trigger.CoreEventIds;
   
   public class Resource
   {
   // camera icon
      
      [Embed("../../res/create/camera.png")]
      public static var IconCamera:Class;
      
      [Embed("../../res/create/force-linear.png")]
      public static var IconForce:Class;
      [Embed("../../res/create/force-angular.png")]
      public static var IconTorque:Class;
      [Embed("../../res/create/acceleration-linear.png")]
      public static var IconLinearAcceleration:Class;
      [Embed("../../res/create/acceleration-angular.png")]
      public static var IconAngularAcceleration:Class;
      [Embed("../../res/create/impulse-linear.png")]
      public static var IconLinearImpulse:Class;
      [Embed("../../res/create/impulse-angular.png")]
      public static var IconAngularImpulse:Class;
      [Embed("../../res/create/velocity-linear.png")]
      public static var IconLinearVelocity:Class;
      [Embed("../../res/create/velocity-angular.png")]
      public static var IconAngularVelocity:Class;
      
   // conditon and action, entity limiters
      
      [Embed("../../res/create/condition.png")]
      public static var IconBasicCondition:Class;
      [Embed("../../res/create/action.png")]
      public static var IconTriggerAction:Class;
      [Embed("../../res/create/input_entity_limiter.png")]
      public static var IconInputEntityManualAssigner:Class;
      [Embed("../../res/create/input_entity_pair_limiter.png")]
      public static var IconInputEntityPairManualAssigner:Class;
      [Embed("../../res/create/input_entity_region_selector.png")]
      public static var IconInputEntityRegionSelector:Class;
      [Embed("../../res/create/input_entity_filter.png")]
      public static var IconInputEntityScriptFilter:Class;
      [Embed("../../res/create/input_entity_pair_filter.png")]
      public static var IconInputEntityPairScriptFilter:Class;
      
   // event icons
      
      // entity init / update / destroy
      
      [Embed("../../res/create/event_on_entity_created.png")]
      public static var IconOnEntityCteatedEvent:Class;
      [Embed("../../res/create/event_on_entity_initilized.png")]
      public static var IconOnEntityInitilizedEvent:Class;
      [Embed("../../res/create/event_on_entity_updated.png")]
      public static var IconOnEntityUpdatedEvent:Class;
      [Embed("../../res/create/event_on_entity_destroyed.png")]
      public static var IconOnEntityDestroyedEvent:Class;
      
      // joint limts
      
      [Embed("../../res/create/event_on_joint_reach_lower_limit.png")]
      public static var IconOnJointReachLowerLimitEvent:Class;
      [Embed("../../res/create/event_on_joint_reach_upper_limit.png")]
      public static var IconOnJointReachUpperLimitEvent:Class;
      
      // level init / update
      
      [Embed("../../res/create/event_on_level_before_initilizing.png")]
      public static var IconOnBeforeLevelInitializingEvent:Class;
      [Embed("../../res/create/event_on_level_after_initilized.png")]
      public static var IconOnAfterLevelInitializedEvent:Class;
      [Embed("../../res/create/event_on_level_before_updating.png")]
      public static var IconOnBeforeLevelUpdatingEvent:Class;
      [Embed("../../res/create/event_on_level_after_updated.png")]
      public static var IconOnAfterLevelUpdatedEvent:Class;
      
      // shape contact
      
      [Embed("../../res/create/event_on_shape_start_contacting.png")]
      public static var IconOnShapeStartContactingEvent:Class;
      [Embed("../../res/create/event_on_shape_keep_contacting.png")]
      public static var IconOnShapeKeepContactingEvent:Class;
      [Embed("../../res/create/event_on_shape_stop_contacting.png")]
      public static var IconOnShapeStopContactingEvent:Class;
      
      // keyboard
      
      [Embed("../../res/create/event_on_key_down.png")]
      public static var IconOnKeyDownEvent:Class;
      [Embed("../../res/create/event_on_key_up.png")]
      public static var IconOnKeyUpEvent:Class;
      [Embed("../../res/create/event_on_key_hold.png")]
      public static var IconOnKeyHoldEvent:Class;
      
      // mouse
      
      [Embed("../../res/create/event_on_world_mouse_clicked.png")]
      public static var IconOnWorldMouseClickedEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_move.png")]
      public static var IconOnWorldMouseMoveEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_down.png")]
      public static var IconOnWorldMouseDownEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_up.png")]
      public static var IconOnWorldMouseUpEvent:Class;
      
      [Embed("../../res/create/event_on_physics_shape_mouse_down.png")]
      public static var IconOnPhysicsEntityMouseDownEvent:Class;
      [Embed("../../res/create/event_on_physics_shape_mouse_up.png")]
      public static var IconOnPhysicsEntityMouseUpEvent:Class;
      
      [Embed("../../res/create/event_on_shape_mouse_clicked.png")]
      public static var IconOnEntityMouseClickedEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_move.png")]
      public static var IconOnEntityMouseMoveEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_down.png")]
      public static var IconOnEntityMouseDownEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_up.png")]
      public static var IconOnEntityMouseUpEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_enter.png")]
      public static var IconOnEntityMouseEnterEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_out.png")]
      public static var IconOnEntityMouseOutEvent:Class;
      
      // timer
      
      [Embed("../../res/create/event_on_entity_timer.png")]
      public static var IconOnEntityTimerEvent:Class;
      
      [Embed("../../res/create/event_on_entity_pair_timer.png")]
      public static var IconOnEntityPairTimerEvent:Class;
      
      [Embed("../../res/create/event_on_world_timer.png")]
      public static var IconOnWorldTimerEvent:Class;
      
   // event id -> icon
      
      private static var sEventId2IconClass:Dictionary = null;
      
      public static function EventId2IconBitmap (eventId:int):Bitmap
      {
         if (sEventId2IconClass == null)
         {
            sEventId2IconClass = new Dictionary ();
            
            sEventId2IconClass [CoreEventIds.ID_OnEntityCreated] = IconOnEntityCteatedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityInitialized] = IconOnEntityInitilizedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityUpdated    ] = IconOnEntityUpdatedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityDestroyed  ] = IconOnEntityDestroyedEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnJointReachLowerLimit] = IconOnJointReachLowerLimitEvent;
            sEventId2IconClass [CoreEventIds.ID_OnJointReachUpperLimit] = IconOnJointReachUpperLimitEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldBeforeInitializing] = IconOnBeforeLevelInitializingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldAfterInitialized  ] = IconOnAfterLevelInitializedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnLWorldBeforeUpdating   ] = IconOnBeforeLevelUpdatingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldAfterUpdated      ] = IconOnAfterLevelUpdatedEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting] = IconOnShapeStartContactingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting ] = IconOnShapeKeepContactingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesEndContacting  ] = IconOnShapeStopContactingEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldKeyDown] = IconOnKeyDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldKeyUp  ] = IconOnKeyUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldKeyHold] = IconOnKeyHoldEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseClick] = IconOnWorldMouseClickedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseDown ] = IconOnWorldMouseDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseUp   ] = IconOnWorldMouseUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseMove ] = IconOnWorldMouseMoveEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnPhysicsShapeMouseDown] = IconOnPhysicsEntityMouseDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnPhysicsShapeMouseUp  ] = IconOnPhysicsEntityMouseUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseClick     ] = IconOnEntityMouseClickedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseDown      ] = IconOnEntityMouseDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseUp        ] = IconOnEntityMouseUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseMove      ] = IconOnEntityMouseMoveEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseEnter     ] = IconOnEntityMouseEnterEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseOut       ] = IconOnEntityMouseOutEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnEntityTimer    ] = IconOnEntityTimerEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityPairTimer] = IconOnEntityPairTimerEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldTimer     ] = IconOnWorldTimerEvent;
         }
         
         var iconClass:Class = sEventId2IconClass [eventId];
         
         return iconClass == null ? null : new iconClass ();
      }
      
   // keyboard icons
      
      [Embed("../../res/keyboard/keyboard.png")]
      public static var Keyboard:Class;
      [Embed("../../res/keyboard/key-a-sel.png")]
      public static var KeyA:Class;
      [Embed("../../res/keyboard/key-b-sel.png")]
      public static var KeyB:Class;
      [Embed("../../res/keyboard/key-c-sel.png")]
      public static var KeyC:Class;
      [Embed("../../res/keyboard/key-d-sel.png")]
      public static var KeyD:Class;
      [Embed("../../res/keyboard/key-e-sel.png")]
      public static var KeyE:Class;
      [Embed("../../res/keyboard/key-f-sel.png")]
      public static var KeyF:Class;
      [Embed("../../res/keyboard/key-g-sel.png")]
      public static var KeyG:Class;
      [Embed("../../res/keyboard/key-h-sel.png")]
      public static var KeyH:Class;
      [Embed("../../res/keyboard/key-i-sel.png")]
      public static var KeyI:Class;
      [Embed("../../res/keyboard/key-j-sel.png")]
      public static var KeyJ:Class;
      [Embed("../../res/keyboard/key-k-sel.png")]
      public static var KeyK:Class;
      [Embed("../../res/keyboard/key-l-sel.png")]
      public static var KeyL:Class;
      [Embed("../../res/keyboard/key-m-sel.png")]
      public static var KeyM:Class;
      [Embed("../../res/keyboard/key-n-sel.png")]
      public static var KeyN:Class;
      [Embed("../../res/keyboard/key-o-sel.png")]
      public static var KeyO:Class;
      [Embed("../../res/keyboard/key-p-sel.png")]
      public static var KeyP:Class;
      [Embed("../../res/keyboard/key-q-sel.png")]
      public static var KeyQ:Class;
      [Embed("../../res/keyboard/key-r-sel.png")]
      public static var KeyR:Class;
      [Embed("../../res/keyboard/key-s-sel.png")]
      public static var KeyS:Class;
      [Embed("../../res/keyboard/key-t-sel.png")]
      public static var KeyT:Class;
      [Embed("../../res/keyboard/key-u-sel.png")]
      public static var KeyU:Class;
      [Embed("../../res/keyboard/key-v-sel.png")]
      public static var KeyV:Class;
      [Embed("../../res/keyboard/key-w-sel.png")]
      public static var KeyW:Class;
      [Embed("../../res/keyboard/key-x-sel.png")]
      public static var KeyX:Class;
      [Embed("../../res/keyboard/key-y-sel.png")]
      public static var KeyY:Class;
      [Embed("../../res/keyboard/key-z-sel.png")]
      public static var KeyZ:Class;
      [Embed("../../res/keyboard/key-up-sel.png")]
      public static var KeyUp:Class;
      [Embed("../../res/keyboard/key-down-sel.png")]
      public static var KeyDown:Class;
      [Embed("../../res/keyboard/key-left-sel.png")]
      public static var KeyLeft:Class;
      [Embed("../../res/keyboard/key-right-sel.png")]
      public static var KeyRight:Class;
      [Embed("../../res/keyboard/key-space-sel.png")]
      public static var KeySpace:Class;
      [Embed("../../res/keyboard/key-backspace-sel.png")]
      public static var KeyBackspace:Class;
      [Embed("../../res/keyboard/key-ctrl-sel.png")]
      public static var KeyCtrl:Class;
      [Embed("../../res/keyboard/key-shift-sel.png")]
      public static var KeyShift:Class;
      [Embed("../../res/keyboard/key-caps-sel.png")]
      public static var KeyCaps:Class;
      [Embed("../../res/keyboard/key-tab-sel.png")]
      public static var KeyTab:Class;
      [Embed("../../res/keyboard/key-0-sel.png")]
      public static var Key0:Class;
      [Embed("../../res/keyboard/key-1-sel.png")]
      public static var Key1:Class;
      [Embed("../../res/keyboard/key-2-sel.png")]
      public static var Key2:Class;
      [Embed("../../res/keyboard/key-3-sel.png")]
      public static var Key3:Class;
      [Embed("../../res/keyboard/key-4-sel.png")]
      public static var Key4:Class;
      [Embed("../../res/keyboard/key-5-sel.png")]
      public static var Key5:Class;
      [Embed("../../res/keyboard/key-6-sel.png")]
      public static var Key6:Class;
      [Embed("../../res/keyboard/key-7-sel.png")]
      public static var Key7:Class;
      [Embed("../../res/keyboard/key-8-sel.png")]
      public static var Key8:Class;
      [Embed("../../res/keyboard/key-9-sel.png")]
      public static var Key9:Class;
      [Embed("../../res/keyboard/key-enter-sel.png")]
      public static var KeyEnter:Class;
      [Embed("../../res/keyboard/key-quote-sel.png")]
      public static var KeyQuote:Class;
      [Embed("../../res/keyboard/key-backquote-sel.png")]
      public static var KeyBackquote:Class;
      [Embed("../../res/keyboard/key-slash-sel.png")]
      public static var KeySlash:Class;
      [Embed("../../res/keyboard/key-backslash-sel.png")]
      public static var KeyBackslash:Class;
      [Embed("../../res/keyboard/key-comma-sel.png")]
      public static var KeyComma:Class;
      [Embed("../../res/keyboard/key-period-sel.png")]
      public static var KeyPeriod:Class;
      [Embed("../../res/keyboard/key-semicolon-sel.png")]
      public static var KeySemicolon:Class;
      [Embed("../../res/keyboard/key-square-bracket-left-sel.png")]
      public static var KeySquareBracketLeft:Class;
      [Embed("../../res/keyboard/key-square-bracket-right-sel.png")]
      public static var KeySquareBracketRight:Class;
      [Embed("../../res/keyboard/key-add-sel.png")]
      public static var KeyAdd:Class;
      [Embed("../../res/keyboard/key-subtract-sel.png")]
      public static var KeySubtract:Class;
      [Embed("../../res/keyboard/key-pageup-sel.png")]
      public static var KeyPageup:Class;
      [Embed("../../res/keyboard/key-pagedown-sel.png")]
      public static var KeyPagedown:Class;
      [Embed("../../res/keyboard/key-home-sel.png")]
      public static var KeyHome:Class;
      [Embed("../../res/keyboard/key-end-sel.png")]
      public static var KeyEnd:Class;
      [Embed("../../res/keyboard/key-insert-sel.png")]
      public static var KeyInsert:Class;
      [Embed("../../res/keyboard/key-del-sel.png")]
      public static var KeyDel:Class;
   }
}
