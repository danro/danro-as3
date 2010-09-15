package net.danro.loaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	
	public class ImageLoader extends SWFLoader
	{
		private var _bmd:BitmapData;
		
		public function ImageLoader ()
		{
			super();
		}
		
		public function get bitmapData ():BitmapData
		{
			return this._bmd;
		}
		
		override public function clear ():void
		{
			super.clear();
			this._bmd = null;
		}
		
		override protected function _completeHandler (e:Event):void 
		{
			this._content = e.target.content as Bitmap;
			Bitmap(this._content).smoothing = true;
			this._bmd = Bitmap(this._content).bitmapData;
			this.addChild(this._content);
			this._ready = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}