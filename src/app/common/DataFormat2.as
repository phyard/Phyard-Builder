
package common {
   
   import flash.utils.ByteArray;
   import flash.geom.Point;
   
   import player.global.Global;
   import player.world.World;
   import player.entity.ShapeContainer;
   
   import player.trigger.entity.EntityBasicCondition;
   import player.trigger.entity.EntityTask;
   import player.trigger.entity.EntityConditionDoor;
   import player.trigger.entity.EntityAction;
   import player.trigger.entity.EntityInputEntityAssigner;
   import player.trigger.entity.EntityEventHandler;
   
   public class DataFormat2
   {
      
      
      
//===========================================================================
// 
//===========================================================================
      
      public static function WorldDefine2PlayerWorld (worldDefine:WorldDefine):player.world.World
      {
         //trace ("WorldDefine2PlayerWorld");
         
         FillMissedFieldsInWorldDefine (worldDefine);
         if (worldDefine.mVersion >= 0x0103)
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine, true);
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
         //
         Global.InitGlobalData ();
         
         //
         var playerWorld:player.world.World = new player.world.World (worldDefine);
         Global.SetCurrentWorld (playerWorld);
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
         var entityDefineArray:Array = worldDefine.mEntityDefines;
         var brotherGroupArray:Array = worldDefine.mBrotherGroupDefines;
         var groupId:int;
         var brotherGroup:Array;
         var entityId:int;
         var entityDefine:Object;
         var i:int;
         var shapeContainer:player.entity.ShapeContainer;
         var params:Object;
         var entity:player.entity.Entity;
         var shape:player.entity.EntityShape;
         var joint:player.entity.EntityJoint;
         var logic:player.trigger.entity.EntityLogic;
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               playerWorld.CreateCollisionCategory (ccDefine);
            }
            
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               playerWorld.CreateCollisionCategoryFriendLink (pairDefine.mCollisionCategory1Index, pairDefine.mCollisionCategory2Index);
            }
         }
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
      // crete shape containers
         
         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;
            
            var numPhyShapes:int = 0;
            var centerX:Number = 0;
            var centerY:Number = 0;
            for (i = 0; i < brotherGroup.length; ++ i)
            {
               entityId = brotherGroup [i];
               entityDefine = entityDefineArray [entityId];
               
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) && entityDefine.mIsPhysicsEnabled)
               {
                  numPhyShapes ++;
                  centerX += entityDefine.mPosX;
                  centerY += entityDefine.mPosY;
               }
            }
            
            if ( numPhyShapes == 0)
               continue;
            
            params = new Object ();
            params.mContainsPhysicsShapes = true;
            params.mWorldDefine = worldDefine;
            params.mPosX = centerX / numPhyShapes;
            params.mPosY = centerY / numPhyShapes;
            
            shapeContainer = playerWorld.CreateShapeContainer (params, true);
            
            for (i = 0; i < brotherGroup.length; ++ i)
            {
               entityId = brotherGroup [i];
               entityDefine = entityDefineArray [entityId];
               
               entityDefine.mShapeContainer = shapeContainer;
            }
         }
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
      // create shapes
         
         for (entityId = 0; entityId < entityDefineArray.length; ++ entityId)
         {
            entity = null;
            
            entityDefine = entityDefineArray [entityId];
            
            // >> starts from version 1.01
            entityDefine.mWorldDefine = worldDefine;
            entityDefine.mEntityIndexInEditor = entityId;
            // <<
            
            //trace ("entityId = " + entityId + ", mEntityType = " + entityDefine.mEntityType);
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) ) // from v1.05
            {
               shapeContainer = GetShapeContainer (playerWorld, worldDefine, entityDefine);
               
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  entity = playerWorld.CreateUtilityCamera (shapeContainer, entityDefine);
               }
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
            {
               logic = null;
               
               shapeContainer = GetShapeContainer (playerWorld, worldDefine, entityDefine);
               
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  entity = logic = playerWorld.CreateEntityBasicCondition (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  entity = logic = playerWorld.CreateEntityTask (entityDefine);
                  
                  (entity as EntityTask).SetEntityAssigners (entityDefine.mInputAssignerIndexes);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  entity = logic = playerWorld.CreateEntityConditionDoor (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  entity = logic = playerWorld.CreateEntityAction (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  entity = logic = playerWorld.CreateEntityInputEntityAssigner (entityDefine, false);
                  
                  (entity as EntityInputEntityAssigner).SetEntityIndexes1 (entityDefine.mEntityIndexes);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  entity = logic = playerWorld.CreateEntityInputEntityAssigner (entityDefine, true);
                  
                  (entity as EntityInputEntityAssigner).SetEntityIndexes1 (entityDefine.mEntityIndexes1);
                  (entity as EntityInputEntityAssigner).SetEntityIndexes2 (entityDefine.mEntityIndexes2);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  entity = logic = playerWorld.CreateEntityEventHandler (entityDefine);
               }
            }
            else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               shape = null;
               
               shapeContainer = GetShapeContainer (playerWorld, worldDefine, entityDefine);
               
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  // commnet following, for mCollisionCategoryIndex is already set in AdjustWorldDefine now
                  //if (worldDefine.mVersion >= 0x0102)
                  //{
                  //   // already set
                  //}
                  //else
                  //{
                  //   entityDefine.mCollisionCategoryIndex = Define.CollisionCategoryId_HiddenCategory;
                  //}
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entity = shape = playerWorld.CreateEntityShapeCircle (shapeContainer, entityDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     entity = shape = playerWorld.CreateEntityShapeRectangle (shapeContainer, entityDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     entity = shape = playerWorld.CreateEntityShapePolygon (shapeContainer, entityDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     entity = shape = playerWorld.CreateEntityShapePolyline (shapeContainer, entityDefine);
                  }
               }
               else // not physics shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     entityDefine.mAiType = Define.ShapeAiType_Unknown;
                     entityDefine.mIsStatic = false;
                     entityDefine.mIsBullet = false;
                     entityDefine.mDensity = 1.0;
                     entityDefine.mFriction = 0.1;
                     entityDefine.mRestitution = 0.2;
                     
                     entity = shape = playerWorld.CreateEntityShapeText (shapeContainer, entityDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     entityDefine.mAiType = Define.ShapeAiType_Unknown;
                     entityDefine.mIsStatic = false;
                     entityDefine.mIsBullet = false;
                     entityDefine.mDensity = 1.0;
                     entityDefine.mFriction = 0.1;
                     entityDefine.mRestitution = 0.2;
                     entityDefine.mAppearanceType = Define.CircleAppearanceType_Ball;
                     
                     entity = shape = playerWorld.CreateEntityShapeGravityController (shapeContainer, entityDefine);
                  }
               }
            }
            
            if (entity != null)
            {
               entityDefine.mEntity = entity;
            }
         }
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
      // update z-order and masses
         
         playerWorld.UpdateShapeLayers ();
         playerWorld.UpdateShapeMasses (); // 
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
      // create joints
         
         for (entityId = 0; entityId < entityDefineArray.length; ++ entityId)
         {
            entityDefine = entityDefineArray [entityId];
            
            entity = null;
            
            if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = null;
               
               // comment some lines, for mConnectedShape1Index and mConnectedShape2Index have been set NONE in AdjustWorldDefine
               //if (worldDefine.mVersion >= 0x0102)
               //{
                  if  (entityDefine.mConnectedShape1Index == Define.EntityId_Ground)
                  {
                     entityDefine.mConnectedShape1 = playerWorld.GetPhysicsEngine ();
                  }
                  else if (entityDefine.mConnectedShape1Index >= 0)
                  {
                     shape = worldDefine.mEntityDefines [entityDefine.mConnectedShape1Index].mEntity as player.entity.EntityShape;
                     entityDefine.mConnectedShape1 = shape.GetPhysicsProxy ();
                  }
                  else
                  {
                     entityDefine.mConnectedShape1 = null;
                  }
                  
                  if  (entityDefine.mConnectedShape2Index == Define.EntityId_Ground)
                  {
                     entityDefine.mConnectedShape2 = playerWorld.GetPhysicsEngine ();
                  }
                  else if (entityDefine.mConnectedShape2Index >= 0)
                  {
                     shape = worldDefine.mEntityDefines [entityDefine.mConnectedShape2Index].mEntity as player.entity.EntityShape;
                     entityDefine.mConnectedShape2 = shape.GetPhysicsProxy ();
                  }
                  else
                  {
                     entityDefine.mConnectedShape2 = null;
                  }
               //}
               //else
               //{
               //   entityDefine.mConnectedShape1 = null; // auto
               //   entityDefine.mConnectedShape2 = null; // auto
               //}
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mAnchorParams = entityDefineArray [entityDefine.mAnchorEntityIndex];
                  
                  entity = joint = playerWorld.CreateEntityJointHinge (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mAnchor1Params = entityDefineArray [entityDefine.mAnchor1EntityIndex];
                  entityDefine.mAnchor2Params = entityDefineArray [entityDefine.mAnchor2EntityIndex];
                  
                  entity = joint = playerWorld.CreateEntityJointSlider (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  entityDefine.mAnchor1Params = entityDefineArray [entityDefine.mAnchor1EntityIndex];
                  entityDefine.mAnchor2Params = entityDefineArray [entityDefine.mAnchor2EntityIndex];
                  
                  entity = joint = playerWorld.CreateEntityJointDistance (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mAnchor1Params = entityDefineArray [entityDefine.mAnchor1EntityIndex];
                  entityDefine.mAnchor2Params = entityDefineArray [entityDefine.mAnchor2EntityIndex];
                  
                  entity = joint = playerWorld.CreateEntityJointSpring (entityDefine);
               }
            }
            
            if (entity != null)
            {
               entityDefine.mEntity = entity;
            }
            
         // all entity are created alrady
            playerWorld.RegisterEntityByIndexInEditor (entityId, entityDefine.mEntity);
         }
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
      // build logics
         
         // here invert the order, to make the fronter event handler registered fronterly
         for (entityId = entityDefineArray.length - 1; entityId >= 0; -- entityId)
         {
            entityDefine = entityDefineArray [entityId];
            
         // ...
            if ( Define.IsLogicEntity (entityDefine.mEntityType) )
            {
               entity = entityDefine.mEntity;
               
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  var condition:EntityBasicCondition = entity as EntityBasicCondition;
                  
                  condition.SetConditionListDefine (entityDefine.mConditionListDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  var task:EntityTask = entity as EntityTask;
                  
                  // moved to the 1st round
                  //task.SetEntityAssigners (entityDefine.mInputAssignerIndexes);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  var condition_door:EntityConditionDoor = entity as EntityConditionDoor;
                  
                  condition_door.SetInputConditions (entityDefine.mInputConditionEntityIndexes, entityDefine.mInputConditionTargetValues);
                  condition_door.SetAnd (entityDefine.mIsAnd);
                  condition_door.SetNot (entityDefine.mIsNot);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  var action:EntityAction = entity as EntityAction;
                  
                  action.SetCommandListDefine (entityDefine.mCommandListDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  var assigner:EntityInputEntityAssigner = entity as EntityInputEntityAssigner;
                  
                  // moved to the 1st round
                  //assigner.SetEntityIndexes1 (entityDefine.mEntityIndexes);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  var pair_assigner:EntityInputEntityAssigner = entity as EntityInputEntityAssigner;
                  
                  // moved to the 1st round
                  //pair_assigner.SetEntityIndexes1 (entityDefine.mEntityIndexes1);
                  //pair_assigner.SetEntityIndexes2 (entityDefine.mEntityIndexes2);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  var event_handler:EntityEventHandler = entity as EntityEventHandler;
                  
                  event_handler.SetExternalCondition (entityDefine.mInputConditionEntityIndex, entityDefine.mInputConditionTargetValue);
                  event_handler.SetExternalPostActionEntity (entityDefine.mPostActionEntityIndex);
                  event_handler.SetEntityAssigners (entityDefine.mInputAssignerIndexes);
                  event_handler.SetInternalConditionListDefine (entityDefine.mConditionListDefine);
                  event_handler.SetInternalCommandListDefine (entityDefine.mCommandListDefine);
                  
                  event_handler.Register ();
               }
            }
         }
         
   //*********************************************************************************************************************************
   // 
   //*********************************************************************************************************************************
         
         playerWorld.Initialize ();
         
         return playerWorld;
      }
      
      private static function GetShapeContainer (playerWorld:player.world.World, worldDefine:Object, entityDefine:Object):ShapeContainer
      {
         var shapeContainer:player.entity.ShapeContainer;
         
         shapeContainer = entityDefine.mShapeContainer;
         if (shapeContainer == null)
         {
            var params:Object = new Object ();
            params.mContainsPhysicsShapes = Define.IsBasicShapeEntity (entityDefine.mEntityType) && entityDefine.mIsPhysicsEnabled;
            params.mWorldDefine = worldDefine;
            params.mPosX = entityDefine.mPosX;
            params.mPosY = entityDefine.mPosY;
            
            shapeContainer = playerWorld.CreateShapeContainer (params, true);
         }
         
         return shapeContainer;
      }
      
      public static function ByteArray2WorldDefine (byteArray:ByteArray):WorldDefine
      {
         //trace ("ByteArray2WorldDefine");
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // COlor INfection
         byteArray.readByte (); // "C".charCodeAt (0);
         byteArray.readByte (); // "O".charCodeAt (0);
         byteArray.readByte (); // "I".charCodeAt (0);
         byteArray.readByte (); // "N".charCodeAt (0);
         
         // basic settings
         {
            worldDefine.mVersion = byteArray.readShort ();
            worldDefine.mAuthorName = byteArray.readUTF ();
            worldDefine.mAuthorHomepage = byteArray.readUTF ();
            
            if (worldDefine.mVersion < 0x0102)
            {
               // the 3 bytes are removed since v1.02
               // hex
               byteArray.readByte (); // "H".charCodeAt (0);
               byteArray.readByte (); // "E".charCodeAt (0);
               byteArray.readByte (); // "X".charCodeAt (0);
            }
            
            if (worldDefine.mVersion >= 0x0102)
            {
               worldDefine.mShareSourceCode = byteArray.readByte () != 0;
               worldDefine.mPermitPublishing = byteArray.readByte () != 0;
            }
         }
         
         // more settings
         {
            if (worldDefine.mVersion >= 0x0104)
            {
               worldDefine.mSettings.mCameraCenterX = byteArray.readInt ();
               worldDefine.mSettings.mCameraCenterY = byteArray.readInt ();
               worldDefine.mSettings.mWorldLeft = byteArray.readInt ();
               worldDefine.mSettings.mWorldTop  = byteArray.readInt ();
               worldDefine.mSettings.mWorldWidth  = byteArray.readInt ();
               worldDefine.mSettings.mWorldHeight = byteArray.readInt ();
               worldDefine.mSettings.mBackgroundColor  = byteArray.readUnsignedInt ();
               worldDefine.mSettings.mBuildBorder  = byteArray.readByte () != 0;
               worldDefine.mSettings.mBorderColor = byteArray.readUnsignedInt ();
            }
            
            if (worldDefine.mVersion >= 0x0106)
            {
               worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = byteArray.readInt ();
               worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = byteArray.readShort ();
            }
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            var numCategories:int = byteArray.readShort ();
            
            //trace ("numCategories = " + numCategories);
            
            for (var ccId:int = 0; ccId < numCategories; ++ ccId)
            {
               var ccDefine:Object = new Object ();
               
               ccDefine.mName = byteArray.readUTF ();
               ccDefine.mCollideInternally = byteArray.readByte () != 0;
               ccDefine.mPosX = byteArray.readFloat ();
               ccDefine.mPosY = byteArray.readFloat ();
               
               worldDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            worldDefine.mDefaultCollisionCategoryIndex = byteArray.readShort ();
            
            //trace ("worldDefine.mDefaultCollisionCategoryIndex = " + worldDefine.mDefaultCollisionCategoryIndex);
            
            var numPairs:int = byteArray.readShort ();
            
            //trace ("numPairs = " + numPairs);
            
            for (var pairId:int = 0; pairId < numPairs; ++ pairId)
            {
               var pairDefine:Object = new Object ();
               pairDefine.mCollisionCategory1Index = byteArray.readShort ();
               pairDefine.mCollisionCategory2Index = byteArray.readShort ();
               
               worldDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         
         // entities
         
         var numEntities:int = byteArray.readShort ();
         
         //trace ("numEntities = " + numEntities);
         
         var entityId:int;
         var vertexId:int;
         
         for (entityId = 0; entityId < numEntities; ++ entityId)
         {
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = byteArray.readShort ();
            
            //trace ("entityId = " + entityId + ", mEntityType = " + entityDefine.mEntityType);
            
            if (worldDefine.mVersion >= 0x0103)
            {
               entityDefine.mPosX = byteArray.readDouble ();
               entityDefine.mPosY = byteArray.readDouble ();
            }
            else
            {
               entityDefine.mPosX = byteArray.readFloat ();
               entityDefine.mPosY = byteArray.readFloat ();
            }
            entityDefine.mRotation = byteArray.readFloat ();
            entityDefine.mIsVisible = byteArray.readByte ();
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) ) // from v1.05
            {
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
               }
            }
            else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  entityDefine.mDrawBorder = byteArray.readByte ();
                  entityDefine.mDrawBackground = byteArray.readByte ();
               }
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  entityDefine.mBorderColor = byteArray.readUnsignedInt ();
                  entityDefine.mBorderThickness = byteArray.readByte ();
                  entityDefine.mBackgroundColor = byteArray.readUnsignedInt ();
                  entityDefine.mTransparency = byteArray.readByte ();
               }
               
               if (worldDefine.mVersion >= 0x0105)
               {
                  entityDefine.mBorderTransparency = byteArray.readByte ();
               }
               
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  if (worldDefine.mVersion >= 0x0105)
                  {
                     entityDefine.mAiType = byteArray.readByte ();
                     entityDefine.mIsPhysicsEnabled = byteArray.readByte ();
                     
                     // the 2 lines are added in v1,04, and moved down from v1.05
                     /////entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
                     /////entityDefine.mIsSensor = byteArray.readByte ();
                  }
                  else if (worldDefine.mVersion >= 0x0104)
                  {
                     entityDefine.mAiType = byteArray.readByte ();
                     entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
                     entityDefine.mIsPhysicsEnabled = byteArray.readByte ();
                     entityDefine.mIsSensor = byteArray.readByte ();
                  }
                  else
                  {
                     if (worldDefine.mVersion >= 0x0102)
                     {
                        entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
                     }
                     
                     entityDefine.mAiType = byteArray.readByte ();
                     
                     entityDefine.mIsPhysicsEnabled = true;
                     // entityDefine.mIsSensor = true; // will be set in FillMissedFieldsInWorldDefine
                  }
                  
                  if (entityDefine.mIsPhysicsEnabled)
                  {
                     entityDefine.mIsStatic = byteArray.readByte ();
                     entityDefine.mIsBullet = byteArray.readByte ();
                     entityDefine.mDensity = byteArray.readFloat ();
                     entityDefine.mFriction = byteArray.readFloat ();
                     entityDefine.mRestitution = byteArray.readFloat ();
                     
                     if (worldDefine.mVersion >= 0x0105)
                     {
                        // the 2 lines are added in v1,04, and moved here from above from v1.05
                        entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
                        entityDefine.mIsSensor = byteArray.readByte ();
                        
                        // ...
                        entityDefine.mIsHollow = byteArray.readByte ();
                     }
                  }
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entityDefine.mRadius = byteArray.readFloat ();
                     entityDefine.mAppearanceType = byteArray.readByte ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     entityDefine.mHalfWidth = byteArray.readFloat ();
                     entityDefine.mHalfHeight = byteArray.readFloat ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     entityDefine.mLocalPoints = new Array ( byteArray.readShort () );
                     
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        entityDefine.mLocalPoints [vertexId] = new Point (
                                          byteArray.readFloat (),
                                          byteArray.readFloat ()
                                       );
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     entityDefine.mCurveThickness = byteArray.readByte ();
                     
                     entityDefine.mLocalPoints = new Array ( byteArray.readShort () );
                     
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        entityDefine.mLocalPoints [vertexId] = new Point (
                                          byteArray.readFloat (),
                                          byteArray.readFloat ()
                                       );
                     }
                  }
               }
               else // not physis shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     entityDefine.mText = byteArray.readUTF ();
                     entityDefine.mAutofitWidth = byteArray.readByte ();
                     
                     entityDefine.mHalfWidth = byteArray.readFloat ();
                     entityDefine.mHalfHeight = byteArray.readFloat ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     entityDefine.mRadius = byteArray.readFloat ();
                     
                     if (worldDefine.mVersion >= 0x0105)
                     {
                        entityDefine.mInteractiveZones = byteArray.readByte ();
                        entityDefine.mInteractiveConditions = byteArray.readShort ();
                     }
                     else
                     {
                        // mIsInteractive is removed from v1.05.
                        // in FillMissedFieldsInWorldDefine (), mIsInteractive will be converted to mInteractiveZones
                        entityDefine.mIsInteractive = byteArray.readByte ();
                     }
                     
                     entityDefine.mInitialGravityAcceleration = byteArray.readFloat ();
                     entityDefine.mInitialGravityAngle = byteArray.readShort ();
                  }
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               entityDefine.mCollideConnected = byteArray.readByte ();
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  entityDefine.mConnectedShape1Index = byteArray.readShort ();
                  entityDefine.mConnectedShape2Index = byteArray.readShort ();
               }
               else if (worldDefine.mVersion >= 0x0102) // ??!! why bytes?
               {
                  entityDefine.mConnectedShape1Index = byteArray.readByte ();
                  entityDefine.mConnectedShape2Index = byteArray.readByte ();
               }
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mAnchorEntityIndex = byteArray.readShort ();
                  
                  entityDefine.mEnableLimits = byteArray.readByte ();
                  entityDefine.mLowerAngle = byteArray.readFloat ();
                  entityDefine.mUpperAngle = byteArray.readFloat ();
                  entityDefine.mEnableMotor = byteArray.readByte ();
                  entityDefine.mMotorSpeed = byteArray.readFloat ();
                  entityDefine.mBackAndForth = byteArray.readByte ();
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     entityDefine.mMaxMotorTorque = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
                  
                  entityDefine.mEnableLimits = byteArray.readByte ();
                  entityDefine.mLowerTranslation = byteArray.readFloat ();
                  entityDefine.mUpperTranslation = byteArray.readFloat ();
                  entityDefine.mEnableMotor = byteArray.readByte ();
                  entityDefine.mMotorSpeed = byteArray.readFloat ();
                  entityDefine.mBackAndForth = byteArray.readByte ();
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     entityDefine.mMaxMotorForce = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
                  
                  entityDefine.mStaticLengthRatio = byteArray.readFloat ();
                  //entityDefine.mFrequencyHz = byteArray.readFloat ();
                  entityDefine.mSpringType = byteArray.readByte ();
                  
                  entityDefine.mDampingRatio = byteArray.readFloat ();
               }
            }
            
            worldDefine.mEntityDefines.push (entityDefine);
         }
         
         // ...
         
         var numGroups:int = byteArray.readShort ();
         var numEntityIds:int;
         
         var groupId:int;
         
         for (groupId = 0; groupId < numGroups; ++ groupId)
         {
            var brotherIDs:Array = new Array ();
            
            numEntityIds = byteArray.readShort ();
            
            for (entityId = 0; entityId < numEntityIds; ++ entityId)
            {
               brotherIDs.push (byteArray.readShort ());
            }
            
            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         
         
         return worldDefine;
      }
      
      public static function HexString2WorldDefine (hexString:String):WorldDefine
      {
         return ByteArray2WorldDefine ( HexString2ByteArray (hexString) );
      }
      
      public static function HexString2ByteArray (hexString:String):ByteArray
      {
         if (hexString == null)
            return null;
         
         hexString = De (hexString);
         
         var byteArray:ByteArray = new ByteArray ();
         byteArray.length = hexString.length / 2;
         
         var index:int = 0;
         
         for (var ci:int = 0; ci < hexString.length; ci += 2)
         {
            byteArray [index ++] = ParseByteFromHexString (hexString.substr (ci, 2));
         }
         
         return byteArray;
      }
      
      public static function ParseByteFromHexString (hexString:String):int
      {
         if (hexString == null || hexString.length != 2)
            return NaN;
         
         var byteValue:int = parseInt (hexString, 16);
         //if ( isNaN (byteValue))
         //{
         //   byteValue -= 128;
         //}
         
         return byteValue;
      }
      
      public static const Value2CharTable:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.";
      
      public static function Value2Char (value:int, num:uint = 1):String
      {
         if (value < 0 || value >= 16 || num > 4 || num <= 0)
            return "?";
         
         return Value2CharTable.charAt (value + (num - 1) * 16);
      }
      
      public static var Char2ValueTable:Array = null;
      
      public static function Char2Value (charCode:int):int
      {
         if (Char2ValueTable == null)
         {
            Char2ValueTable = new Array (128);
            for (var i:int = 0; i < Char2ValueTable.length; ++ i)
               Char2ValueTable [i] = -1;
            for (var k:int = 0; k < Value2CharTable.length; ++ k)
               Char2ValueTable [Value2CharTable.charCodeAt (k)] = k;
         }
         
         if (charCode < 0 || charCode >= Char2ValueTable.length)
            return -1;
         
         return Char2ValueTable [charCode];
      }
      
      public static function De (enStr:String):String
      {
         var str:String = "";
         
         var char:String;
         var value:int;
         var num:int;
         for (var i:int = 0; i < enStr.length; ++ i)
         {
            value = Char2Value (enStr.charCodeAt (i));
            
            if (value >= 0 && value < 64)
            {
               num = ( (value & 0x3F) >> 4 ) + 1;
               value = value & 0xF;
               
               char =  Value2Char (value);
               for (var k:int = 0; k < num; ++ k)
                  str = str + char;
            }
            else
            {
               trace ("De str error! pos = " + i + ", value = " + value + ", char = " +  enStr.charAt (i));
               break;
            }
         }
         
         return str;
      }
      
