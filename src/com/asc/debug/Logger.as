package com.asc.debug
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class Logger extends Sprite
	{
		private static var instance:Logger;
		
		private var background:Shape;
		private var logsText:TextField;
		private var closeBtn:Sprite;
		
		public function resize(w:int, h:int):void
		{
			if (background)
			{
				background.width = w;
				background.height = h;
			}
			
			if (logsText)
			{
				logsText.width = w - 20;
				logsText.height = h - 20;
			}
			
			if (closeBtn)
			{
				closeBtn.x = w - closeBtn.width - 4;
				closeBtn.y = 4;
			}
		}
		
		public function log(str:String, color:String = "#00CC00"):void
		{
			var span:String = '<font color="' + color + '">' + str + '</font><br>'
			logsText.htmlText += span;
			logsText.scrollV = logsText.maxScrollV - logsText.scrollV + 1;
		}
		
		public static function getInstance():Logger
		{
			if (!instance)
			{
				instance = new Logger();
			}
			return instance;
		}
		
		public function Logger()
		{
			init();
		}
		
		private function init():void
		{
			background = getShape(400, 300, 0x000033);
			addChild(background);
			
			addChild(new Stats());
			
			logsText = createTF(10, 30, 380, 270);
			logsText.multiline = true;
			addChild(logsText);
			
			closeBtn = new Sprite();
			closeBtn.graphics.beginFill(0x000000, 0.8);
			closeBtn.graphics.drawRect(0, 0, 30, 30);
			closeBtn.graphics.endFill();
			closeBtn.x = 400 - 30;
			closeBtn.y = 0;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseHlr);
			addChild(closeBtn);
			
			var closeTxt:TextField = createTF(0, 5, 30, 20);
			closeTxt.selectable = false;
			closeTxt.mouseEnabled = false;
			closeTxt.text = "   X";
			closeBtn.addChild(closeTxt);
		}
		
		private function onCloseHlr(e:MouseEvent):void
		{
			visible = false;
		}
		
		private function createTF(x:int, y:int, width:int = 0, height:int = 0, fontSize:int = 12):TextField
		{
			var tf:TextField = new TextField();
			tf.textColor = 0xffffff;
			tf.selectable = true;
			tf.backgroundColor = 0x010101;
			tf.x = x;
			tf.y = y;
			tf.defaultTextFormat = new TextFormat("_sanf", fontSize);
			if (width > 0)
				tf.width = width;
			if (height > 0)
				tf.height = height;
			addChild(tf);
			return tf;
		}
		
		private function getShape(width:Number = 100, height:Number = 75, color:uint = 0x000000, alpha:Number = 1):Shape
		{
			var shape:Shape = new Shape();
			drawRect(shape.graphics, width, height, color, alpha);
			return shape;
		}
		
		private function drawRect(graphics:Graphics, width:Number = 100, height:Number = 75, color:uint = 0x000000, alpha:Number = 1):void
		{
			graphics.clear();
			graphics.beginFill(color, alpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}