
package common {

   import flash.utils.ByteArray;
   import flash.geom.Point;
   
   import com.tapirgames.util.TextUtil;

   import player.design.Global;
   import player.world.World;

   import player.entity.EntityBody;

   import player.entity.Entity;

   import player.entity.EntityVoid;

   import player.entity.EntityShape;
   import player.entity.EntityShapeCircle;
   import player.entity.EntityShapeRectangle;
   import player.entity.EntityShapePolygon;
   import player.entity.EntityShapePolyline;

   import player.entity.EntityShapeImageModule;

   import player.entity.EntityJoint;
   import player.entity.EntityJointHinge;
   import player.entity.EntityJointSlider;
   import player.entity.EntityJointDistance;
   import player.entity.EntityJointSpring;
   import player.entity.EntityJointWeld;
   import player.entity.EntityJointDummy;

   import player.entity.SubEntityJointAnchor;

   import player.entity.EntityShape_Text;
   import player.entity.EntityShape_TextButton;
   import player.entity.EntityShape_Camera;
   import player.entity.EntityShape_PowerSource;
   import player.entity.EntityShape_GravityController;
   import player.entity.EntityShape_CircleBomb;
   import player.entity.EntityShape_RectangleBomb;

   import player.trigger.entity.EntityLogic;
   import player.trigger.entity.EntityBasicCondition;
   import player.trigger.entity.EntityTask;
   import player.trigger.entity.EntityConditionDoor;
   import player.trigger.entity.EntityInputEntityAssigner;
   import player.trigger.entity.EntityInputEntityFilter;
   import player.trigger.entity.EntityAction;
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.entity.EntityEventHandler_Timer;
   import player.trigger.entity.EntityEventHandler_Keyboard;

   import player.trigger.data.ListElement_EventHandler;

   import player.trigger.FunctionDefinition_Custom;

   import common.trigger.define.FunctionDefine;
   import common.trigger.define.CodeSnippetDefine;
   //import common.trigger.define.VariableSpaceDefine;

   import common.trigger.ValueSpaceTypeDefine;

   import common.trigger.CoreEventIds;

   public class DataFormat2
   {

//===========================================================================
// define -> world
//===========================================================================

      public static function CreateEntityInstance (playerWorld:World, entityDefine:Object):Entity
      {
         var entity:Entity = null;

         switch (entityDefine.mEntityType)
         {
         // basic shapes

            case Define.EntityType_ShapeCircle:
               if (entityDefine.mAiType == Define.ShapeAiType_Bomb)
                  entity = new EntityShape_CircleBomb (playerWorld);
               else
                  entity = new EntityShapeCircle (playerWorld);
               break;
            case Define.EntityType_ShapeRectangle:
               if (entityDefine.mAiType == Define.ShapeAiType_Bomb)
                  entity = new EntityShape_RectangleBomb (playerWorld);
               else
                  entity = new EntityShapeRectangle (playerWorld);
               break;
            case Define.EntityType_ShapePolygon:
               entity = new EntityShapePolygon (playerWorld);
               break;
            case Define.EntityType_ShapePolyline:
               entity = new EntityShapePolyline (playerWorld);
               break;

         // preset shapes

            case Define.EntityType_ShapeText:
               entity = new EntityShape_Text (playerWorld);
               break;
            case Define.EntityType_ShapeTextButton:
               entity = new EntityShape_TextButton (playerWorld);
               break;
            case Define.EntityType_UtilityCamera:
               entity = new EntityShape_Camera (playerWorld);
               break;
            case Define.EntityType_UtilityPowerSource:
               entity = new EntityShape_PowerSource (playerWorld);
               break;
            case Define.EntityType_ShapeGravityController:
               entity = new EntityShape_GravityController (playerWorld);
               break;

         // module shape
         
            case Define.EntityType_ShapeImageModule:
               entity = new EntityShapeImageModule (playerWorld);
               break;

         // basic joints

            case Define.EntityType_JointHinge:
               entity = new EntityJointHinge (playerWorld);
               break;
            case Define.EntityType_JointSlider:
               entity = new EntityJointSlider (playerWorld);
               break;
            case Define.EntityType_JointDistance:
               entity = new EntityJointDistance (playerWorld);
               break;
            case Define.EntityType_JointSpring:
               entity = new EntityJointSpring (playerWorld);
               break;
            case Define.EntityType_JointWeld:
               entity = new EntityJointWeld (playerWorld);
               break;
            case Define.EntityType_JointDummy:
               entity = new EntityJointDummy (playerWorld);
               break;

         // joint anchor

            case Define.SubEntityType_JointAnchor:
               entity = new SubEntityJointAnchor (playerWorld);
               break;

         // logic componnets

            case Define.EntityType_LogicCondition:
               entity = new EntityBasicCondition (playerWorld);
               break;
            case Define.EntityType_LogicTask:
               entity = new EntityTask (playerWorld);
               break;
            case Define.EntityType_LogicConditionDoor:
               entity = new EntityConditionDoor (playerWorld);
               break;
            case Define.EntityType_LogicInputEntityAssigner:
               entity = new EntityInputEntityAssigner (playerWorld, false);
               break;
            case Define.EntityType_LogicInputEntityPairAssigner:
               entity = new EntityInputEntityAssigner (playerWorld, true);
               break;
            case Define.EntityType_LogicInputEntityFilter:
               entity = new EntityInputEntityFilter (playerWorld, false);
               break;
            case Define.EntityType_LogicInputEntityPairFilter:
               entity = new EntityInputEntityFilter (playerWorld, true);
               break;
            case Define.EntityType_LogicAction:
               entity = new EntityAction (playerWorld);
               break;
            case Define.EntityType_LogicEventHandler:
               var eventId:int = entityDefine.mEventId;
               switch (eventId)
               {
                  case CoreEventIds.ID_OnWorldTimer:
                  case CoreEventIds.ID_OnEntityTimer:
                  case CoreEventIds.ID_OnEntityPairTimer:
                     entity = new EntityEventHandler_Timer (playerWorld);
                     break;
                  case CoreEventIds.ID_OnWorldKeyDown:
                  case CoreEventIds.ID_OnWorldKeyUp:
                  case CoreEventIds.ID_OnWorldKeyHold:
                     entity = new EntityEventHandler_Keyboard (playerWorld);
                     break;
                  default:
                     entity = new EntityEventHandler (playerWorld);
                     break;
               }
               break;
            default:
            {
               trace ("unknown entity type: " + entityDefine.mEntityType);
               break;
            }
         }

         return entity;
      }

      // see Viewer.as to get why here use Object instead of WorldDefine
      // playerWorld != null for importing, otherwise for laoding
      public static function WorldDefine2PlayerWorld (defObject:Object, playerWorld:World = null):World
      {
         var worldDefine:WorldDefine = defObject as WorldDefine;

         var isLoaingFromStretch:Boolean = (playerWorld == null); // false for importing

         //trace ("WorldDefine2PlayerWorld");

         if (isLoaingFromStretch)
         {
            FillMissedFieldsInWorldDefine (worldDefine);
            if (worldDefine.mVersion >= 0x0103)
               DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine, true);
         }

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************

         // worldDefine.mVersion >= 0x0107
         if (worldDefine.mEntityAppearanceOrder.length != worldDefine.mEntityDefines.length)
         {
            throw new Error ("numCreationOrderIds != numEntities !");
            return null;
         }

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************

         if (isLoaingFromStretch)
         {
            //
            Global.InitGlobalData (worldDefine.mForRestartLevel);

            playerWorld = new World (worldDefine);
            Global.SetCurrentWorld (playerWorld);
         }

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************

         var numEntities:int = worldDefine.mEntityAppearanceOrder.length;
         var entityDefineArray:Array = worldDefine.mEntityDefines;
         var brotherGroupArray:Array = worldDefine.mBrotherGroupDefines;
         var createId:int;
         var appearId:int;
         var entityDefine:Object;
         var entity:Entity;
         var shape:EntityShape;
         var joint:EntityJoint;
         var logic:EntityLogic;

         var groupId:int;
         var brotherGroup:Array;
         var body:EntityBody;

   //*********************************************************************************************************************************
   // create entity instances by the visual layer order
   //*********************************************************************************************************************************

         // for history reason, entities are packaged by children order in editor world.
         // so the appearId is also the appearance order id

         // instance entities by appearance layer order, entities can register their visual elements in constructor

         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
            createId = worldDefine.mEntityAppearanceOrder [appearId];
            entityDefine = entityDefineArray [createId];

            // >> starts from version 1.01
            // >> deprecated from v1.56
            //entityDefine.mWorldDefine = worldDefine;
            // <<

            //>>from v1.07
            entityDefine.mAppearanceOrderId = appearId;
            entityDefine.mCreationOrderId = createId;
            //<<

            entityDefine.mBodyId = -1;

            entity = CreateEntityInstance (playerWorld, entityDefine);

            if (entity == null)
            {
               trace ("entity is not instanced!");
            }
            else
            {
               entityDefine.mEntity = entity;
            }
         }

      // register entities by order of creation id

         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = entityDefineArray [createId];
            entity = entityDefine.mEntity;

            if (entity != null)
            {
               if (isLoaingFromStretch)
               {
                  entity.Register (entityDefine.mCreationOrderId, entityDefine.mAppearanceOrderId);
               }
               else
               {
                  entity.Register (-1, -1);
                  entityDefine.mCreationOrderId = entity.GetCreationId ();
               }
            }
         }

      // init custom variables / correct entity refernce ids

         if (isLoaingFromStretch)
         {
            //Global.InitCustomVariables (worldDefine.mGlobalVariableSpaceDefines, worldDefine.mEntityPropertySpaceDefines); // v1.52 only
            Global.InitCustomVariables (worldDefine.mGlobalVariableDefines, worldDefine.mEntityPropertyDefines, worldDefine.mSessionVariableDefines);
         }
         else
         {
            for (createId = 0; createId < numEntities; ++ createId)
            {
               entityDefine = entityDefineArray [createId];
               entity = entityDefine.mEntity;

               if (Define.IsPhysicsJointEntity (entityDefine.mEntityType))
               {
                  if (entityDefine.mConnectedShape1Index >= 0)
                     entityDefine.mConnectedShape1Index = ((entityDefineArray [entityDefine.mConnectedShape1Index] as Object).mEntity as Entity).GetCreationId ();
                  if (entityDefine.mConnectedShape2Index >= 0)
                     entityDefine.mConnectedShape2Index = ((entityDefineArray [entityDefine.mConnectedShape2Index] as Object).mEntity as Entity).GetCreationId ();

                  entityDefine.mAnchor1EntityIndex = ((entityDefineArray [entityDefine.mAnchor1EntityIndex] as Object).mEntity as Entity).GetCreationId ();
                  entityDefine.mAnchor2EntityIndex = ((entityDefineArray [entityDefine.mAnchor2EntityIndex] as Object).mEntity as Entity).GetCreationId ();
               }
            }
         }

      // init entity custom properties
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = entityDefineArray [createId];
            entity = entityDefine.mEntity;

            if (entity != null)
            {
               entity.InitCustomPropertyValues ();
            }
         }

      // custom functions

         if (isLoaingFromStretch)
         {
            Global.CreateCustomFunctionDefinitions (worldDefine.mFunctionDefines);

            var numFunctions:int = worldDefine.mFunctionDefines.length;
            for (var functionId:int = 0; functionId < numFunctions; ++ functionId)
            {
               var functionDefine:FunctionDefine = worldDefine.mFunctionDefines [functionId] as FunctionDefine;
               var codeSnippetDefine:CodeSnippetDefine = (functionDefine.mCodeSnippetDefine as CodeSnippetDefine).Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (playerWorld.GetCoordinateSystem ());

               var customFunction:FunctionDefinition_Custom = Global.GetCustomFunctionDefinition (functionId);
               customFunction.SetDesignDependent (functionDefine.mDesignDependent);
               customFunction.SetCodeSnippetDefine (codeSnippetDefine);
            }
         }
         else // Adjust Cloned Entities Z Order
         {
            for (createId = 0; createId < numEntities; ++ createId)
            {
               entityDefine = entityDefineArray [createId];
               entity = entityDefine.mEntity as Entity;
               var cloneFromEntity:Entity = entityDefine.mCloneFromEntity as Entity;

               if (entity != null && cloneFromEntity != null)
               {
                  entity.AdjustAppearanceOrder (cloneFromEntity, true);
               }
            }
         }
         
      // modules
         
         if (isLoaingFromStretch)
         {
            Global.CreateImageModules (worldDefine.mImageDefines, worldDefine.mPureImageModuleDefines, worldDefine.mAssembledModuleDefines, worldDefine.mSequencedModuleDefines);
         }

   //*********************************************************************************************************************************
   // create
   //*********************************************************************************************************************************

         for (var createStageId:int = 0; createStageId < Define.kNumCreateStages; ++ createStageId)
         {
            for (createId = 0; createId < numEntities; ++ createId)
            {
               entityDefine = entityDefineArray [createId];
               entity = entityDefine.mEntity;

               if (entity != null)
               {
                  entity.Create (createStageId, entityDefine);
               }
            }
         }

   //*********************************************************************************************************************************
   // register event handlers for entities
   //*********************************************************************************************************************************

         if (isLoaingFromStretch)
         {
            // moved to world.Init () now
            //playerWorld.RegisterEventHandlersForEntity (true); // for all entities placed in editor
         }
         else
         {
            // now, do it at the places where runtime-created entities are created.
            //for (createId = 0; createId < numEntities; ++ createId)
            //{
            //   entityDefine = entityDefineArray [createId];
            //   entity = entityDefine.mEntity; // if this name changed, remember also change it in CloneShape ()
            //
            //   if (entity != null)
            //   {
            //      playerWorld.RegisterEventHandlersForEntity (true, entity);
            //   }
            //}
         }

   //*********************************************************************************************************************************
   // create body for shapes, the created bodies have not build physics yet.
   // all bodies and entities_in_editor will also be registerd
   //*********************************************************************************************************************************

         var bortherId:int;

         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;

            body = new EntityBody (playerWorld);

            for (bortherId = 0; bortherId < brotherGroup.length; ++ bortherId)
            {
               createId = brotherGroup [bortherId];
               entityDefine = entityDefineArray [createId];
               entity = entityDefine.mEntity;

               if (entity is EntityShape)
               {
                  entityDefine.mBody = body;
               }
            }
         }

         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = entityDefineArray [createId];
            entity = entityDefine.mEntity;

            if (entity is EntityShape)
            {
               shape = entity as EntityShape;

               body = entityDefine.mBody;

               if (body == null) // for solo shapes
               {
                  body = new EntityBody (playerWorld);
                  entityDefine.mBody = body;
               }

               playerWorld.RegisterEntity (body);

               shape.SetBody (body);
            }
         }

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************

         // removed from here, for many functions such as Global.SetPlaying are not registerd yet.
         //playerWorld.Initialize ();

         return playerWorld;
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

         var element:XML;

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
         if (worldDefine.mVersion >= 0x0151)
         {
            element = IntSetting2XmlElement ("ui_flags", worldDefine.mSettings.mViewerUiFlags);
            xml.Settings.appendChild (element);
            element = IntSetting2XmlElement ("play_bar_color", worldDefine.mSettings.mPlayBarColor, true);
            xml.Settings.appendChild (element);
            element = IntSetting2XmlElement ("viewport_width", worldDefine.mSettings.mViewportWidth);
            xml.Settings.appendChild (element);
            element = IntSetting2XmlElement ("viewport_height", worldDefine.mSettings.mViewportHeight);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("zoom_scale", worldDefine.mSettings.mZoomScale, true);
            xml.Settings.appendChild (element);
         }

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

         if (worldDefine.mVersion >= 0x0106 && worldDefine.mVersion < 0x0108)
         {
            element = IntSetting2XmlElement ("physics_shapes_potential_max_count", worldDefine.mSettings.mPhysicsShapesPotentialMaxCount);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("physics_shapes_population_density_level", worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel);
            xml.Settings.appendChild (element);
         }

         if (worldDefine.mVersion >= 0x0108)
         {
            element = BoolSetting2XmlElement ("infinite_scene_size", worldDefine.mSettings.mIsInfiniteWorldSize);
            xml.Settings.appendChild (element);

            element = BoolSetting2XmlElement ("border_at_top_layer", worldDefine.mSettings.mBorderAtTopLayer);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_left_thinckness", worldDefine.mSettings.mWorldBorderLeftThickness);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_top_thinckness", worldDefine.mSettings.mWorldBorderTopThickness);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_right_thinckness", worldDefine.mSettings.mWorldBorderRightThickness);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_bottom_thinckness", worldDefine.mSettings.mWorldBorderBottomThickness);
            xml.Settings.appendChild (element);

            element = FloatSetting2XmlElement ("gravity_acceleration_magnitude", worldDefine.mSettings.mDefaultGravityAccelerationMagnitude);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("gravity_acceleration_angle", worldDefine.mSettings.mDefaultGravityAccelerationAngle);
            xml.Settings.appendChild (element);

            element = BoolSetting2XmlElement ("right_hand_coordinates", worldDefine.mSettings.mRightHandCoordinates);
            xml.Settings.appendChild (element);

            element = FloatSetting2XmlElement ("coordinates_origin_x", worldDefine.mSettings.mCoordinatesOriginX, true);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("coordinates_origin_y", worldDefine.mSettings.mCoordinatesOriginY, true);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("coordinates_scale", worldDefine.mSettings.mCoordinatesScale, true);
            xml.Settings.appendChild (element);

            element = BoolSetting2XmlElement ("ci_rules_enabled", worldDefine.mSettings.mIsCiRulesEnabled);
            xml.Settings.appendChild (element);
         }

         if (worldDefine.mVersion >= 0x0155)
         {
            element = BoolSetting2XmlElement ("auto_sleeping_enabled", worldDefine.mSettings.mAutoSleepingEnabled);
            xml.Settings.appendChild (element);
            element = BoolSetting2XmlElement ("camera_rotating_enabled", worldDefine.mSettings.mCameraRotatingEnabled);
            xml.Settings.appendChild (element);
         }

         // precreate some nodes

         xml.Entities = <Entities />

         if (worldDefine.mVersion >= 0x0107)
            xml.EntityAppearingOrder = <EntityAppearingOrder />;

         xml.BrotherGroups = <BrotherGroups />

         if (worldDefine.mVersion >= 0x0102)
            xml.CollisionCategories = <CollisionCategories />;

         if (worldDefine.mVersion >= 0x0152)
         {
            if (worldDefine.mVersion >= 0x0157)
            {
               xml.SessionVariables = <SessionVariables />;
            }
            
            xml.GlobalVariables = <GlobalVariables />;
            xml.EntityProperties = <EntityProperties />;
         }

         if (worldDefine.mVersion >= 0x0153)
            xml.CustomFunctions = <CustomFunctions />;

         if (worldDefine.mVersion >= 0x0158)
         {
            xml.Images = <Images />;
            xml.ImageDivisions = <ImageDivisions />;
            xml.AssembledModules = <AssembledModules />;
            xml.SequencedModules = <SequencedModules />;
         }

         //

         if (worldDefine.mVersion >= 0x0153)
         {
            for (var functionId:int = 0; functionId < worldDefine.mFunctionDefines.length; ++ functionId)
            {
               var functionDefine:FunctionDefine = worldDefine.mFunctionDefines [functionId] as FunctionDefine;

               element = <Function />;
               TriggerFormatHelper2.FunctionDefine2Xml (functionDefine, element, true, true, worldDefine.mFunctionDefines);

               element.@name = functionDefine.mName;
               element.@x = functionDefine.mPosX;
               element.@y = functionDefine.mPosY;
               if (worldDefine.mVersion >= 0x0156)
               {
                  element.@design_dependent = functionDefine.mDesignDependent ? 1 : 0;
               }

               xml.CustomFunctions.appendChild (element);
            }
         }

         // entities ...

         var appearId:int;
         var createId:int;

         var numEntities:int = worldDefine.mEntityDefines.length;

         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [createId];
            element = EntityDefine2XmlElement (entityDefine, worldDefine, createId);

            xml.Entities.appendChild (element);
         }

         // ...
         if (worldDefine.mVersion >= 0x0107)
         {
            xml.EntityAppearingOrder.@entity_indices = IntegerArray2IndicesString (worldDefine.mEntityAppearanceOrder);
         }

         // ...

         var groupId:int;
         var brotherIDs:Array;
         var idsStr:String;

         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = worldDefine.mBrotherGroupDefines [groupId];

            element = <BrotherGroup />;
            element.@num_brothers = brotherIDs.length;
            element.@brother_indices = IntegerArray2IndicesString (brotherIDs);
            
            xml.BrotherGroups.appendChild (element);
         }

         // collision category

         if (worldDefine.mVersion >= 0x0102)
         {
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

         // custom variables

         if (worldDefine.mVersion >= 0x0152)
         {
            // v1.52 only
            //for (var globalSpaceId:int = 0; globalSpaceId < worldDefine.mGlobalVariableSpaceDefines.length; ++ globalSpaceId)
            //{
            //   element = TriggerFormatHelper2.VariableSpaceDefine2Xml (worldDefine.mGlobalVariableSpaceDefines [globalSpaceId]);
            //   xml.GlobalVariables.appendChild (element);
            //}
            //
            //for (var propertySpaceId:int = 0; propertySpaceId < worldDefine.mEntityPropertySpaceDefines.length; ++ propertySpaceId)
            //{
            //   element = TriggerFormatHelper2.VariableSpaceDefine2Xml (worldDefine.mEntityPropertySpaceDefines [propertySpaceId]);
            //   xml.EntityProperties.appendChild (element);
            //}
            //<<

            if (worldDefine.mVersion == 0x0152)
            {
               xml.GlobalVariables.VariablePackage = <VariablePackage />;
               //xml.GlobalVariables.VariablePackage.@name = "";
               //xml.GlobalVariables.VariablePackage.@package_id = 0;
               //xml.GlobalVariables.VariablePackage.@parent_package_id = -1;
               TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mGlobalVariableDefines, xml.GlobalVariables.VariablePackage[0], true);

               xml.EntityProperties.VariablePackage = <VariablePackage />;
               //xml.EntityProperties.VariablePackage.@name = "";
               //xml.EntityProperties.VariablePackage.@package_id = 0;
               //xml.EntityProperties.VariablePackage.@parent_package_id = -1;
               TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mEntityPropertyDefines, xml.EntityProperties.VariablePackage [0], true);
            }
            else
            {
               if (worldDefine.mVersion >= 0x0157)
               {
                  TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mSessionVariableDefines, xml.SessionVariables [0], true);
               }
               TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mGlobalVariableDefines, xml.GlobalVariables [0], true);
               TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mEntityPropertyDefines, xml.EntityProperties [0], true);
            }
         }
         
         if (worldDefine.mVersion >= 0x0158)
         {
            for (var imageId:int = 0; imageId < worldDefine.mImageDefines.length; ++ imageId)
            {
               var imageDefine:Object = worldDefine.mImageDefines [imageId];
               
               if (imageDefine.mFileData == null || imageDefine.mFileData.length == 0)
               {
                  element = <Image/>;
               }
               else
               {
                  var fileDataBase64:String = DataFormat3.EncodeByteArray2String (imageDefine.mFileData);
                  element = <Image>{fileDataBase64}</Image>;
               }
               element.@name = imageDefine.mName;
               //element.@file_data = imageDefine.mFileData;
               
               xml.Images.appendChild (element);
            }

            for (var divisionId:int = 0; divisionId < worldDefine.mPureImageModuleDefines.length; ++ divisionId)
            {
               var divisionDefine:Object = worldDefine.mPureImageModuleDefines [divisionId];

               element = <ImageDivision />;
               element.@image_index = divisionDefine.mImageIndex;
               element.@left = divisionDefine.mLeft;
               element.@top = divisionDefine.mTop;
               element.@right = divisionDefine.mRight;
               element.@bottom = divisionDefine.mBottom;
               
               xml.ImageDivisions.appendChild (element);
            }

            for (var assembledModuleId:int = 0; assembledModuleId < worldDefine.mAssembledModuleDefines.length; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];

               element = <AssembledModule />;
               
               ModuleInstanceDefines2XmlElements (assembledModuleDefine.mModulePartDefines, element, "ModulePart", false);
               
               xml.AssembledModules.appendChild (element);
            }

            for (var sequencedModuleId:int = 0; sequencedModuleId < worldDefine.mSequencedModuleDefines.length; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];

               element = <SequencedModule />;
               
               //element.@looped = sequencedModuleDefine.mIsLooped ? 1 : 0;
               ModuleInstanceDefines2XmlElements (sequencedModuleDefine.mModuleSequenceDefines, element, "ModuleSequence", true);
               
               xml.SequencedModules.appendChild (element);
            }
         }

         return xml;
      }
      
      public static function ModuleInstanceDefines2XmlElements (moduleInstanceDefines:Array, parentElement:XML, childElementName:String, forSequencedModule:Boolean):void
      {
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId]; 
            
            var element:XML = <TempName />; // new XML (); // weird as3
            element.setName (childElementName);
            
            element.@x = moduleInstanceDefine.mPosX;
            element.@y = moduleInstanceDefine.mPosY;
            element.@scale = moduleInstanceDefine.mScale;
            element.@flipped = moduleInstanceDefine.mIsFlipped ? 1 : 0;
            element.@r = moduleInstanceDefine.mRotation;
            element.@visible = moduleInstanceDefine.mVisible ? 1 : 0;
            element.@alpha = moduleInstanceDefine.mAlpha;
            
            if (forSequencedModule)
            {
               element.@duration = moduleInstanceDefine.mModuleDuration;
            }
            
            ModuleInstanceDefine2XmlElement (moduleInstanceDefine, element);
            
            parentElement.appendChild (element);
         }
      }
      
      public static function ModuleInstanceDefine2XmlElement (moduleInstanceDefine:Object, element:XML):void
      {
         element.@module_type = moduleInstanceDefine.mModuleType;
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            element.@shape_attribute_bits = moduleInstanceDefine.mShapeAttributeBits;
            element.@shape_body_argb = UInt2ColorString (moduleInstanceDefine.mShapeBodyOpacityAndColor);
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               element.@shape_path_thickness = moduleInstanceDefine.mShapePathThickness;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  LocalVertices2XmlElement (moduleInstanceDefine.mPolyLocalPoints, element);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               element.@shape_border_argb = UInt2ColorString (moduleInstanceDefine.mShapeBorderOpacityAndColor);
               element.@shape_border_thickness = moduleInstanceDefine.mShapeBorderThickness;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  element.@circle_radius = moduleInstanceDefine.mCircleRadius;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  element.@rect_half_width = moduleInstanceDefine.mRectHalfWidth;
                  element.@rect_half_height = moduleInstanceDefine.mRectHalfHeight;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  LocalVertices2XmlElement (moduleInstanceDefine.mPolyLocalPoints, element);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               element.@module_index = moduleInstanceDefine.mModuleIndex;
            }
         }
         else // ...
         {
         }
      }
      
      public static function ShapePhysicsProperties2Xml (element:XML, entityDefine:Object, worldDefine:WorldDefine):void
      {
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

            if (worldDefine.mVersion >= 0x0108)
            {
               element.@build_border = entityDefine.mBuildBorder ? 1 : 0;
               element.@sleeping_allowed = entityDefine.mIsSleepingAllowed ? 1 : 0;
               element.@rotation_fixed = entityDefine.mIsRotationFixed ? 1 : 0;
               element.@linear_velocity_magnitude = entityDefine.mLinearVelocityMagnitude;
               element.@linear_velocity_angle = entityDefine.mLinearVelocityAngle;
               element.@angular_velocity = entityDefine.mAngularVelocity;
            }
         }
      }

      public static function UInt2ColorString (intValue:uint):String
      {
         var strValue:String;
         strValue = "0x";
         var b:int;

         b = (intValue >> 24) & 0xFF;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);

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

      private static function IntSetting2XmlElement (settingName:String, settingValue:int, isColor:Boolean = false):XML
      {
         var strValue:String;
         if (isColor)
            strValue = UInt2ColorString (settingValue);
         else
            strValue = "" + settingValue;

         return Setting2XmlElement (settingName, strValue);
      }

      private static function BoolSetting2XmlElement (settingName:String, settingValue:Boolean):XML
      {
         return Setting2XmlElement (settingName, settingValue ? "1" : "0");
      }

      private static function FloatSetting2XmlElement (settingName:String, settingValue:Number, isDouble:Boolean = false):XML
      {
         var strValue:String;
         if (isDouble)
            strValue = "" + ValueAdjuster.Number2Precision (settingValue, 12)
         else
            strValue = "" + ValueAdjuster.Number2Precision (settingValue, 6)

         return Setting2XmlElement (settingName, strValue);
      }

      private static function Setting2XmlElement (settingName:String, settingValue:String):XML
      {
         if ( ! (settingValue is String) )
            settingValue = settingValue.toString ();

         var element:XML = <Setting />;
         element.@name = settingName;
         element.@value = settingValue;

         return element;
      }

      public static function EntityDefine2XmlElement (entityDefine:Object, worldDefine:WorldDefine, createId:int):XML
      {
         var vertexId:int;
         var i:int;
         var num:int;
         var creation_ids:Array;

         var element:XML = <Entity />;
         element.@id = createId; // for debug using only
         element.@entity_type = entityDefine.mEntityType;
         element.@x = entityDefine.mPosX;
         element.@y = entityDefine.mPosY;
         //>>from v1.58
         element.@scale = entityDefine.mScale;
         element.@flipped = entityDefine.mIsFlipped ? 1 : 0;
         //<<
         element.@r = entityDefine.mRotation;
         element.@visible = entityDefine.mIsVisible ? 1 : 0;

         //>>from v1.08
         element.@alpha = entityDefine.mAlpha;
         element.@enabled = entityDefine.mIsEnabled ? 1 : 0;
         //<<

         if (worldDefine.mVersion >= 0x0108)
         {
            element.@alpha = entityDefine.mAlpha;
            element.@active = entityDefine.mIsEnabled ? 1 : 0;
         }

         if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
         {
            // from v1.05
            if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
            {
               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@followed_target = entityDefine.mFollowedTarget;
                  element.@following_style = entityDefine.mFollowingStyle;
               }
            }
            //<<
            //>>from v1.10
            else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
            {
               element.@power_source_type = entityDefine.mPowerSourceType;
               element.@power_magnitude = entityDefine.mPowerMagnitude;
               element.@keyboard_event_id = entityDefine.mKeyboardEventId;
               element.@key_codes = IntegerArray2IndicesString (entityDefine.mKeyCodes);
            }
            //<<
         }
         else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
         {
            if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
            {
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, worldDefine.mFunctionDefines);
               else
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, false, worldDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
            {
               element.@assigner_indices = IntegerArray2IndicesString (entityDefine.mInputAssignerCreationIds);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
            {
               element.@is_and = entityDefine.mIsAnd ? 1 : 0;
               element.@is_not = entityDefine.mIsNot ? 1 : 0;

               element.Conditions = <Conditions />;

               var target_values:Array = entityDefine.mInputConditionTargetValues;
               creation_ids = entityDefine.mInputConditionEntityCreationIds;
               num = creation_ids.length;
               if (num > target_values.length)
                  num = target_values.length;
               var elementCondition:XML;
               for (i = 0; i < num; ++ i)
               {
                  elementCondition = <Condition />;
                  elementCondition.@entity_index = creation_ids [i];
                  elementCondition.@target_value = target_values [i];

                  element.Conditions.appendChild (elementCondition);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
            {
               element.@selector_type = entityDefine.mSelectorType;
               element.@entity_indices = IntegerArray2IndicesString (entityDefine.mEntityCreationIds);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
            {
               element.@pairing_type = entityDefine.mPairingType;
               element.@entity_indices1 =  IntegerArray2IndicesString (entityDefine.mEntityCreationIds1);
               element.@entity_indices2 =  IntegerArray2IndicesString (entityDefine.mEntityCreationIds2);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
            {
               element.@event_id = entityDefine.mEventId;
               element.@input_condition_entity_index = entityDefine.mInputConditionEntityCreationId;
               element.@input_condition_target_value = entityDefine.mInputConditionTargetValue;
               element.@assigner_indices = IntegerArray2IndicesString (entityDefine.mInputAssignerCreationIds);

               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@external_action_entity_index = entityDefine.mExternalActionEntityCreationId;
               }

               if (worldDefine.mVersion >= 0x0108)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        element.@running_interval = entityDefine.mRunningInterval;
                        element.@only_run_once = entityDefine.mOnlyRunOnce ? 1 : 0;

                        if (worldDefine.mVersion >= 0x0156)
                        {
                           if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                           {
                              var preHandlingCodeSnippetXML:XML = <PreHandlingCodeSnippet/>
                              TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mPreFunctionDefine as FunctionDefine, element, false, true, worldDefine.mFunctionDefines, false, preHandlingCodeSnippetXML);
                              var postHandlingCodeSnippetXML:XML = <PostHandlingCodeSnippet/>
                              TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mPostFunctionDefine as FunctionDefine, element, false, true, worldDefine.mFunctionDefines, false, postHandlingCodeSnippetXML);
                           }
                        }

                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        element.@key_codes = IntegerArray2IndicesString (entityDefine.mKeyCodes);
                        break;
                     default:
                        break;
                  }
               }

               if (worldDefine.mVersion >= 0x0153)
               {
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, worldDefine.mFunctionDefines);
               }
               else
               {
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, false, worldDefine.mFunctionDefines);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
            {
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, worldDefine.mFunctionDefines);
               else
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, false, worldDefine.mFunctionDefines);
            }
            //>>from v1.56
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
            {
               TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, worldDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
            {
               TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, worldDefine.mFunctionDefines);
            }
            //<<
         }
         else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               element.@draw_border = entityDefine.mDrawBorder ? 1 : 0;
               element.@draw_background = entityDefine.mDrawBackground ? 1 : 0;
            }

            if (worldDefine.mVersion >= 0x0104)
            {
               element.@border_color = UInt2ColorString (entityDefine.mBorderColor);
               element.@border_thickness = entityDefine.mBorderThickness;
               element.@background_color = UInt2ColorString (entityDefine.mBackgroundColor);

               if (worldDefine.mVersion >= 0x0107)
                  element.@background_opacity = entityDefine.mTransparency;
               else
                  element.@transparency = entityDefine.mTransparency;
            }

            if (worldDefine.mVersion >= 0x0105)
            {
               if (worldDefine.mVersion >= 0x0107)
                  element.@border_opacity = entityDefine.mBorderTransparency;
               else
                  element.@border_transparency = entityDefine.mBorderTransparency;
            }

            if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
            {
               element.@ai_type = entityDefine.mAiType;
               
               // ...
               ShapePhysicsProperties2Xml (element, entityDefine, worldDefine);
               
               // ...
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  element.@radius = entityDefine.mRadius;
                  element.@appearance_type = entityDefine.mAppearanceType;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     element.@round_corners = entityDefine.mIsRoundCorners ? 1 : 0;
                  }

                  element.@half_width = entityDefine.mHalfWidth;
                  element.@half_height = entityDefine.mHalfHeight;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
               {
                  LocalVertices2XmlElement (entityDefine.mLocalPoints, element);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
               {
                  element.@curve_thickness = entityDefine.mCurveThickness;

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     element.@round_ends = entityDefine.mIsRoundEnds ? 1 : 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0157)
                  {
                     element.@closed = entityDefine.mIsClosed ? 1 : 0
                  }

                  LocalVertices2XmlElement (entityDefine.mLocalPoints, element);
               }
            }
            else // not physics shape
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText
                  || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                  )
               {
                  element.@text = entityDefine.mText;
                  if (worldDefine.mVersion < 0x0108)
                     element.@autofit_width = entityDefine.mWordWrap ? 1 : 0;
                  else
                     element.@word_wrap = entityDefine.mWordWrap ? 1 : 0;

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     element.@adaptive_background_size = entityDefine.mAdaptiveBackgroundSize ? 1 : 0;
                     element.@text_color = UInt2ColorString (entityDefine.mTextColor);
                     element.@font_size = entityDefine.mFontSize;
                     element.@bold = entityDefine.mIsBold ? 1 : 0;
                     element.@italic = entityDefine.mIsItalic ? 1 : 0;
                  }

                  if (worldDefine.mVersion >= 0x0109)
                  {
                     element.@align = entityDefine.mTextAlign ;
                     element.@underlined = entityDefine.mIsUnderlined ? 1 : 0;
                  }

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                     {
                        element.@using_hand_cursor = entityDefine.mUsingHandCursor ? 1 : 0;

                        element.@draw_background_on_mouse_over = entityDefine.mDrawBackground_MouseOver ? 1 : 0;
                        element.@background_color_on_mouse_over = UInt2ColorString (entityDefine.mBackgroundColor_MouseOver);
                        element.@background_opacity_on_mouse_over = entityDefine.mBackgroundTransparency_MouseOver;

                        element.@draw_border_on_mouse_over = entityDefine.mDrawBorder_MouseOver ? 1 : 0;
                        element.@border_color_on_mouse_over = UInt2ColorString (entityDefine.mBorderColor_MouseOver);
                        element.@border_thickness_on_mouse_over = entityDefine.mBorderThickness_MouseOver;
                        element.@border_opacity_on_mouse_over = entityDefine.mBorderTransparency_MouseOver;
                     }
                  }

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

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     element.@maximal_gravity_acceleration = entityDefine.mMaximalGravityAcceleration;
                  }
               }
            }
         }
         //>> from v1.58
         else if (Define.IsShapeEntity (entityDefine.mEntityType))
         {
            if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
            {
               ShapePhysicsProperties2Xml (element, entityDefine, worldDefine);
               
               element.@module_index = entityDefine.mModuleIndex;
            }
         }
         //<<
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            element.@collide_connected = entityDefine.mCollideConnected ? 1 : 0;

            if (worldDefine.mVersion >= 0x0102)
            {
               element.@connected_shape1_index = entityDefine.mConnectedShape1Index;
               element.@connected_shape2_index = entityDefine.mConnectedShape2Index;
            }

            if (worldDefine.mVersion >= 0x0108)
            {
               element.@breakable = entityDefine.mBreakable ? 1 : 0;
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

               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@break_delta_length = entityDefine.mBreakDeltaLength;
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;

               element.@static_length_ratio = entityDefine.mStaticLengthRatio;
               //element.@frequency_hz = entityDefine.mFrequencyHz;
               element.@spring_type = entityDefine.mSpringType;

               element.@damping_ratio = entityDefine.mDampingRatio;

               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@frequency_determined_manner = entityDefine.mFrequencyDeterminedManner;
                  element.@frequency = entityDefine.mFrequency;
                  element.@spring_constant = entityDefine.mSpringConstant;
                  element.@break_extended_length = entityDefine.mBreakExtendedLength;
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
            {
               element.@anchor_index = entityDefine.mAnchorEntityIndex;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
            }
         }

         return element;
      }
      
      public static function LocalVertices2XmlElement (localPoints:Array, parentElement:XML):void
      {
         parentElement.LocalVertices = <LocalVertices />
         
         if (localPoints != null)
         {
            for (var vertexId:int = 0; vertexId < localPoints.length; ++ vertexId)
            {
               var elementLocalVertex:XML = <Vertex />;
               
               var point:Point = localPoints [vertexId] as Point;
               elementLocalVertex.@x = point.x;
               elementLocalVertex.@y = point.y;
   
               parentElement.LocalVertices.appendChild (elementLocalVertex);
            }
         }
      }

      public static function IntegerArray2IndicesString (ids:Array):String
      {
         if (ids == null)
            return "";

         var num:int = ids.length;
         if (num < 1)
            return "";

         var indicesStr:String = "" + ids [0];
         for (var i:int = 1; i < num; ++ i)
         {
            indicesStr += ",";
            indicesStr += ids [i];
         }

         return indicesStr;
      }
      
