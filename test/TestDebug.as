package
{
	import com.asc.debug.Debug;
	import com.asc.debug.Logger;
	import com.asc.debug.Stats;
	import flash.display.Sprite;
	import flash.events.Event;
	
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
			Debug.log("year={}, month={}, day={}", 2015, 1, 21);
			Debug.color(Debug.RED).log("This is an error!");
			Debug.error("This is an error!");
			
			addChild(Logger.getInstance());
		}
	
	}

}