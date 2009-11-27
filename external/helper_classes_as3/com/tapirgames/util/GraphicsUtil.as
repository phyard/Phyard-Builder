package com.tapirgames.util {
   
   import flash.display.Shape;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   
   import flash.geom.Point;
   
   
   import com.tapirgames.suit2d.loader.Sprite2dFile;
   import com.tapirgames.suit2d.display.Tiled2dBackgroundInstance;
   import com.tapirgames.suit2d.display.Sprite2dModelInstance;
   
   public class GraphicsUtil 
   {
      /*
      public static function CreateTiled2dBackgroundInstance (appearanceDefine:Object, appearanceValue:Object):Tiled2dBackgroundInstance
      {
         var sprite2dFile:Sprite2dFile = Engine.GetDataAsset (appearanceDefine.mFilePath) as Sprite2dFile;
         return new Tiled2dBackgroundInstance (sprite2dFile, appearanceValue as int);
      }
      
      public static function CreateSprite2dModelInstance (appearanceDefine:Object, appearanceValue:Object):Sprite2dModelInstance
      {
         var sprite2dFile:Sprite2dFile = Engine.GetDataAsset (appearanceDefine.mFilePath) as Sprite2dFile;
         var model:Sprite2dModelInstance = new Sprite2dModelInstance (sprite2dFile, appearanceDefine.mModelID as int);
         
         model.SetAnimationID (appearanceValue as int);
         
         return model;
      }
      */
      
      public static function GetInvertColor (color:uint):uint
      {
         var r:int = (color >> 16) & 0xFF;
         var g:int = (color >>  8) & 0xFF;
         var b:int = (color >>  0) & 0xFF;
         
         return (color & 0xFF000000) | ((255 - r) << 16) | ((255 - g) << 8) | ((255 - b));
      }
      
      // return black or white
      public static function GetInvertColor_b (color:uint):uint
      {
         var r:int = (color >> 16) & 0xFF;
         var g:int = (color >>  8) & 0xFF;
         var b:int = (color >>  0) & 0xFF;
         
         if (r + g + b > 100 * 3)
            return (color & 0xFF000000) | 0x0;
         else
            return (color & 0xFF000000) | 0xFFFFFF;
      }
      
      public static function BlendColor (color1:uint, color2:uint, weigth1:Number):uint
      {
         var r1:int = (color1 >> 16) & 0xFF;
         var g1:int = (color1 >>  8) & 0xFF;
         var b1:int = (color1 >>  0) & 0xFF;
         
         var r2:int = (color2 >> 16) & 0xFF;
         var g2:int = (color2 >>  8) & 0xFF;
         var b2:int = (color2 >>  0) & 0xFF;
         
         var weigth2:Number = 1.0 - weigth1;
         
         var r:int = weigth1 * r1 + weigth2 * r2; if (r < 0) r = 0; if (r > 255) r = 255;
         var g:int = weigth1 * g1 + weigth2 * g2; if (g < 0) g = 0; if (g > 255) g = 255;
         var b:int = weigth1 * b1 + weigth2 * b2; if (b < 0) b = 0; if (b > 255) b = 255;
         
         return (r << 16) | (g << 8) | (b);
      }
      
      public static function CreateRectShape (x:Number, y:Number, w:Number, h:Number, borderColor:uint, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):Shape
      {
         var rect:Shape = new Shape();
         if (filled) rect.graphics.beginFill(fillColor);
         rect.graphics.lineStyle(borderSize, borderColor);
         rect.graphics.drawRect(x, y, w, h);
         if (borderSize >= 0) rect.graphics.lineStyle();
         if (filled) rect.graphics.endFill();
         
         return rect;
      }
      
      public static function CreateEllipseShape (x:Number, y:Number, w:Number, h:Number, borderColor:uint, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):Shape
      {
         var rect:Shape = new Shape();
         if (filled) rect.graphics.beginFill(fillColor);
         if (borderSize >= 0) rect.graphics.lineStyle(borderSize, borderColor);
         rect.graphics.drawEllipse(x, y, w, h);
         if (borderSize >= 0) rect.graphics.lineStyle();
         if (filled) rect.graphics.endFill();
         
         return rect;
      }
      
      public static function Clear (shape:Object):void
      {
         shape.graphics.clear ();
      }
      
      public static function ClearAndDrawRect (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor, 1.0, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER, 255);
         shape.graphics.drawRect(x, y, w, h);
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawRect (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor, 1.0, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER, 255);
         shape.graphics.drawRect(x, y, w, h);
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
      public static function ClearAndDrawEllipse (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawEllipse(x, y, w, h);
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawEllipse (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawEllipse(x, y, w, h);
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
      public static function ClearAndDrawCircle (shape:Object, x:Number, y:Number, radius:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawCircle(x, y, radius);
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawCircle (shape:Object, x:Number, y:Number, radius:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawCircle(x, y, radius);
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
      public static function ClearAndDrawLine (shape:Object, x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0x0, thickness:Number = 1):void
      {
         shape.graphics.clear ();
         shape.graphics.lineStyle(thickness, color);
         shape.graphics.moveTo(x1, y1);
         shape.graphics.lineTo(x2, y2);
         shape.graphics.lineStyle();
      }
      
      public static function DrawLine (shape:Object, x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0x0, thickness:Number = 1):void
      {
         //trace ("x1 = " + x1 + ", y1 = " + y1 + ", x2= " + x2 + ", y2 = " + y2 + ", thickness = " + thickness);
         
         shape.graphics.lineStyle(thickness, color);
         shape.graphics.moveTo(x1, y1);
         shape.graphics.lineTo(x2, y2);
         shape.graphics.lineStyle();
      }
      
      public static function ClearAndDrawPolygon (shape:Object, points:Array, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         
         if (points == null)
            return;
         
         var vertexCount:uint = points.length;
         if (vertexCount <= 2)
            return;
         
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.moveTo( points [0].x, points [0].y );
         for (var i:uint = 0; i < vertexCount; ++ i)
            shape.graphics.lineTo (points[i].x, points[i].y);
         shape.graphics.lineTo( points [0].x, points [0].y );
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawPolygon (shape:Object, points:Array, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (points == null)
            return;
         
         var vertexCount:uint = points.length;
         if (vertexCount <= 2)
            return;
         
         if (filled) shape.graphics.beginFill(fillColor);
         if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.moveTo( points [0].x, points [0].y );
         for (var i:uint = 0; i < vertexCount; ++ i)
            shape.graphics.lineTo (points[i].x, points[i].y);
         shape.graphics.lineTo( points [0].x, points [0].y );
         if (borderSize >= 0) shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
   }
}