//===================================================================================
// 
//===================================================================================

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
            if (worldDefine.mVersion >= 0x0151)
            {
               worldDefine.mSettings.mViewerUiFlags = byteArray.readInt ();
               worldDefine.mSettings.mPlayBarColor  = byteArray.readUnsignedInt ();
               worldDefine.mSettings.mViewportWidth  = byteArray.readShort ();
               worldDefine.mSettings.mViewportHeight  = byteArray.readShort ();
               worldDefine.mSettings.mZoomScale = byteArray.readFloat ();
            }

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

            if (worldDefine.mVersion >= 0x0106 && worldDefine.mVersion < 0x0108)
            {
               worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = byteArray.readInt ();
               worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = byteArray.readShort ();
            }

            if (worldDefine.mVersion >= 0x0108)
            {
               worldDefine.mSettings.mIsInfiniteWorldSize = byteArray.readByte () != 0;

               worldDefine.mSettings.mBorderAtTopLayer = byteArray.readByte () != 0;
               worldDefine.mSettings.mWorldBorderLeftThickness = byteArray.readFloat ();
               worldDefine.mSettings.mWorldBorderTopThickness = byteArray.readFloat ();
               worldDefine.mSettings.mWorldBorderRightThickness = byteArray.readFloat ();
               worldDefine.mSettings.mWorldBorderBottomThickness = byteArray.readFloat ();

               worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = byteArray.readFloat ();
               worldDefine.mSettings.mDefaultGravityAccelerationAngle = byteArray.readFloat ();

               worldDefine.mSettings.mRightHandCoordinates = byteArray.readByte () != 0;
               worldDefine.mSettings.mCoordinatesOriginX = byteArray.readDouble ();
               worldDefine.mSettings.mCoordinatesOriginY = byteArray.readDouble ();
               worldDefine.mSettings.mCoordinatesScale = byteArray.readDouble ();

               worldDefine.mSettings.mIsCiRulesEnabled = byteArray.readByte () != 0;
            }

            if (worldDefine.mVersion >= 0x0155)
            {
               worldDefine.mSettings.mAutoSleepingEnabled = byteArray.readByte () != 0;
               worldDefine.mSettings.mCameraRotatingEnabled = byteArray.readByte () != 0;
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
         
         // functions

         if (worldDefine.mVersion >= 0x0153)
         {
            var functionId:int;
            var functionDefine:FunctionDefine;

            var numFunctions:int = byteArray.readShort ();

            for (functionId = 0; functionId < numFunctions; ++ functionId)
            {
               functionDefine = new FunctionDefine ();

               TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, functionDefine, true, true, null);

               worldDefine.mFunctionDefines.push (functionDefine);
            }

            for (functionId = 0; functionId < numFunctions; ++ functionId)
            {
               functionDefine = worldDefine.mFunctionDefines [functionId];

               functionDefine.mName = byteArray.readUTF ();
               functionDefine.mPosX = byteArray.readFloat ();
               functionDefine.mPosY = byteArray.readFloat ();
               if (worldDefine.mVersion >= 0x0156)
               {
                  functionDefine.mDesignDependent = byteArray.readByte () != 0;
               }

               TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, functionDefine, true, false, worldDefine.mFunctionDefines);
            }
         }

         // entities

         var numEntities:int = byteArray.readShort ();

         //trace ("numEntities = " + numEntities);

         var appearId:int;
         var createId:int;
         var vertexId:int;

         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = new Object ();

            entityDefine.mEntityType = byteArray.readShort ();

            //trace ("appearId = " + appearId + ", mEntityType = " + entityDefine.mEntityType);

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
            if (worldDefine.mVersion >= 0x0158)
            {
               entityDefine.mScale = byteArray.readFloat ();
               entityDefine.mIsFlipped = byteArray.readByte () != 0;
            }
            entityDefine.mRotation = byteArray.readFloat ();
            entityDefine.mIsVisible = byteArray.readByte () != 0;

            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mAlpha = byteArray.readFloat ();
               entityDefine.mIsEnabled = byteArray.readByte () != 0;
            }

            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               // from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mFollowedTarget = byteArray.readByte ();
                     entityDefine.mFollowingStyle = byteArray.readByte ();
                  }
               }
               //<<
               //>>from v1.10
               else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
               {
                  entityDefine.mPowerSourceType = byteArray.readByte ();
                  entityDefine.mPowerMagnitude = byteArray.readFloat ();
                  entityDefine.mKeyboardEventId = byteArray.readShort ();
                  entityDefine.mKeyCodes = ReadShortArrayFromBinFile (byteArray);
               }
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, worldDefine.mFunctionDefines);
                  else
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, false, worldDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  entityDefine.mInputAssignerCreationIds = ReadShortArrayFromBinFile (byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  entityDefine.mIsAnd = byteArray.readByte () != 0;
                  entityDefine.mIsNot = byteArray.readByte () != 0;

                  var num:int = byteArray.readShort ();
                  entityDefine.mNumInputConditions = num;
                  entityDefine.mInputConditionEntityCreationIds = new Array (num);
                  entityDefine.mInputConditionTargetValues = new Array (num);

                  for (i = 0; i < num; ++ i)
                  {
                     entityDefine.mInputConditionEntityCreationIds [i] = byteArray.readShort ();
                     entityDefine.mInputConditionTargetValues [i] = byteArray.readByte ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  entityDefine.mSelectorType = byteArray.readByte ();
                  entityDefine.mEntityCreationIds = ReadShortArrayFromBinFile (byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  entityDefine.mPairingType = byteArray.readByte ();
                  entityDefine.mEntityCreationIds1 = ReadShortArrayFromBinFile (byteArray);
                  entityDefine.mEntityCreationIds2 = ReadShortArrayFromBinFile (byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  entityDefine.mEventId = byteArray.readShort ();
                  entityDefine.mInputConditionEntityCreationId = byteArray.readShort ();
                  entityDefine.mInputConditionTargetValue = byteArray.readByte ();
                  entityDefine.mInputAssignerCreationIds = ReadShortArrayFromBinFile (byteArray);

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mExternalActionEntityCreationId = byteArray.readShort ();
                  }

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     switch (entityDefine.mEventId)
                     {
                        case CoreEventIds.ID_OnWorldTimer:
                        case CoreEventIds.ID_OnEntityTimer:
                        case CoreEventIds.ID_OnEntityPairTimer:
                           entityDefine.mRunningInterval = byteArray.readFloat ();
                           entityDefine.mOnlyRunOnce = byteArray.readByte () != 0;

                           if (worldDefine.mVersion >= 0x0156)
                           {
                              if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                              {
                                 entityDefine.mPreFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, worldDefine.mFunctionDefines, false);
                                 entityDefine.mPostFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, worldDefine.mFunctionDefines, false);
                              }
                           }

                           break;
                        case CoreEventIds.ID_OnWorldKeyDown:
                        case CoreEventIds.ID_OnWorldKeyUp:
                        case CoreEventIds.ID_OnWorldKeyHold:
                           entityDefine.mKeyCodes = ReadShortArrayFromBinFile (byteArray);
                           break;
                        default:
                           break;
                     }
                  }

                  if (worldDefine.mVersion >= 0x0153)
                  {
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, worldDefine.mFunctionDefines);
                  }
                  else
                  {
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, false, worldDefine.mFunctionDefines);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, worldDefine.mFunctionDefines);
                  else
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, false, worldDefine.mFunctionDefines);
               }
               //>>from v1.56
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, worldDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, worldDefine.mFunctionDefines);
               }
               //<<
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
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

               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  // ...
                  ReadShapePhysicsPropertiesAndAiType (entityDefine, byteArray, worldDefine, true);
                  
                  // ...
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entityDefine.mRadius = byteArray.readFloat ();
                     entityDefine.mAppearanceType = byteArray.readByte ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        entityDefine.mIsRoundCorners = byteArray.readByte () != 0
                     }

                     entityDefine.mHalfWidth = byteArray.readFloat ();
                     entityDefine.mHalfHeight = byteArray.readFloat ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     entityDefine.mLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     entityDefine.mCurveThickness = byteArray.readByte ();

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        entityDefine.mIsRoundEnds = byteArray.readByte () != 0;
                     }
                  
                     if (worldDefine.mVersion >= 0x0157)
                     {
                        entityDefine.mIsClosed = byteArray.readByte () != 0;
                     }

                     entityDefine.mLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
                  }
               }
               else // not physis shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText
                     || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                     )
                  {
                     entityDefine.mText = byteArray.readUTF ();
                     entityDefine.mWordWrap = byteArray.readByte ();

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        entityDefine.mAdaptiveBackgroundSize = byteArray.readByte () != 0;
                        entityDefine.mTextColor = byteArray.readUnsignedInt ();
                        entityDefine.mFontSize = byteArray.readShort ();
                        entityDefine.mIsBold  = byteArray.readByte () != 0;
                        entityDefine.mIsItalic = byteArray.readByte () != 0;
                     }

                     if (worldDefine.mVersion >= 0x0109)
                     {
                        entityDefine.mTextAlign = byteArray.readByte ();
                        entityDefine.mIsUnderlined = byteArray.readByte () != 0;
                     }

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                        {
                           entityDefine.mUsingHandCursor = byteArray.readByte () != 0;

                           entityDefine.mDrawBackground_MouseOver = byteArray.readByte () != 0;
                           entityDefine.mBackgroundColor_MouseOver = byteArray.readUnsignedInt ();
                           entityDefine.mBackgroundTransparency_MouseOver = byteArray.readByte ();

                           entityDefine.mDrawBorder_MouseOver = byteArray.readByte () != 0;
                           entityDefine.mBorderColor_MouseOver = byteArray.readUnsignedInt ();
                           entityDefine.mBorderThickness_MouseOver = byteArray.readByte ();
                           entityDefine.mBorderTransparency_MouseOver = byteArray.readByte ();
                        }
                     }

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

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        entityDefine.mMaximalGravityAcceleration = byteArray.readFloat ();
                     }
                  }
               }
            }
            //>> from v1.58
            else if (Define.IsShapeEntity (entityDefine.mEntityType))
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
               {
                  ReadShapePhysicsPropertiesAndAiType (entityDefine, byteArray, worldDefine, false);
                  
                  entityDefine.mModuleIndex = byteArray.readShort ();
               }
            }
            //<<
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

               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mBreakable = byteArray.readByte ();
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

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mBreakDeltaLength = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();

                  entityDefine.mStaticLengthRatio = byteArray.readFloat ();
                  //entityDefine.mFrequencyHz = byteArray.readFloat ();
                  entityDefine.mSpringType = byteArray.readByte ();

                  entityDefine.mDampingRatio = byteArray.readFloat ();

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mFrequencyDeterminedManner = byteArray.readByte ();
                     entityDefine.mFrequency = byteArray.readFloat ();
                     entityDefine.mSpringConstant = byteArray.readFloat ();
                     entityDefine.mBreakExtendedLength = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  entityDefine.mAnchorEntityIndex = byteArray.readShort ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
               }
            }

            worldDefine.mEntityDefines.push (entityDefine);
         }

         // ...

         if (worldDefine.mVersion >= 0x0107)
         {
            var numOrderIds:int = byteArray.readShort (); // should == numEntities
            for (var i:int = 0; i < numOrderIds; ++ i)
            {
               worldDefine.mEntityAppearanceOrder.push (byteArray.readShort ());
            }
         }

         // ...

         var numGroups:int = byteArray.readShort ();
         var groupId:int;

         for (groupId = 0; groupId < numGroups; ++ groupId)
         {
            var brotherIDs:Array = ReadShortArrayFromBinFile (byteArray);

            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }

         // custom variables
         if (worldDefine.mVersion >= 0x0152)
         {
            if (worldDefine.mVersion >= 0x0157)
            {
               TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, worldDefine.mSessionVariableDefines, true);
            }
            
            //var numSpaces:int;
            //var spaceId:int;
            //var variableSpaceDefine:VariableSpaceDefine;

            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.readShort (); // numSpaces
               byteArray.readUTF (); // space name
               byteArray.readShort (); // parent id
            }
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, worldDefine.mGlobalVariableDefines, true);

            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.readShort (); // numSpaces
               byteArray.readUTF (); // space name
               byteArray.readShort (); // parent id
            }
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, worldDefine.mEntityPropertyDefines, true);
         }
         
         // modules
         
         if (worldDefine.mVersion >= 0x0158)
         {
            var numImages:int = byteArray.readShort ();
            for (var imageId:int = 0; imageId < numImages; ++ imageId)
            {
               var imageDefine:Object = new Object ();
               
               imageDefine.mName = byteArray.readUTF ();
               
               var fileSize:int = byteArray.readInt ();
               if (fileSize == 0)
               {
                  imageDefine.mFileData = null;
               }
               else
               {
                  imageDefine.mFileData = new ByteArray ();
                  imageDefine.mFileData.length = fileSize;
                  byteArray.readBytes (imageDefine.mFileData, 0, imageDefine.mFileData.length);
               }
               
               worldDefine.mImageDefines.push (imageDefine);
            }

            var numDivisons:int = byteArray.readShort ();
            for (var divisionId:int = 0; divisionId < numDivisons; ++ divisionId)
            {
               var divisionDefine:Object = new Object ();

               divisionDefine.mImageIndex = byteArray.readShort ();
               divisionDefine.mLeft = byteArray.readShort ();
               divisionDefine.mTop = byteArray.readShort ();
               divisionDefine.mRight = byteArray.readShort ();
               divisionDefine.mBottom = byteArray.readShort ();
               
               worldDefine.mPureImageModuleDefines.push (divisionDefine);
            }

            var numAssembledModules:int = byteArray.readShort ();
            for (var assembledModuleId:int = 0; assembledModuleId < numAssembledModules; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = new Object ();

               assembledModuleDefine.mModulePartDefines = ReadModuleInstanceDefinesFromBinFile (byteArray, false);
               
               worldDefine.mAssembledModuleDefines.push (assembledModuleDefine);
            }

            var numSequencedModules:int = byteArray.readShort ();
            for (var sequencedModuleId:int = 0; sequencedModuleId < numSequencedModules; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = new Object ();

               //sequencedModuleDefine.mIsLooped = byteArray.readByte () != 0;
               sequencedModuleDefine.mModuleSequenceDefines = ReadModuleInstanceDefinesFromBinFile (byteArray, true);
               
               worldDefine.mSequencedModuleDefines.push (sequencedModuleDefine);
            }
         }

         // ...
         return worldDefine;
      }
      
      public static function ReadShapePhysicsPropertiesAndAiType (entityDefine:Object, byteArray:ByteArray, worldDefine:WorldDefine, readAiType:Boolean):void
      {
         if (worldDefine.mVersion >= 0x0105)
         {
            if (readAiType)
               entityDefine.mAiType = byteArray.readByte ();
            
            entityDefine.mIsPhysicsEnabled = byteArray.readByte ();

            // the 2 lines are added in v1,04, and moved down from v1.05
            /////entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
            /////entityDefine.mIsSensor = byteArray.readByte ();
         }
         else if (worldDefine.mVersion >= 0x0104)
         {
            if (readAiType)
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

            if (readAiType)
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

            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mBuildBorder = byteArray.readByte () != 0;
               entityDefine.mIsSleepingAllowed = byteArray.readByte () != 0;
               entityDefine.mIsRotationFixed = byteArray.readByte () != 0;
               entityDefine.mLinearVelocityMagnitude = byteArray.readFloat ();
               entityDefine.mLinearVelocityAngle = byteArray.readFloat ();
               entityDefine.mAngularVelocity = byteArray.readFloat ();
            }
         }
      }
         
      public static function ReadModuleInstanceDefinesFromBinFile (byteArray:ByteArray, forSequencedModule:Boolean):Array
      {
         var numModuleInstances:int = byteArray.readShort ();
         var moduleInstanceDefines:Array= new Array (numModuleInstances);
         
         for (var miId:int = 0; miId < numModuleInstances; ++ miId)
         {
            var moduleInstanceDefine:Object = new Object ();
            moduleInstanceDefines [miId] = moduleInstanceDefine;
            
            moduleInstanceDefine.mPosX = byteArray.readFloat ();
            moduleInstanceDefine.mPosY = byteArray.readFloat ();
            moduleInstanceDefine.mScale = byteArray.readFloat ();
            moduleInstanceDefine.mIsFlipped = byteArray.readByte () != 0;
            moduleInstanceDefine.mRotation = byteArray.readFloat ();
            moduleInstanceDefine.mVisible = byteArray.readByte () != 0;
            moduleInstanceDefine.mAlpha = byteArray.readFloat ();
            
            if (forSequencedModule)
            {
               moduleInstanceDefine.mModuleDuration = byteArray.readFloat ();
            }
            
            ReadModuleInstanceDefineFromBinFile (byteArray, moduleInstanceDefine);
         }
         
         return moduleInstanceDefines;
      }
      
      public static function ReadModuleInstanceDefineFromBinFile (byteArray:ByteArray, moduleInstanceDefine:Object):void
      {
         moduleInstanceDefine.mModuleType = byteArray.readShort ();
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            moduleInstanceDefine.mShapeAttributeBits = byteArray.readUnsignedInt ();
            moduleInstanceDefine.mShapeBodyOpacityAndColor = byteArray.readUnsignedInt ();
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapePathThickness = byteArray.readFloat ();
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  moduleInstanceDefine.mPolyLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapeBorderOpacityAndColor = byteArray.readUnsignedInt ();
               moduleInstanceDefine.mShapeBorderThickness = byteArray.readFloat ();
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  moduleInstanceDefine.mCircleRadius = byteArray.readFloat ();
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  moduleInstanceDefine.mRectHalfWidth = byteArray.readFloat ();
                  moduleInstanceDefine.mRectHalfHeight = byteArray.readFloat ();
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  moduleInstanceDefine.mPolyLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               moduleInstanceDefine.mModuleIndex = byteArray.readShort ();
            }
         }
         else // ...
         {
         }
      }
      
      public static function ReadLocalVerticesFromBinFile (byteArray:ByteArray):Array
      {
         var numPoints:int = byteArray.readShort ();
         var localPoints:Array = new Array (numPoints);
         
         if (numPoints == 0)
         {
         }
         else
         {
            for (var vertexId:int = 0; vertexId < localPoints.length; ++ vertexId)
            {
               var point:Point = new Point ();
               localPoints [vertexId] = point;
               
               point.x = byteArray.readFloat ();
               point.y = byteArray.readFloat ();
            }
         }
         
         return localPoints;
      }

      public static function ReadShortArrayFromBinFile (binFile:ByteArray):Array
      {
         var num:int = binFile.readShort ();

         var shortArray:Array = new Array (num);

         for (var i:int = 0; i < num; ++ i)
         {
            shortArray [i] = binFile.readShort ();
         }

         return shortArray;
      }

