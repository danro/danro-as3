package net.danro.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import com.tweenman.ConstantEase;
	import net.danro.views.ScrollView;
	
	public class ScrollBar extends Sprite
	{
		public static var THUMB_PADDING:int = 10;
		
		public var thumb:Sprite;
		public var track:Sprite;
		public var trackFill:Sprite;
		
		private var _scrollView:ScrollView;
		private var _dragOffsets:Object;
		private var _dragBounds:Object;
		private var _ease:ConstantEase;
		private var _mouseDown:Boolean;
		
		public function ScrollBar ()
		{
			super();
			
			// TODO abstract and move parts to subclass
			
			this.trackFill.mouseEnabled = false;
			this.thumb.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
			this.track.addEventListener(MouseEvent.MOUSE_DOWN, this._trackClickHandler);
			
			this._dragBounds = new Rectangle(this.track.x, this.track.y, this.track.width, this.track.height);
			this._dragBounds.left += THUMB_PADDING;
			this._dragBounds.right -= THUMB_PADDING;
			
			this._ease = new ConstantEase(this);
		}
		
		public function set scrollView (value:ScrollView):void
		{
			this._scrollView = value;
			this.scrollPercent = this._scrollView.scrollPercentX;
			this._scrollView.addEventListener(ScrollView.UPDATE, this._scrollViewUpdateHandler);
		}
		
		public function set scrollPercent (value:Number):void
		{
			if (value < 0 || isNaN(value)) value = 0;
			if (value > 1) value = 1;
			this.thumbX = this._dragBounds.left + this._dragBounds.width * value;
		}
		
		public function get scrollPercent ():Number
		{
			return (this.thumb.x - this._dragBounds.left) / this._dragBounds.width;
		}
		
		private function _mouseDownHandler (e:MouseEvent):void
		{
			this._mouseDown = true;
			this._ease.disable();
			this._dragOffsets = { x: -this.thumb.mouseX, y: -this.thumb.mouseX };
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
			this.stage.addEventListener(Event.MOUSE_LEAVE, this._mouseUpHandler);
		}
		
		private function _mouseMoveHandler (e:MouseEvent=null):void
		{
			var newX:Number = this.mouseX + this._dragOffsets.x;
			if (newX < this._dragBounds.left) newX = this._dragBounds.left;
			if (newX > this._dragBounds.right) newX = this._dragBounds.right;
			this.thumbX = newX;
			this._scrollView.scrollPercentX = this.scrollPercent;
			e.updateAfterEvent();
		}

		private function _mouseUpHandler (e:Event):void
		{
			this._mouseDown = false;
			this._ease.enable();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, this._mouseUpHandler);
			this._scrollView.snapToGrid();
		}
		
		private function set thumbX (x:Number):void
		{
			this.thumb.x = x;
			this.trackFill.width = this.thumb.x - this.thumb.width/2;
		}
		
		private function _trackClickHandler (e:Event):void
		{
			this._scrollView.scrollPercentX = this.track.mouseX / this.track.width;
			this._scrollView.snapToGrid();
		}
		
		private function _scrollViewUpdateHandler (e:Event=null):void
		{
			if (this._mouseDown) return;
			this._ease.setProperties({ scrollPercent: this._scrollView.scrollPercentX });
		}		
	}
}