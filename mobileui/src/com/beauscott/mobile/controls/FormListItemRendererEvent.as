package com.beauscott.mobile.controls
{
    import flash.events.Event;
    
    public class FormListItemRendererEvent extends Event
    {
        public static const PROPERTY_CHANGE:String = "propertyChange";
        public static const TYPE_CHANGE:String = "typeChange";
        public static const CONTROL_CHANGE:String = "controlChange";
        public static const CONTROL_PROPERTY_CHANGE:String = "controlPropertyChange";
        public static const CHANGE_EVENT_CHANGE:String = "changeEventChange";
        public static const EDITABLE_CHANGED:String = "editableChanged";
        public static const REQUIRED_CHANGE:String = "requiredChange";
        public static const ADDITIONAL_PROPERTIES_CHANGE:String = "additionalPropertiesChange";
        public static const VALIDATOR_CHANGE:String = "validatorChange";
        public static const LABEL_CHANGE:String = "labelChange";
        public static const ENABLED_CHANGED:String = "enabledChanged";
        public static const SOURCE_DATA_CHANGE:String = "sourceDataChange";
        public static const OPTIONS_CHANGE:String = "optionsChange";
        public static const CURRENCY_CODE_CHANGE:String = "currencyCodeChange";
        public static const INPUT_ACCESSORY_CHANGE:String = "inputAccessoryChange";
        
        public var oldValue:Object;
        
        public var newValue:Object;
        
        public function FormListItemRendererEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, oldValue:Object = null, newValue:Object = null):void
        {
            super(type, bubbles, cancelable);
            this.oldValue = oldValue;
            this.newValue = newValue;
        }
        
        override public function clone():Event {
            return new FormListItemRendererEvent(type, bubbles, cancelable, oldValue, newValue);
        }
    }
}