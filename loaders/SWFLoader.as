package net.danro.loaders
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	
	public class SWFLoader extends Sprite
	{
		protected var _loader:Loader;
		protected var _ready:Boolean;
		protected var _content:DisplayObject;
		protected var _streamOpen:Boolean;
		
		public function SWFLoader ()
		{
			this._loader = new Loader;
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._completeHandler);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this._errorHandler);
		}
		
		public function load (url:String):void
		{
			this._ready = false;
			this._streamOpen = true;
			this._loader.load(new URLRequest(url));
		}
		
		public function clear ():void
		{
			if (this._ready)
			{
				if (this.contains(this._content)) this.removeChild(this._content);
				this._loader.unload();
			}
			else
			{
				if (this._streamOpen) this._loader.close();
			}
			this._ready = false;
			this._streamOpen = false;
			this._content = null;
		}
		
		public function get loader ():Loader
		{
			return this._loader;
		}
		
		public function get ready ():Boolean
		{
			return this._ready;
		}
		
		protected function _completeHandler (e:Event):void 
		{
			this._content = e.target.content as DisplayObject;
			this.addChild(this._content);
			this._ready = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function _errorHandler (e:IOErrorEvent):void
		{
			throw new Error(e);
		}
	}
}