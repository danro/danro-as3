package net.danro.views
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import com.tweenman.TweenMan;
	import com.tweenman.ConstantEase;
	
	public class ScrollView extends Sprite
	{		
		public static var UPDATE:String = "scrollViewUpdate";
		
		public var content:Sprite;
		
		private var _ease:ConstantEase;
		private var _wrapper:Sprite;
		private var _rectangle:Rectangle;
		private var _scrollX:Number = 0;
		private var _gridWidth:Number;
		
		public function ScrollView ()
		{
			super();
		
			// TODO abstract and move parts to subclass
			
			this._wrapper = new Sprite;
			this.addChild(this._wrapper);
			
			this.content = new Sprite;
			this._wrapper.addChild(this.content);
			
			this.rectangle = new Rectangle(0, 0, 100, 100);
		}

		public function set rectangle (value:Rectangle):void
		{
			this._rectangle = value;
			this._ease = new ConstantEase(this._rectangle);
			this._ease.onUpdate = this._easeUpdateHandler;
			this._easeUpdateHandler();
		}

		// default = 0.3
		public function set easeAmount (value:Number):void
		{
			this._ease.setOptions({ easeAmount: value });
		}		

		public function set scrollX (value:Number):void
		{
			this._scrollX = value;
			this._ease.setProperties({ x: value });
		}
		
		public function get scrollX ():Number
		{
			return this._rectangle.x;
		}
		
		public function set scrollPercentX (value:Number):void
		{
			this.scrollX = (this.content.width - this._rectangle.width) * value;
		}
		
		public function get scrollPercentX ():Number
		{
			return this._scrollX / (this.content.width - this._rectangle.width);
		}
						
		public function set gridWidth (value:Number):void
		{
			this._gridWidth = value;
		}
		
		public function snapToGrid ():void
		{
			var gridCountX:int = Math.round(this._scrollX / this._gridWidth);
			this.scrollX = gridCountX * this._gridWidth;
		}
		
		private function _easeUpdateHandler ():void
		{
			this._wrapper.scrollRect = this._rectangle;
			this.dispatchEvent(new Event(UPDATE));
		}
	}
}