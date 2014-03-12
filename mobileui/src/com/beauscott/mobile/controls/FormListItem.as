package com.beauscott.mobile.controls
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import mx.core.IVisualElement;
    import mx.utils.ObjectUtil;
    import mx.validators.Validator;
    
    import spark.core.ISoftKeyboardHintClient;
    
    
    [Event(name="propertyChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="typeChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="controlChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="controlPropertyChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="changeEventChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="editableChanged", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="requiredChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="additionalPropertiesChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="validatorChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="labelChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="enabledChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="optionsChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="currencyCodeChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="click", type="flash.events.MouseEvent")]
    
    [DefaultProperty("control")]
    public class FormListItem extends EventDispatcher implements ISoftKeyboardHintClient
    {
        
        //-----------------------------------------------------------
        // property
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _property:String;

        [Bindable(event="propertyChanged")]
        public function get property():String
        {
            return _property;
        }
        /**
         * @private
         */
        public function set property(value:String):void
        {
            if( _property !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.PROPERTY_CHANGE);
                event.oldValue = _property;
                event.newValue = value;
                _property = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        //-----------------------------------------------------------
        // label
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _label:String;

        [Bindable(event="labelChange")]
        public function get label():String
        {
            return _label == null ? "" : _label;
        }
        /**
         * @private
         */
        public function set label(value:String):void
        {
            if( _label !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.LABEL_CHANGE);
                event.oldValue = _label;
                event.newValue = value;
                _label = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }

        
        //-----------------------------------------------------------
        // type
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _type:String = "text";

        [Inspectable(enumeration="text,date,time,dateAndTime,checkbox,select,password,email,currency,number,custom,heading,link,phone,textArea", defaultValue="text", category="Common")]
        [Bindable(event="typeChange")]
        public function get type():String
        {
            return _type;
        }
        /**
         * @private
         */
        public function set type(value:String):void
        {
            if( _type !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.TYPE_CHANGE);
                event.oldValue = _type;
                event.newValue = value;
                _type = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }

        
        //-----------------------------------------------------------
        // control
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _control:EventDispatcher;

        [Bindable(event="controlChange")]
        public function get control():EventDispatcher
        {
            return type == FormListItemType.CUSTOM || type == FormListItemType.HEADING ? _control : null;
        }
        /**
         * @private
         */
        public function set control(value:EventDispatcher):void
        {
            if( _control !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.CONTROL_CHANGE);
                event.oldValue = _control;
                event.newValue = value;
                _control = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
                if (_control) {
                    if (type != FormListItemType.HEADING)
                        type = FormListItemType.CUSTOM;
                }
                else {
                    type = null;
                }
            }
        }
        
        //-----------------------------------------------------------
        // options
        //-----------------------------------------------------------
        private var _options:Vector.<FormListItemSelectOption>;

        [Bindable(event="optionsChange")]
        public function get options():Vector.<FormListItemSelectOption>
        {
            return _options;
        }

        public function set options(value:Vector.<FormListItemSelectOption>):void
        {
            if( _options !== value)
            {
                var old:Vector.<FormListItemSelectOption> = _options;
                _options = value;
                if (hasEventListener(FormListItemRendererEvent.OPTIONS_CHANGE))
                    dispatchEvent(new FormListItemRendererEvent(
                        FormListItemRendererEvent.OPTIONS_CHANGE, false, false, old, value));
            }
        }

        
        //-----------------------------------------------------------
        // controlProperty
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _controlProperty:String;
        
        [Bindable(event="controlPropertyChange")]
        [Bindable(event="typeChange")]
        [Bindable(event="controlChange")]
        [Bindable(event="changeEventChange")]
        public function get controlProperty():String
        {
            if (_controlProperty) return _controlProperty;
            switch (type) {
                case FormListItemType.CHECKBOX:
                    return "selected";
                    break;
                case FormListItemType.EMAIL:
                case FormListItemType.TEXT:
                case FormListItemType.PASSWORD:
                case FormListItemType.NUMBER:
                case FormListItemType.PHONE:
                case FormListItemType.TEXT_AREA:
                    return "text";
                    break;
                case FormListItemType.CURRENCY:
                    return "value";
                    break;
                case FormListItemType.DATE:
                case FormListItemType.TIME:
                case FormListItemType.DATE_AND_TIME:
                    return "date";
                    break;
                case FormListItemType.SELECT:
                    return "selectedItem";
                    break;
                case FormListItemType.LINK:
                default:
                    return _controlProperty;
            }
        }
        /**
         * @private
         */
        public function set controlProperty(value:String):void
        {
            if( _controlProperty !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.CONTROL_PROPERTY_CHANGE);
                event.oldValue = _controlProperty;
                event.newValue = value;
                _controlProperty = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        //-----------------------------------------------------------
        // changeEvent
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _changeEvent:String = Event.CHANGE;
        
        [Bindable(event="changeEventChange")]
        public function get changeEvent():String
        {
            return _changeEvent;
        }
        /**
         * @private
         */
        public function set changeEvent(value:String):void
        {
            if (value == null) value = Event.CHANGE
            if( _changeEvent !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.CHANGE_EVENT_CHANGE);
                event.oldValue = _changeEvent;
                event.newValue = value;
                _changeEvent = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }

        //-----------------------------------------------------------
        // enabled
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _enabled:Boolean = true;
        
        [Bindable(event="enabledChange")]
        public function get enabled():Boolean
        {
            return _enabled;
        }
        /**
         * @private
         */
        public function set enabled(value:Boolean):void
        {
            if( _enabled !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.ENABLED_CHANGED);
                event.oldValue = _enabled;
                event.newValue = value;
                _enabled = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        //-----------------------------------------------------------
        // editable
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _editable:Boolean = true;

        [Bindable(event="editableChanged")]
        public function get editable():Boolean
        {
            return _editable;
        }
        /**
         * @private
         */
        public function set editable(value:Boolean):void
        {
            if( _editable !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.EDITABLE_CHANGED);
                event.oldValue = _editable;
                event.newValue = value;
                _editable = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        //-----------------------------------------------------------
        // required
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _required:Boolean = false;
        
        [Bindable(event="requiredChange")]
        public function get required():Boolean
        {
            return _required;
        }
        /**
         * @private
         */
        public function set required(value:Boolean):void
        {
            if( _required !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.REQUIRED_CHANGE);
                event.oldValue = _required;
                event.newValue = value;
                _required = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
                if (validator) {
                    validator.required = value;
                }
            }
        }
        
        //-----------------------------------------------------------
        // additionalProperties
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _additionalProperties:Object;
        
        [Bindable(event="additionalPropertiesChange")]
        public function get additionalProperties():Object
        {
            return _additionalProperties;
        }
        /**
         * @private
         */
        public function set additionalProperties(value:Object):void
        {
            if( _additionalProperties !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.ADDITIONAL_PROPERTIES_CHANGE);
                event.oldValue = _additionalProperties;
                event.newValue = value;
                _additionalProperties = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        //-----------------------------------------------------------
        // validator
        //-----------------------------------------------------------
        /**
         * @private
         */
        private var _validator:Validator;
        
        [Bindable(event="validatorChange")]
        public function get validator():Validator
        {
            return _validator;
        }
        /**
         * @private
         */
        public function set validator(value:Validator):void
        {
            if( _validator !== value)
            {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.VALIDATOR_CHANGE);
                event.oldValue = _validator;
                event.newValue = value;
                _validator = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        //-----------------------------------------------------------
        // value
        //-----------------------------------------------------------
        [Bindable("valueCommit")]
        [Bindable("change")]
        public function get controlValue():* {
            return _control && _controlProperty && _control.hasOwnProperty(_controlProperty) ? control[_controlProperty] : undefined;
        }
        
        [Bindable(event="validatorChange")]
        [Bindable("valueCommit")]
        [Bindable("change")]
        public function get isValid():Boolean {
            return _validator && _validator.enabled ? !_validator.validate(controlValue).results : // validator validation
                        required && controlValue !== false ? !!controlValue && !(controlValue is Number && isNaN(controlValue)) : true; // Basic not-null (or empty string or NaN) validation
        }
        
        public function FormListItem():void
        {
            super();
        }
        
        //------------------------
        // ISoftKeyboardHintClient
        //------------------------
        [Bindable]
        [Inspectable(category="General",enumeration="none,word,sentence,all",defaultValue="none")]
        public var autoCapitalize:String;
        
        [Bindable]
        [Inspectable(category="General",defaultValue="true")]
        public var autoCorrect:Boolean = true;
        
        [Bindable]
        [Inspectable(category="General",enumeration="default,done,go,next,search",defaultValue="default")]
        public var returnKeyLabel:String;
        
        [Bindable]
        [Inspectable(category="General",enumeration="default,punctuation,url,number,contact,email",defaultValue="default")]
        public var softKeyboardType:String;
        
        //------------------------
        // IAccessorizableInput
        //------------------------
        private var _inputAccessory:IVisualElement;

        [Bindable(event="inputAccessoryChange")]
        public function get inputAccessory():IVisualElement
        {
            return _inputAccessory;
        }

        public function set inputAccessory(value:IVisualElement):void
        {
            if( _inputAccessory !== value)
            {
                _inputAccessory = value;
                dispatchEvent(new Event("inputAccessoryChange"));
            }
        }
        
        override public function toString():String {
            return ObjectUtil.toString(this, null, ['control', 'validator', 'inputAccessory']);
        }
        
        //------------------------
        // Currencies
        //------------------------
        private var _currencyCode:String;

        [Bindable(event="currencyCodeChange")]
        public function get currencyCode():String
        {
            return _currencyCode;
        }

        /**
         * @private 
         */        
        public function set currencyCode(value:String):void
        {
            if( _currencyCode !== value)
            {
                var event:FormListItemRendererEvent = new FormListItemRendererEvent(FormListItemRendererEvent.CURRENCY_CODE_CHANGE, false, false, _currencyCode, value);
                _currencyCode = value;
                if (hasEventListener(FormListItemRendererEvent.CURRENCY_CODE_CHANGE))
                    dispatchEvent(event);
                
            }
        }
        
        //-------------------------
        // TextArea properties
        //-------------------------
        public var textAreaHeightInLines:Number = NaN;


    }
}