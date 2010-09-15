package net.danro.scrollbox
{
	import com.tweenman.ConstantEase;
	
	/**
	 * @author Dan Rogers
	 */
	public class EasingScrollbox extends Scrollbox
	{
		private var _easeEnabled:Boolean;
		private var _targetY:Number;
		private var _ease:ConstantEase;
		
		public function EasingScrollbox (width:Number, height:Number, options:ScrollboxOptions=null, skin:ScrollboxSkin=null)
		{
			super(width, height, options, skin);
			this._ease = new ConstantEase(this.container);
			this._easeEnabled = true;
		}
		
		// default: 0.3
		public function set easeAmount (value:Number):void
		{
			this._ease.setOptions({ easeAmount: value });
		}
		
		public function set easeEnabled (value:Boolean):void
		{
			this._easeEnabled = value;
			if (!this._easeEnabled) this._ease.disable();
		}
		
		public function get easeEnabled ():Boolean
		{
			return this._easeEnabled;
		}
		
		override public function set containerY (value:Number):void
		{
			this._targetY = value;
			if (this._easeEnabled) {
				this._ease.setProperties({ y: value });
			} else {
				this.container.y = value;
			}
		}
		
		override public function get containerY ():Number
		{
			return this._targetY;
		}
	}
}