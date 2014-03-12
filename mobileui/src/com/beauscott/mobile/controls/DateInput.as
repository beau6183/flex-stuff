package com.beauscott.mobile.controls
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.globalization.DateTimeStyle;
    
    import mx.core.IVisualElement;
    import mx.events.FlexEvent;
    
    import spark.components.DateSpinner;
    import spark.components.calendarClasses.DateSelectorDisplayMode;
    import spark.components.supportClasses.StyleableTextField;
    import spark.events.TextOperationEvent;
    import spark.formatters.DateTimeFormatter;
    
    [Exclude(kind="property", name="text")]
    [DefaultProperty("date")]
    public class DateInput extends AccTextInput
    {
        private var dateFormatChanged:Boolean = false;
        private var dateFormatter:DateTimeFormatter;
        
        private var dateChanged:Boolean = false;
        private var _date:Date;
        
        [Bindable("change")]
        [Bindable("valueCommit")]
        [NonCommittingChangeEvent("change")]
        public function get date():Date {
            return _date;
        }
        /**
         * @private
         */
        public function set date(value:Date):void {
            setDate(value);
        }
        
        private function setDate(value:Date):void {
            if (value != _date) {
                _date = value;
                if (_spinner) spinner.selectedDate = _date;
                if (value) {
                    super.text = dateFormatter.format(date);
                }
                else {
                    super.text = "";
                }
                invalidateProperties();
            }
        }
        
        override public function set text(value:String):void {
            if (!value) {
                setDate(null);
                super.text = value;
            }
            else {
                var d:Number = Date.parse(value);
                setDate(new Date(d));
            }
        }
        
        //
        // displayMode
        //
        private var _displayMode:String = "date";
        [Inspectable(category="General", enumeration="date,time,dateAndTime", defaultValue="date")]
        /**
         * @copy spark.controls.DateSpinner:displayMode
         */ 
        public function get displayMode():String
        {
            return _spinner ? _spinner.displayMode : _displayMode;
        }
        /**
         * @private
         */
        public function set displayMode(value:String):void
        {
            if (_spinner) {
                _spinner.displayMode = value;
            }
            else {
                _displayMode = value;
            }
            dateFormatChanged = true;
            invalidateProperties();
        }
        
        public function DateInput()
        {
            super();
            dateFormatter = new DateTimeFormatter();
            setupDateFormatter();
        }
        
        override protected function commitProperties():void {
            if (dateFormatChanged) {
                setupDateFormatter();
            }
            if (dateChanged || dateFormatChanged) {
                super.text = dateFormatter.format(date);
                dateChanged = false;
                dateFormatChanged = false;
            }
        }
        
        private function setupDateFormatter():void {
            switch (displayMode) {
                case DateSelectorDisplayMode.DATE:
                    dateFormatter.dateStyle = DateTimeStyle.MEDIUM;
                    dateFormatter.timeStyle = DateTimeStyle.NONE;
                    break;
                case DateSelectorDisplayMode.TIME:
                    dateFormatter.dateStyle = DateTimeStyle.NONE;
                    dateFormatter.timeStyle = DateTimeStyle.MEDIUM;
                    break;
                case DateSelectorDisplayMode.DATE_AND_TIME:
                    dateFormatter.timeStyle = DateTimeStyle.MEDIUM;
                    dateFormatter.dateStyle = DateTimeStyle.MEDIUM;
                    break;
            }
        }
        
        //
        // Accessory support
        //
        private var _spinner:DateSpinner;
        
        public function get spinner():DateSpinner {
            if (!_spinner) {
                _spinner = new DateSpinner();
                _spinner.width = NaN;
                _spinner.percentWidth = 100;
                _spinner.displayMode = displayMode;
                _spinner.selectedDate = date;
            }
            return _spinner;
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
            setDate(value);
        }
        
        override public function get inputAccessoryValueField():String {
            return "selectedDate";
        }
    }
}