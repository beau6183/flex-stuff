package com.beauscott.flex.util
{

    /**
     * Utility class that simplifies various types of boolean comparisons.
     */
    public class Compare
    {
        /**
         * Does an 'or' comparison between all given parameters
         * @param The reference value
         * @param the list of objects to compare to the reference
         * @return true if the reference value matches any of the values in
         *      the rest parameter
         */
        public static function any(reference:*, ... rest) : Boolean
        {
            var passes:Boolean = false;
            for each(var arg:* in rest)
            {
                passes = reference == arg;
                if(passes) break;
            }
            return passes;
        }

        /**
         * Performs an all inclusive comparison for all given parameters
         * @param The reference value
         * @param the list of objects to compare to the reference
         * @return true if the reference value matches all of the values in
         *      the rest parameter
         */
        public static function all(reference:*, ... rest) : Boolean
        {
            var passes:Boolean = rest && rest.length;
            for each(var arg:* in rest)
                if(arg != reference) return false;
            return passes;
        }

        /**
         * Performs a greater-than/less-than comparison between subject and the min/max values.
         *
         * @param subject the value to compare to min and max
         * @param min the low end of the range to check
         * @param max the high end of the range to check
         * @param inclusive whether subject is allowed to equal min or max
         * @return true if subject is in between min and max
         */
        public static function between(subject:Object, min:Object, max:Object, inclusive:Boolean = true) : Boolean
        {
            if(inclusive)
            {
                return subject >= min && subject <= max;
            }
            else
            {
                return subject > min && subject < max;
            }
        }
    }
}
