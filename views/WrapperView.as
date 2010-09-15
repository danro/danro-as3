package net.danro.views
{
	import flash.display.MovieClip;
	
	public class WrapperView extends MovieClip
	{
		public var inner:MovieClip;
		
		public function WrapperView ()
		{
		}
		
		public function show ():void
		{
			if (this.inner) this.addChild(this.inner);
		}
		
		public function hide ():void
		{
			if (this.inner && this.contains(this.inner)) this.removeChild(this.inner);
		}
	}
}