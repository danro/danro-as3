package net.danro.scrollbox
{
	/**
	 * @author Simon M Robertson
	 */
	public class ScrollboxOptions
	{
		//----------------------------------------------------------------------
		//
		// Public Properties
		//
		//----------------------------------------------------------------------
		
		/**
		 * Indicates if the mouse scroll wheel can be used to scroll the
		 * Scrollbox contents. If true, the contents of the Scrollbox will
		 * only be scrolled if the mouse is within the bounds of the Scrollbox.
		 * If false, the contents will not be scrolled when the mouse scroll
		 * wheel is rolled.
		 * 
		 * @default true
		 */
		public var scrollWheelEnabled:Boolean = false;
		
		// fixed arrow height for transparent curved buttons, set to 0 to disable
		public var fixedArrowHeight:Number = 0;
		
		// percentage of scroll applied when user clicks the scrollTrack
		public var trackScrollMultiplier:Number = 0.2;
		
		// auto scale thumb mid bitmap relative to scroll content
		public var autoScaleThumb:Boolean = true;
		
		//----------------------------------------------------------------------
		//
		// Private Properties
		//
		//----------------------------------------------------------------------
		
		//
		// Getter/Setter Values
		//
		
		private var _disabledButtonAlpha:Number = 0;
		
		private var _scrollWheelMultiplier:Number = 14.0;
		
		//----------------------------------------------------------------------
		//
		// Constructor
		//
		//----------------------------------------------------------------------
		
		/**
		 * Creates a new ScrollboxOptions object.
		 */
		public function ScrollboxOptions()
		{}
		
		//----------------------------------------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 * Reads a XML defined ScrollboxOptions object. XML can be used to
		 * set the properties of a ScrollboxOptions object instead of setting
		 * each property directly.
		 * 
		 * @example
		 * The following code creates a native XML object which is then
		 * passed to a ScrollboxOptions object:
		 * 
		 * <listing version="3.0">
		 * var optionsXML:XML =
		 * &lt;scrollboxOptions&gt;
		 *     &lt;scrollWheelEnabled value="true"/&gt;
		 *     &lt;disabledButtonAlpha value="0.25"/&gt;
		 *     &lt;scrollWheelMultiplier value="8.0"/&gt;
		 * &lt;/scrollboxOptions&gt;
		 * 
		 * var options:ScrollboxOptions = new ScrollboxOptions();
		 * options.parseXML( options );
		 * 
		 * trace( options.disabledButtonAlpha ); // 0.25
		 * trace( options.scrollWheelMultiplier ); // 8.0
		 * </listing>
		 */
		public function parseXML( options:XML ):void
		{
			if( options.scrollWheenEnabled.length() != 0 )
			{
				scrollWheelEnabled =
					String(options.scrollWheelMultiplier.@value) != "false";
			}
			
			if( options.disabledButtonAlpha.length() != 0 )
			{
				disabledButtonAlpha = options.disabledButtonAlpha.@value;
			}
			
			if( options.scrollWheelMultiplier.length() != 0 )
			{
				scrollWheelMultiplier = options.scrollWheelMultiplier.@value;
			}
		}
		
		//----------------------------------------------------------------------
		//
		// Getters/Setters
		//
		//----------------------------------------------------------------------
		
		/**
		 * Indicates how many pixels the Scrollbox's content will be moved
		 * when the mouse wheel is used to scroll the content. The minimum
		 * value is 1.0, if a value below 1.0 is specified it will default
		 * to 1.0
		 * 
		 * @default 10.0
		 */
		public function get scrollWheelMultiplier():Number
		{
			return _scrollWheelMultiplier;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollWheelMultiplier( value:Number ):void
		{
			if( value < 1.0 )
			{
				value = 1.0;
			}
			
			_scrollWheelMultiplier = value;
		}
		
		/**
		 * Indicates the alpha value that will be used for the Scrollbox's
		 * scroll-up and scroll-down buttons when the Scrollbox's scrollbar
		 * is disabled. The scrollbar is disabled when there is not enough
		 * content in the Scrollbox to allow scrolling to take place.
		 * 
		 * @default 0.5
		 */
		public function get disabledButtonAlpha():Number
		{
			return _disabledButtonAlpha;
		}
		
		/**
		 * @private (setter)
		 */
		public function set disabledButtonAlpha( value:Number ):void
		{
			if( value < 0.0 )
			{
				value = 0.0;
			}
			else if( value > 1.0 )
			{
				value = 1.0;
			}
			
			_disabledButtonAlpha = value;
		}

	}
}




















 