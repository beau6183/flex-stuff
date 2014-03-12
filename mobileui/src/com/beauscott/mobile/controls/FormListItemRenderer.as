package com.beauscott.mobile.controls
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.AntiAliasType;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    
    import mx.binding.utils.BindingUtils;
    import mx.binding.utils.ChangeWatcher;
    import mx.core.EventPriority;
    import mx.core.mx_internal;
    import mx.managers.IFocusManagerComponent;
    import mx.validators.Validator;
    
    import spark.components.LabelItemRenderer;
    import spark.components.supportClasses.SkinnableTextBase;
    import spark.components.supportClasses.StyleableTextField;
    import spark.core.IEditableText;
    import spark.core.ISoftKeyboardHintClient;
    
    use namespace mx_internal;
    
    [Style(name="textRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="dateRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="timeRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="dateAndTimeRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="checkBoxRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="selectRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="passwordRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="emailRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="currencyRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="numberRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="phoneRenderer", inherit="yes", type="Class", format="Class")]
    
    [Style(name="labelColor", inherit="yes", type="uint", format="Color", theme="spark, mobile")]
    [Style(name="headingColor", inherit="yes", type="uint", format="Color", theme="spark, mobile")]
    [Style(name="errorColor", inherit="yes", type="uint", format="Color", theme="spark, mobile")]
    [Style(name="requiredSymbol", inherit="yes", type="String", format="String", theme="spark, mobile")]
    [Style(name="drawFirstBorder", inherit="yes", type="Boolean", format="Boolean")]
    [Style(name="drawLastBorder", inherit="yes", type="Boolean", format="Boolean")]
    [Style(name="groupTopCornerRadius", inherit="no", type="Number", format="Number")]
    [Style(name="groupBottomCornerRadius", inherit="no", type="Number", format="Number")]
    [Style(name="borderVisible", inherit="no", type="Boolean", format="Boolean")]
    [Style(name="borderThickness", inherit="no", type="Number", format="Number")]
    [Style(name="borderColor", inherit="no", type="uint", format="Color")]
    [Style(name="borderAlpha", inherit="no", type="Number", format="Number")]
    
    public class FormListItemRenderer extends LabelItemRenderer implements IFormListItemRenderer, ISoftKeyboardHintClient, IFocusManagerComponent
    {
        public static const LINK_INDICATOR_WIDTH:int = 20;
        
        private var _formItems:Vector.<FormListItem>;
        public function set formItems(value:Vector.<FormListItem>):void {
            _formItems = value;
        }
        
        private var requiredDisplay:StyleableTextField;
        /**
         * @private
         */
        private var sourceDataChanged:Boolean = false;
        /**
         * @private
         */
        private var _sourceData:Object;

        [Bindable(event="sourceDataChange")]
        public function get sourceData():Object
        {
            return _sourceData;
        }
        /**
         * @private
         */ 
        public function set sourceData(value:Object):void
        {
            if( _sourceData !== value)
            {
                unwatchSourceData(false);
                _sourceData = value;
                sourceDataChanged = true;
                dispatchEvent(new Event("sourceDataChange"));
                invalidateProperties();
            }
        }
        
        
        /**
         * @private
         */ 
        private var controlChanged:Boolean = false;
        /**
         * @private
         */
        private var _control:DisplayObject;

        [Bindable(event="controlChange")]
        public function get control():DisplayObject
        {
            return _control;
        }
        
        [Bindable("dataChange")]
        public function get formItem():FormListItem {
            return this.data as FormListItem;
        }
        
        override public function set data(value:Object):void {
            if (super.data !== value) {
                var of:FormListItem = super.data as FormListItem;
                var f:FormListItem = value as FormListItem;
                if (super.data is FormListItem) {
                    unwatchSourceData(!f || f.property != of.property);
                    unregisterFormItemEvents();
                    if (!f || f.type != of.type || f.additionalProperties != of.additionalProperties || 
                        ((f.type == FormListItemType.LINK || f.type == FormListItemType.CUSTOM) && f.control !== of.control)) {
                        destroyControl();
                    }
                }
                super.data = value;
                if (validator) {
                    validator.trigger = null;
                    validator = null;
                }
                if (super.data is FormListItem) {
                    editableChanged = true;
                    controlChanged = true;
                    registerFormItemEvents();
                }
                invalidateProperties();
                invalidateSize();
                invalidateDisplayList();
            }
        }
        
        protected function handleFormItemEvent(event:FormListItemRendererEvent):void {
            if (event.type == FormListItemRendererEvent.CHANGE_EVENT_CHANGE) {
                if (control) {
                    if (event.oldValue && control.hasEventListener(String(event.oldValue)))
                        control.removeEventListener(String(event.oldValue), controlValueChangeHandler);
                    if (event.newValue) {
                        control.addEventListener(String(event.newValue), controlValueChangeHandler, false, EventPriority.DEFAULT, true);
                    }
                }
            }
            
            else if (event.type == FormListItemRendererEvent.PROPERTY_CHANGE) {
                unwatchSourceData(true);
                sourceDataChanged = true;
                invalidateProperties();
            }
            
            else if (event.type == FormListItemRendererEvent.CONTROL_CHANGE) {
                unwatchSourceData(true);
                destroyControl();
                editableChanged = true;
                controlChanged = true;
                invalidateProperties();
            }
            
            else if (event.type == FormListItemRendererEvent.ENABLED_CHANGED) {
                enabled = !!event.newValue;
            }
                
            else if (event.type == FormListItemRendererEvent.EDITABLE_CHANGED) {
                editableChanged = true;
                invalidateProperties();
            }
                
            else if (event.type == FormListItemRendererEvent.REQUIRED_CHANGE) {
                invalidateSize();
                invalidateProperties();
            }
                
            else if (event.type == FormListItemRendererEvent.OPTIONS_CHANGE) {
                FormListItemControlFactory.setOptions(this, control as OptionInput);
            }
            
            else {
                dispatchEvent(event);
            }
        }
        
        protected function get parentForm():FormDataGroup {
            return parent as FormDataGroup;
        }
        
        
        private var editableChanged:Boolean = false;
        [Bindable("editableChanged")]
        [Bindable("dataChange")]
        public function get editable():Boolean {
            return parentForm.editable && formItem && formItem.editable;
        }
        
        override public function set enabled(value:Boolean):void {
            super.enabled = value;
            if (control && 'enabled' in control) {
                control['enabled'] = value;
            }
        }
        
        protected function unregisterFormItemEvents():void {
            if (formItem) {
//                formItem.removeEventListener(FormListItemRendererEvent.ADDITIONAL_PROPERTIES_CHANGE, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.CHANGE_EVENT_CHANGE, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.CONTROL_CHANGE, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.CONTROL_PROPERTY_CHANGE, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.ENABLED_CHANGED, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.EDITABLE_CHANGED, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.LABEL_CHANGE, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.PROPERTY_CHANGE, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.VALIDATOR_CHANGE, handleFormItemEvent);
                formItem.removeEventListener(FormListItemRendererEvent.OPTIONS_CHANGE, handleFormItemEvent);
            }
        }
        
        protected function registerFormItemEvents():void {
            if (formItem) {
//                formItem.addEventListener(FormListItemRendererEvent.ADDITIONAL_PROPERTIES_CHANGE, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.CHANGE_EVENT_CHANGE, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.CONTROL_CHANGE, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.CONTROL_PROPERTY_CHANGE, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.ENABLED_CHANGED, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.EDITABLE_CHANGED, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.LABEL_CHANGE, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.PROPERTY_CHANGE, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.VALIDATOR_CHANGE, handleFormItemEvent, false, 0, true);
                formItem.addEventListener(FormListItemRendererEvent.OPTIONS_CHANGE, handleFormItemEvent, false, 0, true);
            }
        }
        
        private function unwatchSourceData(remove:Boolean = true):void {
            if (sourceDataChangeWatcher != null) {
                sourceDataChangeWatcher.unwatch();
                if (remove)
                    sourceDataChangeWatcher = null;
            }
        }
        
        private function watchSourceData():Boolean {
            if (sourceData && formItem && document) { // don't watch if not in display list
                if (sourceDataChangeWatcher == null) {
                    if (formItem.property) {
                        var propertyTree:Array = formItem.property.split(".");
                        sourceDataChangeWatcher = BindingUtils.bindSetter(sourceDataFieldChangedHandler, sourceData, propertyTree, true, true);
                    }
                }
                else {
                    sourceDataChangeWatcher.reset(sourceData);
                }
                return true;
            }
            return false;
        }
        
        override public function set document(value:Object):void {
            super.document = value;
            if (value == null) {
                unwatchSourceData();
            }
        }
        
        private function sourceDataFieldChangedHandler(value:Object):void {
            if (control && formItem && control[formItem.controlProperty] != value) {
//                trace ("Source Data externally modified", value, "!=", control[formItem.controlProperty], "In item index", itemIndex, this);
                if (formItem.type == FormListItemType.NUMBER && value is Number && isNaN(Number(value))) value = null;
                control[formItem.controlProperty] = value;
            }
        }
        
        [Bindable("change")]
        public function get value():* {
            return formItem ? formItem.controlValue : undefined;
        }
        
        /**
         * @private
         * Binding change watcher
         */
        private var sourceDataChangeWatcher:ChangeWatcher;
        
        private var validator:Validator;
        
        /**
         * Constructor
         */
        public function FormListItemRenderer():void
        {
            super();
//            percentWidth = 100;
        }
        
        override public function setFocus():void {
            if (_control && _control.hasOwnProperty("setFocus")) {
                _control['setFocus']();
            }
            else {
                super.setFocus();
            }
        }
        
        override protected function createChildren():void {
            super.createChildren();
        }
        
        protected function destroyControl():void {
//            trace ("FLIR destroyControl", itemIndex);
            
            removeEventListener(MouseEvent.CLICK, mouseDownHandler);
            
            if (_control) {
                if (this.owns(_control)) {
                    removeChild(_control);
                }
                if (validator) {
                    if (formItem && formItem.validator == null) {
                        // Dealing with an auto generated validator, destroy it.
                        validator.trigger = null;
                        validator = null;
                    }
                }
                _control.removeEventListener(formItem ? formItem.changeEvent : Event.CHANGE, controlValueChangeHandler);
                _control = null;
                controlChanged = true;
                editableChanged = true;
                invalidateProperties();
                invalidateSize();
                invalidateDisplayList();
            }
        }
        
        internal function $createInFontContext(clazz:Class):Object {
            return createInFontContext(clazz);
        }
        
        private function mouseDownHandler(event:MouseEvent):void {
            if (formItem && formItem.hasEventListener(MouseEvent.CLICK) && event.currentTarget != _control) {
                formItem.dispatchEvent(event);
            }
        }
        
        protected function setupControl():void {
//            trace ("FLIR setupControl", itemIndex, control);
            if (!formItem) {
                enabled = true;
                return;
            }
            
            if (formItem.hasEventListener(MouseEvent.CLICK)) {
                addEventListener(MouseEvent.CLICK, mouseDownHandler);
            }
            
            var ctrl:DisplayObject = control;
            if (!ctrl) {
                ctrl = FormListItemControlFactory.getControlInstanceForRenderer(this) as DisplayObject;
                
                if (!ctrl) {
                    enabled = true;
                    return;
                }
            }
//            else {
//                trace('Reusing existing control', formItem);
//            }
            
            FormListItemControlFactory.setProperties(this, ctrl);
            
            if ('enabled' in ctrl) {
                enabled = ctrl['enabled'];
            }
            else {
                enabled = true;
            }
            
            var triggerEvent:String = formItem.changeEvent ? formItem.changeEvent : Event.CHANGE;
            
            _control = ctrl;
            if (this != ctrl.parent) {
                if (ctrl.parent) ctrl.parent.removeChild(ctrl);
                addChild(ctrl);
                if (triggerEvent) {
                    ctrl.addEventListener(triggerEvent, controlValueChangeHandler, false, EventPriority.DEFAULT, true);
                }
            }
            
            if (!validator) {
                validator = FormListItemControlFactory.validatorForRenderer(this);
                if (validator) {
                    if(!validator.trigger && !validator.source) {
                        validator.trigger = ctrl;
                        validator.triggerEvent = triggerEvent;
                    }
                    validator.required = formItem.required;
                }
            }
            invalidateSize();
            invalidateDisplayList();
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void {
            super.commitProperties();
//            trace ("FLIR commitProperties");
            if (controlChanged) {
                setupControl();
                controlChanged = false;
                editableChanged = true;
                sourceDataChanged = true;
            }
            if (sourceDataChanged) {
                sourceDataChanged = !watchSourceData();
            }
            if (editableChanged && control) {
                editableChanged = false;
                FormListItemControlFactory.setEditable(this, control);
            }
            
            updateRequiredLabel();
        }
        
        override protected function measure():void {
//            trace ("FLIR measure");
            super.measure();
            var horizontalPadding:Number = getStyle("paddingLeft") + getStyle("paddingRight");
            if (labelDisplay) horizontalPadding = getStyle("paddingLeft"); // Previous measure already accounted for left/right padding, just add the gap;
            var verticalPadding:Number = getStyle("paddingTop") + getStyle("paddingBottom");
            
            if (_control)
            {
                if (_control is StyleableTextField)
                    StyleableTextField(_control).commitStyles();
                
                measuredWidth += getElementPreferredWidth(_control) + horizontalPadding;
                var vp:Number = _control is StyleableTextField ? verticalPadding : 
                                    Object(_control).getStyle('borderVisible') != true ? 0 : verticalPadding;
                measuredHeight = Math.max(measuredHeight, getElementPreferredHeight(_control) + vp);
//                trace ("Measured control", formItem.type, measuredHeight,  Object(_control).getStyle('borderVisible'), getElementPreferredHeight(_control), vp);
            }
            
            if (requiredDisplay) {
                horizontalPadding = _control || labelDisplay ? getStyle("paddingLeft") : getStyle("paddingLeft") + getStyle("paddingRight");
                requiredDisplay.commitStyles();
                measuredWidth += getElementPreferredWidth(requiredDisplay) + horizontalPadding;
                measuredHeight = Math.max(measuredHeight, getElementPreferredHeight(requiredDisplay) + verticalPadding);
            }
            
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
//            trace ("FLIR updateDisplayList");
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
        
        private function updateRequiredLabel():void {
            if (formItem && formItem.required) {
                if (!requiredDisplay) {
                    requiredDisplay = StyleableTextField(createInFontContext(StyleableTextField));
                    requiredDisplay.colorName = "errorColor";
                    requiredDisplay.styleName = this;
                    addChild(requiredDisplay);
                }
                var symb:String = getStyle("requiredSymbol");
                if (!symb) symb = "*";
                requiredDisplay.text = symb;
                requiredDisplay.commitStyles();
            }
            else if (requiredDisplay) {
                removeChild(requiredDisplay);
                requiredDisplay = null;
            }
        }
        
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void {
//            trace ("FLIR layoutContents");
            
            var paddingLeft:Number   = getStyle("paddingLeft"); 
            var paddingRight:Number  = getStyle("paddingRight");
            var paddingTop:Number    = getStyle("paddingTop");
            var paddingBottom:Number = getStyle("paddingBottom");
            var verticalAlign:String = getStyle("verticalAlign");
            var middleGap:Number     = 0;
            
            var viewWidth:Number  = unscaledWidth  - paddingLeft - paddingRight;
            var viewHeight:Number = unscaledHeight - paddingTop  - paddingBottom;
            if (labelDisplay && control) {
                middleGap = paddingLeft;
            }
            var requiredOffset:Number = 0;
            if (requiredDisplay) {
                requiredOffset = getElementPreferredWidth(requiredDisplay) + StyleableTextField.TEXT_WIDTH_PADDING;
            }
//            trace ("view", viewWidth, viewHeight);
//            trace ("padding", paddingLeft, paddingRight, paddingTop, paddingBottom, middleGap);
            
            var vAlign:Number;
            if (verticalAlign == "top")
                vAlign = 0;
            else if (verticalAlign == "bottom")
                vAlign = 1;
            else // if (verticalAlign == "middle")
                vAlign = 0.5;
            
            // measure the label component
            // text should take up the rest of the space width-wise, but only let it take up
            // its measured textHeight so we can position it later based on verticalAlign
            var labelWidth:Number = Math.max(viewWidth, 0); 
            var labelHeight:Number = 0;
            var controlWidth:Number = Math.max(viewWidth, 0);
            var controlHeight:Number = 0;
            
            if (control) {
                if (control is StyleableTextField) {
                    StyleableTextField(control).commitStyles();
                }
                // reset text if it was truncated before.
                if (control is IEditableText) {
                    var iet:IEditableText = IEditableText(control);
                    if (iet.editable) {
                        if (iet.isTruncated)
                            iet.text = formItem && sourceData ? sourceData[formItem.property] : null;
                        if (!iet.text || iet.text.length == 0) {
                            iet.appendText("Wj"); // Circumvent setting text directly;
                            controlHeight = getElementPreferredHeight(control);
                            iet.selectAll();
                            iet.insertText("");
                        }
                        else {
                            controlHeight = getElementPreferredHeight(control);
                        }
                    }
                }
                else {
                    controlHeight = getElementPreferredHeight(control);
                }
                controlWidth = Math.min(viewWidth, getElementPreferredWidth(control)) - requiredOffset;
//                trace("Initial control width", formItem.property, controlWidth, viewWidth, getElementPreferredWidth(control), requiredOffset);
            }
            else {
                controlWidth = 0;
            }
            
            var labelY:Number = 0;
            var labelOffset:Number = 0;
            
            if (labelDisplay) {
                labelDisplay.colorName = formItem.type == FormListItemType.HEADING ? "headingColor" : "labelColor";
//                trace ('Label Font Size', labelDisplay.getStyle('fontSize'), getStyle('fontSize'));
                if (formItem.type == FormListItemType.HEADING) {
                    labelDisplay.antiAliasType = AntiAliasType.ADVANCED;
                    labelDisplay.setStyle("fontWeight", "bold");
                }
                else {
                    labelDisplay.antiAliasType = AntiAliasType.NORMAL;
                    labelDisplay.setStyle("fontWeight", getStyle("fontWeight"));
                }
                if (label != "")
                {
                    labelDisplay.commitStyles();
                    // reset text if it was truncated before.
                    if (labelDisplay.isTruncated)
                        labelDisplay.text = label;
                    labelHeight = getElementPreferredHeight(labelDisplay);
                    labelWidth = getElementPreferredWidth(labelDisplay);
                    if (control && labelWidth > ((viewWidth - middleGap - requiredOffset) / 2)) {
                        labelWidth = (viewWidth - middleGap - requiredOffset) / 2;
                        controlWidth = Math.min(labelWidth, controlWidth);
                        if (labelWidth < (viewWidth - controlWidth - middleGap - requiredOffset)) {
                            var plw:Number = (viewWidth - controlWidth - middleGap - requiredOffset);
                            var xlw:Number = getElementPreferredWidth(labelDisplay)
                            labelWidth = Math.min(plw, xlw);
                        }
                    }
                    // Text controls should fill the space provided
                    else if (control is IEditableText || control is SkinnableTextBase) {
                        controlWidth = viewWidth - labelWidth - requiredOffset - middleGap;
                        if (controlHeight == 0) {
                            controlHeight = labelHeight;
                        }
                    }
                }
//                if (control) {
//                    trace("Post label control width", formItem.property, controlWidth, viewWidth, getElementPreferredWidth(control), requiredOffset);
//                }
//                trace ("labelHeight", labelHeight);
//                trace ("labelWidth", formItem.property, labelWidth, getElementPreferredWidth(labelDisplay));
                setElementSize(labelDisplay, labelWidth, labelHeight);    
                
                // We want to center using the "real" ascent
                labelY = Math.round(vAlign * (viewHeight - labelHeight))  + paddingTop;
                setElementPosition(labelDisplay, paddingLeft, labelY);
                labelOffset += labelWidth + StyleableTextField.TEXT_WIDTH_PADDING;
                
                // attempt to truncate the text now that we have its official width
                labelDisplay.truncateToFit();
//                trace("labelDisplay coords", labelDisplay.x, labelDisplay.y);
            }
            
            if (control) {
//                trace ("controlHeight", controlHeight);
//                trace ("control dimensions", formItem.type, controlWidth, controlHeight);
//                trace ("Cell dimensions", unscaledWidth, unscaledHeight);
//                trace ("Padding (ltrb)", paddingLeft, paddingTop, paddingRight, paddingBottom);
//                trace ("Viewport dimensions", viewWidth, viewHeight);
                  
                var controlY:Number = Math.round(vAlign * (viewHeight - controlHeight))  + paddingTop;
                var controlX:Number = labelOffset + requiredOffset + middleGap;//(viewWidth - controlWidth);
                if ((controlX + controlWidth) < viewWidth) {
                    controlX = (viewWidth - controlWidth);
                }
                controlX += paddingLeft;
                
                if (!(control is StyleableTextField) && Object(control).getStyle('borderVisible') != true) {
                    controlY = (unscaledHeight - controlHeight) / 2;
//                    controlHeight = unscaledHeight;
                }
//                trace("Control x,y", controlX, controlY);
                
                setElementSize(control, controlWidth, controlHeight);
                // attempt to truncate the text now that we have its official width
                if (control is StyleableTextField) {
                    StyleableTextField(control).truncateToFit();
                }
                
                setElementPosition(control, controlX, controlY);
            }
            
            if (requiredDisplay) {
                setElementSize(requiredDisplay, getElementPreferredWidth(requiredDisplay), labelHeight);
                setElementPosition(requiredDisplay, labelOffset + paddingLeft, labelY);
            }
        }
        
        override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
            if (formItem && formItem.type != FormListItemType.HEADING) {
            
                var prevItem:FormListItem = itemIndex == 0 ? null : _formItems[_formItems.indexOf(formItem) - 1];
                var nextItem:FormListItem = isLastItem ? null : _formItems[_formItems.indexOf(formItem) + 1];
                
                var isTopBoundry:Boolean = formItem.type != FormListItemType.HEADING && 
                                            (prevItem == null || prevItem.type == FormListItemType.HEADING);
                var isBottomBoundry:Boolean = formItem.type != FormListItemType.HEADING && 
                                                (nextItem == null || nextItem.type == FormListItemType.HEADING);;
                
                
                var bx:Number = 0;
                var by:Number = 0;
                var bw:Number = unscaledWidth;
                var bh:Number = unscaledHeight;
                var tr:Number = getStyle('groupTopCornerRadius');
                var br:Number = getStyle('groupBottomCornerRadius');
                
                var bgc:uint = getStyle("contentBackgroundColor");
                var bga:Number = getStyle("contentBackgroundAlpha");
                
                var ba:Number = getStyle("borderVisible") != false ? getStyle("borderAlpha") : 0.0;
                if (isNaN(ba)) ba = 1.0;
                
                var bc:uint = getStyle("borderColor") == undefined ? 0x000000 : getStyle('borderColor');
                
                graphics.beginFill(bgc, bga);
                if (ba > 0) {
                    graphics.lineStyle(getStyle('borderThickness'), bc, ba, true);
                }
                
                if (isTopBoundry || isBottomBoundry) {
                    tr = isTopBoundry ? tr : 0;
                    br = isBottomBoundry ? br : 0;
                    graphics.drawRoundRectComplex(0, isBottomBoundry ? -1 : 0, 
                        unscaledWidth - getStyle('borderThickness'), unscaledHeight + (isBottomBoundry && !isLastItem ? 1 : 0), 
                        tr, tr, br, br);
                }
                else {
                    graphics.drawRect(0, -1, unscaledWidth - getStyle('borderThickness'), unscaledHeight + 2)
                }
                
                graphics.endFill();
                
                if (formItem.type == FormListItemType.LINK && !formItem.control) {
                    var cc:uint = 0x000000;
                    if (getStyle('chromeColor') !== undefined) {
                        cc = getStyle('chromeColor');
                    }
                    
                    var lh:Number = unscaledHeight - getStyle("paddingTop") - getStyle("paddingBottom");
                    var lw:Number = lh * 0.66;
                    var lx:Number = unscaledWidth - getStyle("paddingLeft") - lw;
                    var ly:Number = getStyle("paddingTop");
                        
                    graphics.moveTo(lx, ly);
                    graphics.lineStyle(5, cc, 0.5, true, "normal");
                    graphics.lineTo(lx + lw, ly + (lh/2));
                    graphics.lineTo(lx, ly + lh);
                    graphics.lineStyle();
                }
            }
            else if (formItem.type != FormListItemType.HEADING) {
                drawBorder(unscaledWidth, unscaledHeight);
            }
        }
        
        override protected function drawBorder(unscaledWidth:Number, unscaledHeight:Number):void {
            var topSeparatorColor:uint;
            var topSeparatorAlpha:Number;
            var bottomSeparatorColor:uint;
            var bottomSeparatorAlpha:Number;
            var drawFirstBorder:Boolean = getStyle('drawFirstBorder') !== false;
            var drawLastBorder:Boolean = getStyle('drawLastBorder') !== false;
            
            // separators are a highlight on the top and shadow on the bottom
            topSeparatorColor = 0xFFFFFF;
            topSeparatorAlpha = .3;
            bottomSeparatorColor = 0x000000;
            bottomSeparatorAlpha = .3;
            
            if (itemIndex == 0 && (drawFirstBorder && drawLastBorder)) {
                graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
                graphics.drawRect(0, 0, unscaledWidth, 1);
                graphics.endFill();
            }
            if (!isLastItem || drawLastBorder) {
                graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
                graphics.drawRect(0, unscaledHeight - (isLastItem ? 0 : 1), unscaledWidth, 1);
                graphics.endFill();
            }
            
            
        }
        
        protected function controlValueChanged(value:Object):void {
//            trace ("Control value changed", control, control[formItem.controlProperty], value);
            if (sourceData && formItem) {
                var tree:Array = formItem.property.split(".");
                var t:Object = sourceData;
                var lastWholePropertyName:String;
                var lastWholeProperty:Object;
                var backfilledValue:Object = value;
                
                // Check for any back fill needed
                for (var i:int = 0; i < tree.length - 1; i++) {
                    if ((i <= tree.length - 2) && t[tree[i]] == null) {
                        
                        var ps:XML = describeType(t);
                        var prop:XMLList = ps..accessor.(@name == tree[i]) + ps..variable.(@name == tree[i]);
                        if (prop.length() > 0) {
                            var p:XML = prop[0];
                            var c:Class = getDefinitionByName(prop.@type) as Class;
                            if (c != null) {
                                var filler:Object = new c();
                                if (!lastWholePropertyName) { // place marker for back filling null properties
                                    lastWholePropertyName = tree[i];
                                    lastWholeProperty = t;
                                    backfilledValue = filler;
                                }
                                else {
                                    t[tree[i]] = filler;
                                }
                                t = filler;
                            }
                            else {
                                throw new Error("Could not back fill source data");
                            }
                        }
                        continue;
                    }
                    else {
                        t = t[tree[i]];
                        if (t == null)
                            break;
                    }
                }
                
                if (lastWholeProperty == null) {
                    lastWholePropertyName = tree[i];
                    lastWholeProperty = t;
                }
                else {
                    t[tree[i]] = value;
                }
                
                if (t != null && (lastWholeProperty[lastWholePropertyName] != backfilledValue)) {
                    unwatchSourceData(false);
                    lastWholeProperty[lastWholePropertyName] = backfilledValue;
                    dispatchEvent(new Event(Event.CHANGE));
                }
                watchSourceData()
            }
        }
        
        private function controlValueChangeHandler(event:Event):void {
            if (event.currentTarget == control && !event.isDefaultPrevented()) {
                event.stopImmediatePropagation();
                var v:* = control[formItem.controlProperty];
                if (v is FormListItemSelectOption) {
                    v = FormListItemSelectOption(v).value == null ? FormListItemSelectOption(v).label : FormListItemSelectOption(v).value;
                }
                controlValueChanged(v);
            }
        }
        
        //------------------------
        // ISoftKeyboardHintClient
        //------------------------
        /**
         * @private
         */
        public function get autoCapitalize():String
        {
            return control is ISoftKeyboardHintClient ? ISoftKeyboardHintClient(control).autoCapitalize  : 
                formItem ? formItem.autoCapitalize : undefined;
        }
        /**
         * @private
         */
        public function set autoCapitalize(value:String):void
        {
            if (control is ISoftKeyboardHintClient) {
                ISoftKeyboardHintClient(control).autoCapitalize = value;
            }
            else if(formItem) {
                formItem.autoCapitalize = value;
            }
        }
        
        /**
         * @private
         */
        public function get autoCorrect():Boolean
        {
            return control is ISoftKeyboardHintClient ? ISoftKeyboardHintClient(control).autoCorrect  : 
                formItem ? formItem.autoCorrect : undefined;
        }
        
        /**
         * @private
         */
        public function set autoCorrect(value:Boolean):void
        {
            if (control is ISoftKeyboardHintClient) {
                ISoftKeyboardHintClient(control).autoCorrect = value;
            }
            else if(formItem) {
                formItem.autoCorrect = value;
            }  
        }
        
        /**
         * @private
         */
        public function get returnKeyLabel():String
        {
            return control is ISoftKeyboardHintClient ? ISoftKeyboardHintClient(control).returnKeyLabel  : 
                formItem ? formItem.returnKeyLabel : undefined;
        }
        
        /**
         * @private
         */
        public function set returnKeyLabel(value:String):void
        {
            if (control is ISoftKeyboardHintClient) {
                ISoftKeyboardHintClient(control).returnKeyLabel = value;
            }
            else if(formItem) {
                formItem.returnKeyLabel = value;
            }
        }
        
        /**
         * @private
         */
        public function get softKeyboardType():String
        {
            return control is ISoftKeyboardHintClient ? ISoftKeyboardHintClient(control).softKeyboardType : 
                   formItem ? formItem.softKeyboardType : undefined;
        }
        
        /**
         * @private
         */
        public function set softKeyboardType(value:String):void
        {
            if (control is ISoftKeyboardHintClient) {
                ISoftKeyboardHintClient(control).softKeyboardType = value;
            }
            else if(formItem) {
                formItem.softKeyboardType = value;
            }
        }

    }
}