//====================================================================================
//   
//====================================================================================
      
      public static function WorldDefine2Xml (worldDefine:WorldDefine):XML
      {
         // from v1,03
         FillMissedFieldsInWorldDefine (worldDefine);
         DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         
         // ...
         var xml:XML = <World />;
         
         var element:Object;
         
         // basic
         {
            xml.@app_id  = "COIN";
            xml.@version = uint(worldDefine.mVersion).toString (16);
            xml.@author_name = worldDefine.mAuthorName;
            xml.@author_homepage = worldDefine.mAuthorHomepage;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               xml.@share_source_code = worldDefine.mShareSourceCode ? 1 : 0;
               xml.@permit_publishing = worldDefine.mPermitPublishing ? 1 : 0;
            }
         }
         
         xml.Settings = <Settings />
         var Setting:Object;
         
         // settings
         if (worldDefine.mVersion >= 0x0104)
         {
            element = IntSetting2XmlElement ("camera_center_x", worldDefine.mSettings.mCameraCenterX);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("camera_center_y", worldDefine.mSettings.mCameraCenterY);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("world_left", worldDefine.mSettings.mWorldLeft);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("world_top", worldDefine.mSettings.mWorldTop);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("world_width", worldDefine.mSettings.mWorldWidth);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("world_height", worldDefine.mSettings.mWorldHeight);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("background_color", worldDefine.mSettings.mBackgroundColor, true);
            xml.Settings.appendChild (element);
            
            element = BoolSetting2XmlElement ("build_border", worldDefine.mSettings.mBuildBorder);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("border_color", worldDefine.mSettings.mBorderColor, true);
            xml.Settings.appendChild (element);
         }
         
         if (worldDefine.mVersion >= 0x0106)
         {
            element = IntSetting2XmlElement ("physics_shapes_potential_max_count", worldDefine.mSettings.mPhysicsShapesPotentialMaxCount);
            xml.Settings.appendChild (element);
            
            element = IntSetting2XmlElement ("physics_shapes_population_density_level", worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel);
            xml.Settings.appendChild (element);
         }
         
         xml.Entities = <Entities />
         
         // entities
         var entityId:int;
         
         for (entityId = 0; entityId < worldDefine.mEntityDefines.length; ++ entityId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [entityId];
            element = EntityDefine2XmlElement (entityDefine, worldDefine);
            
            xml.Entities.appendChild (element);
         }
         
         // ...
         
         xml.BrotherGroups = <BrotherGroups />
         
         var groupId:int;
         var brotherIDs:Array;
         var idsStr:String;
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = worldDefine.mBrotherGroupDefines [groupId];
            
            idsStr = "";
            for (entityId = 0; entityId < brotherIDs.length; ++ entityId)
            {
               if (entityId != 0)
                  idsStr += ",";
               idsStr += brotherIDs [entityId];
            }
            
            element = <BrotherGroup />;
            element.@num_brothers = brotherIDs.length;
            element.@brother_indices = idsStr;
            xml.BrotherGroups.appendChild (element);
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            xml.CollisionCategories = <CollisionCategories />
            
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               element = <CollisionCategory />;
               element.@name = ccDefine.mName;
               element.@collide_internally = ccDefine.mCollideInternally ? 1 : 0;
               element.@x = ccDefine.mPosX;
               element.@y = ccDefine.mPosY;
               
               xml.CollisionCategories.appendChild (element);
            }
            
            xml.CollisionCategories.@default_category_index = worldDefine.mDefaultCollisionCategoryIndex;
            
            xml.CollisionCategoryFriendPairs = <CollisionCategoryFriendPairs />
            
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               element = <CollisionCategoryFriendPair />;
               element.@category1_index = pairDefine.mCollisionCategory1Index;
               element.@category2_index = pairDefine.mCollisionCategory2Index;
               xml.CollisionCategoryFriendPairs.appendChild (element);
            }
         }
         
         return xml;
      }
      
      private static function Int2ColorString (intValue:int):String
      {
         var strValue:String;
         strValue = "0x";
         var b:int;
         
         b = (intValue & 0x00FF0000) >> 16;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);
         
         b = (intValue & 0x0000FF00) >>  8;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);
         
         b = (intValue & 0x000000FF) >>  0;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);
         
         return strValue;
      }
      
      private static function IntSetting2XmlElement (settingName:String, settingValue:int, isColor:Boolean = false):Object
      {
         var strValue:String;
         if (isColor)
            strValue = Int2ColorString (settingValue);
         else
            strValue = "" + settingValue;
         
         return Setting2XmlElement (settingName, strValue);
      }
      
      private static function BoolSetting2XmlElement (settingName:String, settingValue:Boolean):Object
      {
         return Setting2XmlElement (settingName, settingValue ? "1" : "0");
      }
      
      private static function Setting2XmlElement (settingName:String, settingValue:String):Object
      {
         if ( ! (settingValue is String) )
            settingValue = settingValue.toString ();
         
         var element:Object = <Setting />; 
         element.@name = settingName; 
         element.@value = settingValue;
         
         return element;
      }
      
      public static function EntityDefine2XmlElement (entityDefine:Object, worldDefine:WorldDefine):Object
      {
         var vertexId:int;
         
         var elementLocalVertex:Object;
         
         var element:Object = <Entity />;
         element.@entity_type = entityDefine.mEntityType;
         element.@x = entityDefine.mPosX;
         element.@y = entityDefine.mPosY;
         element.@r = entityDefine.mRotation;
         element.@visible = entityDefine.mIsVisible ? 1 : 0;
         
         if ( Define.IsUtilityEntity (entityDefine.mEntityType) ) // from v1.05
         {
            if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
            {
            }
         }
         else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               element.@draw_border = entityDefine.mDrawBorder ? 1 : 0;
               element.@draw_background = entityDefine.mDrawBackground ? 1 : 0;
            }
            
            if (worldDefine.mVersion >= 0x0104)
            {
               element.@border_color = Int2ColorString (entityDefine.mBorderColor);
               element.@border_thickness = entityDefine.mBorderThickness;
               element.@background_color = Int2ColorString (entityDefine.mBackgroundColor);
               element.@transparency = entityDefine.mTransparency;
            }
            
            if (worldDefine.mVersion >= 0x0105)
            {
               element.@border_transparency = entityDefine.mBorderTransparency;
            }
            
            if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
            {
               element.@ai_type = entityDefine.mAiType;
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  element.@enable_physics = entityDefine.mIsPhysicsEnabled ? 1 : 0;
                  
                  // move down from v1.05
                  /////element.@is_sensor = entityDefine.mIsSensor ? 1 : 0;
               }
               
               if (entityDefine.mIsPhysicsEnabled)  // always true before v1.04
               {
                  if (worldDefine.mVersion >= 0x0102)
                  {
                     element.@collision_category_index = entityDefine.mCollisionCategoryIndex;
                  }
                  
                  element.@is_static = entityDefine.mIsStatic ? 1 : 0;
                  element.@is_bullet = entityDefine.mIsBullet ? 1 : 0;
                  element.@density = entityDefine.mDensity;
                  element.@friction = entityDefine.mFriction;
                  element.@restitution = entityDefine.mRestitution;
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     // add in v1,04, move here from above from v1.05
                     element.@is_sensor = entityDefine.mIsSensor ? 1 : 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0105)
                  {
                     element.@is_hollow = entityDefine.mIsHollow ? 1 : 0;
                  }
               }
               
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  element.@radius = entityDefine.mRadius;
                  element.@appearance_type = entityDefine.mAppearanceType;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  element.@half_width = entityDefine.mHalfWidth;
                  element.@half_height = entityDefine.mHalfHeight;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
               {
                  element.LocalVertices = <LocalVertices />
                  
                  for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                  {
                     elementLocalVertex = <Vertex />;
                     elementLocalVertex.@x = entityDefine.mLocalPoints [vertexId].x;
                     elementLocalVertex.@y = entityDefine.mLocalPoints [vertexId].y;
                     
                     element.LocalVertices.appendChild (elementLocalVertex);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
               {
                  element.@curve_thickness = entityDefine.mCurveThickness;
                  
                  element.LocalVertices = <LocalVertices />
                  
                  for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                  {
                     elementLocalVertex = <Vertex />;
                     elementLocalVertex.@x = entityDefine.mLocalPoints [vertexId].x;
                     elementLocalVertex.@y = entityDefine.mLocalPoints [vertexId].y;
                     
                     element.LocalVertices.appendChild (elementLocalVertex);
                  }
               }
            }
            else // not physics shape
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText)
               {
                  element.@text = entityDefine.mText;
                  element.@autofit_width = entityDefine.mAutofitWidth ? 1 : 0;
                  
                  element.@half_width = entityDefine.mHalfWidth;
                  element.@half_height = entityDefine.mHalfHeight;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
               {
                  element.@radius = entityDefine.mRadius;
                  
                  if (worldDefine.mVersion >= 0x0105)
                  {
                     element.@interactive_zones = ( int(entityDefine.mInteractiveZones) ).toString(2);
                     element.@interactive_conditions = ( int(entityDefine.mInteractiveConditions) ).toString(2);
                  }
                  else
                  {
                     element.@interactive = entityDefine.mIsInteractive ? 1 : 0;
                  }
                  
                  element.@initial_gravity_acceleration = entityDefine.mInitialGravityAcceleration;
                  element.@initial_gravity_angle = entityDefine.mInitialGravityAngle;
               }
            }
         }
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            element.@collide_connected = entityDefine.mCollideConnected ? 1 : 0;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               element.@connected_shape1_index = entityDefine.mConnectedShape1Index;
               element.@connected_shape2_index = entityDefine.mConnectedShape2Index;
            }
            
            if (entityDefine.mEntityType == Define.EntityType_JointHinge)
            {
               element.@anchor_index = entityDefine.mAnchorEntityIndex;
               
               element.@enable_limits = entityDefine.mEnableLimits ? 1 : 0;
               element.@lower_angle = entityDefine.mLowerAngle;
               element.@upper_angle = entityDefine.mUpperAngle;
               element.@enable_motor = entityDefine.mEnableMotor ? 1 : 0;
               element.@motor_speed = entityDefine.mMotorSpeed;
               element.@back_and_forth = entityDefine.mBackAndForth ? 1 : 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  element.@max_motor_torque = entityDefine.mMaxMotorTorque;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
               
               element.@enable_limits = entityDefine.mEnableLimits ? 1 : 0;
               element.@lower_translation = entityDefine.mLowerTranslation;
               element.@upper_translation = entityDefine.mUpperTranslation;
               element.@enable_motor = entityDefine.mEnableMotor ? 1 : 0;
               element.@motor_speed = entityDefine.mMotorSpeed;
               element.@back_and_forth = entityDefine.mBackAndForth ? 1: 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  element.@max_motor_force = entityDefine.mMaxMotorForce;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
               
               element.@static_length_ratio = entityDefine.mStaticLengthRatio;
               //element.@frequency_hz = entityDefine.mFrequencyHz;
               element.@spring_type = entityDefine.mSpringType;
               
               element.@damping_ratio = entityDefine.mDampingRatio;
            }
         }
         
         return element;
      }
      
