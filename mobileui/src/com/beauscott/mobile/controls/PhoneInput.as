package com.beauscott.mobile.controls
{
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.text.SoftKeyboardType;
    import flash.ui.Keyboard;
    
    import mx.formatters.PhoneFormatter;
    import mx.utils.StringUtil;
    
    import spark.components.TextInput;
    import spark.events.TextOperationEvent;
    
    public class PhoneInput extends TextInput
    {
        [Bindable]
        public var formatter:PhoneFormatter;
        
        public function PhoneInput()
        {
            super();
            formatter = new PhoneFormatter();
            super.softKeyboardType = SoftKeyboardType.NUMBER;
//            super.restrict = "01234569";
            addEventListener(TextEvent.TEXT_INPUT, textInputHandler, true, int.MAX_VALUE);
            addEventListener(KeyboardEvent.KEY_DOWN, textDisplay_keyDownHandler, true, int.MAX_VALUE);
        }
        
        override public function set restrict(value:String):void {
            // not overrideable
        }
        
        override public function set softKeyboardType(value:String):void {
            // not overrideable
        }
        
        [Bindable("change")]
        [Bindable("valueCommit")]
        [Bindable("textChanged")]
        [CollapseWhiteSpace]
        override public function get text():String {
            return super.text.replace(/[^\d]/g, "");
        }
        /**
         * @private
         */
        override public function set text(value:String):void {
            super.text = format(value);
        }
        
        override protected function focusInHandler(event:FocusEvent):void {
            super.focusInHandler(event);
            var n:Number = super.text.length; // pull from super to account for formatting
            selectRange(n, n);
        }
        
        override protected function focusOutHandler(event:FocusEvent):void {
            super.focusOutHandler(event);
            if (cursorManager) {
                cursorManager.showCursor();
            }
        }
        
        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);
        }
        
        override protected function partRemoved(partName:String, instance:Object):void {
            super.partRemoved(partName, instance);
        }
        
        private function textInputHandler(event:TextEvent):void {
            if (event.isDefaultPrevented()) return;
            event.preventDefault();
            var t:String = text + event.text;
            if (t.length > 15) return;
            var tf:String = format(t);
            if (tf) {
                t = tf;
            }
            super.text = t;
            var n:Number = t.length;
            selectRange(n, n);
            
            dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
        }
        
        private function textDisplay_keyDownHandler(event:KeyboardEvent):void {
            if (event.isDefaultPrevented()) return;
            if (event.keyCode == Keyboard.BACKSPACE) {
                event.preventDefault();
                var t:String = text;
                t = t.substr(0, t.length - 1);
                text = t;
                dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            }
            if (event.keyCode == Keyboard.DELETE) {
                event.preventDefault();
                text = "";
                dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            }
        }
        
        private function format(value:String):String {
            //FIXME US support only... 
            var n:String = value ? value.replace(/[^\d]/g, "") : "";
            if (this.resourceManager.localeChain.indexOf("en_US") == -1) {
                return formatter.format(n);
            }
            var l:Number = n.length;
            var showAC:Boolean = n.length >= 10;
            var showCC:Boolean = showAC && (n.charAt(0) == "0" || n.charAt(0) == "1");
            var formatString:String;
            var adl:Number = 0;
            if (l > 3) {
                adl = Math.min(4, l - 3);
                formatString = "###-" + StringUtil.repeat("#", adl);
                l -= adl + 3;
            }
            else {
                formatString = StringUtil.repeat("#", l);
                l = 0;
            }
            
            if (showAC) {
                adl = 3
                l -= adl;
                var ads:String = StringUtil.repeat("#", adl);
                formatString = "(" + ads + ") " + formatString;
                if (showCC && l) {
                    adl = Math.min(3, l);
                    ads = StringUtil.repeat("#", adl);
                    l -= adl;
                    formatString = "+" + ads + " " + formatString;
                }
            }
            if (l > 0) {
                formatString = formatString + " " + StringUtil.repeat("#", l);
            }
            formatter.formatString = formatString;
            var out:String = formatter.format(n);
            formatter.formatString = null; // reset to default;
            return out;
        }
    }
}