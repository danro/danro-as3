package net.danro.utils 
{

	public class NumberUtil 
	{
		public static function addCommas (number:Number):String
		{
			var input:String = String(number);
			if (input.length < 4) return input;
			var output:Array = [];
			var count:int = 0;
			for (var i:int = input.length-1; i>=0; i--)
			{
				count++;
				output.push(input.charAt(i));
				if ((count%3 == 0) && (i - 1 >= 0)) {
					output.push(",");
				}
			}
			output.reverse();
			return output.join("");
		}
	}
}