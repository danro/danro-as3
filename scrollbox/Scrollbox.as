package net.danro.scrollbox
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * @author Simon M Robertson
	 */
	public class Scrollbox extends Sprite
	{
		//----------------------------------------------------------------------
		//
		// Private Constants
		//
		//----------------------------------------------------------------------
		
		private static const BUTTON_STATE_UP:String = "up";
		
		private static const BUTTON_STATE_PRESSED:String = "pressed";
		
		//----------------------------------------------------------------------
		//
		// Private Properties
		//
		//----------------------------------------------------------------------
		
		protected var options:ScrollboxOptions = null;
		
		protected var skin:ScrollboxSkin = null;

		protected var container:Sprite = new Sprite();
				
		protected var containerMask:Shape = new Shape();

		protected var scrollTrack:Sprite = new Sprite();
		
		protected var scrollUp:Sprite = new Sprite();
		
		protected var scrollDown:Sprite = new Sprite();
		
		protected var scrollThumb:Sprite = new Sprite();
		
		protected var metrics:Rectangle = new Rectangle( 0.0, 0.0, -1.0 );
		
		protected var pressedButton:Sprite = null;
		
		protected var dragOffset:Number = 0.0;
		
		protected var scrollDownHeight:Number;
		
		protected var scrollUpHeight:Number;
		
		//
		// Getter/Setter Values
		//

		
		//----------------------------------------------------------------------
		//
		// Constructor
		//
		//----------------------------------------------------------------------
		
		/**
		 * Creates a new Scrollbox object.
		 * 
		 * @param width
		 *        The initial width of the Scrollbox, in pixels.
		 * 
		 * @param height
		 *        The initial height of the Scrollbox, in pixels.
		 * 
		 * @param options
		 *        A ScrollboxOptions object.
		 * 
		 * @param skin
		 *        A ScrollboxSkin object.
		 * 
		 * @see #width
		 * @see #height
		 * @see ScrollboxOptions
		 * @see ScrollboxSkin
		 */
		public function Scrollbox( width:Number, height:Number,
		                           options:ScrollboxOptions=null, skin:ScrollboxSkin=null )
		{
			if (options == null) options = new ScrollboxOptions();
			if (skin == null) skin = new ScrollboxSkin();
			
			this.options = options;
			this.skin = skin;
			
			super.addChild( container );
			super.addChild( containerMask );
			super.addChild( scrollTrack );
			super.addChild( scrollUp );
			super.addChild( scrollDown );
			super.addChild( scrollThumb );
			
			scrollTrack.addChild( skin.trackBitmap );
			scrollUp.addChild( skin.upBitmap );
			scrollDown.addChild( skin.downBitmap );
			scrollThumb.addChild( skin.thumbTopBitmap );
			scrollThumb.addChild( skin.thumbMidBitmap );
			scrollThumb.addChild( skin.thumbBottomBitmap );
			
			scrollUpHeight = options.fixedArrowHeight > 0 ? options.fixedArrowHeight : scrollUp.height;
			scrollDownHeight = options.fixedArrowHeight > 0 ? options.fixedArrowHeight : scrollDown.height;
			
			container.graphics.beginFill( 0, 0.0 );
			container.graphics.drawRect( 0.0, 0.0, 1.0, 1.0 );
			container.graphics.endFill();
			container.mask = containerMask;
			
			container.addEventListener( Event.ADDED, containerListener, false, 100 );
			container.addEventListener( Event.REMOVED, containerListener, false, 100 );

			addEventListener( Event.ADDED_TO_STAGE, addedToStageListener, false, 100 );			
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDownListener, false, 100 );
			
			setSize( width, height );
			disableScrollbar();
		}
		
		//----------------------------------------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 * Forces the Scrollbox to update the size and position of the
		 * scrollbar thumb. This method should be invoked if the height of any
		 * of the Scrollbox's child DisplayObjects is changed.
		 */
		public function invalidate():void
		{
			// We can just invoked the containerListener() method here.
			containerListener();
		}
		
		/**
		 * Sets the position of the Scrollbox.
		 * 
		 * @param x
		 *        The new x position, in pixels.
		 * 
		 * @param y
		 *        The new y position, in pixels.
		 * 
		 * @see #x
		 * @see #y
		 */
		public function setPosition( x:Number, y:Number ):void
		{
			super.x = Math.round( x );
			super.y = Math.round( y );
		}
		
		/**
		 * Sets the size of the Scrollbox.
		 * 
		 * @param width
		 *        The new width, in pixels.
		 * 
		 * @param height
		 *        The new height, in pixels.
		 * 
		 * @see #width
		 * @see #height
		 */
		public function setSize( width:Number, height:Number ):void
		{
			if( width < 0.0 )
			{
				width = 0.0;
			}
			else
			{
				width = Math.round( width );
			}
			
			if( height < 0.0 )
			{
				height = 0.0;
			}
			else
			{
				height = Math.round( height );
			}
			
			// Only update the Scrollbox if the width or height has changed.
			if( width != metrics.width || height != metrics.height )
			{
				metrics.width = width;
				metrics.height = height;
				
				measureChildren();
			}
		}
		
		/**
		 * Scrolls to the top of the Scrollbox's content.
		 */
		public function scrollToTop():void
		{
			setThumbPosition( 0.0 );
		}
		
		/**
		 * Scrolls to the bottom of the Scrollbox's content.
		 */
		public function scrollToBottom():void
		{
			setThumbPosition( height );
		}
		
		/**
		 * Scrolls to the specified position.
		 */
		public function scrollTo (value:Number):void
		{
			scrollPosition = value;
		}
		
		public function set scrollPosition ( value:Number ):void
		{
			var range:Number = container.height - height;
			var percent:Number = ( 1.0 / range ) * value;
			var min:Number = scrollUpHeight;
			var max:Number = height - ( scrollThumb.height + scrollDownHeight );
			var y:Number = ( ( max - min ) * percent ) + min;
			setThumbPosition( y );
		}
		
		public function get scrollPosition ():Number
		{
			return -containerY;
		}
		
		public function set containerY (value:Number):void
		{
			container.y = value;
		}
		
		public function get containerY ():Number
		{
			return container.y;
		}
		
		/**
		 * Scrolls the Scrollbox's content so the specified DisplayObject is
		 * positioned at the top of the window. If the specified DisplayObject
		 * is not a child of the Scrollbox the content is not scrolled.
		 * 
		 * @param child
		 *        The DisplayObject to scroll to.
		 */
		public function scrollToChild( child:DisplayObject ):void
		{
			if( child.parent != container || isScrollbarDisabled() )
			{
				return;
			}
			scrollPosition = child.y;
		}
		
		/**
		 * Vertically aligns all of the Scrollbox's child DisplayObjects.
		 * 
		 * @param spacing
		 *        The amount of space, in pixels, between each DisplayObject.
		 */
		public function alignChildren( spacing:uint=0 ):void
		{
			var offset:Number = 0.0;
			var i:int = -1;
			var n:int = numChildren;
			
			while( ++ i < n )
			{
				var child:DisplayObject = getChildAt( i );
				child.y = offset;
				offset += child.height + spacing;
			}
			
			// Force an update of the container.
			containerListener();
		}
		
		/**
		 * Adds a child DisplayObject to the Scrollbox.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function addChild( child:DisplayObject ):DisplayObject
		{
			return container.addChild( child );
		}
		
		/**
		 * Adds a child DisplayObject instance to the Scrollbox. The child
		 * is added at the index position specified.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
		{
			return container.addChildAt( child, index );
		}
		
		/**
		 * Determines whether the specified DisplayObject is a child of the
		 * Scrollbox instance or the instance itself.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function contains( child:DisplayObject ):Boolean
		{
			return container.contains( child );
		}
		
		/**
		 * Returns the child DisplayObject instance that exists at the
		 * specified index.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function getChildAt( index:int ):DisplayObject
		{
			return container.getChildAt( index );
		}
		
		/**
		 * Returns the child DisplayObject that exists with the specified name.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function getChildByName( name:String ):DisplayObject
		{
			return container.getChildByName( name );
		}
		
		/**
		 * Returns the index position of a child DisplayObject instance.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function getChildIndex( child:DisplayObject ):int
		{
			return container.getChildIndex( child );
		}
		
		/**
		 * Removes the specified child DisplayObject instance from the
		 * child list of the Scrollbox.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function removeChild( child:DisplayObject ):DisplayObject
		{
			return container.removeChild( child );
		}
		
		/**
		 * Removes a child DisplayObject from the specified index position
		 * in the child list of the Scrollbox.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function removeChildAt( index:int ):DisplayObject
		{
			return container.removeChildAt( index );
		}
		
		/**
		 * Changes the position of an existing child DisplayObject in the
		 * Scrollbox.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function setChildIndex( child:DisplayObject, index:int ):void
		{
			container.setChildIndex( child, index );
		}
		
		/**
		 * Swaps the z-order (front-to-back order) of the two specified
		 * child DisplayObjects.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function swapChildren( child1:DisplayObject, child2:DisplayObject ):void
		{
			container.swapChildren( child1, child2 );
		}
		
		/**
		 * Swaps the z-order (front-to-back order) of the child DisplayObjects
		 * at the two specified index positions in the child list.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function swapChildrenAt( index1:int, index2:int ):void
		{
			container.swapChildrenAt( index1, index2 );
		}
		
		//----------------------------------------------------------------------
		//
		// Private Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 * Aligns the container object, scroll-up button, scroll-down button,
		 * scroll thumb, and scroll track, to match the width and height
		 * of the Scrollbox. This method is invoked whenever the width or
		 * height of the Scrollbox is changed.
		 */
		private function measureChildren():void
		{
			scrollTrack.x = width - scrollTrack.width;
			scrollTrack.y = scrollUpHeight;
			scrollTrack.height = height - scrollUpHeight - scrollDownHeight;
			scrollUp.x = width - scrollUp.width;
			scrollDown.x = width - scrollDown.width;
			scrollDown.y = height - scrollDown.height;
			scrollThumb.x = width - scrollThumb.width;
			scrollThumb.y = scrollUpHeight;
			
			var w:Number = width - scrollTrack.width;
			var h:Number = height;
			
			// Update the containerMask so it matches the visible area
			// of the container.
			containerMask.graphics.clear();
			containerMask.graphics.beginFill( 0 );
			containerMask.graphics.drawRect( 0.0, 0.0, w, h );
			containerMask.graphics.endFill();
			
			// Force an update of the container.
			containerListener();
		}
		
		/**
		 * Sets the height of the scroll thumb.
		 */
		private function setThumbHeight( value:Number ):void
		{
			value = Math.round( value );
			
			var top:Bitmap = Bitmap(scrollThumb.getChildAt(0));
			var mid:Bitmap = Bitmap(scrollThumb.getChildAt(1));
			var bottom:Bitmap = Bitmap(scrollThumb.getChildAt(2));
			
			if (!options.autoScaleThumb) value = top.height + mid.height + bottom.height;
			
			mid.y = top.height;
			mid.height = value - ( top.height + bottom.height );
			bottom.y = value - bottom.height;
		}
		
		/**
		 * Sets the position of the scroll thumb. true is returned if the
		 * position of scroll thumb actually changes, otherwise false is returned.
		 */
		private function setThumbPosition( value:Number ):Boolean
		{
			var min:Number = scrollUpHeight;
			var max:Number = height - ( scrollThumb.height + scrollDownHeight );
			
			if( value < min )
			{
				value = min;
			}
			else if( value > max )
			{
				value = max;
			}
			
			if( value != scrollThumb.y )
			{
				scrollThumb.y = value;
				syncContainer();
				scrollThumb.y = Math.round(scrollThumb.y); // fix gaps
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Syncs the position of the container object with the scroll thumb.
		 */
		private function syncContainer():void
		{
			var min:Number = scrollUpHeight;
			var max:Number = height - ( scrollThumb.height + scrollDownHeight );
			var range:Number = max - min;
			var percent:Number = ( 1.0 / range ) * ( scrollThumb.y - min );
			var y:Number = ( container.height - height ) * percent;
			
			containerY = -y;
		}
		
		/**
		 * Sets the visual state of the scroll-up button, the scroll-down
		 * button, or the scroll thumb.
		 */
		private function setButtonState( button:Sprite, state:String ):void
		{
			var bitmap:Bitmap;
			
			if( button == scrollUp )
			{
				switch( state )
				{
					case BUTTON_STATE_UP:
						bitmap = skin.upBitmap;
						break;
					
					case BUTTON_STATE_PRESSED:
						bitmap = skin.upPressedBitmap;
						break;
				}
				
				if( bitmap.parent != button )
				{
					button.addChild( bitmap );
					button.removeChildAt( 0 );
				}

				return;
			}
			
			if( button == scrollDown )
			{
				switch( state )
				{
					case BUTTON_STATE_UP:
						bitmap = skin.downBitmap;
						break;
					
					case BUTTON_STATE_PRESSED:
						bitmap = skin.downPressedBitmap;
						break;
				}
				
				if( bitmap.parent != button )
				{
					button.addChild( bitmap );
					button.removeChildAt( 0 );
				}

				return;
			}
			
			if( button == scrollThumb )
			{
				var bitmapA:Bitmap;
				var bitmapB:Bitmap;
				var bitmapC:Bitmap;
				
				switch( state )
				{
					case BUTTON_STATE_UP:
						bitmapA = skin.thumbTopBitmap;
						bitmapB = skin.thumbMidBitmap;
						bitmapC = skin.thumbBottomBitmap;
						break;
					
					case BUTTON_STATE_PRESSED:
						bitmapA = skin.thumbTopPressedBitmap;
						bitmapB = skin.thumbMidPressedBitmap;
						bitmapC = skin.thumbBottomPressedBitmap;
						break;
				}
				
				if( bitmapA.parent != button )
				{
					var height:Number = button.height;
					
					button.addChild( bitmapA );
					button.addChild( bitmapB );
					button.addChild( bitmapC );
					
					button.removeChildAt( 0 );
					button.removeChildAt( 0 );
					button.removeChildAt( 0 );
					
					setThumbHeight( height );
				}

				return;
			}
		}
		
		/**
		 * Enables the scrollbar.
		 */
		private function enableScrollbar():void
		{
			scrollUp.alpha = 1.0;
			scrollUp.mouseEnabled = true;
			
			scrollDown.alpha = 1.0;
			scrollDown.mouseEnabled = true;
			
			scrollThumb.visible = true;
			scrollTrack.visible = true;
		}
		
		/**
		 * Disables the scrollbar.
		 */
		private function disableScrollbar():void
		{
			scrollUp.alpha = options.disabledButtonAlpha;
			scrollUp.mouseEnabled = false;
			
			scrollDown.alpha = options.disabledButtonAlpha;
			scrollDown.mouseEnabled = false;
			
			scrollThumb.visible = false;
			scrollTrack.visible = false;
			
			setThumbPosition( 0.0 );
		}
		
		/**
		 * Indicates if the scrollbar is enabled.
		 */
		private function isScrollbarDisabled():Boolean
		{
			return ( scrollThumb.visible == false );
		}
		
		/**
		 * Indicates if the mouse is within the bounds of the Scrollbox.
		 */
		private function containsMouse():Boolean
		{
			if( mouseX >= 0 && mouseY >= 0 )
			{
				if( mouseX < width && mouseY < height )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 */
		private function startScrollDrag():void
		{
			dragOffset = scrollThumb.y - mouseY;
			stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveListener, false, 100 );
		}
		
		/**
		 */
		private function stopScrollDrag():void
		{
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveListener );
		}
		
		/**
		 */
		private function startButtonScroll():void
		{
			addEventListener( Event.ENTER_FRAME, updateButtonScroll, false, 100 );
		}
		
		/**
		 */
		private function stopButtonScroll():void
		{
			removeEventListener( Event.ENTER_FRAME, updateButtonScroll );
		}
		
		/**
		 * Invoked on every frame while the scroll-up or scroll-down button
		 * is pressed down.
		 */
		private function updateButtonScroll( event:Event ):void
		{
			var delta:int = options.scrollWheelMultiplier * 0.5;

			if( pressedButton == scrollUp )
			{
				delta = -delta;
			}
			
			setThumbPosition( scrollThumb.y + delta );
		}
		
		/**
		 * Invoked whenever a child DisplayObject is added to, or removed from,
		 * the container object.
		 */
		private function containerListener( event:Event=null ):void
		{
			if( container.height <= height )
			{
				if( isScrollbarDisabled() == false )
				{
					disableScrollbar();
				}

				return;
			}
				
			var range:Number = height - ( scrollUpHeight + scrollDownHeight );
			var percent:Number = ( 1.0 / container.height ) * height;

			setThumbHeight( range * percent );
			
			if( event == null || event.type == Event.REMOVED )
			{
				setThumbPosition( scrollThumb.y );
			}
			
			if( isScrollbarDisabled() )
			{
				enableScrollbar();
			}
		}
		
		/**
		 * Invoked when the Scrollbox is first added to the active display list.
		 */
		private function addedToStageListener( event:Event ):void
		{
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelListener, false, 100, true );
			removeEventListener( Event.ADDED_TO_STAGE, addedToStageListener );
		}
		
		/**
		 * Invoked when the mouse button is pressed.
		 */
		private function mouseDownListener( event:MouseEvent ):void
		{
			if( event.currentTarget != this || isScrollbarDisabled() )
			{
				return;
			}
			
			switch( event.target )
			{
				case scrollUp:
					setButtonState( scrollUp, BUTTON_STATE_PRESSED );
					pressedButton = scrollUp;
					
					startButtonScroll();
					break;
				
				case scrollDown:
					setButtonState( scrollDown, BUTTON_STATE_PRESSED );
					pressedButton = scrollDown;
					
					startButtonScroll();
					break;
				
				case scrollThumb:
					setButtonState( scrollThumb, BUTTON_STATE_PRESSED );
					pressedButton = scrollThumb;

					startScrollDrag();
					break;
				
				case scrollTrack:
					pressedButton = null;
					var delta:int = options.trackScrollMultiplier * scrollTrack.height;
					if (mouseY < scrollThumb.y) delta = -delta;
					setThumbPosition( scrollThumb.y + delta );
					break;
			}
			
			stage.addEventListener( Event.MOUSE_LEAVE, mouseUpListener, false, 200 );
			stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpListener, false, 100 );
		}
		
		/**
		 * Invoked when the mouse button is released after the scroll-up,
		 * scroll-down, or scroll thumb has been pressed.
		 */
		private function mouseUpListener( event:Event ):void
		{
			switch( pressedButton )
			{
				case scrollUp:
					setButtonState( scrollUp, BUTTON_STATE_UP );
					
					stopButtonScroll();
					break;
				
				case scrollDown:
					setButtonState( scrollDown, BUTTON_STATE_UP );
					
					stopButtonScroll();
					break;
				
				case scrollThumb:
					setButtonState( scrollThumb, BUTTON_STATE_UP );
					
					stopScrollDrag();
					break;
			}
			
			pressedButton = null;
			
			stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpListener );
			stage.removeEventListener( Event.MOUSE_LEAVE, mouseUpListener );
		}
		
		/**
		 * Invoked whenever the mouse is moved while the scroll thumb is
		 * being dragged.
		 */
		private function mouseMoveListener( event:MouseEvent ):void
		{
			if( pressedButton != scrollThumb )
			{
				return;
			}
			
			if( setThumbPosition( mouseY + dragOffset ) )
			{
				event.updateAfterEvent();
			}
		}
		
		/**
		 * Invoked whenever the mouse wheel is scrolled.
		 */
		private function mouseWheelListener( event:MouseEvent ):void
		{
			if( options.scrollWheelEnabled == false )
			{
				return;
			}
			
			if( pressedButton == scrollThumb || isScrollbarDisabled() )
			{
				return;
			}
			
			if( containsMouse() )
			{
				var delta:int = options.scrollWheelMultiplier;
				
				if( event.delta > 0 )
				{
					delta = -delta;
				}

				if( setThumbPosition( scrollThumb.y + delta ) )
				{
					event.updateAfterEvent();
				}
			}
		}
		
		//----------------------------------------------------------------------
		//
		// Getters/Setters
		//
		//----------------------------------------------------------------------
		
		/**
		 * @private
		 * Returns the default scaleX value.
		 */
		override public function get scaleX():Number
		{
			return 1.0;
		}
		
		/**
		 * @private
		 * Prevents the scaleX value from being changed.
		 */
		override public function set scaleX( value:Number ):void
		{}
		
		/**
		 * @private
		 * Returns the default scaleY value.
		 */
		override public function get scaleY():Number
		{
			return 1.0;
		}
		
		/**
		 * @private
		 * Prevents the scaleY value from being changed.
		 */
		override public function set scaleY( value:Number ):void
		{}
		
		/**
		 * Indicates the x position of the Scrollbox relative to the registration
		 * point of the Scrollbox's parent. The position of the Scrollbox will
		 * always snap to the nearest whole pixel.
		 */
		override public function get x():Number
		{
			return super.x;
		}
		
		/**
		 * @private (setter)
		 */
		override public function set x( value:Number ):void
		{
			setPosition( value, y );
		}
		
		/**
		 * Indicates the y position of the Scrollbox relative to the registration
		 * point of the Scrollbox's parent. The position of the Scrollbox will
		 * always snap to the nearest whole pixel.
		 */
		override public function get y():Number
		{
			return super.y;
		}
		
		/**
		 * @private (setter)
		 */
		override public function set y( value:Number ):void
		{
			setPosition( x, value );
		}
		
		/**
		 * Indicates the width of the Scrollbox. The width of the Scrollbox
		 * will always snap to the nearest whole pixel.
		 */
		override public function get width():Number
		{
			return metrics.width;
		}
		
		/**
		 * @private (setter)
		 */
		override public function set width( value:Number ):void
		{
			setSize( value, height );
		}
		
		/**
		 * Indicates the height of the Scrollbox. The height of the Scrollbox
		 * will always snap to the nearest whole pixel.
		 */
		override public function get height():Number
		{
			return metrics.height;
		}
		
		/**
		 * @private (setter)
		 */
		override public function set height( value:Number ):void
		{
			setSize( width, value );
		}
		
		/**
		 * Returns the number of child DisplayObjects in the Scrollbox.
		 * 
		 * @see flash.display.DisplayObjectContainer
		 */
		override public function get numChildren():int // read-only
		{
			return container.numChildren;
		}

	}
}
