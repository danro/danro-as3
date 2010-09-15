package net.danro.controls
{
	import com.tweenman.TweenMan;
	import flash.display.*;
	import flash.events.*;

	public class BaseButton extends MovieClip
	{
		//--------------------------------------
		//  INIT
		//--------------------------------------
		
		public var id:String;
		public var index:int;
		public var path:String;
		public var target:String;
		public var options:Object;
		
		private var _selected:Boolean;

		public function BaseButton ()
		{
			this.buttonMode = true;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.enable();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function enable ():void
		{
			if (this.mouseEnabled) return;
			this.mouseEnabled = true;
			this._addMouseListeners();
			this.addEventListener(MouseEvent.CLICK, this._clickHandler);
			this._enableHandler();
		}
		
		public function disable ():void
		{
			if (!this.mouseEnabled) return;
			this.mouseEnabled = false;
			this._removeMouseListeners();
			this.removeEventListener(MouseEvent.CLICK, this._clickHandler);
			this._disableHandler();
		}
		
		public override function get enabled ():Boolean
		{
			return this.mouseEnabled;
		}
		
		public override function set enabled (state:Boolean):void
		{
			state ? enable() : disable();
		}
		
		public function select ():void
		{
			if (this._selected) return;
			this._selected = true;
			this._removeMouseListeners();
			this._selectHandler();
		}
		
		public function deselect ():void
		{
			if (!this._selected) return;
			this._selected = false;
			if (this.mouseEnabled) this._addMouseListeners();
			this._deselectHandler();
		}
		
		public function get selected ():Boolean
		{
			return this._selected;
		}
		
		public function set selected (state:Boolean):void
		{
			state ? select() : deselect();
		}
		
		//--------------------------------------
		//  ABSTRACT METHODS
		//--------------------------------------
		
		protected function _enableHandler (e:Event=null):void
		{
		}
		
		protected function _disableHandler (e:Event=null):void
		{
		}
		
		protected function _selectHandler (e:Event=null):void
		{
		}
		
		protected function _deselectHandler (e:Event=null):void
		{
		}
		
		protected function _rollOverHandler (e:Event=null):void
		{
		}
		
		protected function _rollOutHandler (e:Event=null):void
		{
		}
		
		protected function _mouseDownHandler (e:Event=null):void
		{
		}
		
		protected function _mouseUpHandler (e:Event=null):void
		{
		}
		
		protected function _clickHandler (e:MouseEvent):void
		{
		}
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		
		private function _addMouseListeners ():void
		{
			this._removeMouseListeners();
			this.addEventListener(MouseEvent.ROLL_OVER, this._rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, this._rollOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDownHandler);
		}
		
		private function _removeMouseListeners ():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, this._rollOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, this._rollOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDownHandler);
		}
		
		private function __mouseDownHandler (e:Event):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.__mouseUpHandler);
			this.stage.addEventListener(Event.MOUSE_LEAVE, this.__mouseUpHandler);
			this._mouseDownHandler(e);
		}
		
		private function __mouseUpHandler (e:Event):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseUpHandler);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, this.__mouseUpHandler);
			this._mouseUpHandler(e);
		}
	}
}