package net.danro.scrollbox
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	/**
	 * @author Simon M Robertson
	 */
	public class ScrollboxSkin
	{
		//----------------------------------------------------------------------
		//
		// Private Properties
		//
		//----------------------------------------------------------------------
		
		//
		// Getter/Setter Values
		//
		
		private var _scrollTrack:String = null;
		
		private var _scrollUp:String = null;
		
		private var _scrollUpPressed:String = null;
		
		private var _scrollDown:String = null;

		private var _scrollDownPressed:String = null;

		private var _scrollThumbTop:String = null;

		private var _scrollThumbTopPressed:String = null;

		private var _scrollThumbMid:String = null;

		private var _scrollThumbMidPressed:String = null;

		private var _scrollThumbBottom:String = null;

		private var _scrollThumbBottomPressed:String = null;
		
		//----------------------------------------------------------------------
		//
		// Internal Properties
		//
		//----------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal var trackBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var upBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var upPressedBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var downBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var downPressedBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var thumbTopBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var thumbTopPressedBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var thumbMidBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var thumbMidPressedBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var thumbBottomBitmap:Bitmap = new Bitmap();
		
		/**
		 * @private
		 */
		internal var thumbBottomPressedBitmap:Bitmap = new Bitmap();
		
		//----------------------------------------------------------------------
		//
		// Constructor
		//
		//----------------------------------------------------------------------
		
		/**
		 * Creates a new ScrollboxSkin object.
		 */
		public function ScrollboxSkin()
		{
			setDefaults();			
		}
		
		private function setDefaults ()
		{
			scrollTrack = "ScrollTrack";
			scrollUp = "ScrollUpButton";
			scrollUpPressed = "ScrollUpButton";
			scrollDown = "ScrollDownButton";
			scrollDownPressed = "ScrollDownButton";
			scrollThumbTop = "ScrollThumbTop";
			scrollThumbTopPressed = "ScrollThumbTop";
			scrollThumbMid = "ScrollThumbMid";
			scrollThumbMidPressed = "ScrollThumbMid";
			scrollThumbBottom = "ScrollThumbBottom";
			scrollThumbBottomPressed = "ScrollThumbBottom";
		}
		
		//----------------------------------------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 * Reads a XML defined ScrollboxSkin object. XML can be used to
		 * set the properties of a ScrollboxSkin object instead of setting
		 * each property directly.
		 * 
		 * @example
		 * The following code creates a native XML object which is then
		 * passed to a ScrollboxSkin object:
		 * 
		 * <listing version="3.0">
		 * var skinXML:XML =
		 * &lt;scrollboxSkin&gt;
		 *     &lt;scrollbar&gt;
		 *         &lt;track class="lib.skin.Track"/&gt;
		 *         &lt;up class="lib.skin.Up"/&gt;
		 *         &lt;upPressed class="lib.skin.UpPressed"/&gt;
		 *         &lt;down class="lib.skin.Down"/&gt;
		 *         &lt;downPressed class="lib.skin.DownPressed"/&gt;
		 *         &lt;thumb&gt;
		 *             &lt;top class="lib.skin.ThumbTop"/&gt;
		 *             &lt;mid class="lib.skin.ThumbMid"/&gt;
		 *             &lt;bottom class="lib.skin.ThumbBottom"/&gt;
		 *             &lt;topPressed class="lib.skin.ThumbTopPressed"/&gt;
		 *             &lt;midPressed class="lib.skin.ThumbMidPressed"/&gt;
		 *             &lt;bottomPressed class="lib.skin.ThumbBottomPressed"/&gt;
		 *         &lt;/thumb&gt;
		 *     &lt;/scrollbar&gt;
		 * &lt;/scrollboxSkin&gt;
		 * 
		 * var skin:ScrollboxSkin = new ScrollboxSkin();
		 * skin.parseXML( options );
		 * </listing>
		 */
		public function parseXML( skin:XML ):void
		{
			var node:XML = skin.scrollbar[0];
			
			scrollTrack = node.track.attribute( "class" );
			
			scrollUp = node.up.attribute( "class" );
			scrollUpPressed = node.upPressed.attribute( "class" );
			
			scrollDown = node.down.attribute( "class" );
			scrollDownPressed = node.downPressed.attribute( "class" );
			
			scrollThumbTop = node.thumb.top.attribute( "class" );
			scrollThumbTopPressed = node.thumb.topPressed.attribute( "class" );
			scrollThumbMid = node.thumb.mid.attribute( "class" );
			scrollThumbMidPressed = node.thumb.midPressed.attribute( "class" );
			scrollThumbBottom = node.thumb.bottom.attribute( "class" );
			scrollThumbBottomPressed = node.thumb.bottomPressed.attribute( "class" );
		}
		
		//----------------------------------------------------------------------
		//
		// Private Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 */
		private function setBitmapData( bitmap:Bitmap, className:String ):void
		{
			var bitmapData:BitmapData = null;
			
			try
			{
				var cls:Object = getDefinitionByName( className );
				bitmapData = new cls( 0, 0 );
			}
			catch( error:Error )
			{}
			
			try
			{
				bitmap.bitmapData.dispose();
			}
			catch( error:Error )
			{}
			
			bitmap.bitmapData = bitmapData;
		}
		
		//----------------------------------------------------------------------
		//
		// Getter/Setters
		//
		//----------------------------------------------------------------------
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the Scrollbox's scrollbar track.
		 * 
		 * <p>If you do not want the scrollbar to have a visible track
		 * you should pass an empty string to this property.</p>
		 * 
		 * <p>The BitmapData object used for the scrollbar track will be
		 * stretched vertically to match the height of the Scrollbox.</p>
		 */
		public function get scrollTrack():String
		{
			return _scrollTrack;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollTrack( value:String ):void
		{
			_scrollTrack = value;
			setBitmapData( trackBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the Scrollbox's scroll-up button.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll-up
		 * button you should pass an empty string to this property.</p>
		 */
		public function get scrollUp():String
		{
			return _scrollUp;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollUp( value:String ):void
		{
			_scrollUp = value;
			setBitmapData( upBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the Scrollbox's scroll-up button
		 * while it is pressed down.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll-up
		 * button you should pass an empty string to this property.</p>
		 */
		public function get scrollUpPressed():String
		{
			return _scrollUpPressed;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollUpPressed( value:String ):void
		{
			_scrollUpPressed = value;
			setBitmapData( upPressedBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the Scrollbox's scroll-down button.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll-down
		 * button you should pass an empty string to this property.</p>
		 */
		public function get scrollDown():String
		{
			return _scrollDown;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollDown( value:String ):void
		{
			_scrollDown = value;
			setBitmapData( downBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the Scrollbox's scroll-down button
		 * while it is pressed down.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll-down
		 * button you should pass an empty string to this property.</p>
		 */
		public function get scrollDownPressed():String
		{
			return _scrollDownPressed;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollDownPressed( value:String ):void
		{
			_scrollDownPressed = value;
			setBitmapData( downPressedBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the top of the Scrollbox's scroll thumb.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll thumb
		 * you should pass an empty string to this property.</p>
		 */
		public function get scrollThumbTop():String
		{
			return _scrollThumbTop;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollThumbTop( value:String ):void
		{
			_scrollThumbTop = value;
			setBitmapData( thumbTopBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the top of the Scrollbox's scroll thumb
		 * while the scroll thumb is pressed down.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll thumb
		 * you should pass an empty string to this property.</p>
		 */
		public function get scrollThumbTopPressed():String
		{
			return _scrollThumbTopPressed;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollThumbTopPressed( value:String ):void
		{
			_scrollThumbTopPressed = value;
			setBitmapData( thumbTopPressedBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the middle of the Scrollbox's scroll thumb.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll thumb
		 * you should pass an empty string to this property.</p>
		 * 
		 * <p>The BitmapData object used for the middle of the scroll thumb
		 * will be stretched vertically to fill the space between the top and
		 * bottom sections of the scroll thumb.</p>
		 */
		public function get scrollThumbMid():String
		{
			return _scrollThumbMid;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollThumbMid( value:String ):void
		{
			_scrollThumbMid = value;
			setBitmapData( thumbMidBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the middle of the Scrollbox's scroll thumb
		 * while the scroll thumb is pressed down.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll thumb
		 * you should pass an empty string to this property.</p>
		 * 
		 * <p>The BitmapData object used for the middle of the scroll thumb
		 * will be stretched vertically to fill the space between the top and
		 * bottom sections of the scroll thumb.</p>
		 */
		public function get scrollThumbMidPressed():String
		{
			return _scrollThumbMidPressed;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollThumbMidPressed( value:String ):void
		{
			_scrollThumbMidPressed = value;
			setBitmapData( thumbMidPressedBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the bottom of the Scrollbox's scroll thumb.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll thumb
		 * you should pass an empty string to this property.</p>
		 */
		public function get scrollThumbBottom():String
		{
			return _scrollThumbBottom;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollThumbBottom( value:String ):void
		{
			_scrollThumbBottom = value;
			setBitmapData( thumbBottomBitmap, value );
		}
		
		/**
		 * Indicates the qualified class name of the BitmapData object that
		 * will be used to represent the bottom of the Scrollbox's scroll thumb
		 * while the scroll thumb is pressed down.
		 * 
		 * <p>If you do not want the scrollbar to have a visible scroll thumb
		 * you should pass an empty string to this property.</p>
		 */
		public function get scrollThumbBottomPressed():String
		{
			return _scrollThumbBottomPressed;
		}
		
		/**
		 * @private (setter)
		 */
		public function set scrollThumbBottomPressed( value:String ):void
		{
			_scrollThumbBottomPressed = value;
			setBitmapData( thumbBottomPressedBitmap, value );
		}

	}
}




















