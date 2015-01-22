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
		
		private const WIDTH:uint = 400;
		private const HEIGHT:uint = 300;
		
		private var background:Shape;
		private var logsText:TextField;
		private var stats:Stats;
		
		private var hideLogBtn:Sprite;
		private var hideStatsBtn:Sprite;
		private var closeBtn:Sprite;
		
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
			background = getShape(WIDTH, HEIGHT, 0x000033);
			addChild(background);
			
			stats = new Stats(WIDTH, HEIGHT)
			addChild(stats);
			
			logsText = createTF(10, 30, WIDTH - 20, HEIGHT - 30);
			logsText.multiline = true;
			addChild(logsText);
			
			closeBtn = new Sprite();
			closeBtn.graphics.beginFill(0x000000, 0.2);
			closeBtn.graphics.drawRect(0, 0, 30, 30);
			closeBtn.graphics.endFill();
			closeBtn.graphics.lineStyle(2, 0xffffff);
			closeBtn.graphics.moveTo(10, 10);
			closeBtn.graphics.lineTo(20, 20);
			closeBtn.graphics.moveTo(20, 10);
			closeBtn.graphics.lineTo(10, 20);
			closeBtn.x = WIDTH - 30;
			closeBtn.y = 0;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseHlr);
			addChild(closeBtn);
			
			addHideLogBtn();
			addHideStatsBtn();
		}
		
		private function addHideLogBtn():void
		{
			if (!logsText || !contains(logsText))
				return;
			hideLogBtn = new Sprite();
			hideLogBtn.graphics.beginFill(0x000000, 0.2);
			hideLogBtn.graphics.drawRect(0, 0, 30, 30);
			hideLogBtn.graphics.endFill();
			hideLogBtn.graphics.lineStyle(2, 0xffffff);
			hideLogBtn.graphics.moveTo(12, 10);
			hideLogBtn.graphics.lineTo(12, 20);
			hideLogBtn.graphics.lineTo(18, 20);
			hideLogBtn.graphics.lineStyle(1, 0x333333, 0.4);
			hideLogBtn.graphics.moveTo(30, 0);
			hideLogBtn.graphics.lineTo(30, 30);
			hideLogBtn.x = WIDTH - 60;
			hideLogBtn.y = 0;
			hideLogBtn.buttonMode = true;
			hideLogBtn.addEventListener(MouseEvent.CLICK, onHideLogHlr);
			addChild(hideLogBtn);
		}
		
		private function addHideStatsBtn():void
		{
			if (!stats || !contains(stats))
				return;
			hideStatsBtn = new Sprite();
			hideStatsBtn.graphics.beginFill(0x000000, 0.2);
			hideStatsBtn.graphics.drawRect(0, 0, 30, 30);
			hideStatsBtn.graphics.endFill();
			hideStatsBtn.graphics.lineStyle(2, 0xffffff);
			hideStatsBtn.graphics.moveTo(20, 10);
			hideStatsBtn.graphics.lineTo(10, 14);
			hideStatsBtn.graphics.lineTo(20, 16);
			hideStatsBtn.graphics.lineTo(10, 20);
			hideStatsBtn.graphics.lineStyle(1, 0x333333, 0.4);
			hideStatsBtn.graphics.moveTo(30, 0);
			hideStatsBtn.graphics.lineTo(30, 30);
			hideStatsBtn.x = WIDTH - 90;
			hideStatsBtn.y = 0;
			hideStatsBtn.buttonMode = true;
			hideStatsBtn.addEventListener(MouseEvent.CLICK, onHideStatsHlr);
			addChild(hideStatsBtn);
		}
		
		private function onHideLogHlr(e:MouseEvent):void
		{
			logsText.visible = logsText.visible ? false : true;
		}
		
		private function onHideStatsHlr(e:MouseEvent):void
		{
			stats.visible = stats.visible ? false : true;
		}
		
		private function onCloseHlr(e:MouseEvent):void
		{
			visible = false;
		}
		
		private function createTF(x:int, y:int, width:int = 0, height:int = 0, fontSize:int = 10):TextField
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
			
			if (hideLogBtn)
			{
				hideLogBtn.x = w - 60;
			}
			
			if (closeBtn)
			{
				closeBtn.x = w - 30;
			}
		}
		
		public function log(str:String, color:String = "#00CC00"):void
		{
			var span:String = '<font color="' + color + '">' + str + '</font><br>'
			logsText.htmlText += span;
			logsText.scrollV = logsText.maxScrollV - logsText.scrollV + 1;
		}
		
		public function clear():void
		{
			logsText.htmlText = "";
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
		}
		
		override public function get visible():Boolean
		{
			return super.visible;
		}
	}
}