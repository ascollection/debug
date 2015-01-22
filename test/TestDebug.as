package
{
	import com.asc.debug.Debug;
	import com.asc.debug.Logger;
	import com.asc.debug.Stats;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class TestDebug extends Sprite
	{
		
		public function TestDebug():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//init stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.frameRate = 25;
			
			//init contextMenu
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var logItem:ContextMenuItem = new ContextMenuItem("LOG MESSAGE", true, true);
			logItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function():void
				{
					if (logger && contains(logger))
					{
						logger.visible = logger.visible ? false : true
					}
				});
			myContextMenu.customItems.push(logItem);
			contextMenu = myContextMenu;
			
			//config
			Debug.allowAdvancedTrace = true; //允许日志定位 若为false [1779 2015-1-22 11:30:07.918] year=2015, month=1, day=22
			Debug.allowArthropodLog = true; //允许arthropod日志输出
			Debug.allowConsole = true; //允许浏览器控制台输出
			Debug.allowOutputTrace = true; //允许trace输出以及logger输出
			
			//testing
			var date:Date = new Date();
			var obj:Object = {'hello': 'world'};
			var arr:Array = ['hello', 'world'];
			Debug.log("year={}, month={}, day={}", date.getFullYear(), date.getMonth() + 1, date.getDate());
			Debug.color(Debug.PINK).log("This is a pink log");
			Debug.warning("warning warning warning");
			Debug.error("This is an error!");
			Debug.object(obj);
			Debug.array(arr);
			Debug.object(date);
			
			addChild(logger);
		}
		
		private var logger:Logger = Logger.getInstance();
	}

}