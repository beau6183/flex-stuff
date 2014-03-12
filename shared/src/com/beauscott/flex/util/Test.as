package com.beauscott.flex.util
{
    import mx.collections.ICollectionView;
    import mx.collections.IList;




    /**
     * A utility for mass boolean checking, akin to Ruby's Try
     */
    public class Test
    {

        /**
         * Does an 'or' comparison between all given parameters
         * Casts all parameters to boolean for comparison
         *
         * @param The list of values to check for true/false. If a given parameter is a function,
         *        the function will be executed and the return value evaluated.
         * @return true if any of the items in rest evaluates to true
         */
        public static function any(... rest) : Boolean
        {
            var passes:Boolean = false;
            for each(var arg:* in rest)
            {
                if(arg is Function)
                {
                    passes = Boolean(arg());
                    if(passes) break;
                }
                else
                {
                    passes = !!arg;
                    if(passes) break;
                }
            }
            return passes;
        }

        /**
         * Performs an all inclusive && comparison for all given parameters
         * Casts all parameters to boolean for comparison. If no arguments
         * are given, true is returned.
         *
         * @param The list of values to check for true/false. If a given parameter is a function,
         *        the function will be executed and the return value evaluated.
         * @return true if sll of the items in rest evaluate to true
         */
        public static function all(... rest) : Boolean
        {
            for each(var arg:* in rest)
            {
                if(arg is Function)
                {
                    return Boolean(arg());
                }
                else
                {
                    if(!arg) return false;
                }
            }
            return true;
        }

        /**
         * Checks a string for zero length, subtracting any whitespace
         * @param input String to check
         * @return True if null, zero length or nothing but white space.
         */
        public static function isWhitespace(input:String):Boolean
        {
            if(isEmpty(input)) return true
            return input.replace(/\s/g, '') == '';
        }

        /**
         * Checks a given object for null or zero-length value
         * @example
         * <code>
         *       Test.isEmpty([]); //true
         *       Test.isEmpty([1]); //false
         *       Test.isEmpty(new ArrayCollection()); //true
         *       Test.isEmpty(new ArrayCollection([1])); //false
         *       Test.isEmpty(null); //true
         *       Test.isEmpty(""); //true
         *       Test.isEmpty("1"); //false
         *       Test.isEmpty(NaN); //true
         *       Test.isEmpty(1); //false
         *       Test.isEmpty(false); //true
         *       Test.isEmpty(true); //false
         * </code>
         * @param input String to check
         * @return True if null or zero length.
         */
        public static function isEmpty(input:*):Boolean
        {
            if(input != null && input !== false)
            {
                switch(true)
                {
                    case input is Number:
                        return isNaN(input);
                        break;

                    case input is ICollectionView:
                    case input is IList:
                    case input is Array:
                    case input is String:
                        return input.length == 0;
                        break;

                    case input is XMLList:
                    case input is XML:
                        return input.length() == 0;
                        break;

                    default:
                        return false;
                        break;
                }
            }

            return true;
        }

    }
}