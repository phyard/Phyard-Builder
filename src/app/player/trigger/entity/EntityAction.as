package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.ValueDefine;
   
   public class EntityAction extends EntityLogic implements ScriptHolder
   {
      public var mVoidFunctionDefinition:FunctionDefinition_Custom;
      public var mName:String = null;
      
      public function EntityAction (world:World)
      {
         super (world);
         
         mVoidFunctionDefinition = new FunctionDefinition_Custom (TriggerEngine.GetVoidFunctionDeclaration  ());
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mName != undefined)
               mName = entityDefine.mName;
            
            if (entityDefine.mCodeSnippetDefine != undefined)
            {
               var codeSnippetDefine:CodeSnippetDefine = entityDefine.mCodeSnippetDefine.Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
               mVoidFunctionDefinition.SetCodeSnippetDefine (codeSnippetDefine);
            }
         }
      }
            
//=============================================================
//   as action
//=============================================================
      
      public function Perform ():void
      {
         mVoidFunctionDefinition.ExcuteAction ();
      }
      
//=============================================================
//   as ScriptHolder
//=============================================================
      
      public function RunScript ():void
      {
         Perform ();
      }
      
   }
}
