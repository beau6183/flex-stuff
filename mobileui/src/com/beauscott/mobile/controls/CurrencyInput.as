package com.beauscott.mobile.controls
{
    import com.beauscott.flex.localization.ExtendedCurrencyFormatter;
    
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.text.SoftKeyboardType;
    import flash.ui.Keyboard;
    
    import mx.core.FlexGlobals;
    
    import spark.components.Label;
    import spark.components.TextInput;
    import spark.components.supportClasses.StyleableTextField;
    import spark.events.TextOperationEvent;
    import spark.formatters.CurrencyFormatter;
    import spark.formatters.NumberFormatter;
    
    [Style(name="symbolAlign", inherit="yes", type="String", enumeration="left,right")]
    
    public class CurrencyInput extends AccTextInput
    {
        [Bindable]
        public var currencyFormatter:CurrencyFormatter;
        
        private var numberFormatter:NumberFormatter;
        
        //-----------------------------------------------------------
        // Skin parts
        //-----------------------------------------------------------
        [SkinPart]
        public var currencySymbolLabel:StyleableTextField;
        
        
        //-----------------------------------------------------------
        // Properties
        //-----------------------------------------------------------
        override public function set restrict(value:String):void {}
        override public function set selectable(value:Boolean):void {}
        
        [Bindable("change")]
        [Bindable("textChanged")]
        public function get value():Number
        {
            return numberFormatter.parseNumber(super.text);
        }
        /**
         * @private
         */
        public function set value(value:Number):void
        {
            super.text = fixedFormat(value);
        }

        
        private var _allowNegative:Boolean;

        [Bindable(event="allowNegativeChange")]
        public function get allowNegative():Boolean
        {
            return _allowNegative;
        }
        /**
         * @private
         */ 
        public function set allowNegative(value:Boolean):void
        {
            if( _allowNegative !== value)
            {
                _allowNegative = value;
                if (value) {
                    super.restrict = "1234567890-";
                }
                else {
                    super.restrict = "1234567890";
                }
                dispatchEvent(new Event("allowNegativeChange"));
            }
        }
        
        [Bindable(event="currencyCodeChange")]
        public function get currencyCode():String
        {
            return currencyFormatter.currencyISOCode;
        }

        public function set currencyCode(value:String):void
        {
            if( value != null && currencyFormatter.currencyISOCode !== value)
            {
                currencyFormatter.currencyISOCode = value;
                dispatchEvent(new Event("currencyCodeChange"));
                text = formatCurrency(this.value);
            }
        }
        
        [Bindable(event="fractionalDigitsChange")]
        public function get fractionalDigits():uint
        {
            return numberFormatter.fractionalDigits;
        }

        public function set fractionalDigits(value:uint):void
        {
            if (numberFormatter.fractionalDigits !== value)
            {
                numberFormatter.fractionalDigits = value;
                currencyFormatter.fractionalDigits = value;
                dispatchEvent(new Event("fractionalDigitsChange"));
                text = formatCurrency(this.value);
            }
        }

        private function fixedFormat(n:Number):String {
            if (isNaN(n)) n = 0;
            if (n == 0) return numberFormatter.format(1).replace("1", "0");
            return numberFormatter.format(n);
        }
        
        [Bindable(event="currencyCodeChange")]
        [Bindable(event="fractionalDigitsChange")]
        [Bindable("change")]
        [Bindable("textChanged")]
        [CollapseWhiteSpace]
        override public function get text():String {
            var n:Number = numberFormatter.parseNumber(super.text);
            return n.toFixed(fractionalDigits);
        }
        /**
         * @private
         */
        override public function set text(value:String):void {
            var n:Number = numberFormatter.parseNumber(value);
            super.text = fixedFormat(n);
        }
        
        [Bindable(event="currencyCodeChange")]
        [Bindable(event="fractionalDigitsChange")]
        [Bindable("change")]
        [Bindable("textChanged")]
        public function get formattedText():String {
            var n:Number = numberFormatter.parseNumber(super.text);
            return currencyFormatter.format(n);
        }

        public function CurrencyInput()
        {
            super();
            currencyFormatter = new ExtendedCurrencyFormatter();
            currencyFormatter.useCurrencySymbol = true;
            currencyFormatter.useGrouping = true;
            currencyFormatter.fractionalDigits = 2;
            currencyFormatter.trailingZeros = true;
            
            
            numberFormatter = new NumberFormatter();
            numberFormatter.useGrouping = true;
            numberFormatter.fractionalDigits = 2;
            numberFormatter.trailingZeros = true;
            
            text = "0";
            
            super.selectable = false;
            super.restrict = "1234567890";
            addEventListener(TextEvent.TEXT_INPUT, textInputHandler, true, int.MAX_VALUE);
            addEventListener(KeyboardEvent.KEY_DOWN, textDisplay_keyDownHandler, true, int.MAX_VALUE);
            softKeyboardType = SoftKeyboardType.NUMBER;
            setStyle("textAlign", "right");
            addEventListener(FocusEvent.FOCUS_IN, _focusInHandler);
        }
        
        private function _focusInHandler(event:FocusEvent):void {
            var n:Number = super.text.length; // pull from super to account for formatting
            selectRange(n-1, n-1);
        }
        
        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);
        }
        
        override protected function partRemoved(partName:String, instance:Object):void {
            super.partRemoved(partName, instance);
        }
        
        override public function insertText(textToInsert:String):void {
            var n:Number = numberFormatter.parseNumber(text);
            if (isNaN(n)) n = 0;
            if (text == "-") {
                if (allowNegative && n > 0) {
                    n = n * -1;
                }
            }
            else if (textToInsert.length > 1 || restrict.indexOf(textToInsert) == -1) {
                return;
            }
            else {
                var s:String = n.toFixed(fractionalDigits).replace(/[^\d]/g, "");
                s += textToInsert;
                n = Number(s) / (Math.pow(10, fractionalDigits));
                if (n > int.MAX_VALUE) {
                    //                    trace ("Value to large, aborting...", n);
                    return;
                }
            }
            text = n.toFixed(fractionalDigits);
            n = super.text.length; // pull from super to account for formatting
            selectRange(n-1, n-1);
            dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
        }
        
        private function textInputHandler(event:TextEvent):void {
            if (event.isDefaultPrevented()) return;
            event.preventDefault();
            var n:Number = numberFormatter.parseNumber(text);
            if (isNaN(n)) n = 0;
            if (event.text == "-") {
                if (allowNegative && n > 0) {
                    n = n * -1;
                }
            }
            else if (event.text.length > 1 || restrict.indexOf(event.text) == -1) {
                return;
            }
            else {
                var s:String = n.toFixed(fractionalDigits).replace(/[^\d]/g, "");
                s += event.text;
                n = Number(s) / (Math.pow(10, fractionalDigits));
                if (n > int.MAX_VALUE) {
//                    trace ("Value to large, aborting...", n);
                    return;
                }
            }
            text = n.toFixed(fractionalDigits);
            n = super.text.length; // pull from super to account for formatting
            selectRange(n-1, n-1);
            dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
        }
        
        private function textDisplay_keyDownHandler(event:KeyboardEvent):void {
            if (event.isDefaultPrevented()) return;
            selectRange(super.text.length-1, super.text.length-1);
            if (event.keyCode == Keyboard.BACKSPACE) {
                event.preventDefault();
                var t:String = text.replace(/[^\d]/g, "");
                t = t.substr(0, t.length - 1);
                var n:Number = n = Number(t) / (Math.pow(10, fractionalDigits));
                text = n.toFixed(fractionalDigits);
                dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            }
            if (event.keyCode == Keyboard.DELETE) {
                event.preventDefault();
                text = "0";
                dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            }
        }
        
        public function formatCurrency(value:Number):String {
            return currencyFormatter.format(value);
        }
    }
}