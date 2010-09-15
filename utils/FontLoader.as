package net.danro.utils
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class FontLoader extends MovieClip
	{	
		private static var INSTANCE:FontLoader;
		
		public function FontLoader ()
		{
			INSTANCE = this;
		}
		
		public static function getInstance ():FontLoader
		{
			if (!INSTANCE) new FontLoader;
			return INSTANCE;
		}
		
		public function printNames ():void
		{
			for (var i:int=0; i < this.numChildren; ++i)
			{
				var tf:TextField = this.getChildAt(i) as TextField;
				trace("["+ tf.getTextFormat().font + "]");
			}
		}
	}
}