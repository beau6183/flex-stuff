package com.beauscott.mobile.controls
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    public class FormListItemSelectOption extends EventDispatcher
    {
        private var _label:String;

        [Bindable(event="labelChange")]
        public function get label():String
        {

            
            // TODO for some reason on the Customer.genderType list (for existing customer), when you clicked on the list, _label was null
            if (_label == null && _labelFunction != null) return _labelFunction(_value);
            if (_label) return _label;
            if (_value !== null) return _value.toString();
            return "";
        }

        /**
         * @private
         */
        public function set label(value:String):void
        {
            if( _label !== value)
            {
                _label = value;
                dispatchEvent(new Event("labelChange"));
            }
        }


        private var _value:Object;

        [Bindable(event="change")]
        public function get value():Object
        {
            return _value;
        }
        /**
         * @private
         */
        public function set value(value:Object):void
        {
            if( _value !== value)
            {
                _value = value;
                dispatchEvent(new Event("change"));
            }
        }

        private var _labelFunction:Function;

        [Bindable(event="labelChange")]
        public function get labelFunction():Function
        {
            return _labelFunction;
        }
        /**
         * @private
         */
        public function set labelFunction(value:Function):void
        {
            if( _labelFunction !== value)
            {
                _labelFunction = value;
                dispatchEvent(new Event("labelChange"));
            }
        }


        public function FormListItemSelectOption()
        {
            super();
        }
        
        public static function toOptionList(src:Object, labelPropOrFunc:Object, valuePropOrFunc:Object = null):Vector.<FormListItemSelectOption> {
            var out:Vector.<FormListItemSelectOption> = new Vector.<FormListItemSelectOption>();
            for each(var obj:Object in src) {
                var label:String;
                var value:* = obj;
                if (labelPropOrFunc is Function) {
                    label = labelPropOrFunc(obj);
                }
                else {
                    label = obj[labelPropOrFunc];
                }
                if (valuePropOrFunc is Function) {
                    value = valuePropOrFunc(obj);
                }
                else if (valuePropOrFunc != null) {
                    value = obj[valuePropOrFunc];
                }
                var opt:FormListItemSelectOption = new FormListItemSelectOption();
                opt.label = label;
                opt.value = value;
                out.push(opt);
            }
            return out;
        }
    }
}