package net.danro.loaders
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
		
	public class XMLLoader extends EventDispatcher
	{
		public var data:XML;
		public var loader:URLLoader;
		
		public function XMLLoader ()
		{
			this.loader = new URLLoader;
			this.loader.addEventListener(Event.COMPLETE, this._completeHandler);
		}
		
		public function load (url:String):void
		{
            try {
                this.loader.load(new URLRequest(url));
            } catch (error:Error) {
                trace("Error: unable to load XML: " + url);
            }
		}
		
		private function _completeHandler (e:Event):void
		{
			this.data = new XML(e.target.data);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}