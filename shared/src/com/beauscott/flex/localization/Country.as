package com.beauscott.flex.localization {
    import flash.events.EventDispatcher;
    
    import mx.utils.ObjectUtil;
    
    public class Country extends EventDispatcher {
        private var _isoCode:String;
        [Bindable("isoCodeChanged")]
        public function get isoCode():String {
            return _isoCode;
        }
        private var _name:String;
        [Bindable("nameChanged")]
        public function get name():String {
            return _name;
        }
        public function Country(isoCode:String = null, name:String = null):void {
            _isoCode = isoCode;
            _name = name;
        }
        override public function toString():String {
            return ObjectUtil.toString(this);
        }
    }
    
}