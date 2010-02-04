
package common.trigger {
   
   public class CoreFunctionIds
   {
      public static function IsReturnCalling (id:int):Boolean
      {
         return  id == ID_Return
              || id == ID_ReturnIfTrue
              || id == ID_ReturnIfFalse
            ;
      }
      
      
   // the id < 8196 will be reserved for officeial core apis
      
      public static const ID_ForDebug:int                    = 0; // 
      
   // some specail
      
      public static const ID_Void:int                        = 10; // 
      public static const ID_Bool:int                        = 11; // 
      
   // global
      
      public static const ID_Return:int                       = 20; //
      public static const ID_ReturnIfTrue:int                 = 21; //
      public static const ID_ReturnIfFalse:int                = 22; //
      
   // system
      
      public static const ID_GetProgramMilliseconds:int           = 70; //
      public static const ID_GetCurrentDateTime:int               = 71; //
      public static const ID_IsKeyHold:int                        = 72; //
      
   // string
      
      public static const ID_String_Assign:int                    = 120; // 
      public static const ID_String_Add:int                       = 121; // to exchange with 122
      public static const ID_String_ConditionAssign:int           = 122; //
      
      public static const ID_String_NumberToString:int            = 150; // 
      public static const ID_String_BooleanToString:int           = 151; // 
      public static const ID_String_EntityToString:int            = 152; // 
      public static const ID_String_CollisionCategoryToString:int = 153; // 
      
   // bool
      
      public static const ID_Bool_Assign :int                    = 170; // 
      public static const ID_Bool_Invert :int                    = 171; // 
      public static const ID_Bool_IsTrue :int                    = 172; // 
      public static const ID_Bool_IsFalse:int                    = 173; // 
      public static const ID_Bool_ConditionAssign:int            = 174; // // to put after ID_Bool_Assign
      
      public static const ID_Bool_EqualsNumber:int               = 180; // 
      public static const ID_Bool_EqualsBoolean:int              = 181; // 
      public static const ID_Bool_EqualsEntity:int               = 182; // 
      public static const ID_Bool_EqualsString:int               = 183; // 
      public static const ID_Bool_EqualsCCat:int                 = 184; // 
      
      public static const ID_Bool_Larger:int                     = 210; // 
      public static const ID_Bool_Less:int                       = 211; // 
      
      public static const ID_Bool_And:int                        = 230; // 
      public static const ID_Bool_Or:int                         = 231; // 
      public static const ID_Bool_Not:int                        = 232; // 
      public static const ID_Bool_Xor:int                        = 233; // 
      
   // math basic op 
      
      public static const ID_Math_Assign:int                      = 300; // 
      public static const ID_Math_Negative:int                    = 301; // 
      public static const ID_Math_ConditionAssign:int             = 302; //
      
      
      public static const ID_Math_Add:int                         = 306; // 
      public static const ID_Math_Subtract:int                    = 307; // 
      public static const ID_Math_Multiply:int                    = 308; // 
      public static const ID_Math_Divide:int                      = 309; // 
      public static const ID_Math_Modulo:int                      = 310; // 
      
   // math / bitwise 
      
      public static const ID_Bitwise_ShiftLeft :int               = 315; // 
      public static const ID_Bitwise_ShiftRight :int              = 316; // 
      public static const ID_Bitwise_ShiftRightUnsigned :int      = 317; // 
      public static const ID_Bitwise_And :int                     = 318; // 
      public static const ID_Bitwise_Or :int                      = 319; // 
      public static const ID_Bitwise_Not :int                     = 320; // 
      public static const ID_Bitwise_Xor :int                     = 321; // 
      
  // math / trigonometry
      
      public static const ID_Math_SinRadians:int                  = 350; // 
      public static const ID_Math_CosRadians:int                  = 351; // 
      public static const ID_Math_TanRadians:int                  = 352; // 
      public static const ID_Math_ArcSinRadians:int               = 353; // 
      public static const ID_Math_ArcCosRadians:int               = 354; // 
      public static const ID_Math_ArcTanRadians:int               = 355; // 
      public static const ID_Math_ArcTan2Radians:int              = 356; // 
      
  // math / random
      
      public static const ID_Math_Random:int                      = 380; // 
      public static const ID_Math_RandomRange:int                 = 381; // 
      public static const ID_Math_RandomIntRange:int              = 382; // 
      
   // math number convert
      
      public static const ID_Math_Degrees2Radians:int            = 400; // 
      public static const ID_Math_Radians2Degrees:int            = 401; // 
      public static const ID_Math_Number2RGB:int                 = 402; // 
      public static const ID_Math_RGB2Number:int                 = 403; // 
      public static const ID_MillisecondsToMinutesSeconds:int    = 404; //
      //public static const ID_MillisecondsToMinutesSeconds:int    = 405; //
      
   // math more ...
      
      public static const ID_Math_Max:int                         = 500; // 
      public static const ID_Math_Min:int                         = 501; // 
      
      public static const ID_Math_Inverse:int                     = 510; // 
      public static const ID_Math_Abs:int                         = 511; // 
      public static const ID_Math_Sqrt:int                        = 512; // 
      public static const ID_Math_Ceil:int                        = 513; // 
      public static const ID_Math_Floor:int                       = 514; // 
      public static const ID_Math_Round:int                       = 515; // 
      public static const ID_Math_Log:int                         = 516; // 
      public static const ID_Math_Exp:int                         = 517; // 
      public static const ID_Math_Power:int                       = 518; // 
      public static const ID_Math_Clamp:int                       = 519; // 
      
      public static const Id_Math_LinearInterpolation:int                  = 530; //
      public static const Id_Math_LinearInterpolationColor:int             = 531; //
      
      
   // game / design
      
      public static const ID_Design_GetLevelMilliseconds:int                    = 600; // design
      public static const ID_Design_GetLevelSteps:int                           = 601; // design
      public static const ID_Design_GetMousePosition:int                        = 602; // design
      public static const ID_Design_IsMouseButtonHold:int                       = 603; // design
      
      public static const ID_Design_SetLevelStatus:int                           = 609; // design
      public static const ID_Design_IsLevelSuccessed:int                         = 610; // design
      public static const ID_Design_IsLevelFailed:int                            = 612; // design
      public static const ID_Design_IsLevelUnfinished:int                        = 614; // design
      
   // game / world
      
      //public static const ID_World_GetLevelMilliseconds:int               = 700; // world
      
      public static const ID_World_SetGravityAcceleration_Radians:int       = 710; // world
      public static const ID_World_SetGravityAcceleration_Degrees:int       = 711; // world
      public static const ID_World_SetGravityAcceleration_Vector:int        = 712; // world
      
      public static const ID_World_FollowCameraWithShape:int                         = 720; // world
      public static const ID_World_FollowCameraCenterXWithShape:int                  = 721; // world
      public static const ID_World_FollowCameraCenterYWithShape:int                  = 722; // world
      //public static const ID_World_FollowCameraRotationWithShape:int               = 723; // world
      public static const ID_World_CameraFadeOutThenFadeIn:int                       = 725; // world
      //public static const ID_World_CameraFadeOut:int                       = 725; // world
      //public static const ID_World_CameraFadeIn:int                        = 725; // world
      //public static const ID_World_CameraCloseThenOpen:int                           = 726; // world
      
      public static const ID_World_CallScript:int                               = 750; // world
      public static const ID_World_ConditionCallScript:int                      = 751; // world
      public static const ID_World_CallBoolFunction:int                         = 752; // world
      public static const ID_World_ConditionCallBoolFunction:int                = 753; // world
      public static const ID_World_CallScriptMultiTimes:int                   = 754; // world      
      public static const ID_World_CallBoolFunctionMultiTimes:int             = 755; // world      
      
      // VirtualClickOnEntityCenter (entity)
      
   // game / collision category
      
      public static const ID_CCat_Assign:int                              = 850; // CCat
      public static const ID_CCat_SetCollideInternally:int                = 851; // CCat
      public static const ID_CCat_SetAsFriends:int                        = 852; // CCat
      public static const ID_CCat_ConditionAssign:int                     = 853; // CCat, to ptu after ID_CCat_Assign
      
   // game / entity
      
      public static const ID_Entity_Assign:int                         = 900; // entity.shape
      public static const ID_Entity_ConditionAssign:int                = 901; // entity.shape
      
      public static const ID_Entity_IsTaskSuccessed:int                = 910; // entity.shape
      public static const ID_Entity_SetTaskSuccessed:int               = 911; // entity.shape
      public static const ID_Entity_IsTaskFailed:int                   = 912; // entity.shape
      public static const ID_Entity_SetTaskFailed:int                  = 913; // entity.shape
      public static const ID_Entity_IsTaskUnfinished:int               = 914; // entity.shape
      public static const ID_Entity_SetTaskUnfinished:int              = 915; // entity.shape
      public static const ID_Entity_SetTaskStatus:int                  = 916; // entity.shape
      
      //public static const ID_Entity_IsShapeEntity:int                  = 920; // entity.shape
      //public static const ID_Entity_IsJointEntity:int                  = 951; // entity.shape
      
      
      public static const ID_Entity_IsVisible:int                      = 980; // entity 
      public static const ID_Entity_SetVisible:int                     = 981; // entity 
      public static const ID_Entity_GetAlpha:int                       = 982; // entity 
      public static const ID_Entity_SetAlpha:int                       = 983; // entity 
      public static const ID_Entity_IsEnabled:int                      = 984; // entity 
      public static const ID_Entity_SetEnabled:int                     = 985; // entity 
      
      public static const ID_Entity_GetPosition:int                    = 1001; // entity 
      //public static const ID_Entity_SetPosition:int                    = 1002; // entity 
      //public static const ID_Entity_GetLocalPosition:int               = 1003; // entity 
      //public static const ID_Entity_SetLocalPosition:int             = 1004; // entity 
      public static const ID_Entity_GetRotationByRadians:int           = 1005; // entity 
      //public static const ID_Entity_SetRotationByRadians:int         = 1006; // entity 
      public static const ID_Entity_GetRotationByDegrees:int           = 1007; // entity 
      //public static const ID_Entity_SetRotationByDegrees:int         = 1008; // entity 
      public static const ID_Entity_WorldPoint2LocalPoint:int          = 1010; // entity 
      public static const ID_Entity_LocalPoint2WorldPoint:int          = 1011; // entity 
      
      public static const ID_Entity_IsDestroyed:int                    = 1049; // entity 
      public static const ID_Entity_Destroy:int                        = 1050; // entity 
      
      public static const ID_Entity_Overlapped:int                     = 1060; // entity 
      
   // game / entity / shape
      
      public static const ID_EntityShape_GetCIType:int            = 1100; // entity.shape
      public static const ID_EntityShape_SetCIType:int            = 1101; // entity.shape
      
      public static const ID_EntityShape_GetFilledColor:int            = 1110; // entity.shape
      public static const ID_EntityShape_SetFilledColor:int            = 1111; // entity.shape
      public static const ID_EntityShape_GetFilledColorRGB:int         = 1112; // entity.shape
      public static const ID_EntityShape_SetFilledColorRGB:int         = 1113; // entity.shape
      //public static const ID_EntityShape_GetFilledOpacity:int          = 1114; // entity.shape
      //public static const ID_EntityShape_SetFilledOpacity:int          = 1115; // entity.shape
      //public static const ID_EntityShape_IsShowBorder:int              = 1116; // entity.shape
      //public static const ID_EntityShape_SetShowBorder:int             = 1117; // entity.shape
      //public static const ID_EntityShape_GetBorderThickness:int        = 1118; // entity.shape
      //public static const ID_EntityShape_SetBorderThickness:int        = 1119; // entity.shape
      //public static const ID_EntityShape_GetBorderColor:int            = 1120; // entity.shape
      //public static const ID_EntityShape_SetBorderColor:int            = 1121; // entity.shape
      //public static const ID_EntityShape_GetBorderColorRGB:int         = 1122; // entity.shape
      //public static const ID_EntityShape_SetBorderColorRGB:int         = 1123; // entity.shape
      //public static const ID_EntityShape_GetBorderOpacity:int          = 1124; // entity.shape
      //public static const ID_EntityShape_SetBorderOpacity:int          = 1125; // entity.shape
      
      
      
      public static const ID_EntityShape_IsPhysicsEnabled:int          = 1150; // entity.shape physics
      //public static const ID_EntityShape_SetPhysicsEnabled:int       = 1151; // entity.shape physics
      public static const ID_EntityShape_GetCollisionCategory:int      = 1152; // entity.shape physics
      public static const ID_EntityShape_SetCollisionCategory:int      = 1153; // entity.shape physics
      //public static const ID_EntityShape_SetPhysicsEnabled:int       = 1154; // entity.shape physics
      public static const ID_EntityShape_IsStatic:int                  = 1155; // entity.shape physics
      public static const ID_EntityShape_SetStatic:int                 = 1156; // entity.shape physics
      public static const ID_EntityShape_IsSensor:int                  = 1157; // entity.shape physics
      public static const ID_EntityShape_SetAsSensor:int               = 1158; // entity.shape physics
      //public static const ID_EntityShape_IsBullet:int                  = 1159; // entity.shape physics
      //public static const ID_EntityShape_SetAsBullet:int               = 1160; // entity.shape physics
      public static const ID_EntityShape_IsSleeping:int                  = 1161; // entity.shape physics
      public static const ID_EntityShape_SetSleeping:int                 = 1162; // entity.shape physics
      
      //public static const ID_EntityShape_GetLocalCentroid:int          = 1070; // entity.shape physics
      //public static const ID_EntityShape_GetWorldCentroid:int          = 1071; // entity.shape physics
      //public static const ID_EntityShape_AutoSetMassInertia:int        = 1072; // entity.shape physics
      //public static const ID_EntityShape_GetMass:int                   = 1073; // entity.shape physics
      //public static const ID_EntityShape_SetMass:int                   = 1074; // entity.shape physics
      //public static const ID_EntityShape_GetInertia:int                = 1075; // entity.shape physics
      //public static const ID_EntityShape_SetInertia:int                = 1076; // entity.shape physics
      //public static const ID_EntityShape_GetDensity:int                = 1077; // entity.shape physics
      //public static const ID_EntityShape_SetDensity:int                = 1078; // entity.shape physics
      //public static const ID_EntityShape_GetFriction:int               = 1079; // entity.shape physics
      //public static const ID_EntityShape_SetFriction:int               = 1080; // entity.shape physics
      //public static const ID_EntityShape_GetRestitution:int            = 1081; // entity.shape physics
      //public static const ID_EntityShape_SetRestitution:int            = 1082; // entity.shape physics
      
      //public static const ID_EntityShape_GetLinearVelocity:int                          = 1100; // entity.shape physics
      //public static const ID_EntityShape_SetLinearVelocity:int                          = 1101; // entity.shape physics
      //public static const ID_EntityShape_GetAngularVelocity:int                         = 1102; // entity.shape physics
      //public static const ID_EntityShape_SetAngularVelocity:int                         = 1103; // entity.shape physics
      
      public static const ID_EntityShape_ApplyStepForce:int                                   = 1104; // entity.shape physics
      public static const ID_EntityShape_ApplyStepForceAtLocalPoint:int                       = 1105; // entity.shape physics
      public static const ID_EntityShape_ApplyStepForceAtWorldPoint:int                       = 1106; // entity.shape physics
      public static const ID_EntityShape_ApplyStepTorque:int                                  = 1107; // entity.shape physics
      
      //public static const ID_EntityShape_ApplyStepForce:int                             = 1104; // entity.shape physics
      //public static const ID_EntityShape_ApplyStepForceAtPoint:int                      = 1105; // entity.shape physics
      //public static const ID_EntityShape_ApplyStepForceAtLocalPoint:int                 = 1106; // entity.shape physics
      //public static const ID_EntityShape_ApplyStepLocalForce:int                        = 1107; // entity.shape physics
      //public static const ID_EntityShape_ApplyStepLocalForceAtPoint:int                 = 1108; // entity.shape physics
      //public static const ID_EntityShape_ApplyStepLocalForceAtLocalPoint:int            = 1109; // entity.shape physics
      
      //public static const ID_EntityShape_ApplyPermanentForce:int                        = 1110; // entity.shape physics
      //public static const ID_EntityShape_ApplyPermanentForceAtPoint:int                 = 1111; // entity.shape physics
      //public static const ID_EntityShape_ApplyPermanentForceAtLocalPoint:int            = 1112; // entity.shape physics
      //public static const ID_EntityShape_ApplyPermanentLocalForce:int                   = 1113; // entity.shape physics
      //public static const ID_EntityShape_ApplyPermanentLocalForceAtPoint:int            = 1114; // entity.shape physics
      //public static const ID_EntityShape_ApplyPermanentLocalForceAtLocalPoint:int       = 1115; // entity.shape physics
      
      //public static const ID_EntityShape_ApplyPermanentTorque:int                       = 1117; // entity.shape physics
      //impulse and angular impulse
      
      
      
      public static const ID_EntityShape_Teleport:int                         = 1252;
      public static const ID_EntityShape_TeleportOffsets:int                  = 1253;
      //public static const ID_EntityShape_Clone:int                          = 1255;
      
      public static const ID_EntityShape_Detach:int                         = 1260;
      public static const ID_EntityShape_AttachWith:int                     = 1261;
      public static const ID_EntityShape_DetachThenAttachWith:int           = 1262;
      public static const ID_EntityShape_BreakupBrothers:int                = 1263;
      
      public static const ID_EntityShape_BreakAllJoints:int                 = 1280;
      
   // game / shape / is a 
      
      public static const ID_Entity_IsCircleShapeEntity:int            = 1400; // entity.shape
      public static const ID_Entity_IsRectangleShapeEntity:int         = 1401; // entity.shape
      public static const ID_Entity_IsPolygonShapeEntity:int           = 1402; // entity.shape
      public static const ID_Entity_IsPolylineShapeEntity:int          = 1403; // entity.shape
      public static const ID_Entity_IsBombShapeEntitiy:int             = 1404; // entity.shape
      public static const ID_Entity_IsWorldBorderShapeEntitiy:int      = 1405; // entity.shape

      
   // game / entity / shape / text
      
      public static const ID_EntityText_GetText:int                   = 1550; // entity.text
      public static const ID_EntityText_SetText:int                   = 1551; // entity.text
      public static const ID_EntityText_AppendText:int                = 1552; // entity.text
      public static const ID_EntityText_AppendNewLine:int             = 1553; // entity.text
      
   // game / entity / joint
      
      // from 2000
      
      public static const ID_EntityJoint_GetHingeLimitsByDegrees:int                   = 2000; // joint.hinge
      //public static const ID_EntityJoint_GetHingeLimitsByRadians:int                   = 2001; // joint.hinge
      public static const ID_EntityJoint_SetHingeLimitsByDegrees:int                       = 2004; // joint.hinge
      //public static const ID_EntityJoint_SetHingeAngleLimitsByRadians:int                              = 2005; // joint.hinge
      public static const ID_EntityJoint_GetHingeMotorSpeed:int                      = 2006; // joint.slider
      public static const ID_EntityJoint_SetHingeMotorSpeed:int                      = 2007; // joint.slider
      
      public static const ID_EntityJoint_GetSliderLimits:int                      = 2030; // joint.slider
      public static const ID_EntityJoint_GetSliderMotorSpeed:int                  = 2031; // joint.slider
      public static const ID_EntityJoint_SetSliderLimits:int                      = 2032; // joint.slider
      public static const ID_EntityJoint_SetSliderMotorSpeed:int                  = 2033; // joint.slider
      
   // game / entity / field
      
      // from 2200
      
   // game / entity / event handler
      
      //public static const ID_EntityTrigger_GetTimerTicks:int                       = 2500; // trigger.timer
      public static const ID_EntityTrigger_ResetTimer:int                          = 2501; // trigger.timer
      //public static const ID_EntityTrigger_IsTimerPaused:int                       = 2502; // trigger.timer
      public static const ID_EntityTrigger_SetTimerPaused:int                      = 2503; // trigger.timer
      //public static const ID_EntityTrigger_GetTimerInterval:int                    = 2504; // trigger.timer
      //public static const ID_EntityTrigger_SetTimerInterval:int                    = 2505; // trigger.timer
      
   //=============================================================
      
      public static const NumPlayerFunctions:int = 4096;
   }
}
