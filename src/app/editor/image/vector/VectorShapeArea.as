pacakge editor.image.vector
{
   public class VectorShapeArea extends VectorShape
   {  
      //protected var mAttributeBits:int = 0;
         public static const Flag_BuildBorder      :int = 1 << 8;
         public static const Flag_ShowBorder       :int = 1 << 9;
            
      protected var mBorderColor:uint = 0x000000;
      protected var mBorderOpacity:int = 100; // 0-100. To changed to float.
      protected var mBorderThickness:int = 1.0; //0-255. To changed to float.
      
      public function IsBuildBorder ():Boolean
      {
         return (mAttributeBits & Flag_BuildBorder) != 0;
      }
      
      public function SetBuildBorder (buildBorder:Boolean):void
      {
         if (buildBorder)
            mAttributeBits |= Flag_BuildBorder;
         else
            mAttributeBits &= ~Flag_BuildBorder;
      }
      
      public function IsShowBorder ():Boolean
      {
         return (mAttributeBits & Flag_ShowBorder) != 0;
      }
      
      public function SetShowBorder (showBorder:Boolean):void
      {
         if (showBorder)
            mAttributeBits |= Flag_ShowBorder;
         else
            mAttributeBits &= ~Flag_ShowBorder;
      }
      
      public function GetBorderColor ():uint
      {
         return mBorderColor;
      }
      
      public function SetBorderColor (color:uint):void
      {
         mBorderColor = color;
      }
      
      public function GetBorderOpacity ():int
      {
         return mBorderOpacity;
      }
      
      public function SetBorderOpacity (opacity:int):void
      {
         mBorderOpacity = opacity;
      }
      
      public function GetBorderThickness ():int
      {
         return mBorderThickness;
      }
      
      public function SetBorderThickness (thickness:int):void
      {
         mBorderThickness = thickness;
      }
   }
}