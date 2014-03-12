package com.beauscott.flex.util
{
    import flash.utils.Dictionary;

    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * This class provides a common interface for logging execution times
     * on the client.  The client must simply keep the "timingKey" returned
     * to it by the start() method, and pass this to the end() method, and
     * this class does the rest.
     */
    public class TimingUtil
    {
        /**
         * Private constructor because this is a Singleton.
         */
        public function TimingUtil()
        {
            throw new Error("TimingUtil is a Singleton - do not instantiate");
        }

        private static var timings : Dictionary = new Dictionary();
        private static var timingsSize : Number = 0;
        private static var log:ILogger = Log.getLogger("com.beauscott.mobile.shared.util.TimingUtil");
        private static const DELIMITER : String = "|";
        private static const MAX_TIMINGS : Number = 25;

        /**
         * Start tracking a particular execution time.
         *
         * @param keyBase an identifier used to organize a timing request
         * @return String key that should be passed to the end() method of this class
         *      to indicate that the execution of a particular process has completed
         */
        public static function start(keyBase : String) : String
        {
            // in order to avoid any memory leaks, don't allow any more than
            // MAX_TIMINGS entries in the dictionary
            if (timingsSize > MAX_TIMINGS)
            {
                timings = new Dictionary();
                log.warn("clearing TimingUtil cache to avoid memory leaks");
            }

            var now : Number = new Date().getTime();
            var key : String = keyBase + DELIMITER + now.toString();
            timings[key] = now;

            return key
        }

        /**
         * Ends tracking a particular execution time, and logs that time to the logging
         * mechanism.
         *
         * @param key the key identifying the start time of the process being tracked
         * @param success true if the process was successful, false otherwise, default=true
         * @param message the message that should appear in the log file with this timing log message
         *      default="complete execution time for".  This message is purely for informational purposes
         *      when a user is browsing the actual log file - it is not used by the grokflextimes.py script
         *      that extracts and summarizes timings
         * @param categoryOverride normally, the keyBase that is passed into the start() method is used to group
         *      the execution time results.  Pass this value to specify a different category with which this
         *      execution time should be grouped.  If null is passed, it will use the keyBase value passed into
         *      start().
         */
        public static function end(
            key : String,
            success : Boolean = true,
            message : String = "complete execution time for",
            categoryOverride : String = null) : void
        {
            if (timings[key] == null)
            {
                log.debug("[TIMING]: timing cache miss [" + key.slice(0, key.indexOf(DELIMITER)) + "] [failure] [0]");
            }
            else
            {
                log.debug("[TIMING]: "
                    + message + " ["
                    + (categoryOverride != null ? categoryOverride : key.slice(0, key.indexOf(DELIMITER))) + "] ["
                    + (success ? "success" : "failure") + "] ["
                    + String(new Date().getTime() - timings[key]) + "]");
            }

            delete timings[key];
        }

    }
}
