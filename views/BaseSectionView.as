package net.danro.views
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.tweenman.TweenMan;
	
	public class BaseSectionView extends MovieClip
	{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		public static var INTRO_COMPLETE:String = "introComplete";
		public static var OUTRO_COMPLETE:String = "outroComplete";
		public static var PRELOAD_START:String = "preloadStart";
		public static var PRELOAD_COMPLETE:String = "preloadComplete";
		
		//--------------------------------------
		//  INIT
		//--------------------------------------
		
		private var _model:Object;
		private var _preloaded:Boolean;
		private var _active:Boolean;

		public function BaseSectionView ()
		{
		}
		
		//--------------------------------------
		//  ABSTRACT METHODS
		//--------------------------------------
		
		protected function _init ():void
		{
			// abstract: intialize using data from model
		}
		
		protected function _preloadStart ():void
		{
			// abstract: preload assets and invoke this._preloadComplete
		}

		protected function _intro ():void
		{
			// abstract: animate intro and invoke this._introComplete
		}

		protected function _outro ():void
		{
			// abstract: animate outro
		}

		protected function _destroy ():void
		{
			// abstract: clean up prior to removal
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set model (model:Object):void
		{
			this._model = model;
			this._init();
		}
		
		public function get model ():Object
		{
			return this._model;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function intro ():void
		{
			this._active = true;
			this.mouseEnabled = this.mouseChildren = true;
			if (this._preloaded)
			{
				this._intro();
			}
			else
			{
				this.dispatchEvent(new Event(PRELOAD_START));
				this._preloadStart();
			}
		}

		public function outro ():void
		{
			this._active = false;
			this.mouseEnabled = this.mouseChildren = false;
			this._outro();
		}
		
		public function destroy ():void
		{
			TweenMan.addTween(this, { visible: false });
			this._destroy();
		}
		
		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------
		
		protected function _preloadComplete (...args):void
		{
			this._preloaded = true;
			this.dispatchEvent(new Event(PRELOAD_COMPLETE));
			if (this._active) this._intro();
		}

		protected function _introComplete (...args):void
		{
			this.dispatchEvent(new Event(INTRO_COMPLETE));
		}
	}
}