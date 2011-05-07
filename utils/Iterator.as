/*
Iterator

Author: Dan Rogers - http://danro.net

Description: Iterates through an array.

*/
package net.danro.utils
{
	public class Iterator
	{
		private var _collection:Array;
		private var _repeating:Boolean;
		private var _index:int;

		public function Iterator (sourceCollection:Array, repeating:Boolean=true)
		{
			this._collection = sourceCollection || [];
			this._repeating = repeating;
			this._index = 0;
		}
		
		public function set index (i:int):void
		{
			if (this._repeating) i %= this._collection.length;
			this._index = i;
		}
		
		public function get index ():int
		{
			return this._index;
		}
		
		public function hasNext ():Boolean
		{
			return this._index < this._collection.length;
		}
		
		public function next ():*
		{
			return this._collection[ this.index++ ];
		}
	}
}