//====================================================================================
//   
//====================================================================================
      
      // adjust some float numbers
      
      public static function AdjustNumberValuesInWorldDefine (worldDefine:WorldDefine, isForPlayer:Boolean = false):void
      {
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            var numCategories:int = worldDefine.mCollisionCategoryDefines.length;
            for (var ccId:int = 0; ccId < numCategories; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               ccDefine.mPosX = ValueAdjuster.Number2Precision (ccDefine.mPosX, 6);
               ccDefine.mPosY = ValueAdjuster.Number2Precision (ccDefine.mPosY, 6);
            }
         }
         
         // entities
         
         var numEntities:int = worldDefine.mEntityDefines.length;
         
         var entityId:int;
         var vertexId:int;
         
         for (entityId = 0; entityId < numEntities; ++ entityId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [entityId];
            
            entityDefine.mPosX = ValueAdjuster.Number2Precision (entityDefine.mPosX, 12);
            entityDefine.mPosY = ValueAdjuster.Number2Precision (entityDefine.mPosY, 12);
            entityDefine.mRotation = ValueAdjuster.Number2Precision (entityDefine.mRotation, 6);
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mIsPhysicsEnabled)
                  {
                     entityDefine.mDensity = ValueAdjuster.Number2Precision (entityDefine.mDensity, 6);
                     entityDefine.mFriction = ValueAdjuster.Number2Precision (entityDefine.mFriction, 6);
                     entityDefine.mRestitution = ValueAdjuster.Number2Precision (entityDefine.mRestitution, 6);
                  }
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);
                     
                     if (isForPlayer)
                        entityDefine.mRadius = ValueAdjuster.AdjustCircleRadius (entityDefine.mRadius, worldDefine.mVersion);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     entityDefine.mHalfWidth = ValueAdjuster.Number2Precision (entityDefine.mHalfWidth, 6);
                     entityDefine.mHalfHeight = ValueAdjuster.Number2Precision (entityDefine.mHalfHeight, 6);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        entityDefine.mLocalPoints [vertexId].x = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].x, 6);
                        entityDefine.mLocalPoints [vertexId].y = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].y, 6);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        entityDefine.mLocalPoints [vertexId].x = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].x, 6);
                        entityDefine.mLocalPoints [vertexId].y = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].y, 6);
                     }
                  }
               }
               else // not physis shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     entityDefine.mHalfWidth = ValueAdjuster.Number2Precision (entityDefine.mHalfWidth, 6);
                     entityDefine.mHalfHeight = ValueAdjuster.Number2Precision (entityDefine.mHalfHeight, 6);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);
                     
                     entityDefine.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (entityDefine.mInitialGravityAcceleration, 6);
                  }
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mLowerAngle = ValueAdjuster.Number2Precision (entityDefine.mLowerAngle, 6);
                  entityDefine.mUpperAngle = ValueAdjuster.Number2Precision (entityDefine.mUpperAngle, 6);
                  entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);
                  
                  entityDefine.mMaxMotorTorque = ValueAdjuster.Number2Precision (entityDefine.mMaxMotorTorque, 6);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mLowerTranslation = ValueAdjuster.Number2Precision (entityDefine.mLowerTranslation, 6);
                  entityDefine.mUpperTranslation = ValueAdjuster.Number2Precision (entityDefine.mUpperTranslation, 6);
                  entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);
                  
                  entityDefine.mMaxMotorForce = ValueAdjuster.Number2Precision (entityDefine.mMaxMotorForce, 6);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mStaticLengthRatio = ValueAdjuster.Number2Precision (entityDefine.mStaticLengthRatio, 6);
                  
                  entityDefine.mDampingRatio = ValueAdjuster.Number2Precision (entityDefine.mDampingRatio, 6);
               }
            }
         }
      }
      
      // fill some missed fields in earliser versions
      
      public static function FillMissedFieldsInWorldDefine (worldDefine:WorldDefine):void
      {
         // setting
         
         if (worldDefine.mVersion < 0x0102)
         {
            worldDefine.mShareSourceCode = false;
            worldDefine.mPermitPublishing = false;
         }
         
         if (worldDefine.mVersion < 0x0104)
         {
            worldDefine.mSettings.mWorldLeft = 0;
            worldDefine.mSettings.mWorldTop  = 0;
            worldDefine.mSettings.mWorldWidth = Define.DefaultWorldWidth;
            worldDefine.mSettings.mWorldHeight = Define.DefaultWorldHeight;
            worldDefine.mSettings.mCameraCenterX = worldDefine.mSettings.mWorldLeft + Define.DefaultWorldWidth * 0.5
            worldDefine.mSettings.mCameraCenterY = worldDefine.mSettings.mWorldTop + Define.DefaultWorldHeight * 0.5;
            worldDefine.mSettings.mBackgroundColor = 0xDDDDA0;
            worldDefine.mSettings.mBuildBorder = true;
            worldDefine.mSettings.mBorderColor = Define.ColorStaticObject;
         }
         
         if (worldDefine.mVersion < 0x0101)
         {
            worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = 512;
            worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 8;
         }
         else if (worldDefine.mVersion < 0x0104)
         {
            worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = 1024;
            worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 8;
         }
         else if (worldDefine.mVersion < 0x0105)
         {
            worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = 2048;
            worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 8;
         }
         else if (worldDefine.mVersion < 0x0106)
         {
            worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = 4096;
            worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 4;
         }
         
         // collision category
         
         // entities
         
         var numEntities:int = worldDefine.mEntityDefines.length;
         
         var entityId:int;
         var vertexId:int;
         
         for (entityId = 0; entityId < numEntities; ++ entityId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [entityId];
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
               }
               else // not physis shape
               {
                  entityDefine.mAiType = Define.ShapeAiType_Unknown;
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     if (worldDefine.mVersion < 0x0105)
                     {
                        entityDefine.mInteractiveZones = entityDefine.mIsInteractive ? (1 << Define.GravityController_InteractiveZone_AllArea) : 0;
                        entityDefine.mInteractiveConditions = 0;
                     }
                  }
               }
               
               // some if(s) put below for the mAiType would be adjust in above code block
               
               if (worldDefine.mVersion < 0x0102)
               {
                  entityDefine.mCollisionCategoryIndex = Define.CollisionCategoryId_HiddenCategory;
                  
                  entityDefine.mDrawBorder = (! entityDefine.mIsStatic) || Define.IsBreakableShape (entityDefine.mAiType);
                  entityDefine.mDrawBackground = true;
               }
               
               if (worldDefine.mVersion < 0x0104)
               {
                  entityDefine.mIsPhysicsEnabled = true;
                  entityDefine.mIsSensor = false;
                  
                  entityDefine.mBorderColor = 0x0;
                  entityDefine.mBorderThickness = 1;
                  entityDefine.mBackgroundColor = Define.GetShapeFilledColor (entityDefine.mAiType);
                  entityDefine.mTransparency = 100;
               }
               
               if (worldDefine.mVersion < 0x0105)
               {
                  entityDefine.mBorderTransparency = entityDefine.mTransparency;
                  entityDefine.mIsHollow = false;
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  if (worldDefine.mVersion < 0x0104)
                     entityDefine.mMaxMotorTorque = Define.DefaultHingeMotorTorque;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  if (worldDefine.mVersion < 0x0104)
                     entityDefine.mMaxMotorForce = Define.DefaultSliderMotorForce;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
               }
               
               if (worldDefine.mVersion < 0x0102)
               {
                  entityDefine.mConnectedShape1Index = Define.EntityId_None;
                  entityDefine.mConnectedShape2Index = Define.EntityId_None;
               }
            }
         }
      }
      
      
      
   }
   
}