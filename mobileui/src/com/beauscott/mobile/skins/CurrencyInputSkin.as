package com.beauscott.mobile.skins
{
    import com.beauscott.flex.localization.Currency;
    import com.beauscott.mobile.controls.CurrencyInput;
    
    import flash.events.Event;
    import flash.events.SoftKeyboardEvent;
    import flash.system.Capabilities;
    
    import mx.core.DPIClassification;
    import mx.core.EventPriority;
    import mx.core.mx_internal;
    import mx.events.FlexEvent;
    
    import spark.components.TextInput;
    import spark.components.supportClasses.StyleableTextField;
    import spark.layouts.HorizontalAlign;
    import spark.skins.mobile.TextInputSkin;
    import spark.skins.mobile.supportClasses.TextSkinBase;
    import spark.skins.mobile160.assets.TextInput_border;
    import spark.skins.mobile240.assets.TextInput_border;
    import spark.skins.mobile320.assets.TextInput_border;
    
    use namespace mx_internal;
    
    /**
     *  ActionScript-based skin for TextInput controls in mobile applications. 
     * 
     * @see spark.components.TextInput
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5 
     *  @productversion Flex 4.5
     */
    public class CurrencyInputSkin extends TextInputSkin
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        public function CurrencyInputSkin()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
//        /** 
//         *  @copy spark.skins.spark.ApplicationSkin#hostComponent
//         */
//        public var hostComponent:TextInput;  // SkinnableComponent will populate
        
        /**
         *  @private
         */
        private var _isIOS:Boolean;
        
        /**
         *  @private
         */
        private var _isEditing:Boolean;
        
        /**
         *  textDisplay skin part.
         */
        public var currencySymbolLabel:StyleableTextField;
        
        /**
         *  @private
         */
        override protected function createChildren():void
        {
            if (!currencySymbolLabel) {
                currencySymbolLabel = StyleableTextField(createInFontContext(StyleableTextField));
                currencySymbolLabel.styleName = this;
                currencySymbolLabel.editable = false;
                currencySymbolLabel.useTightTextBounds = false;
                currencySymbolLabel.mouseEnabled = false;
                currencySymbolLabel.mouseWheelEnabled = false;
                addChild(currencySymbolLabel);
            }
            super.createChildren();
            textDisplay.addEventListener(Event.CHANGE, textDisplay_changeHandler);
            textDisplay.addEventListener(FlexEvent.VALUE_COMMIT, textDisplay_changeHandler);
        }
        
        private function textDisplay_changeHandler(event:Event):void {
//            trace ("changed 1", initialized, parent != null, visible, currencySymbolLabel != null);
            if (parent && visible && currencySymbolLabel) {
                var symbolAlign:String = HorizontalAlign.RIGHT;
                if (getStyle("symbolAlign") == HorizontalAlign.LEFT) {
                    symbolAlign = HorizontalAlign.LEFT;
                }
                if (stage && stage.focus == textDisplay) {
                    textDisplay.setSelection(textDisplay.text.length,textDisplay.text.length);
                }
                invalidateDisplayList();
//                trace ("changed 2");
            }
        }
        
        private var previousHost:CurrencyInput;
        
        override protected function commitProperties():void {
            super.commitProperties();
            if (hostComponent != previousHost) {
                if (previousHost) {
                    previousHost.removeEventListener("currencyCodeChange", currencyCodeChangeHandler);
                }
                previousHost = hostComponent as CurrencyInput;
                if (previousHost) {
                    previousHost.addEventListener("currencyCodeChange", currencyCodeChangeHandler, false, EventPriority.BINDING, true);
                }
                invalidateDisplayList();
            }
        }
        
        private function currencyCodeChangeHandler(event:Event):void {
            invalidateDisplayList();
        }
        
        /**
         *  @private
         
        override protected function measure():void
        {
            super.measure();
            
            var paddingLeft:Number = getStyle("paddingLeft");
            var paddingRight:Number = getStyle("paddingRight");
            var paddingTop:Number = getStyle("paddingTop");
            var paddingBottom:Number = getStyle("paddingBottom");
            var textHeight:Number = getStyle("fontSize") as Number;
            
            if (textDisplay)
            {
                // temporarily change text for measurement
                var oldText:String = textDisplay.text;
                
                // commit styles so we can get a valid textHeight
                textDisplay.text = "Wj";
                textDisplay.commitStyles();
                
                textHeight = textDisplay.measuredTextSize.y;
                textDisplay.text = oldText;
            }
            
            // width is based on maxChars (if set)
            if (hostComponent && hostComponent.maxChars)
            {
                // Grab the fontSize and subtract 2 as the pixel value for each character.
                // This is just an approximation, but it appears to be a reasonable one
                // for most input and most font.
                var characterWidth:int = Math.max(1, (getStyle("fontSize") - 2));
                measuredWidth =  (characterWidth * hostComponent.maxChars) + 
                    paddingLeft + paddingRight + StyleableTextField.TEXT_WIDTH_PADDING;
            }
            
            measuredHeight = paddingTop + textHeight + paddingBottom;
        } */
        
        protected function updateSymbolPosition(unscaledWidth:Number, 
                                                unscaledHeight:Number):void {
            if (!currencySymbolLabel) return;
            
            // position & size the text
            var paddingLeft:Number = getStyle("paddingLeft");
            var paddingRight:Number = getStyle("paddingRight");
            var paddingTop:Number = getStyle("paddingTop");
            var paddingBottom:Number = getStyle("paddingBottom");
            var symbolAlign:String = HorizontalAlign.RIGHT;
            if (getStyle("symbolAlign") == HorizontalAlign.LEFT) {
                symbolAlign = HorizontalAlign.LEFT;
            }
            
            var unscaledTextWidth:Number = unscaledWidth - paddingLeft - paddingRight;
            var unscaledTextHeight:Number = unscaledHeight - paddingTop - paddingBottom;
            
            // default vertical positioning is centered
            var textHeight:Number = getElementPreferredHeight(textDisplay);
            var textY:Number = Math.round(0.5 * (unscaledTextHeight - textHeight)) + paddingTop;
            var adjustedTextHeight:Number = (_isIOS && _isEditing) ? textHeight : textHeight + paddingBottom;
            
            var cdWidthOffset:Number = 0;
            
            if (currencySymbolLabel) {
                currencySymbolLabel.styleChanged(null);
                currencySymbolLabel.commitStyles();
                var cs:String = "$";
                if (previousHost) {
                    cs = previousHost.currencyFormatter.currencySymbol;
                }
                currencySymbolLabel.text = cs;
                cdWidthOffset = currencySymbolLabel.measuredTextSize.x + StyleableTextField.TEXT_WIDTH_PADDING + paddingLeft;
                setElementSize(currencySymbolLabel, currencySymbolLabel.measuredTextSize.x + StyleableTextField.TEXT_WIDTH_PADDING, adjustedTextHeight);
                if (symbolAlign == HorizontalAlign.LEFT) {
                    // set x=0 since we're using textDisplay.leftMargin = paddingLeft
                    setElementPosition(currencySymbolLabel, paddingLeft, textY);
                }
                else {
                    var textMargin:Number = unscaledWidth - cdWidthOffset;
                    if (textDisplay) {
//                        trace (textDisplay.measuredTextSize.x, hostComponent.text);
                        textMargin -= textDisplay.measuredTextSize.x;
                    }
                    if (textMargin > cdWidthOffset) {
                        setElementPosition(currencySymbolLabel, textMargin, textY);
//                        cdWidthOffset = textMargin;
                    }
                    else {
                        setElementPosition(currencySymbolLabel, paddingLeft, textY);
                    }
                }
                
            }
            
            if (textDisplay)
            {
                // We're going to do a few tricks to try to increase the size of our hitArea to make it 
                // easier for users to select text or put the caret in a certain spot.  To do that, 
                // rather than set textDisplay.x=paddingLeft,  we are going to set 
                // textDisplay.leftMargin = paddingLeft.  In addition, we're going to size the height 
                // of the textDisplay larger than just the size of the text inside to increase the hitArea
                // on the bottom.  We'll also assign textDisplay.rightMargin = paddingRight to increase the 
                // the hitArea on the right.  Unfortunately, there's no way to increase the hitArea on the top
                // just yet, but these three tricks definitely help out with regards to user experience.  
                // See http://bugs.adobe.com/jira/browse/SDK-29406 and http://bugs.adobe.com/jira/browse/SDK-29405
                
                // set leftMargin, rightMargin to increase the hitArea.  Need to set it before calling commitStyles().
                var marginChanged:Boolean = ((textDisplay.leftMargin != (paddingLeft + cdWidthOffset)) || 
                    (textDisplay.rightMargin != paddingRight));
                
                textDisplay.leftMargin = paddingLeft + cdWidthOffset;
                textDisplay.rightMargin = paddingRight;
                
                // need to force a styleChanged() after setting leftMargin, rightMargin if they 
                // changed values.  Then we can validate the styles through commitStyles()
                if (marginChanged)
                    textDisplay.styleChanged(null);
                textDisplay.commitStyles();
                
                setElementSize(textDisplay, unscaledWidth, adjustedTextHeight);
                
                // set x=0 since we're using textDisplay.leftMargin = paddingLeft
                setElementPosition(textDisplay, 0, textY);
            }
            
            if (promptDisplay)
            {
                promptDisplay.commitStyles();
                setElementSize(promptDisplay, unscaledTextWidth - cdWidthOffset, adjustedTextHeight);
                setElementPosition(promptDisplay, paddingLeft + cdWidthOffset, textY);
            }
        }
        
        /**
         *  @private
         */
        override protected function layoutContents(unscaledWidth:Number, 
                                                   unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            updateSymbolPosition(unscaledWidth, unscaledHeight);
        }
        
        /**
         *  @private
         */
        private function editableChangedHandler(event:Event):void
        {
            invalidateDisplayList();
        }
        
        /**
         *  @private
         *  The text changed in some way.
         * 
         *  Dynamic fields (ie !editable) with no text measure with width=0 and height=0.
         *  If the text changed, need to remeasure the text to get the correct height so it
         *  will be laid out correctly.
         */
        private function valueCommitHandler(event:Event):void
        {
            if (textDisplay && !textDisplay.editable)
                invalidateDisplayList();
        }
        
        /**
         *  @private
         */
        private function textDisplay_softKeyboardActivatingHandler(event:SoftKeyboardEvent):void
        {
            if (event.isDefaultPrevented())
                return;
            
            _isEditing = true;
            invalidateDisplayList();
        }
        
        /**
         *  @private
         */
        private function textDisplay_softKeyboardDeactivateHandler(event:SoftKeyboardEvent):void
        {
            _isEditing = false;
            invalidateDisplayList();
        }
    }
}