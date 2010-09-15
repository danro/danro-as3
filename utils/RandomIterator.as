/*
RandomIterator

Author: Dan Rogers - http://danro.net

Description: Iterates through a list by selecting a random item and removing it from the list.

*/
package net.danro.utils
{
	public class RandomIterator
	{
		private var _collection:Array;
		private var _punchlist:Array;
		private var _repeating:Boolean;

		public function RandomIterator (sourceCollection:Array, repeating:Boolean=true)
		{
			this._collection = sourceCollection;
			this._punchlist = this._collection.slice();
			this._repeating = repeating;
		}

		public function hasNext ():Boolean
		{
			return this._punchlist.length > 0;
		}
	
		public function next ():*
		{
			if (this._punchlist.length > 1)
			{
				var randomIndex:int = Math.floor(Math.random()*this._punchlist.length);
				var randomObject:* = this._punchlist[randomIndex];
				this._punchlist.splice(randomIndex, 1);
				return randomObject;
			} 
			else
			{
				var lastObject:* = this._punchlist[0];
				this._punchlist = [];
				if (this._repeating) {
					var testObject:*;
					var newList:Array = this._collection.slice();
					for each (testObject in newList)
					{
						if (testObject != lastObject) this._punchlist.push(testObject);
					}
				}
				return lastObject;
			}
		}
	}
}