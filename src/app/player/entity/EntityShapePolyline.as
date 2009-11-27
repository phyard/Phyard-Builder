package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;   
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapePolyline extends EntityShape
   {
      public function EntityShapePolyline (world:World)
      {
         super (world);
         
         SetCurveThickness (mWorld.DisplayLength2PhysicsLength (1.0));

         mPhysicsShapePotentially = true;
         
         mAppearanceObjectsContainer.addChild (mLineShape);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mLocalPoints != undefined)
               SetLocalDisplayVertexPoints (entityDefine.mLocalPoints);
            if (entityDefine.mCurveThickness != undefined)
            	SetCurveThickness (mWorld.DisplayLength2PhysicsLength (entityDefine.mCurveThickness));
            if (entityDefine.mIsRoundEnd != undefined)
            	SetRoundEnds (entityDefine.mIsRoundEnds);               
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mLocalPoints:Array = null;
      protected var mLocalDisplayPoints:Array = null;
      
      protected var mCurveThickness:Number; 
      protected var mIsRoundEnds:Boolean;

      public function GetVertexPointsCount ():int
      {
         if (mLocalPoints == null)
            return 0;
         else
            return mLocalPoints.length;
      }
      
      public function SetLocalDisplayVertexPoints (points:Array):void
      {
			var i:int;
			var inputDisplayPoint:Point;
			var displayPoint:Point;
			var physicsPoint:Point;
         if (mLocalPoints == null || mLocalPoints.length != points.length)
         {
            mLocalPoints = new Array (points.length);
            mLocalDisplayPoints = new Array (points.length);
            for (i = 0; i < mLocalPoints.length; ++ i)
            {
               mLocalPoints        [i] = new Point ();
               mLocalDisplayPoints [i] = new Point ();
            }
         }
         
         for (i = 0; i < mLocalPoints.length; ++ i)
         {
				inputDisplayPoint = points [i];
				
				displayPoint = mLocalDisplayPoints [i];
				displayPoint.x = inputDisplayPoint.x;
				displayPoint.y = inputDisplayPoint.y;
				
				physicsPoint = mLocalPoints [i];
            physicsPoint.x =  mWorld.DisplayX2PhysicsX (inputDisplayPoint.x);
            physicsPoint.y =  mWorld.DisplayY2PhysicsY (inputDisplayPoint.y);
         }
      }
            
      public function SetCurveThickness (thickness:Number):void
      {
         mCurveThickness = thickness;
      }
      
      public function GetCurveThickness ():uint
      {
         return mCurveThickness;
      }
      
      public function SetRoundEnds (roundEnds:Boolean):void
      {
			mIsRoundEnds = roundEnds;
      }
      
      public function IsRoundEnds ():Boolean
      {
			return mIsRoundEnds;
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mLineShape:Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayCurveThickness:Number = mWorld.PhysicsLength2DisplayLength (mCurveThickness);
            
            trace ("mCurveThickness = " + mCurveThickness);
            trace ("displayCurveThickness = " + displayCurveThickness);
            
            var i:int;
            var numVertesex:int = mLocalDisplayPoints.length;
            var point1:Point;
            var point2:Point;
            
            GraphicsUtil.Clear (mLineShape);
            for (i = 1; i < numVertesex; ++ i)
            {
               point1 = mLocalDisplayPoints [i - 1];
               point2 = mLocalDisplayPoints [i];
               
               GraphicsUtil.DrawLine (
                        mLineShape, 
                        point1.x, 
                        point1.y, 
                        point2.x, 
                        point2.y, 
                        GetFilledColor (), 
                        displayCurveThickness);
            }
         }
         
         if (mNeedUpdateAppearanceProperties)
         {
            mNeedUpdateAppearanceProperties = false;
            
            mLineShape.visible = IsDrawBackground ();
            mLineShape.alpha = GetTransparency () * 0.01;
         }
      }
     
//=============================================================
//   physics proxy
//=============================================================
     
      override public function RebuildShapePhysics ():void
      {
         var proxyShape:PhysicsProxyShape = PrepareRebuildShapePhysics ();
         if (proxyShape != null)
         {
            proxyShape.AddPolyline (mLocalPoints, mCurveThickness, mIsRoundEnds);
			}
      }
      
      
      
   }
}
