package net.danro.events
{
	import flash.events.Event;

	public class NavigationEvent extends Event
	{
		public static const CHANGE:String = "navigationChange";
		public static const COMPLETE:String = "navigationComplete";
		
		public var path:String;
		public var options:Object;
		
		public function NavigationEvent (type:String, bubbles:Boolean, cancelable:Boolean, path:String, options:Object=null)
		{
			this.path = path;
			this.options = options;
			super(type, bubbles, cancelable);
		}
	
		override public function clone ():Event
		{
			return new NavigationEvent(type, bubbles, cancelable, this.path, this.options);
		}
	}
}