//==================================== playcode with hex string ======================================================

      public static function HexString2WorldDefine (hexString:String):WorldDefine
      {
         return ByteArray2WorldDefine (DataFormat3.HexString2ByteArray (hexString));
      }

//==================================== new playcode with base64 ======================================================

      public static function PlayCode2WorldDefine_Base64 (playCode:String):WorldDefine
      {
         var bytesArray:ByteArray = DataFormat3.DecodeString2ByteArray (playCode);
         if (bytesArray == null)
            return null;

         bytesArray.uncompress ();
         return ByteArray2WorldDefine (bytesArray);
      }

//====================================================================================
//
//====================================================================================

      // adjust some float numbers

      // must call FillMissedFieldsInWorldDefine before call this
      public static function AdjustNumberValuesInWorldDefine (worldDefine:WorldDefine, isForPlayer:Boolean = false):void
      {
         // world settings

         worldDefine.mSettings.mZoomScale = ValueAdjuster.Number2Precision (worldDefine.mSettings.mZoomScale, 6);

         worldDefine.mSettings.mWorldBorderLeftThickness = ValueAdjuster.Number2Precision (worldDefine.mSettings.mWorldBorderLeftThickness, 6);
         worldDefine.mSettings.mWorldBorderTopThickness = ValueAdjuster.Number2Precision (worldDefine.mSettings.mWorldBorderTopThickness, 6);
         worldDefine.mSettings.mWorldBorderRightThickness = ValueAdjuster.Number2Precision (worldDefine.mSettings.mWorldBorderRightThickness, 6);
         worldDefine.mSettings.mWorldBorderBottomThickness = ValueAdjuster.Number2Precision (worldDefine.mSettings.mWorldBorderBottomThickness, 6);

         worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = ValueAdjuster.Number2Precision (worldDefine.mSettings.mDefaultGravityAccelerationMagnitude, 6);
         worldDefine.mSettings.mDefaultGravityAccelerationAngle = ValueAdjuster.Number2Precision (worldDefine.mSettings.mDefaultGravityAccelerationAngle, 6);

         worldDefine.mSettings.mCoordinatesOriginX = ValueAdjuster.Number2Precision (worldDefine.mSettings.mCoordinatesOriginX, 12);
         worldDefine.mSettings.mCoordinatesOriginY = ValueAdjuster.Number2Precision (worldDefine.mSettings.mCoordinatesOriginY, 12);
         worldDefine.mSettings.mCoordinatesScale = ValueAdjuster.Number2Precision (worldDefine.mSettings.mCoordinatesScale, 12);

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

         var createId:int;
         //var vertexId:int;

         var hasGravityControllers:Boolean = false;

         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [createId];

            entityDefine.mPosX = ValueAdjuster.Number2Precision (entityDefine.mPosX, 12);
            entityDefine.mPosY = ValueAdjuster.Number2Precision (entityDefine.mPosY, 12);
            entityDefine.mScale = ValueAdjuster.Number2Precision (entityDefine.mScale, 6);
            entityDefine.mRotation = ValueAdjuster.Number2Precision (entityDefine.mRotation, 6);

            entityDefine.mAlpha = ValueAdjuster.Number2Precision (entityDefine.mAlpha, 6);

            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
               {
                  entityDefine.mPowerMagnitude = ValueAdjuster.Number2Precision (entityDefine.mPowerMagnitude, 6);
               }
            }
            if ( Define.IsLogicEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);

                  // from v1.56
                  if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                  {
                     if (entityDefine.mPreFunctionDefine != undefined)
                        TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPreFunctionDefine);
                     if (entityDefine.mPostFunctionDefine != undefined)
                        TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPostFunctionDefine);
                  }
                  //<<
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
               }
               //>>from v1.56
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
               }
               //<<
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  // ...
                  AdjustNumberValuesOfShapePhysicsProperties (entityDefine, worldDefine);
                  
                  // ...
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     //if (worldDefine.mVersion >= 0x0105 && worldDefine.mVersion < 0x0107) // bug: should be v1,02
                     if (worldDefine.mVersion >= 0x0102 && worldDefine.mVersion < 0x0107)
                     {
                        if (entityDefine.mBorderThickness != 0)
                           entityDefine.mRadius = entityDefine.mRadius - 0.5;
                     }

                     entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);

                     if (isForPlayer)
                        entityDefine.mRadius = ValueAdjuster.AdjustCircleDisplayRadius (entityDefine.mRadius, worldDefine.mVersion);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     //if (worldDefine.mVersion >= 0x0105 && worldDefine.mVersion < 0x0107) // bug: should be v1,02
                     if (worldDefine.mVersion >= 0x0102 && worldDefine.mVersion < 0x0107)
                     {
                        if (entityDefine.mBorderThickness != 0)
                        {
                           entityDefine.mHalfWidth = entityDefine.mHalfWidth - 0.5;
                           entityDefine.mHalfHeight = entityDefine.mHalfHeight - 0.5;
                        }
                     }

                     entityDefine.mHalfWidth = ValueAdjuster.Number2Precision (entityDefine.mHalfWidth, 6);
                     entityDefine.mHalfHeight = ValueAdjuster.Number2Precision (entityDefine.mHalfHeight, 6);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     //for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     //{
                     //   entityDefine.mLocalPoints [vertexId].x = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].x, 6);
                     //   entityDefine.mLocalPoints [vertexId].y = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].y, 6);
                     //}
                     AdjustNumberValuesInPointArray (entityDefine.mLocalPoints);

                     if (worldDefine.mVersion < 0x0107)
                     {
                        if (entityDefine.mBorderThickness < 2.0)
                           entityDefine.mBuildBorder = false;
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     //for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     //{
                     //   entityDefine.mLocalPoints [vertexId].x = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].x, 6);
                     //   entityDefine.mLocalPoints [vertexId].y = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].y, 6);
                     //}
                     AdjustNumberValuesInPointArray (entityDefine.mLocalPoints);

                     if (worldDefine.mVersion < 0x0107)
                     {
                        if (entityDefine.mCurveThickness < 2.0)
                           entityDefine.mIsPhysicsEnabled = false;
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
                     hasGravityControllers = true;

                     entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);

                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mInitialGravityAcceleration = Define.kDefaultCoordinateSystem_BeforeV0108.P2D_LinearAccelerationMagnitude (entityDefine.mInitialGravityAcceleration);
                     }

                     entityDefine.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (entityDefine.mInitialGravityAcceleration, 6);

                     entityDefine.mMaximalGravityAcceleration = ValueAdjuster.Number2Precision (entityDefine.mMaximalGravityAcceleration, 6);
                  }
               }
            }
            //>> from v1.58
            else if (Define.IsShapeEntity (entityDefine.mEntityType))
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
               {
                  AdjustNumberValuesOfShapePhysicsProperties (entityDefine, worldDefine);
               }
            }
            //<<
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mLowerAngle = ValueAdjuster.Number2Precision (entityDefine.mLowerAngle, 6);
                  entityDefine.mUpperAngle = ValueAdjuster.Number2Precision (entityDefine.mUpperAngle, 6);

                  if (worldDefine.mVersion < 0x0107)
                     entityDefine.mMotorSpeed *= (0.1 * Define.kRadians2Degrees); // for a history bug

                  if (worldDefine.mVersion < 0x0108)
                  {
                     entityDefine.mMaxMotorTorque = Define.kDefaultCoordinateSystem_BeforeV0108.P2D_Torque (entityDefine.mMaxMotorTorque);

                     // anchor visible
                     worldDefine.mEntityDefines [entityDefine.mAnchorEntityIndex].mIsVisible = entityDefine.mIsVisible;
                  }

                  entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);
                  entityDefine.mMaxMotorTorque = ValueAdjuster.Number2Precision (entityDefine.mMaxMotorTorque, 6);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mLowerTranslation = ValueAdjuster.Number2Precision (entityDefine.mLowerTranslation, 6);
                  entityDefine.mUpperTranslation = ValueAdjuster.Number2Precision (entityDefine.mUpperTranslation, 6);
                  entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);

                  if (worldDefine.mVersion < 0x0108)
                  {
                     entityDefine.mMaxMotorForce = Define.kDefaultCoordinateSystem_BeforeV0108.P2D_ForceMagnitude (entityDefine.mMaxMotorForce);

                     // anchor visilbe
                     worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex].mIsVisible = entityDefine.mIsVisible;
                     worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex].mIsVisible = entityDefine.mIsVisible;
                  }

                  entityDefine.mMaxMotorForce = ValueAdjuster.Number2Precision (entityDefine.mMaxMotorForce, 6);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  entityDefine.mBreakDeltaLength = ValueAdjuster.Number2Precision (entityDefine.mBreakDeltaLength, 6);

                  if (worldDefine.mVersion < 0x0108)
                  {
                     // anchor visilbe
                     worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex].mIsVisible = entityDefine.mIsVisible;
                     worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex].mIsVisible = entityDefine.mIsVisible;
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mStaticLengthRatio = ValueAdjuster.Number2Precision (entityDefine.mStaticLengthRatio, 6);

                  entityDefine.mDampingRatio = ValueAdjuster.Number2Precision (entityDefine.mDampingRatio, 6);

                  entityDefine.mFrequency = ValueAdjuster.Number2Precision (entityDefine.mFrequency, 6);
                  entityDefine.mBreakExtendedLength = ValueAdjuster.Number2Precision (entityDefine.mBreakExtendedLength, 6);

                  if (worldDefine.mVersion < 0x0108)
                  {
                     // anchor visilbe
                     worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex].mIsVisible = entityDefine.mIsVisible;
                     worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex].mIsVisible = entityDefine.mIsVisible;
                  }
               }
            }
         }

         // before v1.08, gravity = hasGravityControllers ? theLastGravityController.gravity : world.defaultGravity
         // from   v1.08, gravity = world.defaultGravity + sum (all GravityController.gravity)
         if (worldDefine.mVersion < 0x0108 && hasGravityControllers)
         {
            worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = 0.0;
         }

         // custom variables
         // from v1.52
         //{
              //>> v1.52 only
              //var numSpaces:int;
              //var spaceId:int;
              //
              //numSpaces = worldDefine.mGlobalVariableSpaceDefines.length;
              //for (spaceId = 0; spaceId < numSpaces; ++ spaceId)
              //{
              //    TriggerFormatHelper2.AdjustNumberPrecisionsInVariableSpaceDefine (worldDefine.mGlobalVariableSpaceDefines [spaceId] as VariableSpaceDefine);
              //}
              //
              //numSpaces = worldDefine.mEntityPropertySpaceDefines.length;
              //for (spaceId = 0; spaceId < numSpaces; ++ spaceId)
              //{
              //    TriggerFormatHelper2.AdjustNumberPrecisionsInVariableSpaceDefine (worldDefine.mEntityPropertySpaceDefines [spaceId] as VariableSpaceDefine);
              //}
              //<<

              TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (worldDefine.mSessionVariableDefines);
              TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (worldDefine.mGlobalVariableDefines);
              TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (worldDefine.mEntityPropertyDefines);
         //}

         //custom functions
         // from v1.53
         //{
            for (var functionId:int = 0; functionId < worldDefine.mFunctionDefines.length; ++ functionId)
            {
               var functionDefine:FunctionDefine = worldDefine.mFunctionDefines [functionId];

               functionDefine.mPosX = ValueAdjuster.Number2Precision (functionDefine.mPosX, 6);
               functionDefine.mPosY = ValueAdjuster.Number2Precision (functionDefine.mPosY, 6);
               TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (functionDefine);
            }
         //}
         
         //modules
         // from v1.58
         //{
            for (var assembledModuleId:int = 0; assembledModuleId < worldDefine.mAssembledModuleDefines.length; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];

               AdjustNumberValuesInModuleInstanceDefines (assembledModuleDefine.mModulePartDefines, false);
            }
            
            for (var sequencedModuleId:int = 0; sequencedModuleId < worldDefine.mSequencedModuleDefines.length; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];

               //byteArray.writeByte (sequencedModuleDefine.mIsLooped ? 1 : 0);
               AdjustNumberValuesInModuleInstanceDefines (sequencedModuleDefine.mModuleSequenceDefines, true);
            }
         //}
         //
      }
      
      public static function AdjustNumberValuesOfShapePhysicsProperties (entityDefine:Object, worldDefine:WorldDefine):void
      {
         if (entityDefine.mIsPhysicsEnabled)
         {
            // from v1.08, a dynamic shape with zero density will not view as a static shape
            if (worldDefine.mVersion < 0x0108 && Number (entityDefine.mDensity) <= 0)
            {
               entityDefine.mIsStatic = true;
            }

            entityDefine.mDensity = ValueAdjuster.Number2Precision (entityDefine.mDensity, 6);
            entityDefine.mFriction = ValueAdjuster.Number2Precision (entityDefine.mFriction, 6);
            entityDefine.mRestitution = ValueAdjuster.Number2Precision (entityDefine.mRestitution, 6);

            entityDefine.mLinearVelocityMagnitude = ValueAdjuster.Number2Precision (entityDefine.mLinearVelocityMagnitude, 6);
            entityDefine.mLinearVelocityAngle = ValueAdjuster.Number2Precision (entityDefine.mLinearVelocityAngle, 6);
            entityDefine.mAngularVelocity = ValueAdjuster.Number2Precision (entityDefine.mAngularVelocity, 6);
         }
      } 
      
      public static function AdjustNumberValuesInModuleInstanceDefines (moduleInstanceDefines:Array, forSequencedModule:Boolean):void
      {
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId];
            
            moduleInstanceDefine.mAlpha = ValueAdjuster.Number2Precision (moduleInstanceDefine.mAlpha, 6);
            moduleInstanceDefine.mPosX = ValueAdjuster.Number2Precision (moduleInstanceDefine.mPosX, 6); //12); // here, different with entity
            moduleInstanceDefine.mPosY = ValueAdjuster.Number2Precision (moduleInstanceDefine.mPosY, 6); //12);
            moduleInstanceDefine.mScale = ValueAdjuster.Number2Precision (moduleInstanceDefine.mScale, 6);
            moduleInstanceDefine.mRotation = ValueAdjuster.Number2Precision (moduleInstanceDefine.mRotation, 6);
            
            if (forSequencedModule)
               moduleInstanceDefine.mModuleDuration = ValueAdjuster.Number2Precision (moduleInstanceDefine.mModuleDuration, 6);
            
            AdjustNumberValuesInModuleInstanceDefine (moduleInstanceDefine);
         }
      }
      
      public static function AdjustNumberValuesInModuleInstanceDefine (moduleInstanceDefine:Object):void
      {
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapePathThickness = ValueAdjuster.Number2Precision (moduleInstanceDefine.mShapePathThickness, 6);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  AdjustNumberValuesInPointArray (moduleInstanceDefine.mPolyLocalPoints);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapeBorderThickness = ValueAdjuster.Number2Precision (moduleInstanceDefine.mShapeBorderThickness, 6);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  moduleInstanceDefine.mCircleRadius = ValueAdjuster.Number2Precision (moduleInstanceDefine.mCircleRadius, 6);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  moduleInstanceDefine.mRectHalfWidth = ValueAdjuster.Number2Precision (moduleInstanceDefine.mRectHalfWidth, 6);
                  moduleInstanceDefine.mRectHalfHeight = ValueAdjuster.Number2Precision (moduleInstanceDefine.mRectHalfHeight, 6);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  AdjustNumberValuesInPointArray (moduleInstanceDefine.mPolyLocalPoints);
               }
            }
         }
         //else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         //{
         //   if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
         //   {
         //      moduleInstanceDefine.mModuleIndex = parseInt (element.@module_index);
         //   }
         //}
         //else // ...
         //{
         //}
      }
      
      public static function AdjustNumberValuesInPointArray (points:Array):void
      {
         if (points == null)
            return;
         
         for (var vertexId:int = 0; vertexId < points.length; ++ vertexId)
         {
            var point:Point = points [vertexId];
            point.x = ValueAdjuster.Number2Precision (point.x, 6);
            point.y = ValueAdjuster.Number2Precision (point.y, 6);
         }
      }
      
