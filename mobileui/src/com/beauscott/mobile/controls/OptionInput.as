package com.beauscott.mobile.controls
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.core.IVisualElement;
    
    import spark.utils.LabelUtil;

    [Event(name="optionsChange", type="flash.events.Event")]
    [Exclude(kind="property", name="text")]
    [DefaultProperty("options")]
    public class OptionInput extends AccStyleableTextField
    {
        //----------------------------------------
        // options
        //----------------------------------------
        /**
         * @private 
         */        
        private var _options:Array;
        private var optionsChanged:Boolean = false;

        [Bindable(event="optionsChange")]
        public function get options():Array
        {
            return _options ? _options.slice() : null;
        }
        /**
         * @private 
         */
        public function set options(value:Array):void
        {
            if( _options !== value)
            {
                _options = value ? value.slice() : null;
                optionsChanged = true;
                dispatchEvent(new Event("optionsChange"));
                invalidateProperties();
            }
        }

        //----------------------------------------
        // selectedIndex
        //----------------------------------------
        /**
         * @private 
         */
        private var _selectedItem:Object;
        private var selectedItemChanged:Boolean = false;

        [Bindable(event="change")]
        [Bindable("valueCommit")]
        [NonCommittingChangeEvent("change")]
        public function get selectedItem():Object
        {
            return _selectedItem;
        }
        /**
         * @private 
         */
        public function set selectedItem(value:Object):void
        {
            if( _selectedItem !== value)
            {
                _selectedItem = value;
                selectedItemChanged = true;
                super.text = itemToLabel(value);
//                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                invalidateProperties();
            }
        }

        //----------------------------------------
        // selectedIndex
        //----------------------------------------
        /**
         * @private 
         */
        [Bindable(event="change")]
        [Bindable("valueCommit")]
        [NonCommittingChangeEvent("change")]
        public function get selectedIndex():int
        {
            return options && selectedItem ? options.indexOf(selectedItem) : -1;
        }

        public function set selectedIndex(value:int):void
        {
            var idx:int = options && selectedItem ? options.indexOf(selectedItem) : -1;
            if(idx !== value)
            {
                if (value < 0 || value >= (options ? options.length : 0)) {
                    selectedItem = null;
                }
                else {
                    selectedItem = options[value];
                }
            }
        }
        
        //----------------------------------------
        // labelField
        //----------------------------------------
        /**
         * @private 
         */
        private var _labelField:String = "label";

        [Bindable(event="labelChange")]
        public function get labelField():String
        {
            return _labelField;
        }

        public function set labelField(value:String):void
        {
            if( _labelField !== value)
            {
                _labelField = value;
                dispatchEvent(new Event("labelChange"));
            }
        }

        //----------------------------------------
        // labelFunction
        //----------------------------------------
        /**
         * @private 
         */
        private var _labelFunction:Function;

        [Bindable(event="labelChange")]
        public function get labelFunction():Function
        {
            return _labelFunction;
        }

        public function set labelFunction(value:Function):void
        {
            if( _labelFunction !== value)
            {
                _labelFunction = value;
                dispatchEvent(new Event("labelChange"));
            }
        }

        
        //----------------------------------------
        // overrides
        //----------------------------------------
        /**
         * @private 
         */        
        override public function set text(value:String):void {
            selectedItem = labelToItem(value);
        }
        
        /**
         * @private 
         */  
        override public function set editable(value:Boolean):void {
            // Not editable. Ever.
        }

        /**
         * Constructor 
         */        
        public function OptionInput()
        {
            super();
            super.editable = false;
        }
        
        override protected function commitProperties():void {
            setSpinnerData();
            super.commitProperties();
        }
        
        /**
         * Converts a given object to a string value 
         * @param item
         * @return 
         */        
        public function itemToLabel(item:Object):String {
            return LabelUtil.itemToLabel(item, _labelField, _labelFunction);
        }
        
        /**
         * Converts a string value to the first matching computed object label in the options 
         * @param value
         * @return 
         * 
         */        
        public function labelToItem(value:String):Object {
            for each(var opt:Object in options) {
                var l:String = itemToLabel(opt);
                if (value == l) {
                    return opt;
                }
            }
            return null;
        }
        
        //
        // Accessory support
        //
        private var _spinner:OptionInputSpinnerListContainer;
        
        public function get spinner():OptionInputSpinnerListContainer {
            if (!_spinner) {
                _spinner = new OptionInputSpinnerListContainer();
                _spinner.width = NaN;
                _spinner.percentWidth = 100;
                setSpinnerData();
            }
            return _spinner;
        }
        
        protected function setSpinnerData():void {
            if (_spinner != null) {
                if (optionsChanged) {
                    var dp:ArrayCollection = new ArrayCollection(_options);
                    _spinner.dataProvider = dp;
                    optionsChanged = false;
                }
                if (selectedItemChanged) {
                    _spinner.selectedItem = selectedItem;
                    selectedItemChanged = false;
                }
                
                _spinner.labelField = labelField;
                _spinner.labelFunction = labelFunction;
            }
        }
        
        override public function get inputAccessory():IVisualElement
        {
            return spinner;
        }
        
        /**
         * @private
         */
        override public function set inputAccessory(value:IVisualElement):void
        {
            // read only
        }
        
        override protected function commitAccessoryValue(value:*):void {
            if (spinner.selectedIndex == -1 && options && options.length) {
                value = options[0];
            }
            selectedItem = value;
        }
        
        override public function get inputAccessoryValueField():String {
            return "selectedItem";
        }
    }
}