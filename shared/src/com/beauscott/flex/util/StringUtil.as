package com.beauscott.flex.util
{
    public class StringUtil
    {
        public static function camelize(input:String, lowerFirst:Boolean = true):String
        {
            // trim, remove whitespace and multi-dashes and opening dashes
            input = input.replace(/[\r\n\s]/g, '').replace(/\-{2,}/g, '').replace(/^\-/, i);
            if (Test.isEmpty(input)) return input;

            var parts:Array = input.split('-');
			var i:uint = 0;
			if (lowerFirst) {
				i = 1;
            	parts[0] = parts[0].charAt(0).toLowerCase() + parts[0].substring(1);
			}

            for(i; i < parts.length; i++)
                parts[i] = parts[i].charAt(0).toUpperCase() + parts[i].substring(1);

            return parts.join();
        }
    }
}