//============================================================

      // fill some missed fields in earliser versions

      public static function FillMissedFieldsInWorldDefine (worldDefine:WorldDefine):void
      {
         // setting

         if (worldDefine.mVersion < 0x0102)
         {
            worldDefine.mShareSourceCode = false;
            worldDefine.mPermitPublishing = false;
         }

         if (worldDefine.mVersion < 0x0151)
         {
            worldDefine.mSettings.mViewerUiFlags = Define.PlayerUiFlags_BeforeV0151;
            worldDefine.mSettings.mPlayBarColor = 0x606060;
            worldDefine.mSettings.mViewportWidth = 600;
            worldDefine.mSettings.mViewportHeight = 600;
            worldDefine.mSettings.mZoomScale = 1.0;
         }

         if (worldDefine.mVersion < 0x0104)
         {
            worldDefine.mSettings.mWorldLeft = 0;
            worldDefine.mSettings.mWorldTop  = 0;
            worldDefine.mSettings.mWorldWidth = 600;
            worldDefine.mSettings.mWorldHeight = 600;
            worldDefine.mSettings.mCameraCenterX = worldDefine.mSettings.mWorldLeft + 600 * 0.5
            worldDefine.mSettings.mCameraCenterY = worldDefine.mSettings.mWorldTop + 600 * 0.5;
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

         if (worldDefine.mVersion < 0x0108)
         {
            worldDefine.mSettings.mIsInfiniteWorldSize = false;

            worldDefine.mSettings.mBorderAtTopLayer = false;
            worldDefine.mSettings.mWorldBorderLeftThickness = 10;
            worldDefine.mSettings.mWorldBorderTopThickness = 20;
            worldDefine.mSettings.mWorldBorderRightThickness = 10;
            worldDefine.mSettings.mWorldBorderBottomThickness = 20;

            worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = Define.kDefaultCoordinateSystem_BeforeV0108.P2D_LinearAccelerationMagnitude (9.8);
            worldDefine.mSettings.mDefaultGravityAccelerationAngle = Define.kDefaultCoordinateSystem_BeforeV0108.P2D_RotationDegrees (90);

            worldDefine.mSettings.mRightHandCoordinates = Define.kDefaultCoordinateSystem_BeforeV0108.IsRightHand ();
            worldDefine.mSettings.mCoordinatesOriginX = Define.kDefaultCoordinateSystem_BeforeV0108.GetOriginX ();
            worldDefine.mSettings.mCoordinatesOriginY = Define.kDefaultCoordinateSystem_BeforeV0108.GetOriginY ();
            worldDefine.mSettings.mCoordinatesScale = Define.kDefaultCoordinateSystem_BeforeV0108.GetScale ();

            worldDefine.mSettings.mIsCiRulesEnabled  = true;
         }

         if (worldDefine.mVersion < 0x0155)
         {
            worldDefine.mSettings.mAutoSleepingEnabled = true;
            worldDefine.mSettings.mCameraRotatingEnabled = false;
         }

         // collision category

         // entities

         var numEntities:int = worldDefine.mEntityDefines.length;

         var createId:int;
         var vertexId:int;

         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [createId];

            if (worldDefine.mVersion < 0x0158)
            {
               entityDefine.mScale = 1.0;
               entityDefine.mIsFlipped = false;
            }

            if (worldDefine.mVersion < 0x0108)
            {
               entityDefine.mAlpha = 1.0;
               entityDefine.mIsEnabled = true;
            }

            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  if (worldDefine.mVersion < 0x0108)
                  {
                     entityDefine.mFollowedTarget = Define.Camera_FollowedTarget_Brothers;
                     entityDefine.mFollowingStyle = Define.Camera_FollowingStyle_Default;
                  }
               }
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
            {
               //if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               //{
               //   TriggerFormatHelper2.FillMissedFieldsInFunctionDefine (entityDefine.mFunctionDefine);
               //}
               //if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               //{
               //   TriggerFormatHelper2.FillMissedFieldsInFunctionDefine (entityDefine.mFunctionDefine);
               //}
               //else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               //{
               //   if (worldDefine.mVersion < 0x0108)
               //   {
               //      entityDefine.mExternalActionEntityCreationId = -1;
               //   }
               //
               //   TriggerFormatHelper2.FillMissedFieldsInFunctionDefine (entityDefine.mFunctionDefine);
               //
               //   if (worldDefine.mVersion >= 0x0156)
               //   {
               //      if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
               //      {
               //         TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPreFunctionDefine);
               //         TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPostFunctionDefine);
               //      }
               //   }
               //}
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mIsRoundCorners = false;
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mIsRoundEnds = true;
                     }
                     
                     if (worldDefine.mVersion < 0x0157)
                     {
                        entityDefine.mIsClosed = false;
                     }
                  }
               }
               else // not physis shape
               {
                  entityDefine.mAiType = Define.ShapeAiType_Unknown;

                  if (entityDefine.mEntityType == Define.EntityType_ShapeText
                     || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                     )
                  {
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mAdaptiveBackgroundSize = false;
                        entityDefine.mTextColor = 0x0;
                        entityDefine.mFontSize = 10;
                        entityDefine.mIsBold = false;
                        entityDefine.mIsItalic = false;
                     }

                     if (worldDefine.mVersion < 0x0109)
                     {
                        entityDefine.mTextAlign = entityDefine.mEntityType == Define.EntityType_ShapeTextButton ? TextUtil.TextAlign_Center : TextUtil.TextAlign_Left;
                        entityDefine.mIsUnderlined = false;
                     }

                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     if (worldDefine.mVersion < 0x0105)
                     {
                        entityDefine.mInteractiveZones = entityDefine.mIsInteractive ? (1 << Define.GravityController_InteractiveZone_AllArea) : 0;
                        entityDefine.mInteractiveConditions = 0;
                     }

                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mMaximalGravityAcceleration = Define.kDefaultCoordinateSystem_BeforeV0108.P2D_LinearAccelerationMagnitude (9.8);
                     }
                  }
               }

               // some if(s) put below for the mAiType would be adjust in above code block

               if (worldDefine.mVersion < 0x0102)
               {
                  entityDefine.mCollisionCategoryIndex = Define.CCatId_Hidden;

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

               if (worldDefine.mVersion < 0x0108)
               {
                  entityDefine.mBuildBorder = true;
                  entityDefine.mIsSleepingAllowed = true;
                  entityDefine.mIsRotationFixed = false;
                  entityDefine.mLinearVelocityMagnitude = 0.0;
                  entityDefine.mLinearVelocityAngle = 0.0;
                  entityDefine.mAngularVelocity = 0.0;
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion < 0x0108)
               {
                  entityDefine.mBreakable = false;
               }

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
                  if (worldDefine.mVersion < 0x0108)
                  {
                     entityDefine.mBreakDeltaLength = 0.0;
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  if (worldDefine.mVersion < 0x0108)
                  {
                     entityDefine.mFrequencyDeterminedManner = Define.SpringFrequencyDetermineManner_Preset;
                     entityDefine.mFrequency = 0.0;
                     entityDefine.mSpringConstant = 0.0;
                     entityDefine.mBreakExtendedLength = 0.0;
                  }
               }

               if (worldDefine.mVersion < 0x0102)
               {
                  entityDefine.mConnectedShape1Index = Define.EntityId_None;
                  entityDefine.mConnectedShape2Index = Define.EntityId_None;
               }
            }
         }

         // creation order
         if (worldDefine.mVersion < 0x0107 || worldDefine.mEntityAppearanceOrder.length == 0)
         {
            for (var appearId:int = 0; appearId < numEntities; ++ appearId)
            {
               worldDefine.mEntityAppearanceOrder.push (appearId);
            }
         }

         // functions
         if (worldDefine.mVersion >= 0x0152)
         {
            for (var functionId:int = 0; functionId < worldDefine.mFunctionDefines.length; ++ functionId)
            {
               var functionDefine:FunctionDefine = worldDefine.mFunctionDefines [functionId] as FunctionDefine;

               if (worldDefine.mVersion < 0x0156)
               {
                  functionDefine.mDesignDependent = false;
               }
            }
         }
      }

   }

}
