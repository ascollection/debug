package com.asc.debug
{
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	
	public class Debug
	{
		
		public static const NAME:String = 'Debug';
		public static const VERSION:String = '0.74';
		public static var password:String = 'password';
		
		public static const RED:uint = 0xCC0000;
		public static const GREEN:uint = 0x00CC00;
		public static const BLUE:uint = 0x6666CC;
		public static const PINK:uint = 0xCC00CC;
		public static const YELLOW:uint = 0xCCCC00;
		public static const LIGHT_BLUE:uint = 0x00CCCC;
		public static const LIGHT_GREY:uint = 0xFEFEFE;
		
		public static var ignoreStatus:Boolean = true;
		public static var secure:Boolean = false;
		public static var secureDomain:String = '*';
		
		public static var allowArthropodLog:Boolean = true;
		public static var allowAdvancedTrace:Boolean = true;
		public static var allowOutputTrace:Boolean = true;
		public static var allowConsole:Boolean = true;
		
		private static const DOMAIN:String = 'com.carlcalderon.Arthropod';
		private static const CHECK:String = '.161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1';
		private static const TYPE:String = 'app';
		private static const CONNECTION:String = 'arthropod';
		
		private static const LOG_OPERATION:String = 'debug';
		private static const ERROR_OPERATION:String = 'debugError';
		private static const WARNING_OPERATION:String = 'debugWarning';
		private static const ARRAY_OPERATION:String = 'debugArray';
		private static const OBJECT_OPERATION:String = 'debugObject';
		private static const CLEAR_OPERATION:String = 'debugClear';
		
		private static var lc:LocalConnection = new LocalConnection();
		private static var inited:Boolean = false;
		private static var r_number:Number = int(Math.random() * 900) + 1000;
		private static var _color:int = -1;
		
		/**
		 * 使用示例：Debug.log("year={}, month={}, day={}", 2015, 1, 21);
		 */
		public static function log(obj:*, ... args):Boolean
		{
			return send(LOG_OPERATION, obj, args, LIGHT_GREY);
		}
		
		public static function error(obj:*, ... args):Boolean
		{
			return send(ERROR_OPERATION, obj, args, RED);
		}
		
		public static function warning(obj:*, ... args):Boolean
		{
			return send(WARNING_OPERATION, obj, args, YELLOW);
		}
		
		public static function clear():Boolean
		{
			return send(CLEAR_OPERATION, 0);
		}
		
		public static function array(arr:Array):Boolean
		{
			return send(ARRAY_OPERATION, arr);
		}
		
		public static function object(obj:*):Boolean
		{
			return send(OBJECT_OPERATION, obj);
		}
		
		/**
		 * 设置下一条log信息的颜色。
		 * 如：Debug.color(Debug.RED).log("This is an error!");
		 */
		public static function color(value:uint):*
		{
			_color = value;
			return Debug;
		}
		
		private static function send(operation:String, obj:*, args:Array = null, msgColor:uint = LIGHT_GREY):Boolean
		{
			var msg:String = String(obj);
			var placehoder:String = "{}";
			var pIndex:int = 0;
			var argIndex:int = 0;
			var arg:String = null;
			var console_fun:String;
			
			if (args != null)
			{
				while ((pIndex = msg.indexOf(placehoder, pIndex)) != -1 && args.length > 0)
				{
					arg = String(args.shift());
					msg = msg.substring(0, pIndex) + arg + msg.substring(pIndex + 2);
					pIndex += arg.length;
				}
				if (args.length > 0)
				{
					msg += " " + args.join(" ");
				}
			}
			
			if (operation == ARRAY_OPERATION)
			{
				operation = LOG_OPERATION;
				msgColor = BLUE;
				msg = 'array: ' + msg;
			}
			if (operation == OBJECT_OPERATION)
			{
				operation = LOG_OPERATION;
				msgColor = GREEN;
				msg = 'object: ' + msg;
			}
			
			msg = wrapMessage(msg, allowAdvancedTrace);
			if (allowOutputTrace)
			{
				trace(msg);
				if (_color >= 0)
				{
					msgColor = _color;
				}
				if (operation == CLEAR_OPERATION)
					Logger.getInstance().clear();
				else
					Logger.getInstance().log(msg, hex2css(msgColor));
			}
			
			if (allowConsole)
			{
				try
				{
					if (ExternalInterface.available)
					{
						switch (operation)
						{
							case LOG_OPERATION: 
								console_fun = 'console.log';
								break;
							case WARNING_OPERATION: 
								console_fun = 'console.warn';
								break;
							case ERROR_OPERATION: 
								console_fun = 'console.error';
								break;
							case CLEAR_OPERATION: 
								console_fun = 'console.clear';
								break;
							case ARRAY_OPERATION: 
							case OBJECT_OPERATION: 
								console_fun = 'console.dir';
								break;
							default: 
								console_fun = 'console.log';
						}
						
						ExternalInterface.call(console_fun, (operation == CLEAR_OPERATION || operation == ARRAY_OPERATION || operation == OBJECT_OPERATION) ? obj : msg)
					}
				}
				catch (e:*)
				{
					
				}
			}
			
			if (!inited)
			{
				if (!secure)
					lc.allowInsecureDomain('*');
				else
					lc.allowDomain(secureDomain);
				if (ignoreStatus)
					lc.addEventListener(StatusEvent.STATUS, ignore);
				else
					lc.addEventListener(StatusEvent.STATUS, status);
				inited = true;
			}
			
			if (allowArthropodLog)
			{
				if (_color >= 0)
				{
					msgColor = _color;
					_color = -1;
				}
				try
				{
					lc.send(TYPE + '#' + DOMAIN + CHECK + ':' + CONNECTION, operation, password, msg, msgColor);
					return true;
				}
				catch (e:*)
				{
					return false;
				}
			}
			return false;
		}
		
		private static function wrapMessage(msg:String, allowAdvancedTrace:Boolean = true):String
		{
			var date:Date = new Date();
			var time:String = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + String("00" + date.hours).substr(-2) + ":" + String("00" + date.minutes).substr(-2) + ":" + String("00" + date.seconds).substr(-2) + "." + String("000" + date.milliseconds).substr(-3);
			var str:String = "[" + r_number + " " + time;
			
			var stack:String;
			if (allowAdvancedTrace)
			{
				try
				{
					throw new Error();
				}
				catch (err:Error)
				{
					stack = err.getStackTrace();
						//trace(stack);
				}
			}
			
			if (stack)
			{
				stack = stack.split("\t").join("");
				var lines:Array = stack.split("\n").slice(4);
				var className:String = "";
				var method:String = "";
				var file:String = "";
				var lineNumber:String = "";
				
				for (var i:int = 0; i < 1; i++)
				{
					var line:String = String(lines[i]).substring(3);
					var methodIndex:int = line.indexOf("/");
					var bracketIndex:int = line.indexOf("[");
					var endIndex:int;
					
					endIndex = methodIndex >= 0 ? methodIndex : bracketIndex != -1 ? bracketIndex : line.length;
					className = getClassType(line.substring(0, endIndex));
					if (methodIndex != line.length && methodIndex != bracketIndex)
					{
						endIndex = bracketIndex != -1 ? bracketIndex : line.length;
						method = line.substring(methodIndex + 1, endIndex - 2);
					}
					if (methodIndex == -1)
					{
						method = "$iinit";
					}
					if (bracketIndex != -1 && bracketIndex != line.length)
					{
						file = line.substring(bracketIndex + 1, line.lastIndexOf(":"));
						lineNumber = line.substring(line.lastIndexOf(":") + 1, line.length - 1);
					}
				}
				
				str += " " + className + "." + method;
				if (lineNumber)
					str += ":" + lineNumber;
			}
			
			str += "] " + msg;
			
			return str;
		}
		
		private static function getClassType(type:String):String
		{
			if (type.indexOf("::") != -1)
			{
				type = type.substring(type.indexOf("::") + 2, type.length);
			}
			
			if (type.indexOf("::") != -1)
			{
				var part1:String = type.substring(0, type.indexOf("<") + 1);
				var part2:String = type.substring(type.indexOf("::") + 2, type.length);
				type = part1 + part2;
			}
			
			type = type.replace("()", "").replace("MethodClosure", "Function").replace(/\$$/, "");
			
			return type;
		}
		
		private static function status(e:StatusEvent):void
		{
			trace('Arthropod status:\n' + e.toString());
		}
		
		private static function ignore(e:StatusEvent):void
		{
		
		}
		
		private static function hex2css(color:int):String
		{
			return "#" + color.toString(16);
		}
	}
}
