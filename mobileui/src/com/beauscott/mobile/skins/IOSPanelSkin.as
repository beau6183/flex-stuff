package com.beauscott.mobile.skins
{
    import flash.display.DisplayObject;
    import flash.display.GradientType;
    
    import mx.core.DPIClassification;
    import mx.core.FlexGlobals;
    import mx.core.IVisualElement;
    import mx.core.mx_internal;
    import mx.states.State;
    import mx.utils.ColorUtil;
    
    import spark.components.Group;
    import spark.components.Panel;
    import spark.components.VGroup;
    import spark.components.supportClasses.StyleableTextField;
    import spark.core.IDisplayText;
    import spark.skins.mobile.supportClasses.MobileSkin;
    
    use namespace mx_internal;
    
    [Style(name="backgroundAlphas", type="Array", arrayType="Number", inherit="no")]
    [Style(name="backgroundColor", inherit="no", type="uint", format="Color")]
    [Style(name="backgroundRatios", type="Array", arrayType="Number", inherit="no")]
    [Style(name="borderColor", inherit="no", type="uint", format="Color")]
    [Style(name="borderVisible", inherit="no", type="Boolean")]
    [Style(name="highlightBrightness", type="number", format="Number", inherit="no")]
    [Style(name="highlightRotation", type="number", format="Number", inherit="yes")]
    
    public class IOSPanelSkin extends MobileSkin
    {
        
        /**
         * An array of color distribution ratios.
         * This is used in the chrome color fill.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        mx_internal static const CHROME_COLOR_RATIOS:Array = [0, 127.5];
        
        /**
         * An array of alpha values for the corresponding colors in the colors array. 
         * This is used in the chrome color fill.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        mx_internal static const CHROME_COLOR_ALPHAS:Array = [0.85, 0.85];
        
        private var _hostComponent:Panel;
        
        /**
         * @copy spark.skins.spark.ApplicationSkin#hostComponent
         */
        public function get hostComponent():Panel
        {
            return _hostComponent;
        }
        
        /**
         * @private
         */
        public function set hostComponent(value:Panel):void
        {
            _hostComponent = value;
        }
        
        //
        // Skin parts
        //
        
        public var titleDisplay:IDisplayText;
        public var titleGroup:Group;
        
        public var controlBarGroup:Group;
        
        public var contentGroup:Group;
        
        //
        // Properties
        //
        
        protected var cornerRadius:Number;
        
        protected var borderThickness:Number;
        
        protected var padding:Number;
        
        protected var layoutGap:Number;
        
        public function IOSPanelSkin()
        {
            super();
            switch (applicationDPI)
            {
                case DPIClassification.DPI_320:
                {
                    layoutGap = 10;
                    cornerRadius = 40;
                    padding = 20;
                    borderThickness = 2;
                    break;
                }
                case DPIClassification.DPI_240:
                {
                    layoutGap = 7;
                    cornerRadius = 30;
                    padding = 15;
                    borderThickness = 1;
                    break;
                }
                default:
                {
                    // default DPI_160
                    layoutGap = 5;
                    cornerRadius = 20;
                    padding = 10;
                    borderThickness = 1;
                    break;
                }
            }
            
            if (!FlexGlobals.topLevelApplication.isTablet) {
                 measuredDefaultWidth = FlexGlobals.topLevelApplication.width * 0.75;
            }
        }
        
        override protected function createChildren():void {
            
            if (!titleGroup) {
                titleGroup = new Group();
                titleGroup.id = "titleGroup";
//                titleGroup.styleName = this;
                addChild(titleGroup);
            }
            if (!titleDisplay) {
                titleDisplay = createInFontContext(StyleableTextField) as StyleableTextField;
                StyleableTextField(titleDisplay).styleName = titleGroup;
                titleGroup.addElement(titleDisplay as IVisualElement);
            }
            
            if (!contentGroup) {
                contentGroup = new Group();
                contentGroup.styleName = this;
                contentGroup.id = "contentGroup";
                addChild(contentGroup);
            }
            
            if (!controlBarGroup) {
                controlBarGroup = new Group();
                controlBarGroup.id = "controlBarGroup";
                controlBarGroup.styleName = this;
                addChild(controlBarGroup);
            }
            super.createChildren();
        }
        
        override protected function measure():void {
            super.measure();
            var offset:Number = 2 * (borderThickness + padding);
            measuredHeight = offset;
            var rows:int = -1;
            var elementHeight:Number;
            if (titleDisplay) {
                if (titleDisplay is StyleableTextField) {
                    StyleableTextField(titleDisplay).commitStyles();
                }
                measuredWidth = getElementPreferredWidth(titleDisplay) + offset;
                elementHeight = getElementPreferredHeight(titleDisplay);
                if (elementHeight > 0) {
                    measuredHeight += elementHeight;
                    rows++;
                }
            }
            
            if (contentGroup && contentGroup.numElements) {
                measuredWidth = Math.max(getElementPreferredWidth(contentGroup) + offset, measuredWidth);
                elementHeight = getElementPreferredHeight(contentGroup);
                if (elementHeight > 0) {
                    measuredHeight += elementHeight;
                    rows++;
                }
            }
            
            if (controlBarGroup && controlBarGroup.numElements) {
                measuredWidth = Math.max(getElementPreferredWidth(controlBarGroup) + offset, measuredWidth);
                elementHeight = getElementPreferredHeight(controlBarGroup);
                if (elementHeight > 0) {
                    measuredHeight += elementHeight;
                    rows++;
                }
            }
            
            if (rows > -1) {
                measuredHeight += rows * layoutGap;
                measuredMinHeight += rows * layoutGap;
            }
        }
        
        override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
            var borderVisible:Boolean = getStyle("borderVisible") === undefined || getStyle("borderVisible") != "false";
            graphics.moveTo(0, 0);
            if (borderVisible) {
                var borderColor:uint = getStyle("borderColor") === undefined ? 0xFFFFFF : getStyle("borderColor");
                
                graphics.lineStyle(borderThickness, borderColor, 1.0, true);
            }
            
            var backgroundColor:uint = getStyle("backgroundColor") === undefined ? 0x000066 : getStyle("backgroundColor");
            
            var colors:Array = [];
            var brightness:Number = getStyle('highlightBrightness') === undefined ? 70 : getStyle('highlightBrightness');
            var rotation:Number = getStyle("highlightRotation") === undefined ? 180 : getStyle("highlightRotation");
            rotation = Math.PI / (360 / rotation);
            
            //                trace("Chrome rotation", rotation, "brightness", brightness);
            colorMatrix.createGradientBox(unscaledWidth, unscaledHeight, rotation, 0, 0);
            colors[0] = ColorUtil.adjustBrightness2(backgroundColor, brightness);
            colors[1] = backgroundColor;
            
            var chromeAlphas:Array = getStyle("backgroundAlphas") === undefined ? CHROME_COLOR_ALPHAS : getStyle("backgroundAlphas");
            var chromeRatios:Array = getStyle("backgroundRatios") === undefined ? CHROME_COLOR_RATIOS : getStyle("backgroundRatios");
            graphics.beginGradientFill(GradientType.LINEAR, colors, chromeAlphas, chromeRatios, colorMatrix);
            
            graphics.drawRoundRect(borderThickness, borderThickness, 
                unscaledWidth - (borderThickness * 2), 
                unscaledHeight - (borderThickness * 2), 
                cornerRadius, cornerRadius);
            
            graphics.endFill();
        }
        
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void {
            super.layoutContents(unscaledWidth, unscaledHeight);
            var ho:Number = padding + borderThickness;
            var vo:Number = ho;
            var viewWidth:Number = unscaledWidth - (2 * (borderThickness + padding));
            var viewHeight:Number = unscaledHeight - (2 * (borderThickness + padding));
            var availableViewHeight:Number = viewHeight;
            if (titleDisplay) {
                if (titleDisplay is StyleableTextField) {
                    StyleableTextField(titleDisplay).setStyle('textAlign', 'center');
                    StyleableTextField(titleDisplay).commitStyles();
                }
                if (titleGroup) {
                    setElementSize(titleDisplay, Math.min(getElementPreferredWidth(titleDisplay), viewWidth), getElementPreferredHeight(titleDisplay));
                    setElementSize(titleGroup, viewWidth, getElementPreferredHeight(titleDisplay));
                    setElementPosition(titleGroup, ho, vo);
                    var tw:Number = getElementPreferredWidth(titleDisplay);
                    if (tw > titleGroup.getLayoutBoundsWidth()) {
                        tw = 0;
                    }
                    else {
                        tw = (titleGroup.getLayoutBoundsWidth() - tw) / 2;
                        setElementPosition(titleDisplay, tw, 0);
                    }
                    if (titleDisplay is StyleableTextField) {
                        StyleableTextField(titleDisplay).truncateToFit();
                    }
                }
                else {
                    setElementSize(titleDisplay, viewWidth, getElementPreferredHeight(titleDisplay));
                    setElementPosition(titleDisplay, ho, vo);
                }
                if (titleDisplay is StyleableTextField)
                    StyleableTextField(titleDisplay).truncateToFit();
                vo += (getElementPreferredHeight(titleDisplay) + layoutGap);
                availableViewHeight -= (getElementPreferredHeight(titleDisplay) + layoutGap);
            }
            if (controlBarGroup) {
                setElementSize(controlBarGroup, viewWidth, getElementPreferredHeight(controlBarGroup));
                setElementPosition(controlBarGroup, ho, unscaledHeight - padding - getElementPreferredHeight(controlBarGroup));
                controlBarGroup.clipAndEnableScrolling = true;
                availableViewHeight -= (getElementPreferredHeight(controlBarGroup) + layoutGap);
            }
            if (contentGroup) {
                setElementSize(contentGroup, viewWidth, availableViewHeight);
                setElementPosition(contentGroup, ho, vo);
                vo += (availableViewHeight + layoutGap);
            }
        }
        
        
    }
}