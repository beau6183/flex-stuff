package com.beauscott.mobile.controls
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import mx.core.FlexGlobals;

    public class POSMenuItem extends EventDispatcher
    {
        [Bindable]
        public var label:String;
        
        [Bindable]
        public var action:String;
        
        [Bindable]
        public var styleName:String;
        
        [Bindable]
        public var data:*;
        
        [Bindable]
        public var callback:Function;
        
        private var chromeColorSet:Boolean = false;
        private var _chromeColor:uint = 0;
        [Inspectable(format="color")]
        [Bindable("chromeColorChanged")]
        public function get chromeColor():uint {
            if (chromeColorSet) return _chromeColor;
            return FlexGlobals.topLevelApplication.getStyle('chromeColor');
        }
        /**
         * @private
         */
        public function set chromeColor(x:uint):void {
            if (x !== _chromeColor) {
                chromeColorSet = true;
                _chromeColor = x;
                dispatchEvent(new Event("chromeColorChanged"));
            }
        }
        
        private var _color:uint = 0;
        private var colorSet:Boolean = false;
        
        [Inspectable(format="color")]
        [Bindable(event="colorChanged")]
        public function get color():uint
        {
            if (colorSet) return _color;
            return FlexGlobals.topLevelApplication.getStyle('color');
        }

        public function set color(value:uint):void
        {
            if( _color !== value)
            {
                colorSet = true;
                _color = value;
                dispatchEvent(new Event("colorChanged"));
            }
        }

        
        public function POSMenuItem():void {
            super();
        }
    }
}