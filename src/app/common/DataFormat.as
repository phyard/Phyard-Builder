
package common {
   
   import flash.utils.ByteArray;
   import flash.geom.Point;
   
   import editor.world.World;
   
   import editor.entity.Entity;
   
   import editor.entity.EntityShape
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapePolygon;
   import editor.entity.EntityShapePolyline;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityShapeTextButton;
   import editor.entity.EntityShapeGravityController;
   
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointSpring;
   import editor.entity.EntityJointWeld;
   import editor.entity.EntityJointDummy;
   
   import editor.entity.SubEntityJointAnchor;
   
   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   
   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityAction;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   
   import editor.runtime.Runtime;
   
   import common.trigger.CoreEventIds;
   
   public class DataFormat
   {
      
      
      
//===========================================================================
//   
//===========================================================================
      
      // create a world define from a editor world.
      // the created word define can be used to create either a player world or a editor world
      
      public static function EditorWorld2WorldDefine (editorWorld:World):WorldDefine
      {
         if (editorWorld == null)
            return null;
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // basic
         {
            worldDefine.mVersion = Config.VersionNumber;
            
            worldDefine.mAuthorName = editorWorld.GetAuthorName ();
            worldDefine.mAuthorHomepage = editorWorld.GetAuthorHomepage ();
            
            //>>from v1.02
            worldDefine.mShareSourceCode = editorWorld.IsShareSourceCode ();
            worldDefine.mPermitPublishing = editorWorld.IsPermitPublishing ();
            //<<
         }
         
         // settings
         {
            //>>from v1.04
            worldDefine.mSettings.mCameraCenterX = editorWorld.GetCameraCenterX ();
            worldDefine.mSettings.mCameraCenterY = editorWorld.GetCameraCenterY ();
            worldDefine.mSettings.mWorldLeft = editorWorld.GetWorldLeft ();
            worldDefine.mSettings.mWorldTop = editorWorld.GetWorldTop ();
            worldDefine.mSettings.mWorldWidth = editorWorld.GetWorldWidth ();
            worldDefine.mSettings.mWorldHeight = editorWorld.GetWorldHeight ();
            worldDefine.mSettings.mBackgroundColor = editorWorld.GetBackgroundColor ();
            worldDefine.mSettings.mBuildBorder = editorWorld.IsBuildBorder ();
            worldDefine.mSettings.mBorderColor = editorWorld.GetBorderColor ();
            //<<
            
            //>>added from v1.06
            //>>removed from v1.08
            editorWorld.StatisticsPhysicsShapes ();
            worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = editorWorld.GetPhysicsShapesPotentialMaxCount ();
            worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = editorWorld.GetPhysicsShapesPopulationDensityLevel ();
            //<<
            //<<
            
            //>>from v1.08
            worldDefine.mSettings.mIsInfiniteWorldSize = editorWorld.IsInfiniteSceneSize ();
            
            worldDefine.mSettings.mBorderAtTopLayer = editorWorld.IsBorderAtTopLayer ();
            worldDefine.mSettings.mWorldBorderLeftThickness = editorWorld.GetWorldBorderLeftThickness ();
            worldDefine.mSettings.mWorldBorderTopThickness = editorWorld.GetWorldBorderTopThickness ();
            worldDefine.mSettings.mWorldBorderRightThickness = editorWorld.GetWorldBorderRightThickness ();
            worldDefine.mSettings.mWorldBorderBottomThickness = editorWorld.GetWorldBorderBottomThickness ();
            
            worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = editorWorld.GetDefaultGravityAccelerationMagnitude ();
            worldDefine.mSettings.mDefaultGravityAccelerationAngle     = editorWorld.GetDefaultGravityAccelerationAngle ();
            
            worldDefine.mSettings.mRightHandCoordinates   = editorWorld.GetCoordinateSystem ().IsRightHand ();
            worldDefine.mSettings.mCoordinatesOriginX     = editorWorld.GetCoordinateSystem ().GetOriginX ();
            worldDefine.mSettings.mCoordinatesOriginY     = editorWorld.GetCoordinateSystem ().GetOriginY ();
            worldDefine.mSettings.mCoordinatesScale       = editorWorld.GetCoordinateSystem ().GetScale ();
            
            worldDefine.mSettings.mIsCiRulesEnabled = editorWorld.IsCiRulesEnabled ();
            //<<
         }
         
         var numEntities:int = editorWorld.GetNumEntities ();
         var appearId:int;
         var createId:int;
         var editorEntity:Entity;
         //var arraySortedByCreationId:Array = new Array ();
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            editorEntity = editorWorld.GetEntityByCreationId (createId);
            
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = Define.EntityType_Unkonwn; // default
            
            entityDefine.mPosX = editorEntity.GetPositionX ();
            entityDefine.mPosY = editorEntity.GetPositionY ();
            entityDefine.mRotation = editorEntity.GetRotation ();
            entityDefine.mIsVisible = editorEntity.IsVisible ();
            
            //>>from v1.08
            entityDefine.mAlpha = editorEntity.GetAlpha ();
            entityDefine.mIsEnabled = editorEntity.IsEnabled ();
            //<<
            
            if (editorEntity is editor.entity.EntityUtility)
            {
               //>>from v1.05
                if (editorEntity is editor.entity.EntityUtilityCamera)
               {
                  entityDefine.mEntityType = Define.EntityType_UtilityCamera;
                  
                  var camera:editor.entity.EntityUtilityCamera = editorEntity as editor.entity.EntityUtilityCamera;
                  
                  //>>from v.108
                  entityDefine.mFollowedTarget = camera.GetFollowedTarget ();
                  entityDefine.mFollowingStyle = camera.GetFollowingStyle ();
                  //<<
               }
               //<<
            }
            else if (editorEntity is editor.trigger.entity.EntityLogic) // from v1.07
            {
               var entityIndexArray:Array;
               
               if (editorEntity is editor.trigger.entity.EntityBasicCondition)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicCondition;
                  
                  var basicCondition:editor.trigger.entity.EntityBasicCondition = editorEntity as editor.trigger.entity.EntityBasicCondition;
                  
                  entityDefine.mCodeSnippetDefine = TriggerFormatHelper.CodeSnippet2CodeSnippetDefine (editorWorld, basicCondition.GetCodeSnippet ());
               }
               else if (editorEntity is editor.trigger.entity.EntityTask)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicTask;
                  
                  var task:editor.trigger.entity.EntityTask = editorEntity as editor.trigger.entity.EntityTask;
                  entityIndexArray = editorWorld.EntitiyArray2EntityCreationIdArray (task.GetEntityAssigners ());
                  
                  entityDefine.mInputAssignerCreationIds = entityIndexArray;
               }
               else if (editorEntity is editor.trigger.entity.EntityConditionDoor)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicConditionDoor;
                  
                  var conditionDoor:editor.trigger.entity.EntityConditionDoor = editorEntity as editor.trigger.entity.EntityConditionDoor;
                  
                  entityDefine.mIsAnd = conditionDoor.IsAnd ();
                  entityDefine.mIsNot = conditionDoor.IsNot ();
                  TriggerFormatHelper.ConditionAndTargetValueArray2EntityDefineProperties (editorWorld, conditionDoor.GetInputConditions (), entityDefine);
               }
               else if (editorEntity is editor.trigger.entity.EntityInputEntityAssigner)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityAssigner;
                  
                  var entityAssigner:editor.trigger.entity.EntityInputEntityAssigner = editorEntity as editor.trigger.entity.EntityInputEntityAssigner;
                  entityIndexArray = editorWorld.EntitiyArray2EntityCreationIdArray (entityAssigner.GetInputEntities ());
                  
                  entityDefine.mSelectorType = entityAssigner.GetSelectorType ();
                  entityDefine.mNumEntities = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds = entityIndexArray;
               }
               else if (editorEntity is editor.trigger.entity.EntityInputEntityPairAssigner)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityPairAssigner;
                  
                  var pairAssigner:editor.trigger.entity.EntityInputEntityPairAssigner = editorEntity as editor.trigger.entity.EntityInputEntityPairAssigner;
                  
                  entityDefine.mPairingType = pairAssigner.GetPairingType ();
                  
                  var pairEntities:Array = pairAssigner.GetInputPairEntities ();
                  entityIndexArray = editorWorld.EntitiyArray2EntityCreationIdArray (pairEntities [0]);
                  
                  entityDefine.mNumEntities1 = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds1 = entityIndexArray;
                  
                  entityIndexArray = editorWorld.EntitiyArray2EntityCreationIdArray (pairEntities [1]);
                  
                  entityDefine.mNumEntities2 = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds2 = entityIndexArray;
               }
               else if (editorEntity is editor.trigger.entity.EntityEventHandler)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicEventHandler;
                  
                  var eventHandler:editor.trigger.entity.EntityEventHandler = editorEntity as editor.trigger.entity.EntityEventHandler;
                  entityIndexArray = editorWorld.EntitiyArray2EntityCreationIdArray (eventHandler.GetEntityAssigners ());
                  
                  entityDefine.mEventId = eventHandler.GetEventId ();
                  
                  entityDefine.mInputConditionEntityCreationId = editorWorld.GetEntityCreationId (eventHandler.GetInputConditionEntity () as Entity);
                  entityDefine.mInputConditionTargetValue = eventHandler.GetInputConditionTargetValue ();
                  
                  entityDefine.mInputAssignerCreationIds = entityIndexArray;
                  
                  //>>v1.08
                  entityDefine.mExternalActionEntityCreationId = editorWorld.GetEntityCreationId (eventHandler.GetExternalAction ());
                  
                  if (editorEntity is editor.trigger.entity.EntityEventHandler_Timer)
                  {
                     var timerEventHandler:EntityEventHandler_Timer = eventHandler as EntityEventHandler_Timer;
                     
                     entityDefine.mRunningInterval = timerEventHandler.GetRunningInterval ();
                     entityDefine.mOnlyRunOnce = timerEventHandler.IsOnlyRunOnce ();
                  }
                  else if (editorEntity is editor.trigger.entity.EntityEventHandler_Keyboard)
                  {
                     var keyboardEventHandler:EntityEventHandler_Keyboard = eventHandler as EntityEventHandler_Keyboard;
                     
                     entityDefine.mKeyCodes = keyboardEventHandler.GetKeyCodes ();
                  }
                  else if (editorEntity is editor.trigger.entity.EntityEventHandler_Mouse)
                  {
                     var mouseEventHandler:EntityEventHandler_Mouse = eventHandler as EntityEventHandler_Mouse;
                  }
                  else if (editorEntity is editor.trigger.entity.EntityEventHandler_Contact)
                  {
                     var contactEventHandler:EntityEventHandler_Contact = eventHandler as EntityEventHandler_Contact;
                  }
                  //<<
                  
                  entityDefine.mCodeSnippetDefine = TriggerFormatHelper.CodeSnippet2CodeSnippetDefine (editorWorld, eventHandler.GetCodeSnippet ());
               }
               else if (editorEntity is editor.trigger.entity.EntityAction)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicAction;
                  
                  var action:editor.trigger.entity.EntityAction = editorEntity as editor.trigger.entity.EntityAction;
                  
                  entityDefine.mCodeSnippetDefine = TriggerFormatHelper.CodeSnippet2CodeSnippetDefine (editorWorld, action.GetCodeSnippet ());
               }
            }
            else if (editorEntity is editor.entity.EntityShape)
            {
               var shape:editor.entity.EntityShape = editorEntity as editor.entity.EntityShape;
               
               //>>from v1.02
               entityDefine.mDrawBorder = shape.IsDrawBorder ();
               entityDefine.mDrawBackground = shape.IsDrawBackground ();
               //<<
               
               //>>from v1.04
               entityDefine.mBorderColor = shape.GetBorderColor ();
               entityDefine.mBorderThickness = shape.GetBorderThickness ();
               entityDefine.mBackgroundColor =shape.GetFilledColor ();
               entityDefine.mTransparency = shape.GetTransparency ();
               //<<
               
               //>>from v1.05
               entityDefine.mBorderTransparency = shape.GetBorderTransparency ();
               //<<
               
               if (shape.IsBasicShapeEntity ())
               {
                  //>> move up from v1.04
                  entityDefine.mAiType = shape.GetAiType ();
                  //<<
                  
                  //>>from v1.04
                  entityDefine.mIsPhysicsEnabled = shape.IsPhysicsEnabled ();
                  /////entityDefine.mIsSensor = shape.mIsSensor; // move down from v1.05
                  //<<
                  
                  //if (entityDefine.mIsPhysicsEnabled)  // always true before v1.04
                  {
                     //>>from v1.02
                     entityDefine.mCollisionCategoryIndex = shape.GetCollisionCategoryIndex ();
                     //<<
                     
                     //>> removed here, move up from v1.04
                     /////entityDefine.mAiType = Define.GetShapeAiType ( shape.GetFilledColor ()); // move up from v1.04
                     //<<
                     
                     entityDefine.mIsStatic = shape.IsStatic ();
                     entityDefine.mIsBullet = shape.mIsBullet;
                     entityDefine.mDensity = shape.mDensity;
                     entityDefine.mFriction = shape.mFriction;
                     entityDefine.mRestitution = shape.mRestitution;
                     
                     // add in v1,04, move here from above since v1.05
                     entityDefine.mIsSensor = shape.mIsSensor;
                     
                     //>>from v1.05
                     entityDefine.mIsHollow = shape.IsHollow ();
                     //<<
                     
                     //>>from v1.08
                     entityDefine.mBuildBorder = shape.IsBuildBorder ();
                     entityDefine.mIsSleepingAllowed = shape.IsAllowSleeping ();
                     entityDefine.mIsRotationFixed = shape.IsFixRotation ();
                     entityDefine.mLinearVelocityMagnitude = shape.GetLinearVelocityMagnitude ();
                     entityDefine.mLinearVelocityAngle = shape.GetLinearVelocityAngle ();
                     entityDefine.mAngularVelocity = shape.GetAngularVelocity ();
                     //<<
                  }
                  
                  if (editorEntity is editor.entity.EntityShapeCircle)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeCircle;
                     
                     entityDefine.mRadius = (shape as editor.entity.EntityShapeCircle).GetRadius ();
                     
                     entityDefine.mAppearanceType = (shape as editor.entity.EntityShapeCircle).GetAppearanceType ();
                  }
                  else if (editorEntity is editor.entity.EntityShapeRectangle)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeRectangle;
                     
                     entityDefine.mHalfWidth = (shape as editor.entity.EntityShapeRectangle).GetHalfWidth ();
                     entityDefine.mHalfHeight = (shape as editor.entity.EntityShapeRectangle).GetHalfHeight ();
                     
                     //from v1.08
                     entityDefine.mIsRoundCorners = (shape as EntityShapeRectangle).IsRoundCorners ();
                     //<<
                  }
                  //>>from v1.04
                  else if (editorEntity is editor.entity.EntityShapePolygon)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapePolygon;
                     
                     entityDefine.mLocalPoints = (shape as editor.entity.EntityShapePolygon).GetLocalVertexPoints ();
                  }
                  //<<
                  //>>from v1.05
                  else if (editorEntity is editor.entity.EntityShapePolyline)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapePolyline;
                     
                     entityDefine.mCurveThickness = (shape as editor.entity.EntityShapePolyline).GetCurveThickness ();
                     
                     //>> from v1.08
                     entityDefine.mIsRoundEnds = (shape as editor.entity.EntityShapePolyline).IsRoundEnds ();
                     //<<
                     
                     entityDefine.mLocalPoints = (shape as editor.entity.EntityShapePolyline).GetLocalVertexPoints ();
                  }
                  //<<
               }
               else // not physics entity
               {
                  //>>from v1.02
                  if (editorEntity is editor.entity.EntityShapeText)
                  {
                     entityDefine.mText = (shape as EntityShapeText).GetText ();
                     
                     entityDefine.mHalfWidth = (shape as editor.entity.EntityShapeRectangle).GetHalfWidth ();
                     entityDefine.mHalfHeight = (shape as editor.entity.EntityShapeRectangle).GetHalfHeight ();
                     
                     entityDefine.mWordWrap = (shape as EntityShapeText).IsWordWrap ();
                     
                     //from v1.08
                     entityDefine.mAdaptiveBackgroundSize = (shape as EntityShapeText).IsAdaptiveBackgroundSize ();
                     entityDefine.mTextColor = (shape as EntityShapeText).GetTextColor ();
                     entityDefine.mFontSize = (shape as EntityShapeText).GetFontSize ();
                     entityDefine.mIsBold = (shape as EntityShapeText).IsBold ();
                     entityDefine.mIsItalic = (shape as EntityShapeText).IsItalic ();
                     //<<
                     
                     //from v1.09
                     entityDefine.mTextAlign = (shape as EntityShapeText).GetTextAlign ();
                     entityDefine.mIsUnderlined = (shape as EntityShapeText).IsUnderlined ();
                     //<<
                     
                     // from v1.08
                     if (editorEntity is EntityShapeTextButton) 
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeTextButton;
                        
                        entityDefine.mUsingHandCursor = (shape as EntityShapeTextButton).UsingHandCursor ();
                        
                        var mouseOverShape:EntityShape = (shape as EntityShapeTextButton).GetMouseOverShape ();
                        
                        entityDefine.mDrawBackground_MouseOver = mouseOverShape.IsDrawBackground ();
                        entityDefine.mBackgroundColor_MouseOver = mouseOverShape.GetFilledColor ();
                        entityDefine.mBackgroundTransparency_MouseOver = mouseOverShape.GetTransparency ();
                        
                        entityDefine.mDrawBorder_MouseOver = mouseOverShape.IsDrawBorder ();
                        entityDefine.mBorderColor_MouseOver = mouseOverShape.GetBorderColor ();
                        entityDefine.mBorderThickness_MouseOver = mouseOverShape.GetBorderThickness ();
                        entityDefine.mBorderTransparency_MouseOver = mouseOverShape.GetBorderTransparency ();
                     }
                     //<<
                     else
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeText;
                     }
                  }
                  else if (editorEntity is editor.entity.EntityShapeGravityController)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeGravityController;
                     
                     entityDefine.mRadius = (shape as editor.entity.EntityShapeCircle).GetRadius ();
                     
                     // removed from v1.05
                     /////entityDefine.mIsInteractive = (shape as editor.entity.EntityShapeGravityController).IsInteractive ();
                     
                     // added in v1,05
                     entityDefine.mInteractiveZones = (shape as editor.entity.EntityShapeGravityController).GetInteractiveZones ();
                     entityDefine.mInteractiveConditions = (shape as editor.entity.EntityShapeGravityController).mInteractiveConditions;
                     
                     // ...
                     entityDefine.mInitialGravityAcceleration = (shape as editor.entity.EntityShapeGravityController).GetInitialGravityAcceleration ();
                     entityDefine.mInitialGravityAngle = (shape as editor.entity.EntityShapeGravityController).GetInitialGravityAngle ();
                     
                     //>> from v1,08
                     entityDefine.mMaximalGravityAcceleration = (shape as editor.entity.EntityShapeGravityController).GetMaximalGravityAcceleration ();
                     //<<
                  }
                  //<<
               }
            }
            else if (editorEntity is editor.entity.EntityJoint)
            {
               var joint:editor.entity.EntityJoint = (editorEntity as editor.entity.EntityJoint);
               
               entityDefine.mCollideConnected = joint.mCollideConnected;
               
               //>>from v1.02
               entityDefine.mConnectedShape1Index = joint.GetConnectedShape1Index ();
               entityDefine.mConnectedShape2Index = joint.GetConnectedShape2Index ();
               //<<
               
               //>>from v1.08
               entityDefine.mBreakable = joint.IsBreakable ();
               //<<
               
               if (editorEntity is editor.entity.EntityJointHinge)
               {
                  var hinge:editor.entity.EntityJointHinge = editorEntity as editor.entity.EntityJointHinge;
                  
                  entityDefine.mEntityType = Define.EntityType_JointHinge;
                  entityDefine.mAnchorEntityIndex = editorWorld.GetEntityCreationId ( hinge.GetAnchor () );
                  
                  entityDefine.mEnableLimits = hinge.IsLimitsEnabled ();
                  entityDefine.mLowerAngle = hinge.GetLowerLimit ();
                  entityDefine.mUpperAngle = hinge.GetUpperLimit ();
                  entityDefine.mEnableMotor = hinge.mEnableMotor;
                  entityDefine.mMotorSpeed = hinge.mMotorSpeed;
                  entityDefine.mBackAndForth = hinge.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorTorque = hinge.GetMaxMotorTorque ();
                  //<<
               }
               else if (editorEntity is editor.entity.EntityJointSlider)
               {
                  var slider:editor.entity.EntityJointSlider = editorEntity as editor.entity.EntityJointSlider;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSlider;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( slider.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( slider.GetAnchor2 () );
                  
                  entityDefine.mEnableLimits = slider.IsLimitsEnabled ();
                  entityDefine.mLowerTranslation = slider.GetLowerLimit ();
                  entityDefine.mUpperTranslation = slider.GetUpperLimit ();
                  entityDefine.mEnableMotor = slider.mEnableMotor;
                  entityDefine.mMotorSpeed = slider.mMotorSpeed;
                  entityDefine.mBackAndForth = slider.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorForce = slider.GetMaxMotorForce ();
                  //<<
               }
               else if (editorEntity is editor.entity.EntityJointDistance)
               {
                  var distanceJoint:editor.entity.EntityJointDistance = editorEntity as editor.entity.EntityJointDistance;
                  
                  entityDefine.mEntityType = Define.EntityType_JointDistance;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( distanceJoint.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( distanceJoint.GetAnchor2 () );
                  
                  //>>from v1.08
                  entityDefine.mBreakDeltaLength = distanceJoint.GetBreakDeltaLength ();
                  //<<
               }
               else if (editorEntity is editor.entity.EntityJointSpring)
               {
                  var spring:editor.entity.EntityJointSpring = editorEntity as editor.entity.EntityJointSpring;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSpring;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( spring.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( spring.GetAnchor2 () );
                  
                  entityDefine.mStaticLengthRatio = spring.GetStaticLengthRatio ();
                  //entityDefine.mFrequencyHz = spring.GetFrequencyHz ();
                  entityDefine.mSpringType = spring.GetSpringType ();
                  entityDefine.mDampingRatio = spring.mDampingRatio;
                  
                  //>>from v1.08
                  entityDefine.mFrequencyDeterminedManner = spring.GetFrequencyDeterminedManner ();
                  entityDefine.mFrequency = spring.GetFrequency ();
                  entityDefine.mSpringConstant = spring.GetSpringConstant ();
                  entityDefine.mBreakExtendedLength = spring.GetBreakExtendedLength ();
                  //<<
               }
               else if (editorEntity is editor.entity.EntityJointWeld)
               {
                  var weld:editor.entity.EntityJointWeld = editorEntity as editor.entity.EntityJointWeld;
                  
                  entityDefine.mEntityType = Define.EntityType_JointWeld;
                  entityDefine.mAnchorEntityIndex = editorWorld.GetEntityCreationId ( weld.GetAnchor () );
               }
               else if (editorEntity is editor.entity.EntityJointDummy)
               {
                  var dummy:editor.entity.EntityJointDummy = editorEntity as editor.entity.EntityJointDummy;
                  
                  entityDefine.mEntityType = Define.EntityType_JointDummy;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( dummy.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( dummy.GetAnchor2 () );
               }
               
               if (joint != null)
               {
                  joint.UpdateJointPosition ();
               }
            }
            else if (editorEntity is editor.entity.SubEntityJointAnchor)
            {
               entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            
            worldDefine.mEntityDefines.push (entityDefine);
            
            //arraySortedByCreationId.push ({entity:editorEntity, creationId:editorEntity.GetCreationOrderId ()});
         }
         
         // 
         //arraySortedByCreationId.sortOn ("creationId", Array.NUMERIC);
         //for (var arrayIndex:int = 0; arrayIndex < arraySortedByCreationId.length; ++ arrayIndex)
         //{
         //   editorEntity = arraySortedByCreationId [arrayIndex].entity;
         //   worldDefine.mEntityAppearanceOrder.push (editorEntity.GetEntityIndex ());
         //}
         
         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
            editorEntity = editorWorld.GetEntityByAppearanceId (appearId);
            worldDefine.mEntityAppearanceOrder.push (editorEntity.GetCreationOrderId ());
         }
         
         // 
         var brotherGroupArray:Array = editorWorld.GetBrotherGroups ();
         var groupId:int;
         var brotherId:int;
         var brotherGroup:Array;
         
         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;
            
            if (brotherGroup == null)
            {
               trace ("brotherGroup == null");
               continue;
            }
            if (brotherGroup.length  < 2)
            {
               trace ("brotherGroup.length  < 2");
               continue;
            }
            
            var brotherIDs:Array = new Array (brotherGroup.length);
            for (brotherId = 0; brotherId < brotherGroup.length; ++ brotherId)
            {
               editorEntity = brotherGroup [brotherId] as editor.entity.Entity;
               brotherIDs [brotherId] = editorWorld.GetEntityCreationId (editorEntity);
            }
            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         //>>fromv1.02
         // collision category
         {
            var numCats:int = editorWorld.GetNumCollisionCategories ();
            
            for (var ccId:int = 0; ccId < numCats; ++ ccId)
            {
               var collisionCategory:editor.entity.EntityCollisionCategory = editorWorld.GetCollisionCategoryByIndex (ccId);
               
               var ccDefine:Object = new Object ();
               
               ccDefine.mName = collisionCategory.GetCategoryName ();
               ccDefine.mCollideInternally = collisionCategory.IsCollideInternally ();
               ccDefine.mPosX = collisionCategory.GetPositionX ();
               ccDefine.mPosY = collisionCategory.GetPositionY ();
               
               worldDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            worldDefine.mDefaultCollisionCategoryIndex = editorWorld.GetCollisionCategoryIndex (editorWorld.GetDefaultCollisionCategory ());
            
            var ccFriendPairs:Array = editorWorld.GetCollisionCategoryFriendPairs ();
            for (var pairId:int = 0; pairId < ccFriendPairs.length; ++ pairId)
            {
               var friendPair:Object = ccFriendPairs [pairId];
               
               var pairDefine:Object = new Object ();
               
               pairDefine.mCollisionCategory1Index = editorWorld.GetCollisionCategoryIndex (friendPair.mCategory1);
               pairDefine.mCollisionCategory2Index = editorWorld.GetCollisionCategoryIndex (friendPair.mCategory2);
               
               worldDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         //<<
         
         return worldDefine;
      }
      
      public static function WorldDefine2EditorWorld (worldDefine:WorldDefine, adjustPrecisionsInWorldDefine:Boolean = true, editorWorld:editor.world.World = null):editor.world.World
      {
         if (worldDefine == null)
            return editorWorld;
            
         // from v1,03
         DataFormat2.FillMissedFieldsInWorldDefine (worldDefine);
         if (adjustPrecisionsInWorldDefine)
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         
         //
         if (editorWorld == null)
         {
            editorWorld = new editor.world.World ();
            
            // basic
            {
               editorWorld.SetAuthorName (worldDefine.mAuthorName);
               editorWorld.SetAuthorHomepage (worldDefine.mAuthorHomepage);
               
               editorWorld.SetShareSourceCode (worldDefine.mShareSourceCode);
               editorWorld.SetPermitPublishing (worldDefine.mPermitPublishing);
            }
            
            // settings
            {
               //>> from v1.04
               editorWorld.SetCameraCenterX (worldDefine.mSettings.mCameraCenterX);
               editorWorld.SetCameraCenterY (worldDefine.mSettings.mCameraCenterY);
               editorWorld.SetWorldLeft (worldDefine.mSettings.mWorldLeft);
               editorWorld.SetWorldTop (worldDefine.mSettings.mWorldTop);
               editorWorld.SetWorldWidth (worldDefine.mSettings.mWorldWidth);
               editorWorld.SetWorldHeight (worldDefine.mSettings.mWorldHeight);
               editorWorld.SetBackgroundColor (worldDefine.mSettings.mBackgroundColor);
               editorWorld.SetBuildBorder (worldDefine.mSettings.mBuildBorder);
               editorWorld.SetBorderColor (worldDefine.mSettings.mBorderColor);
               //<<
               
               
               //>> [v1.06, v1.08)
               //worldDefine.mSettings.mPhysicsShapesPotentialMaxCount;
               //worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel;
               //<<
               
               //>>from v1.08
               editorWorld.SetInfiniteSceneSize (worldDefine.mSettings.mIsInfiniteWorldSize);
               
               editorWorld.SetBorderAtTopLayer (worldDefine.mSettings.mBorderAtTopLayer);
               editorWorld.SetWorldBorderLeftThickness (worldDefine.mSettings.mWorldBorderLeftThickness);
               editorWorld.SetWorldBorderTopThickness (worldDefine.mSettings.mWorldBorderTopThickness);
               editorWorld.SetWorldBorderRightThickness (worldDefine.mSettings.mWorldBorderRightThickness);
               editorWorld.SetWorldBorderBottomThickness (worldDefine.mSettings.mWorldBorderBottomThickness);
               
               editorWorld.SetDefaultGravityAccelerationMagnitude (worldDefine.mSettings.mDefaultGravityAccelerationMagnitude);
               editorWorld.SetDefaultGravityAccelerationAngle (worldDefine.mSettings.mDefaultGravityAccelerationAngle);
               
               editorWorld.RebuildCoordinateSystem (
                     worldDefine.mSettings.mCoordinatesOriginX,
                     worldDefine.mSettings.mCoordinatesOriginY,
                     worldDefine.mSettings.mCoordinatesScale,
                     worldDefine.mSettings.mRightHandCoordinates
                  );
               
               editorWorld.SetCiRulesEnabled (worldDefine.mSettings.mIsCiRulesEnabled);
               //<<
            }
         }
         
         // collision category
         
         var beginningCollisionCategoryIndex:int = editorWorld.GetNumCollisionCategories ();
         
         if (worldDefine.mVersion >= 0x0102)
         {
            var collisionCategory:editor.entity.EntityCollisionCategory;
            
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               collisionCategory = editorWorld.CreateEntityCollisionCategory (ccDefine.mName);
               collisionCategory.SetCollideInternally (ccDefine.mCollideInternally);
               
               collisionCategory.SetPosition (ccDefine.mPosX, ccDefine.mPosY);
               
               collisionCategory.UpdateAppearance ();
               collisionCategory.UpdateSelectionProxy ();
            }
            
            collisionCategory = editorWorld.GetCollisionCategoryByIndex (worldDefine.mDefaultCollisionCategoryIndex);
            if (collisionCategory != null)
               collisionCategory.SetDefaultCategory (true);
            
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               //editorWorld.CreateEntityCollisionCategoryFriendLink (pairDefine.mCollisionCategory1Index, pairDefine.mCollisionCategory2Index);
               editorWorld.CreateEntityCollisionCategoryFriendLink (beginningCollisionCategoryIndex + pairDefine.mCollisionCategory1Index, 
                                                                    beginningCollisionCategoryIndex + pairDefine.mCollisionCategory2Index);
            }
         }
         
         // entities
         
         var beginningEntityIndex:int = editorWorld.GetNumEntities ();
         
         var appearId:int;
         var createId:int;
         var entityDefine:Object;
         var entity:Entity;
         var shape:EntityShape;
         var anchorDefine:Object;
         var joint:EntityJoint;
         var utility:EntityUtility;
         var logic:EntityLogic;
         
         var numEntities:int = worldDefine.mEntityDefines.length;
         
         editorWorld.SetCreationEntityArrayLocked (true);
         
         Runtime.mPauseCreateShapeProxy = true;
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = worldDefine.mEntityDefines [createId];
            
            entity = null;
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               utility = null;
               
               //>>from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  var camera:editor.entity.EntityUtilityCamera = editorWorld.CreateEntityUtilityCamera ();
                  
                  //>>from v.108
                  camera.SetFollowedTarget (entityDefine.mFollowedTarget);
                  camera.SetFollowingStyle (entityDefine.mFollowingStyle);
                  //<<
                  
                  entity = utility = camera;
               }
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               logic = null;
               
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  entity = logic = editorWorld.CreateEntityCondition ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  entity = logic = editorWorld.CreateEntityTask ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  entity = logic = editorWorld.CreateEntityConditionDoor ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  entity = logic = editorWorld.CreateEntityInputEntityAssigner ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  entity = logic = editorWorld.CreateEntityInputEntityPairAssigner ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        entity = logic = editorWorld.CreateEntityEventHandler_Timer (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        entity = logic = editorWorld.CreateEntityEventHandler_Keyboard (entityDefine.mEventId);
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
                        entity = logic = editorWorld.CreateEntityEventHandler_Mouse (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting:
                     case CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting:
                     case CoreEventIds.ID_OnTwoPhysicsShapesEndContacting:
                        entity = logic = editorWorld.CreateEntityEventHandler_Contact (entityDefine.mEventId);
                        break;
                     default:
                        entity = logic = editorWorld.CreateEntityEventHandler (entityDefine.mEventId);
                        break;
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  entity = logic = editorWorld.CreateEntityAction ();
               }
            }
            else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               shape = null;
               
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     var circle:editor.entity.EntityShapeCircle = editorWorld.CreateEntityShapeCircle ();
                     circle.SetAppearanceType (entityDefine.mAppearanceType);
                     circle.SetRadius (entityDefine.mRadius);
                     
                     entity = shape = circle;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     var rect:editor.entity.EntityShapeRectangle = editorWorld.CreateEntityShapeRectangle ();
                     rect.SetHalfWidth (entityDefine.mHalfWidth);
                     rect.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     //from v1.08
                     rect.SetRoundCorners (entityDefine.mIsRoundCorners);
                     //<<
                     
                     entity = shape = rect;
                  }
                  //>> from v1.04
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     var polygon:editor.entity.EntityShapePolygon = editorWorld.CreateEntityShapePolygon ();
                     
                     // commented off, do it in the 2nd round below
                     //   polygon.SetPosition (entityDefine.mPosX, entityDefine.mPosY); // the position and rotation are set again below, 
                     //   polygon.SetRotation (entityDefine.mRotation);                 // but the SetLocalVertexPoints needs position and rotation set before
                     //polygon.SetLocalVertexPoints (entityDefine.mLocalPoints);
                     
                     entity = shape = polygon;
                  }
                  //<<
                  //>>from v1.05
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     var polyline:editor.entity.EntityShapePolyline = editorWorld.CreateEntityShapePolyline ();
                     
                     polyline.SetCurveThickness (entityDefine.mCurveThickness);
                     
                     //>> from v1.08
                     polyline.SetRoundEnds (entityDefine.mIsRoundEnds);
                     //<<
                     
                     // commented off, do it in the 2nd round below
                     //   polyline.SetPosition (entityDefine.mPosX, entityDefine.mPosY); // the position and rotation are set again below, 
                     //   polyline.SetRotation (entityDefine.mRotation);                 // but the SetLocalVertexPoints needs position and rotation set before
                     //polyline.SetLocalVertexPoints (entityDefine.mLocalPoints);
                     
                     entity = shape = polyline;
                  }
                  //<<
                  
                  if (shape != null)
                  {
                     shape.SetAiType (entityDefine.mAiType);
                     
                     //>>from v1.04
                     shape.SetPhysicsEnabled (entityDefine.mIsPhysicsEnabled);
                     /////shape.mIsSensor = entityDefine.mIsSensor; // move down from v1.05
                     //<<
                     
                     if (entityDefine.mIsPhysicsEnabled) // always true before v1.04
                     {
                        //>>from v1.02
                        if (entityDefine.mCollisionCategoryIndex >= 0)
                           shape.SetCollisionCategoryIndex ( int(entityDefine.mCollisionCategoryIndex) + beginningCollisionCategoryIndex);
                        else
                           shape.SetCollisionCategoryIndex (entityDefine.mCollisionCategoryIndex);
                        //<<
                        
                        shape.SetStatic (entityDefine.mIsStatic);
                        shape.mIsBullet = entityDefine.mIsBullet;
                        shape.mDensity = entityDefine.mDensity;
                        shape.mFriction = entityDefine.mFriction;
                        shape.mRestitution = entityDefine.mRestitution;
                        
                        // add in v1,04, move here from above from v1.05
                        shape.mIsSensor = entityDefine.mIsSensor;
                        
                        //>>from v1.05
                        shape.SetHollow (entityDefine.mIsHollow);
                        //<<
                        
                        //>>from v1.08
                        shape.SetBuildBorder (entityDefine.mBuildBorder);
                        shape.SetAllowSleeping (entityDefine.mIsSleepingAllowed);
                        shape.SetFixRotation (entityDefine.mIsRotationFixed);
                        shape.SetLinearVelocityMagnitude (entityDefine.mLinearVelocityMagnitude);
                        shape.SetLinearVelocityAngle (entityDefine.mLinearVelocityAngle);
                        shape.SetAngularVelocity (entityDefine.mAngularVelocity);
                        //<<
                     }
                  }
               }
               else // not physics shape
               {
                  //>> v1.02
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText || entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                  {
                     var text:EntityShapeText;
                     
                     // from v1.08
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                     {
                        var textButton:EntityShapeTextButton = editorWorld.CreateEntityShapeTextButton ();
                        
                        textButton.SetUsingHandCursor (entityDefine.mUsingHandCursor);
                        
                        var mouseOverShape:EntityShape = textButton.GetMouseOverShape ();
                        
                        mouseOverShape.SetDrawBackground (entityDefine.mDrawBackground_MouseOver);
                        mouseOverShape.SetFilledColor (entityDefine.mBackgroundColor_MouseOver);
                        mouseOverShape.SetTransparency (entityDefine.mBackgroundTransparency_MouseOver);
                        
                        mouseOverShape.SetDrawBorder (entityDefine.mDrawBorder_MouseOver);
                        mouseOverShape.SetBorderColor (entityDefine.mBorderColor_MouseOver);
                        mouseOverShape.SetBorderThickness (entityDefine.mBorderThickness_MouseOver);
                        mouseOverShape.SetBorderTransparency (entityDefine.mBorderTransparency_MouseOver);
                        
                        text = textButton;
                     }
                     //<<
                     else
                     {
                        text = editorWorld.CreateEntityShapeText ();
                     }
                     
                     text.SetText (entityDefine.mText);
                     text.SetWordWrap (entityDefine.mWordWrap);
                     
                     //from v1.08
                     text.SetAdaptiveBackgroundSize (entityDefine.mAdaptiveBackgroundSize);
                     text.SetTextColor (entityDefine.mTextColor);
                     text.SetFontSize (entityDefine.mFontSize);
                     text.SetBold (entityDefine.mIsBold);
                     text.SetItalic (entityDefine.mIsItalic);
                     //<<
                     
                     //from v1.09
                     text.SetTextAlign (entityDefine.mTextAlign);
                     text.SetUnderlined (entityDefine.mIsUnderlined);
                     //<<
                     
                     text.SetHalfWidth (entityDefine.mHalfWidth);
                     text.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     entity = shape = text;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     var gController:editor.entity.EntityShapeGravityController = editorWorld.CreateEntityShapeGravityController ();
                     
                     gController.SetRadius (entityDefine.mRadius)
                     
                     // removed from v1.05
                     /////gController.SetInteractive (entityDefine.mIsInteractive)
                     
                     // added in v1.05
                     gController.SetInteractiveZones (entityDefine.mInteractiveZones);
                     gController.mInteractiveConditions = entityDefine.mInteractiveConditions
                     
                     // ...
                     gController.SetInitialGravityAcceleration (entityDefine.mInitialGravityAcceleration)
                     gController.SetInitialGravityAngle (entityDefine.mInitialGravityAngle)
                     
                     //>> from v1,08
                     gController.SetMaximalGravityAcceleration (entityDefine.mMaximalGravityAcceleration);
                     //<<
                     
                     entity = shape = gController;
                  }
                  //<<
               }
               
               if (shape != null)
               {
                  //>>v1.02
                  shape.SetDrawBorder (entityDefine.mDrawBorder);
                  shape.SetDrawBackground (entityDefine.mDrawBackground);
                  //<<
                  
                  //>>from v1.04
                  shape.SetBorderColor (entityDefine.mBorderColor);
                  shape.SetBorderThickness (entityDefine.mBorderThickness);
                  shape.SetFilledColor (entityDefine.mBackgroundColor);
                  shape.SetTransparency (entityDefine.mTransparency);
                  //<<
                  
                  //>>from v1.05
                  shape.SetBorderTransparency (entityDefine.mBorderTransparency);
                  //<<
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = null;
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  var hinge:editor.entity.EntityJointHinge = editorWorld.CreateEntityJointHinge ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchorEntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (hinge.GetAnchor ());
                  anchorDefine.mEntity = hinge.GetAnchor ();
                  
                  hinge.SetLimitsEnabled (entityDefine.mEnableLimits);
                  hinge.SetLimits (entityDefine.mLowerAngle, entityDefine.mUpperAngle);
                  hinge.mEnableMotor = entityDefine.mEnableMotor;
                  hinge.mMotorSpeed = entityDefine.mMotorSpeed;
                  hinge.mBackAndForth = entityDefine.mBackAndForth;
                  
                  //>>v1.04
                  hinge.SetMaxMotorTorque (entityDefine.mMaxMotorTorque);
                  //<<
                  
                  entity = joint = hinge;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  var slider:editor.entity.EntityJointSlider = editorWorld.CreateEntityJointSlider ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (slider.GetAnchor1 ());
                  anchorDefine.mEntity = slider.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (slider.GetAnchor2 ());
                  anchorDefine.mEntity = slider.GetAnchor2 ();
                  
                  slider.SetLimitsEnabled (entityDefine.mEnableLimits);
                  slider.SetLimits (entityDefine.mLowerTranslation, entityDefine.mUpperTranslation);
                  slider.mEnableMotor = entityDefine.mEnableMotor;
                  slider.mMotorSpeed = entityDefine.mMotorSpeed;
                  slider.mBackAndForth = entityDefine.mBackAndForth;
                  
                  //>>v1.04
                  slider.SetMaxMotorForce (entityDefine.mMaxMotorForce);
                  //<<
                  
                  entity = joint = slider;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  var distanceJoint:editor.entity.EntityJointDistance = editorWorld.CreateEntityJointDistance ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (distanceJoint.GetAnchor1 ());
                  anchorDefine.mEntity = distanceJoint.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (distanceJoint.GetAnchor2 ());
                  anchorDefine.mEntity = distanceJoint.GetAnchor2 ();
                  
                  //>>from v1.08
                  distanceJoint.SetBreakDeltaLength (entityDefine.mBreakDeltaLength);
                  //<<
                  
                  entity = joint = distanceJoint;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  var spring:editor.entity.EntityJointSpring = editorWorld.CreateEntityJointSpring ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor1 ());
                  anchorDefine.mEntity = spring.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor2 ());
                  anchorDefine.mEntity = spring.GetAnchor2 ();
                  
                  spring.SetStaticLengthRatio (entityDefine.mStaticLengthRatio);
                  //spring.SetFrequencyHz (entityDefine.mFrequencyHz);
                  spring.SetSpringType (entityDefine.mSpringType);
                  
                  spring.mDampingRatio = entityDefine.mDampingRatio;
                  
                  //>>from v1.08
                  spring.SetFrequencyDeterminedManner (entityDefine.mFrequencyDeterminedManner);
                  spring.SetFrequency (entityDefine.mFrequency);
                  spring.SetSpringConstant (entityDefine.mSpringConstant);
                  spring.SetBreakExtendedLength (entityDefine.mBreakExtendedLength);
                  //<<
                  
                  entity = joint = spring;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  var weld:editor.entity.EntityJointWeld = editorWorld.CreateEntityJointWeld ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchorEntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (hinge.GetAnchor ());
                  anchorDefine.mEntity = weld.GetAnchor ();
                  
                  entity = joint = weld;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  var dummy:editor.entity.EntityJointDummy = editorWorld.CreateEntityJointDummy ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor1 ());
                  anchorDefine.mEntity = spring.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor2 ());
                  anchorDefine.mEntity = spring.GetAnchor2 ();
                  
                  entity = joint = dummy;
               }
               
               if (joint != null)
               {
                  joint.mCollideConnected = entityDefine.mCollideConnected ;
                  
                  //>>from v1.08
                  joint.SetBreakable (entityDefine.mBreakable);
                  //<<
               }
            }
            else if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
            {
               //entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            else
            {
               //entityDefine.mEntityType = Define.EntityType_Unkonwn;
            }
            
            if (entity != null)
            {
               entityDefine.mEntity = entity;
               
               entity.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               //>>from v1.08
               entity.SetAlpha (entityDefine.mAlpha);
               entity.SetEnabled (entityDefine.mIsEnabled);
               //<<
            }
         }
         
         // remove entities then readd them by appearance id order
         //>>>
         while (editorWorld.numChildren > beginningEntityIndex)
            editorWorld.removeChildAt (beginningEntityIndex);
         
         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
            createId = worldDefine.mEntityAppearanceOrder [appearId];
            entityDefine = worldDefine.mEntityDefines [createId];
            editorWorld.addChild (entityDefine.mEntity);
         }
         //<<<
         
         editorWorld.SetCreationEntityArrayLocked (false);
         
         //>>> add entities by creation id order
         // from version 0x0107)
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = worldDefine.mEntityDefines [createId];
            entity = entityDefine.mEntity;
            
            editorWorld.AddEntityToCreationArray (entity);
         }
         //<<<
         
         // modify, 2nd round
         
         Runtime.mPauseCreateShapeProxy = false;
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = worldDefine.mEntityDefines [createId];
            entity = entityDefine.mEntity;
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  //>> from v1.04
                  if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     polygon = entityDefine.mEntity as EntityShapePolygon;
                     polygon.SetLocalVertexPoints (entityDefine.mLocalPoints);
                  }
                  //<<
                  //>>from v1.05
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     polyline = entityDefine.mEntity as  EntityShapePolyline;
                     polyline.SetLocalVertexPoints (entityDefine.mLocalPoints);
                  }
                  //<<
               }
            }
            else if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
            {
               //trace ("entityDefine.mPosX = " + entityDefine.mPosX + ", entityDefine.mPosY = " + entityDefine.mPosY);
               
               entity = entityDefine.mEntity as editor.entity.Entity;
               entity.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
               
               entity.GetMainEntity ().UpdateAppearance ();
               
               //editorWorld.addChildAt (entity, appearId);
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = entityDefine.mEntity as EntityJoint;
               
               // from v1.02
               if (entityDefine.mConnectedShape1Index >= 0)
                  entityDefine.mConnectedShape1Index += beginningEntityIndex;
               
               joint.SetConnectedShape1Index (entityDefine.mConnectedShape1Index);
               
               if (entityDefine.mConnectedShape2Index >= 0)
                  entityDefine.mConnectedShape2Index += beginningEntityIndex;
               
               joint.SetConnectedShape2Index (entityDefine.mConnectedShape2Index);
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  var condition:EntityBasicCondition = entityDefine.mEntity as EntityBasicCondition;
                  
                  TriggerFormatHelper.ShiftEntityRefIndexesInCodeSnippet (entityDefine.mCodeSnippetDefine, beginningEntityIndex, beginningCollisionCategoryIndex);
                  TriggerFormatHelper.LoadCodeSnippetFromCodeSnippetDefine (editorWorld, condition.GetCodeSnippet (), entityDefine.mCodeSnippetDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  var task:EntityTask = entityDefine.mEntity as EntityTask;
                  
                  ShiftEntityRefIndexes (entityDefine.mInputAssignerCreationIds, beginningEntityIndex);
                  task.SetEntityAssignersByCreationIds (entityDefine.mInputAssignerCreationIds);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  var conditionDoor:EntityConditionDoor = entityDefine.mEntity as EntityConditionDoor;
                  conditionDoor.SetAsAnd (entityDefine.mIsAnd);
                  conditionDoor.SetAsNot (entityDefine.mIsNot);
                  ShiftEntityRefIndexes (entityDefine.mInputConditionEntityCreationIds, beginningEntityIndex);
                  conditionDoor.SetInputConditionsByCreationIds (entityDefine.mInputConditionEntityCreationIds, entityDefine.mInputConditionTargetValues);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  var entityAssigner:EntityInputEntityAssigner = entityDefine.mEntity as EntityInputEntityAssigner;
                  
                  entityAssigner.SetSelectorType (entityDefine.mSelectorType);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds, beginningEntityIndex);
                  entityAssigner.SetInputEntitiesByCreationIds (entityDefine.mEntityCreationIds);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  var pairAsigner:EntityInputEntityPairAssigner = entityDefine.mEntity as EntityInputEntityPairAssigner;
                  
                  pairAsigner.SetPairingType (entityDefine.mPairingType);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds1, beginningEntityIndex);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds2, beginningEntityIndex);
                  pairAsigner.SetInputPairEntitiesByCreationdIds (entityDefine.mEntityCreationIds1, entityDefine.mEntityCreationIds2);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  var eventHandler:EntityEventHandler = entityDefine.mEntity as EntityEventHandler;
                  
                  if (entityDefine.mInputConditionEntityCreationId >= 0)
                     entityDefine.mInputConditionEntityCreationId += beginningEntityIndex;
                  
                  eventHandler.SetInputConditionByCreationId (entityDefine.mInputConditionEntityCreationId, entityDefine.mInputConditionTargetValue);
                  ShiftEntityRefIndexes (entityDefine.mInputAssignerCreationIds, beginningEntityIndex);
                  eventHandler.SetEntityAssignersByCreationIds (entityDefine.mInputAssignerCreationIds);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mExternalActionEntityCreationId >= 0)
                        entityDefine.mExternalActionEntityCreationId += beginningEntityIndex;
                     
                     eventHandler.SetExternalActionByCreationId (entityDefine.mExternalActionEntityCreationId);
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (eventHandler is editor.trigger.entity.EntityEventHandler_Timer)
                     {
                        var timerEventHandler:EntityEventHandler_Timer = eventHandler as EntityEventHandler_Timer;
                        
                        timerEventHandler.SetRunningInterval (entityDefine.mRunningInterval);
                        timerEventHandler.SetOnlyRunOnce (entityDefine.mOnlyRunOnce);
                     }
                     else if (eventHandler is editor.trigger.entity.EntityEventHandler_Keyboard)
                     {
                        var keyboardEventHandler:EntityEventHandler_Keyboard = eventHandler as EntityEventHandler_Keyboard;
                        
                        keyboardEventHandler.SetKeyCodes (entityDefine.mKeyCodes);
                     }
                     else if (eventHandler is editor.trigger.entity.EntityEventHandler_Mouse)
                     {
                        var mouseEventHandler:EntityEventHandler_Mouse = eventHandler as EntityEventHandler_Mouse;
                     }
                  }
                  
                  TriggerFormatHelper.ShiftEntityRefIndexesInCodeSnippet (entityDefine.mCodeSnippetDefine, beginningEntityIndex, beginningCollisionCategoryIndex);
                  TriggerFormatHelper.LoadCodeSnippetFromCodeSnippetDefine (editorWorld, eventHandler.GetCodeSnippet (), entityDefine.mCodeSnippetDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  var action:EntityAction = entityDefine.mEntity as EntityAction;
                  
                  TriggerFormatHelper.ShiftEntityRefIndexesInCodeSnippet (entityDefine.mCodeSnippetDefine, beginningEntityIndex, beginningCollisionCategoryIndex);
                  TriggerFormatHelper.LoadCodeSnippetFromCodeSnippetDefine (editorWorld, action.GetCodeSnippet (), entityDefine.mCodeSnippetDefine);
               }
            }
            
            // ...
            if (entity != null)
            {
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
            }
         }
         
         var groupId:int;
         var brotherId:int;
         var brotherIds:Array;
         var entities:Array;
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIds = worldDefine.mBrotherGroupDefines [groupId] as Array;
            
            ShiftEntityRefIndexes (brotherIds, beginningEntityIndex);
            
            for (brotherId = 0; brotherId < brotherIds.length; ++ brotherId)
            {
               entityDefine = worldDefine.mEntityDefines [brotherIds [brotherId]];
               
               brotherIds [brotherId] = brotherIds [brotherId];
            }
            
            editorWorld.GlueEntitiesByCreationIds (brotherIds);
         }
        
         return editorWorld;
      }
      
      public static function ShiftEntityRefIndexes (entityIndexes:Array, idShiftedValue:int):void
      {
         if (entityIndexes != null)
         {
            var num:int = entityIndexes.length;
            var id:int;
            for (var i:int = 0; i < num; ++ i)
            {
               id = entityIndexes [i];
               
               if (id >= 0)
                  entityIndexes [i] = id + idShiftedValue;
            }
         }
      }
      
      public static function Xml2WorldDefine (worldXml:XML):WorldDefine
      {
         if (worldXml == null || worldXml.localName() != "World")
            return null;
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // basic
         {
            worldDefine.mVersion = parseInt (worldXml.@version, 16);
            worldDefine.mAuthorName = worldXml.@author_name;
            worldDefine.mAuthorHomepage = worldXml.@author_homepage;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               worldDefine.mShareSourceCode = parseInt (worldXml.@share_source_code) != 0;
               worldDefine.mPermitPublishing = parseInt (worldXml.@permit_publishing) != 0;
            }
            else
            {
               // ...
            }
         }
         
         var element:XML;
         
         // settings
         if (worldDefine.mVersion >= 0x0104)
         {
            for each (element in worldXml.Settings.Setting)
            {
               if (element.@name == "camera_center_x")
                  worldDefine.mSettings.mCameraCenterX = parseInt (element.@value);
               else if (element.@name == "camera_center_y")
                  worldDefine.mSettings.mCameraCenterY = parseInt (element.@value);
               else if (element.@name == "world_left")
                  worldDefine.mSettings.mWorldLeft = parseInt (element.@value);
               else if (element.@name == "world_top")
                  worldDefine.mSettings.mWorldTop  = parseInt (element.@value);
               else if (element.@name == "world_width")
                  worldDefine.mSettings.mWorldWidth  = parseInt (element.@value);
               else if (element.@name == "world_height")
                  worldDefine.mSettings.mWorldHeight = parseInt (element.@value);
               else if (element.@name == "background_color")
                  worldDefine.mSettings.mBackgroundColor  = parseInt ( (element.@value).substr (2), 16);
               else if (element.@name == "build_border")
                  worldDefine.mSettings.mBuildBorder  = parseInt (element.@value) != 0;
               else if (element.@name == "border_color")
                  worldDefine.mSettings.mBorderColor = parseInt ( (element.@value).substr (2), 16);
               
               //>>from v1.06 to v1.08 (not include 1.08)
               else if (element.@name == "physics_shapes_potential_max_count")
                  worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = parseInt (element.@value);
               else if (element.@name == "physics_shapes_population_density_level")
                  worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = parseInt (element.@value);
               //<<
               
               //>>from v1.08
               else if (element.@name == "infinite_scene_size")
                  worldDefine.mSettings.mIsInfiniteWorldSize = parseInt (element.@value) != 0;
               
               else if (element.@name == "border_at_top_layer")
                  worldDefine.mSettings.mBorderAtTopLayer = parseInt (element.@value) != 0;
               else if (element.@name == "border_left_thinckness")
                  worldDefine.mSettings.mWorldBorderLeftThickness = parseFloat (element.@value);
               else if (element.@name == "border_top_thinckness")
                  worldDefine.mSettings.mWorldBorderTopThickness = parseFloat (element.@value);
               else if (element.@name == "border_right_thinckness")
                  worldDefine.mSettings.mWorldBorderRightThickness = parseFloat (element.@value);
               else if (element.@name == "border_bottom_thinckness")
                  worldDefine.mSettings.mWorldBorderBottomThickness = parseFloat (element.@value);
               
               else if (element.@name == "gravity_acceleration_magnitude")
                  worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = parseFloat (element.@value);
               else if (element.@name == "gravity_acceleration_angle")
                  worldDefine.mSettings.mDefaultGravityAccelerationAngle = parseFloat (element.@value);
               
               else if (element.@name == "right_hand_coordinates")
                  worldDefine.mSettings.mRightHandCoordinates = parseInt (element.@value) != 0;
               else if (element.@name == "coordinates_origin_x")
                  worldDefine.mSettings.mCoordinatesOriginX = parseFloat (element.@value);
               else if (element.@name == "coordinates_origin_y")
                  worldDefine.mSettings.mCoordinatesOriginY = parseFloat (element.@value);
               else if (element.@name == "coordinates_scale")
                  worldDefine.mSettings.mCoordinatesScale = parseFloat (element.@value);
               
               else if (element.@name == "ci_rules_enabled")
                  worldDefine.mSettings.mIsCiRulesEnabled = parseInt (element.@value) != 0;
               //<<
               
               else
                  trace ("Unkown setting: " + element.@name);
            }
         }
         
         var appearId:int;
         var createId:int;
         
         for each (element in worldXml.Entities.Entity)
         {
            var entityDefine:Object = XmlElement2EntityDefine (element, worldDefine);
            
            worldDefine.mEntityDefines.push (entityDefine);
         }
         
         // ...
         // worldDefine.mVersion >= 0x0107
         if (worldXml.EntityAppearingOrder != undefined)
         {
            IndicesString2IntegerArray (worldXml.EntityAppearingOrder.@entity_indices, worldDefine.mEntityAppearanceOrder);
         }
         
         // ...
         
         var groupId:int;
         var brotherGroup:Array;
         var brotherIDs:Array;
         
         for each (element in worldXml.BrotherGroups.BrotherGroup)
         {
            brotherIDs = IndicesString2IntegerArray (element.@brother_indices);
            
            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            for each (element in worldXml.CollisionCategories.CollisionCategory)
            {
               var ccDefine:Object = new Object ();
               
               ccDefine.mName = element.@name;
               ccDefine.mCollideInternally = parseInt (element.@collide_internally) != 0;
               ccDefine.mPosX = parseFloat (element.@x);
               ccDefine.mPosY = parseFloat (element.@y);
               
               worldDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            worldDefine.mDefaultCollisionCategoryIndex = parseInt (worldXml.CollisionCategories.@default_category_index);
            
            for each (element in worldXml.CollisionCategoryFriendPairs.CollisionCategoryFriendPair)
            {
               var pairDefine:Object = new Object ();
               
               pairDefine.mCollisionCategory1Index = parseInt (element.@category1_index);
               pairDefine.mCollisionCategory2Index = parseInt (element.@category2_index);
               
               worldDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         
         return worldDefine;
      }
      
      public static function IndicesString2IntegerArray (indicesStr:String, idArray:Array = null):Array
      {
         if (idArray == null)
            idArray = new Array ();
         
         if (indicesStr == null || indicesStr.length == 0)
            return idArray;
         
         var indexStrArray:Array = indicesStr.split (/,/);
         
         var index:int;
         for (var i:int = 0; i < indexStrArray.length; ++ i)
         {
            index = parseInt (indexStrArray [i]);;
            if (isNaN (index))
               index = -1;
            
            idArray.push (index);
         }
         
         return idArray;
      }
      
      public static function XmlElement2EntityDefine (element:XML, worldDefine:WorldDefine):Object
      {
         var elementLocalVertex:XML;
         
         var entityDefine:Object = new Object ();
         
         entityDefine.mEntityType = parseInt (element.@entity_type);
         entityDefine.mPosX = parseFloat (element.@x);
         entityDefine.mPosY = parseFloat (element.@y);
         entityDefine.mRotation = parseFloat (element.@r);
         entityDefine.mIsVisible = parseInt (element.@visible) != 0;
         
         if (worldDefine.mVersion >= 0x0108)
         {
            entityDefine.mAlpha = parseFloat (element.@alpha);;
            entityDefine.mIsEnabled = parseInt (element.@active) != 0;
         }
         
         if ( Define.IsUtilityEntity (entityDefine.mEntityType) ) // from v1.05
         {
            if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
            {
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mFollowedTarget = parseFloat (element.@followed_target);
                  entityDefine.mFollowingStyle = parseFloat (element.@following_style);
               }
            }
         }
         else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
         {
            if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
            {
               entityDefine.mCodeSnippetDefine = TriggerFormatHelper.Xml2CodeSnippetDefine (element.CodeSnippet);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
            {
               entityDefine.mInputAssignerCreationIds = IndicesString2IntegerArray (element.@assigner_indices);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
            {
               entityDefine.mIsAnd = parseInt (element.@is_and) != 0;
               entityDefine.mIsNot = parseInt (element.@is_not) != 0;
               
               TriggerFormatHelper.CondtionListXml2EntityDefineProperties (element.Conditions, entityDefine);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
            {
               entityDefine.mSelectorType = parseInt (element.@selector_type);
               entityDefine.mEntityCreationIds = IndicesString2IntegerArray (element.@entity_indices);
               entityDefine.mNumEntities = entityDefine.mEntityCreationIds.length;
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
            {
               entityDefine.mPairingType = parseInt (element.@pairing_type);
               entityDefine.mEntityCreationIds1 = IndicesString2IntegerArray (element.@entity_indices1);
               entityDefine.mNumEntities1 = entityDefine.mEntityCreationIds1.length;
               entityDefine.mEntityCreationIds2 = IndicesString2IntegerArray (element.@entity_indices2);
               entityDefine.mNumEntities2 = entityDefine.mEntityCreationIds2.length;
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
            {
               entityDefine.mEventId = parseInt (element.@event_id);
               entityDefine.mInputConditionEntityCreationId = parseInt (element.@input_condition_entity_index);
               entityDefine.mInputConditionTargetValue = parseInt (element.@input_condition_target_value);
               entityDefine.mInputAssignerCreationIds = IndicesString2IntegerArray (element.@assigner_indices);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mExternalActionEntityCreationId = parseInt (element.@external_action_entity_index);
               }
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        entityDefine.mRunningInterval = parseFloat (element.@running_interval);
                        entityDefine.mOnlyRunOnce = parseInt (element.@only_run_once) != 0;
                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        entityDefine.mKeyCodes = IndicesString2IntegerArray (element.@key_codes);
                        break;
                     default:
                        break;
                  }
               }
               
               entityDefine.mCodeSnippetDefine = TriggerFormatHelper.Xml2CodeSnippetDefine (element.CodeSnippet);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
            {
               entityDefine.mCodeSnippetDefine = TriggerFormatHelper.Xml2CodeSnippetDefine (element.CodeSnippet);
            }
         }
         else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mDrawBorder = parseInt (element.@draw_border) != 0;
               entityDefine.mDrawBackground = parseInt (element.@draw_background) != 0;
            }
            
            if (worldDefine.mVersion >= 0x0104)
            {
               entityDefine.mBorderColor = parseInt ( (element.@border_color).substr (2), 16);
               entityDefine.mBorderThickness = parseInt (element.@border_thickness);
               entityDefine.mBackgroundColor = parseInt ( (element.@background_color).substr (2), 16);
               
               if (worldDefine.mVersion >= 0x0107)
                  entityDefine.mTransparency = parseInt (element.@background_opacity);
               else
                  entityDefine.mTransparency = parseInt (element.@transparency);
            }
            
            if (worldDefine.mVersion >= 0x0105)
            {
               if (worldDefine.mVersion >= 0x0107)
                  entityDefine.mBorderTransparency = parseInt (element.@border_opacity);
               else
                  entityDefine.mBorderTransparency = parseInt (element.@border_transparency);
            }
            
            if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
            {
               entityDefine.mAiType = parseInt (element.@ai_type);
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  entityDefine.mIsPhysicsEnabled = parseInt (element.@enable_physics) != 0;
                  
                  // move down from v1.05
                  /////entityDefine.mIsSensor = parseInt (element.@is_sensor) != 0; 
               }
               else
               {
                  entityDefine.mIsPhysicsEnabled = true; // always true before v1.04
                  // entityDefine.mIsSensor will be filled in FillMissedFieldsInWorldDefine
               }
               
               if (entityDefine.mIsPhysicsEnabled)
               {
                  if (worldDefine.mVersion >= 0x0102)
                  {
                     entityDefine.mCollisionCategoryIndex = element.@collision_category_index;
                  }
                  
                  entityDefine.mIsStatic = parseInt (element.@is_static) != 0;
                  entityDefine.mIsBullet = parseInt (element.@is_bullet) != 0;
                  entityDefine.mDensity = parseFloat (element.@density);
                  entityDefine.mFriction = parseFloat (element.@friction);
                  entityDefine.mRestitution = parseFloat (element.@restitution);
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     // add in v1,04, move here from above from v1.05
                     entityDefine.mIsSensor = parseInt (element.@is_sensor) != 0
                  }
                  
                  if (worldDefine.mVersion >= 0x0105)
                  {
                     entityDefine.mIsHollow = parseInt (element.@is_hollow) != 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mBuildBorder = parseInt (element.@build_border) != 0;
                     entityDefine.mIsSleepingAllowed = parseInt (element.@sleeping_allowed) != 0;
                     entityDefine.mIsRotationFixed = parseInt (element.@rotation_fixed) != 0;
                     entityDefine.mLinearVelocityMagnitude = parseFloat (element.@linear_velocity_magnitude);
                     entityDefine.mLinearVelocityAngle = parseFloat (element.@linear_velocity_angle);
                     entityDefine.mAngularVelocity = parseFloat (element.@angular_velocity);
                  }
               }
               
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  entityDefine.mRadius = parseFloat (element.@radius);
                  entityDefine.mAppearanceType = parseInt (element.@appearance_type);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mIsRoundCorners = parseInt (element.@round_corners) != 0;
                  }
                  
                  entityDefine.mHalfWidth = parseFloat (element.@half_width);
                  entityDefine.mHalfHeight = parseFloat (element.@half_height);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
               {
                  entityDefine.mLocalPoints = new Array ();
                  for each (elementLocalVertex in element.LocalVertices.Vertex)
                  {
                     entityDefine.mLocalPoints.push (new Point (parseFloat (elementLocalVertex.@x), parseFloat (elementLocalVertex.@y)));
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
               {
                  entityDefine.mCurveThickness = parseInt (element.@curve_thickness);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mIsRoundEnds = parseInt (element.@round_ends) != 0;
                  }
                  
                  entityDefine.mLocalPoints = new Array ();
                  for each (elementLocalVertex in element.LocalVertices.Vertex)
                  {
                     entityDefine.mLocalPoints.push (new Point (parseFloat (elementLocalVertex.@x), parseFloat (elementLocalVertex.@y)));
                  }
               }
            }
            else
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText 
                  || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                  )
               {
                  entityDefine.mText = element.@text;
                  if (worldDefine.mVersion < 0x0108)
                     entityDefine.mWordWrap = parseInt (element.@autofit_width) != 0;
                  else
                     entityDefine.mWordWrap = parseInt (element.@word_wrap) != 0;
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mAdaptiveBackgroundSize = parseInt (element.@adaptive_background_size) != 0;
                     entityDefine.mTextColor = parseInt ( (element.@text_color).substr (2), 16);
                     entityDefine.mFontSize = parseInt (element.@font_size);
                     entityDefine.mIsBold = parseInt (element.@bold) != 0;
                     entityDefine.mIsItalic = parseInt (element.@italic) != 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0109)
                  {
                     entityDefine.mTextAlign = parseInt (element.@align) != 0;;
                     entityDefine.mIsUnderlined = parseInt (element.@underlined) != 0;;
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton) 
                     {
                        entityDefine.mUsingHandCursor = parseInt (element.@using_hand_cursor) != 0;
                        
                        entityDefine.mDrawBackground_MouseOver = parseInt (element.@draw_background_on_mouse_over) != 0;
                        entityDefine.mBackgroundColor_MouseOver = parseInt ( (element.@background_color_on_mouse_over).substr (2), 16);
                        entityDefine.mBackgroundTransparency_MouseOver = parseInt (element.@background_opacity_on_mouse_over);
                        
                        entityDefine.mDrawBorder_MouseOver = parseInt (element.@draw_border_on_mouse_over) != 0;
                        entityDefine.mBorderColor_MouseOver = parseInt ( (element.@border_color_on_mouse_over).substr (2), 16);
                        entityDefine.mBorderThickness_MouseOver = parseInt (element.@border_thickness_on_mouse_over);
                        entityDefine.mBorderTransparency_MouseOver = parseInt (element.@border_opacity_on_mouse_over);
                     }
                  }
                  
                  entityDefine.mHalfWidth = parseFloat (element.@half_width);
                  entityDefine.mHalfHeight = parseFloat (element.@half_height);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
               {
                  entityDefine.mRadius = parseFloat (element.@radius);
                  
                  if (worldDefine.mVersion >= 0x0105)
                  {
                     entityDefine.mInteractiveZones = parseInt (element.@interactive_zones, 2);
                     
                     entityDefine.mInteractiveConditions = parseInt (element.@interactive_conditions, 2);
                  }
                  else
                  {
                     // mIsInteractive is removed from v1.05.
                     // in FillMissedFieldsInWorldDefine (), mIsInteractive will be converted to mInteractiveZones
                     entityDefine.mIsInteractive = parseInt (element.@is_interactive) != 0;
                  }
                  
                  entityDefine.mInitialGravityAcceleration = parseFloat (element.@initial_gravity_acceleration);
                  entityDefine.mInitialGravityAngle = parseFloat (element.@initial_gravity_angle);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mMaximalGravityAcceleration = parseFloat (element.@maximal_gravity_acceleration);
                  }
               }
            }
         }
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            entityDefine.mCollideConnected = parseInt (element.@collide_connected) != 0;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mConnectedShape1Index = parseInt (element.@connected_shape1_index);
               entityDefine.mConnectedShape2Index = parseInt (element.@connected_shape2_index);
            }
            else
            {
               // ...
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mBreakable = parseInt (element.@breakable) != 0;
            }
            
            if (entityDefine.mEntityType == Define.EntityType_JointHinge)
            {
               entityDefine.mAnchorEntityIndex = parseInt (element.@anchor_index);
               
               entityDefine.mEnableLimits = parseInt (element.@enable_limits) != 0;
               entityDefine.mLowerAngle = parseFloat (element.@lower_angle);
               entityDefine.mUpperAngle = parseFloat (element.@upper_angle);
               entityDefine.mEnableMotor = parseInt (element.@enable_motor) != 0;
               entityDefine.mMotorSpeed = parseFloat (element.@motor_speed);
               entityDefine.mBackAndForth = parseInt (element.@back_and_forth) != 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  entityDefine.mMaxMotorTorque = parseFloat (element.@max_motor_torque);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               entityDefine.mEnableLimits = parseInt (element.@enable_limits) != 0;
               entityDefine.mLowerTranslation = parseFloat (element.@lower_translation);
               entityDefine.mUpperTranslation = parseFloat (element.@upper_translation);
               entityDefine.mEnableMotor = parseInt (element.@enable_motor) != 0;
               entityDefine.mMotorSpeed = parseFloat (element.@motor_speed);
               entityDefine.mBackAndForth = parseInt (element.@back_and_forth) != 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  entityDefine.mMaxMotorForce = parseFloat (element.@max_motor_force);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mBreakDeltaLength = parseFloat (element.@break_delta_length);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               entityDefine.mStaticLengthRatio = parseFloat (element.@static_length_ratio);
               //entityDefine.mFrequencyHz = parseFloat (element.@frequency_hz);
               entityDefine.mSpringType = parseFloat (element.@spring_type);
               
               entityDefine.mDampingRatio = parseFloat (element.@damping_ratio);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mFrequencyDeterminedManner = parseInt (element.@frequency_determined_manner);
                  entityDefine.mFrequency = parseFloat (element.@frequency);
                  entityDefine.mSpringConstant = parseFloat (element.@spring_constant);
                  entityDefine.mBreakExtendedLength = parseFloat (element.@break_extended_length);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
            {
               entityDefine.mAnchorEntityIndex = parseInt (element.@anchor_index);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
            }
         }
         
         return entityDefine;
      }
      
      public static function WorldDefine2ByteArray (worldDefine:WorldDefine):ByteArray
      {
         // from v1,03
         DataFormat2.FillMissedFieldsInWorldDefine (worldDefine);
         if (worldDefine.mVersion >= 0x0103)
         {
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         }
         
         //
         var byteArray:ByteArray = new ByteArray ();
         
         // COlor INfection
         byteArray.writeByte ("C".charCodeAt (0));
         byteArray.writeByte ("O".charCodeAt (0));
         byteArray.writeByte ("I".charCodeAt (0));
         byteArray.writeByte ("N".charCodeAt (0));
         
         // basic
         {
            // version, author
            byteArray.writeShort (worldDefine.mVersion);
            byteArray.writeUTF (worldDefine.mAuthorName);
            byteArray.writeUTF (worldDefine.mAuthorHomepage);
            
            // removed since v1.02
            if (worldDefine.mVersion < 0x0102)
            {
               // hex
               byteArray.writeByte ("H".charCodeAt (0));
               byteArray.writeByte ("E".charCodeAt (0));
               byteArray.writeByte ("X".charCodeAt (0));
            }
            
            if (worldDefine.mVersion >= 0x0102)
            {
               byteArray.writeByte (worldDefine.mShareSourceCode ? 1 : 0);
               byteArray.writeByte (worldDefine.mPermitPublishing ? 1 : 0);
            }
         }
         
         // settings
         {
            if (worldDefine.mVersion >= 0x0104)
            {
               byteArray.writeInt (worldDefine.mSettings.mCameraCenterX);
               byteArray.writeInt (worldDefine.mSettings.mCameraCenterY);
               byteArray.writeInt (worldDefine.mSettings.mWorldLeft);
               byteArray.writeInt (worldDefine.mSettings.mWorldTop);
               byteArray.writeInt (worldDefine.mSettings.mWorldWidth);
               byteArray.writeInt (worldDefine.mSettings.mWorldHeight);
               byteArray.writeUnsignedInt (worldDefine.mSettings.mBackgroundColor);
               byteArray.writeByte (worldDefine.mSettings.mBuildBorder ? 1 : 0);
               byteArray.writeUnsignedInt (worldDefine.mSettings.mBorderColor);
            }
            
            if (worldDefine.mVersion >= 0x0106 && worldDefine.mVersion < 0x0108)
            {
               byteArray.writeInt (worldDefine.mSettings.mPhysicsShapesPotentialMaxCount);
               byteArray.writeShort (worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel);
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeByte (worldDefine.mSettings.mIsInfiniteWorldSize ? 1 : 0);
               
               byteArray.writeByte (worldDefine.mSettings.mBorderAtTopLayer ? 1 : 0);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderLeftThickness);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderTopThickness);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderRightThickness);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderBottomThickness);
               
               byteArray.writeFloat (worldDefine.mSettings.mDefaultGravityAccelerationMagnitude);
               byteArray.writeFloat (worldDefine.mSettings.mDefaultGravityAccelerationAngle);
               
               byteArray.writeByte (worldDefine.mSettings.mRightHandCoordinates ? 1 : 0);
               byteArray.writeDouble (worldDefine.mSettings.mCoordinatesOriginX);
               byteArray.writeDouble (worldDefine.mSettings.mCoordinatesOriginY);
               byteArray.writeDouble (worldDefine.mSettings.mCoordinatesScale);
               
               byteArray.writeByte (worldDefine.mSettings.mIsCiRulesEnabled ? 1 : 0);
            }
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            byteArray.writeShort (worldDefine.mCollisionCategoryDefines.length);
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               byteArray.writeUTF (ccDefine.mName);
               byteArray.writeByte (ccDefine.mCollideInternally);
               byteArray.writeFloat (ccDefine.mPosX);
               byteArray.writeFloat (ccDefine.mPosY);
            }
            
            byteArray.writeShort (worldDefine.mDefaultCollisionCategoryIndex);
            
            byteArray.writeShort (worldDefine.mCollisionCategoryFriendLinkDefines.length);
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               byteArray.writeShort (pairDefine.mCollisionCategory1Index);
               byteArray.writeShort (pairDefine.mCollisionCategory2Index);
            }
         }
         
         // entities
         var appearId:int;
         var createId:int;
         var vertexId:int;
         
         var i:int;
         
         var numEntities:int = worldDefine.mEntityDefines.length;
         
         byteArray.writeShort (worldDefine.mEntityDefines.length);
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [createId];
            
            byteArray.writeShort (entityDefine.mEntityType);
            if (worldDefine.mVersion >= 0x0103)
            {
               byteArray.writeDouble (entityDefine.mPosX);
               byteArray.writeDouble (entityDefine.mPosY);
            }
            else
            {
               byteArray.writeFloat (entityDefine.mPosX);
               byteArray.writeFloat (entityDefine.mPosY);
            }
            byteArray.writeFloat (entityDefine.mRotation);
            byteArray.writeByte (entityDefine.mIsVisible ? 1 : 0);
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeFloat (entityDefine.mAlpha);
               byteArray.writeByte (entityDefine.mIsEnabled ? 1 : 0);
            }
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) ) // from v1.05
            {
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeByte (entityDefine.mFollowedTarget);
                     byteArray.writeByte (entityDefine.mFollowingStyle);
                  }
               }
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  TriggerFormatHelper.WriteCodeSnippetDefineIntoBinFile (byteArray, entityDefine.mCodeSnippetDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  WriteShortArrayIntoBinFile (entityDefine.mInputAssignerCreationIds, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  byteArray.writeByte (entityDefine.mIsAnd ? 1 : 0);
                  byteArray.writeByte (entityDefine.mIsNot ? 1 : 0);
                  
                  var target_values:Array = entityDefine.mInputConditionTargetValues;
                  var creation_ids:Array = entityDefine.mInputConditionEntityCreationIds;
                  var num:int = creation_ids.length;
                  if (num > target_values.length)
                     num = target_values.length;
                  
                  byteArray.writeShort (num);
                  for (i = 0; i < num; ++ i)
                  {
                     byteArray.writeShort (creation_ids [i]);
                     byteArray.writeByte (target_values [i]);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  byteArray.writeByte (entityDefine.mSelectorType);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  byteArray.writeByte (entityDefine.mPairingType);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds1, byteArray);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds2, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  byteArray.writeShort (entityDefine.mEventId);
                  byteArray.writeShort (entityDefine.mInputConditionEntityCreationId);
                  byteArray.writeByte (entityDefine.mInputConditionTargetValue);
                  WriteShortArrayIntoBinFile (entityDefine.mInputAssignerCreationIds, byteArray);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeShort (entityDefine.mExternalActionEntityCreationId);
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     switch (entityDefine.mEventId)
                     {
                        case CoreEventIds.ID_OnWorldTimer:
                        case CoreEventIds.ID_OnEntityTimer:
                        case CoreEventIds.ID_OnEntityPairTimer:
                           byteArray.writeFloat (entityDefine.mRunningInterval);
                           byteArray.writeByte (entityDefine.mOnlyRunOnce ? 1 : 0);
                           break;
                        case CoreEventIds.ID_OnWorldKeyDown:
                        case CoreEventIds.ID_OnWorldKeyUp:
                        case CoreEventIds.ID_OnWorldKeyHold:
                           WriteShortArrayIntoBinFile (entityDefine.mKeyCodes, byteArray);
                           break;
                        default:
                           break;
                     }
                  }
                  
                  TriggerFormatHelper.WriteCodeSnippetDefineIntoBinFile (byteArray, entityDefine.mCodeSnippetDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  TriggerFormatHelper.WriteCodeSnippetDefineIntoBinFile (byteArray, entityDefine.mCodeSnippetDefine);
               }
            }
            else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  byteArray.writeByte (entityDefine.mDrawBorder);
                  byteArray.writeByte (entityDefine.mDrawBackground);
               }
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  byteArray.writeUnsignedInt (entityDefine.mBorderColor);
                  byteArray.writeByte (entityDefine.mBorderThickness);
                  byteArray.writeUnsignedInt (entityDefine.mBackgroundColor);
                  byteArray.writeByte (entityDefine.mTransparency);
               }
               
               if (worldDefine.mVersion >= 0x0105)
               {
                  byteArray.writeByte (entityDefine.mBorderTransparency);
               }
               
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  if (worldDefine.mVersion >= 0x0105) 
                  {
                     byteArray.writeByte (entityDefine.mAiType);
                     byteArray.writeByte (entityDefine.mIsPhysicsEnabled);
                     
                     // the 2 lines are added in v1,04, and moved down from v1.05
                     /////byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
                     /////byteArray.writeByte (entityDefine.mIsSensor)
                  }
                  else if (worldDefine.mVersion >= 0x0104)
                  {
                     // changed the order of mAiType and mCollisionCategoryIndex, 
                     // add mIsPhysicsEnabled and mIsSensor
                     
                     byteArray.writeByte (entityDefine.mAiType);
                     byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
                     byteArray.writeByte (entityDefine.mIsPhysicsEnabled);
                     byteArray.writeByte (entityDefine.mIsSensor)
                  }
                  else 
                  {
                     if (worldDefine.mVersion >= 0x0102)
                     {
                        byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
                     }
                     
                     byteArray.writeByte (entityDefine.mAiType);
                     
                     //entityDefine.mIsPhysicsEnabled = true; // already set in FillMissedFieldsInWorldDefine
                  }
                  
                  if (entityDefine.mIsPhysicsEnabled) // always true before v1.05
                  {
                     byteArray.writeByte (entityDefine.mIsStatic);
                     byteArray.writeByte (entityDefine.mIsBullet);
                     byteArray.writeFloat (entityDefine.mDensity);
                     byteArray.writeFloat (entityDefine.mFriction);
                     byteArray.writeFloat (entityDefine.mRestitution);
                     
                     if (worldDefine.mVersion >= 0x0105)
                     {
                        // the 2 lines are added in v1,04, and moved here from above from v1.05
                        byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
                        byteArray.writeByte (entityDefine.mIsSensor)
                        
                        // ...
                        byteArray.writeByte (entityDefine.mIsHollow);
                     }
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mBuildBorder ? 1 : 0);
                        byteArray.writeByte (entityDefine.mIsSleepingAllowed ? 1 : 0);
                        byteArray.writeByte (entityDefine.mIsRotationFixed) ? 1 : 0;
                        byteArray.writeFloat (entityDefine.mLinearVelocityMagnitude);
                        byteArray.writeFloat (entityDefine.mLinearVelocityAngle);
                        byteArray.writeFloat (entityDefine.mAngularVelocity);
                     }
                  }
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     byteArray.writeFloat (entityDefine.mRadius);
                     byteArray.writeByte (entityDefine.mAppearanceType);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mIsRoundCorners ? 1 : 0);
                     }
                     
                     byteArray.writeFloat (entityDefine.mHalfWidth);
                     byteArray.writeFloat (entityDefine.mHalfHeight);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     byteArray.writeShort (entityDefine.mLocalPoints.length);
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].x);
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].y);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     byteArray.writeByte (entityDefine.mCurveThickness);
                  
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mIsRoundEnds ? 1 : 0);
                     }
                     
                     byteArray.writeShort (entityDefine.mLocalPoints.length);
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].x);
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].y);
                     }
                  }
               }
               else // not physics entity
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText 
                     || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                     )
                  {
                     byteArray.writeUTF (entityDefine.mText);
                     byteArray.writeByte (entityDefine.mWordWrap ? 1 : 0);
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mAdaptiveBackgroundSize ? 1 : 0);
                        byteArray.writeUnsignedInt (entityDefine.mTextColor);
                        byteArray.writeShort (entityDefine.mFontSize);
                        byteArray.writeByte (entityDefine.mIsBold ? 1 : 0);
                        byteArray.writeByte (entityDefine.mIsItalic ? 1 : 0);
                     }
                     
                     if (worldDefine.mVersion >= 0x0109)
                     {
                        byteArray.writeByte (entityDefine.mTextAlign);
                        byteArray.writeByte (entityDefine.mIsUnderlined ? 1 : 0);
                     }
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton) 
                        {
                           byteArray.writeByte (entityDefine.mUsingHandCursor ? 1 : 0);
                           
                           byteArray.writeByte (entityDefine.mDrawBackground_MouseOver ? 1 : 0);
                           byteArray.writeUnsignedInt (entityDefine.mBackgroundColor_MouseOver);
                           byteArray.writeByte (entityDefine.mBackgroundTransparency_MouseOver);
                           
                           byteArray.writeByte (entityDefine.mDrawBorder_MouseOver ? 1 : 0);
                           byteArray.writeUnsignedInt (entityDefine.mBorderColor_MouseOver);
                           byteArray.writeByte (entityDefine.mBorderThickness_MouseOver);
                           byteArray.writeByte (entityDefine.mBorderTransparency_MouseOver);
                        }
                     }
                     
                     byteArray.writeFloat (entityDefine.mHalfWidth);
                     byteArray.writeFloat (entityDefine.mHalfHeight);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     byteArray.writeFloat (entityDefine.mRadius);
                     
                     if (worldDefine.mVersion >= 0x0105)
                     {
                        byteArray.writeByte (entityDefine.mInteractiveZones);
                        byteArray.writeShort (entityDefine.mInteractiveConditions);
                     }
                     else
                     {
                        byteArray.writeByte (entityDefine.mIsInteractive);
                     }
                     
                     byteArray.writeFloat (entityDefine.mInitialGravityAcceleration);
                     byteArray.writeShort (entityDefine.mInitialGravityAngle);
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeFloat (entityDefine.mMaximalGravityAcceleration);
                     }
                  }
               }
            }
            else if (Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               byteArray.writeByte (entityDefine.mCollideConnected);
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  byteArray.writeShort (entityDefine.mConnectedShape1Index);
                  byteArray.writeShort (entityDefine.mConnectedShape2Index);
               }
               else if (worldDefine.mVersion >= 0x0102) // ??!! why bytes
               {
                  byteArray.writeByte (entityDefine.mConnectedShape1Index);
                  byteArray.writeByte (entityDefine.mConnectedShape2Index);
               }
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  byteArray.writeByte (entityDefine.mBreakable ? 1 : 0);
               }
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  byteArray.writeShort (entityDefine.mAnchorEntityIndex);
                  
                  byteArray.writeByte (entityDefine.mEnableLimits);
                  byteArray.writeFloat (entityDefine.mLowerAngle);
                  byteArray.writeFloat (entityDefine.mUpperAngle);
                  byteArray.writeByte (entityDefine.mEnableMotor);
                  byteArray.writeFloat (entityDefine.mMotorSpeed);
                  byteArray.writeByte (entityDefine.mBackAndForth);
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     byteArray.writeFloat (entityDefine.mMaxMotorTorque);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  byteArray.writeByte (entityDefine.mEnableLimits);
                  byteArray.writeFloat (entityDefine.mLowerTranslation);
                  byteArray.writeFloat (entityDefine.mUpperTranslation);
                  byteArray.writeByte (entityDefine.mEnableMotor);
                  byteArray.writeFloat (entityDefine.mMotorSpeed);
                  byteArray.writeByte (entityDefine.mBackAndForth);
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     byteArray.writeFloat (entityDefine.mMaxMotorForce);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeFloat (entityDefine.mBreakDeltaLength);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  byteArray.writeFloat (entityDefine.mStaticLengthRatio);
                  //byteArray.writeFloat (entityDefine.mFrequencyHz);
                  byteArray.writeByte (entityDefine.mSpringType);
                  
                  byteArray.writeFloat (entityDefine.mDampingRatio);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeByte (entityDefine.mFrequencyDeterminedManner);
                     byteArray.writeFloat (entityDefine.mFrequency);
                     byteArray.writeFloat (entityDefine.mSpringConstant);
                     byteArray.writeFloat (entityDefine.mBreakExtendedLength);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  byteArray.writeShort (entityDefine.mAnchorEntityIndex);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
               }
            }
         }
         
         // ...
         if (worldDefine.mVersion >= 0x0107)
         {
            WriteShortArrayIntoBinFile (worldDefine.mEntityAppearanceOrder, byteArray);
         }
         
         // ...
         
         var groupId:int;
         var brotherIDs:Array;
         
         byteArray.writeShort (worldDefine.mBrotherGroupDefines.length);
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = worldDefine.mBrotherGroupDefines [groupId] as Array;
            
            WriteShortArrayIntoBinFile (brotherIDs, byteArray);
         }
         
         return byteArray;
      }
      
      public static function WriteShortArrayIntoBinFile (shortArray:Array, binFile:ByteArray):void
      {
         if (shortArray == null)
         {
            binFile.writeShort (0);
            return;
         }
         
         binFile.writeShort (shortArray.length);
         
         for (var i:int = 0; i < shortArray.length; ++ i)
         {
            binFile.writeShort (shortArray [i]);
         }
      }
      
      public static function WorldDefine2HexString (worldDefine:WorldDefine):String
      {
         return ByteArray2HexString (WorldDefine2ByteArray (worldDefine) );
      }
      
      public static function ByteArray2HexString (byteArray:ByteArray):String
      {
         if (byteArray == null)
            return null;
         
         var arrayLength:int = byteArray.length;
         var stringLength:int = arrayLength * 2;
         
         var hexString:String = "";
         var n1:int;
         var n2:int;
         
         for (var bi:int = 0; bi < arrayLength; ++ bi)
         {
            hexString = hexString + MakeHexStringFromByte (byteArray [bi]);
         }
         
         if (hexString.length != arrayLength * 2)
            trace ("hexString.length != arrayLength * 2");
         
         return En (hexString);
      }
      
      public static function MakeHexStringFromByte (byteValue:int):String
      {
         //if (byteValue < -128 || byteValue > 127)
         if (byteValue < 0 || byteValue > 255)
         {
            return "??";
         }
         
         var n1:int = (byteValue & 0xF0) >> 4;
         var n2:int = (byteValue & 0x0F);
         
         return DataFormat2.Value2Char (n1) + DataFormat2.Value2Char (n2);
      }
      
      public static function En (str:String):String
      {
         var enStr:String = "";
         
         var index:int = 0;
         var code:int;
         var num:int;
         while (index < str.length)
         {
            code = str.charCodeAt (index);
            num = 1;
            ++ index;
            while (num < 4 && index < str.length && str.charCodeAt (index) == code)
            {
               ++ num;
               ++ index;
            }
            
            enStr = enStr + DataFormat2.Value2Char (DataFormat2.Char2Value (code), num);
         }
         
         return enStr;
      }
      
   }
   
}