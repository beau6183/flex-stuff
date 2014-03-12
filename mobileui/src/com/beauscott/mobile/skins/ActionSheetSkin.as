package com.beauscott.mobile.skins
{
    import com.beauscott.mobile.controls.ActionSheet;
    
    import flash.display.BlendMode;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.events.Event;
    
    import flashx.textLayout.formats.TextAlign;
    
    import mx.core.FlexGlobals;
    import mx.core.mx_internal;
    import mx.effects.Effect;
    import mx.events.EffectEvent;
    import mx.events.FlexEvent;
    import mx.utils.ColorUtil;
    
    import spark.components.ArrowDirection;
    import spark.components.Callout;
    import spark.components.ContentBackgroundAppearance;
    import spark.components.Label;
    import spark.core.SpriteVisualElement;
    import spark.effects.Move;
    import spark.effects.easing.Power;
    
    use namespace mx_internal;
    
    public class ActionSheetSkin extends CalloutSkin
    {
        private var isOpen:Boolean = false;
        
        private var openEffect:Effect;
        private var closeEffect:Effect;
        
        //
        // Skin parts
        //
        public var titleDisplay:Label;
        
        public function ActionSheetSkin()
        {
            super();
        }
        
        public function get $borderThickness():Number {
            return isNaN(borderThickness) ? 0 : borderThickness;
        }
        
        public function get $frameThickness():Number {
            return isNaN(frameThickness) ? 0 : frameThickness;
        }
        
        override protected function createChildren():void {
            super.createChildren();
            if (arrow && (!(hostComponent is ActionSheet) || !ActionSheet(hostComponent).showFromParent)) {
                removeChild(arrow);
                arrowHeight = 0;
                arrowWidth = 0;
            }
            if (!titleDisplay) {
                titleDisplay = new Label();
                titleDisplay.id = "titleDisplay";
                titleDisplay.styleName = this;
                titleDisplay.maxDisplayedLines = 1;
                addChild(titleDisplay);
            }
        }
        
        /**
         * @private
         */
        override protected function measure():void
        {
            super.measure();
            
            var borderWeight:Number = isNaN(borderThickness) ? 0 : borderThickness;
            var frameAdjustment:Number = (frameThickness + borderWeight) * 2;
            
            var arrowMeasuredWidth:Number;
            var arrowMeasuredHeight:Number;
            
            // pad the arrow so that the edges are within the background corner radius
            if (isArrowHorizontal)
            {
                arrowMeasuredWidth = arrowHeight;
                arrowMeasuredHeight = arrowWidth + (backgroundCornerRadius * 2);
            }
            else if (isArrowVertical)
            {
                arrowMeasuredWidth = arrowWidth + (backgroundCornerRadius * 2);
                arrowMeasuredHeight = arrowHeight;
            }
            
            var titleAdjustment:Number = 0;
            if (titleDisplay && titleDisplay.text) {
                titleAdjustment = getElementPreferredHeight(titleDisplay) + frameThickness; 
            }
            
            // count the contentGroup size and frame size
            measuredMinWidth = contentGroup.measuredMinWidth + frameAdjustment;
            measuredMinHeight = contentGroup.measuredMinHeight + frameAdjustment + titleAdjustment;
            
            measuredWidth = contentGroup.getPreferredBoundsWidth() + frameAdjustment;
            measuredHeight = contentGroup.getPreferredBoundsHeight() + frameAdjustment + titleAdjustment;
            
            // add the arrow size based on the arrowDirection
            if (isArrowHorizontal)
            {
                measuredMinWidth += arrowMeasuredWidth;
                measuredMinHeight = Math.max(measuredMinHeight, arrowMeasuredHeight);
                
                measuredWidth += arrowMeasuredWidth;
                measuredHeight = Math.max(measuredHeight, arrowMeasuredHeight);
            }
            else if (isArrowVertical)
            {
                measuredMinWidth += Math.max(measuredMinWidth, arrowMeasuredWidth);
                measuredMinHeight += arrowMeasuredHeight;
                
                measuredWidth = Math.max(measuredWidth, arrowMeasuredWidth);
                measuredHeight += arrowMeasuredHeight;
            }
            
            if (systemManager && systemManager.stage) {
                measuredHeight = Math.min(systemManager.stage.stageHeight, measuredHeight);
            }
        }
        
        /**
         * @private
         */
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
//            super.layoutContents(unscaledWidth, unscaledHeight);
            
//            trace("ASK", unscaledWidth, unscaledHeight, localToGlobal(new Point(x,y)));
            
            // pad the arrow so that the edges are within the background corner radius
            if (isArrowHorizontal)
            {
                arrow.width = arrowHeight;
                arrow.height = arrowWidth + (backgroundCornerRadius * 2);
            }
            else if (isArrowVertical)
            {
                arrow.width = arrowWidth + (backgroundCornerRadius * 2);
                arrow.height = arrowHeight;
            }
            
            setElementSize(backgroundFill, unscaledWidth, unscaledHeight);
            setElementPosition(backgroundFill, 0, 0);
            
            var frameX:Number = 0;
            var frameY:Number = 0;
            var frameWidth:Number = unscaledWidth;
            var frameHeight:Number = unscaledHeight;
            
            if (hostComponent is Callout) {
                switch (hostComponent.arrowDirection)
                {
                    case ArrowDirection.UP:
                        frameY = arrow.height;
                        frameHeight -= arrow.height;
                        break;
                    case ArrowDirection.DOWN:
                        frameHeight -= arrow.height;
                        break;
                    case ArrowDirection.LEFT:
                        frameX = arrow.width;
                        frameWidth -= arrow.width;
                        break;
                    case ArrowDirection.RIGHT:
                        frameWidth -= arrow.width;
                        break;
                    default:
                        // no arrow, content takes all available space
                        break;
                }
            }
            
            
            // Show frameThickness by inset of contentGroup
            var borderWeight:Number = isNaN(borderThickness) ? 0 : borderThickness;
            var contentBackgroundAdjustment:Number = frameThickness + borderWeight;
            var titleOffset:Number = 0;
            
            if (titleDisplay) {
                if (titleDisplay.text) {
                    titleDisplay.setStyle("textAlign", TextAlign.CENTER);
                    titleDisplay.setStyle("contentBackgroundAlpha", 0);
                    titleDisplay.setStyle("backgroundAlpha", 0);
                    titleOffset = getElementPreferredHeight(titleDisplay);
                    setElementSize(titleDisplay, frameWidth - (contentBackgroundAdjustment * 2), titleOffset);
                    setElementPosition(titleDisplay, frameX + contentBackgroundAdjustment, frameY + contentBackgroundAdjustment);
                    titleOffset += frameThickness;
                }
                else {
                    titleDisplay.visible = false;
                }
            }
            
            if (dropShadow)
            {
                setElementSize(dropShadow, frameWidth, frameHeight);
                setElementPosition(dropShadow, frameX, frameY);
            }
            
            var contentBackgroundX:Number = frameX + contentBackgroundAdjustment;
            var contentBackgroundY:Number = (frameY + contentBackgroundAdjustment) + titleOffset;
            
            contentBackgroundAdjustment = contentBackgroundAdjustment * 2;
            var contentBackgroundWidth:Number = frameWidth - contentBackgroundAdjustment;
            var contentBackgroundHeight:Number = (frameHeight - contentBackgroundAdjustment) - titleOffset;
            
            if (contentBackgroundGraphic)
            {
                setElementSize(contentBackgroundGraphic, contentBackgroundWidth, contentBackgroundHeight);
                setElementPosition(contentBackgroundGraphic, contentBackgroundX, contentBackgroundY);
            }
            
            setElementSize(contentGroup, contentBackgroundWidth, contentBackgroundHeight);
            setElementPosition(contentGroup, contentBackgroundX, contentBackgroundY);
            
            // mask position is in the contentGroup coordinate space
            if (contentMask)
                setElementSize(contentMask, contentBackgroundWidth, contentBackgroundHeight);
        }
        
        protected function get isTablet():Boolean {
            return FlexGlobals.topLevelApplication.isTablet;
        }
        
        
        override protected function commitCurrentState():void {
            if (isTablet) {
                super.commitCurrentState();
            }
            else {
                var isNormal:Boolean = (!currentState || currentState.indexOf("normal") > -1);
                var isDisabled:Boolean = (currentState && currentState.indexOf("disabled") > -1);
                
                // play a fade out if the callout was previously open
                if (!(isNormal || isDisabled) && isOpen)
                {
                    if (!closeEffect)
                    {
                        var ce:Move = new Move();
                        ce.easer = new Power(0.5, 3);
                        ce.disableLayout = true;
                        ce.target = this;
                        ce.duration = 200;
                        ce.yBy = this.getLayoutBoundsHeight();
                        closeEffect = ce;
                    }
                    
                    // BlendMode.LAYER while fading out
                    blendMode = BlendMode.LAYER;
                    
                    // play a short fade effect
                    closeEffect.addEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
                    closeEffect.play();
                    
                    isOpen = false;
                }
                else
                {
                    isOpen = isNormal || isDisabled;
                    
                    // handle re-opening the Callout while fading out
                    if (closeEffect && closeEffect.isPlaying)
                    {
                        // Do not dispatch a state change complete.
                        // SkinnablePopUpContainer handles state interruptions.
                        closeEffect.removeEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
                        closeEffect.stop();
                    }
                    
                    if (!openEffect)
                    {
                        var oe:Move = new Move();
                        oe.easer = new Power(0.5, 3);
//                        oe.disableLayout = true; // Left on so it renders as it opens;
                        oe.target = this;
                        oe.duration = 200;
                        openEffect = oe;
                    }
                    
                    if (openEffect is Move) {
                        Move(openEffect).yTo = y;
                        Move(openEffect).yFrom = getLayoutBoundsHeight();
                    }
                    
                    // BlendMode.LAYER while fading out
//                    blendMode = BlendMode.LAYER;
                    
                    // play a short fade effect
                    openEffect.addEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
                    openEffect.play();
                    
                    if (isDisabled)
                    {
                        // BlendMode.LAYER to allow CalloutArrow BlendMode.ERASE
                        blendMode = BlendMode.LAYER;
                        
                        alpha = 0.5;
                    }
                    else
                    {
                        // BlendMode.NORMAL for non-animated state transitions
                        blendMode = BlendMode.NORMAL;
                        
                        if (isNormal)
                            alpha = 1;
                        else
                            alpha = 0;
                    }
                    
                    stateChangeComplete();
                }
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //--------------------------------------------------------------------------
        
        private function stateChangeComplete(event:Event=null):void
        {
            if (event && event.currentTarget is Effect)
                event.currentTarget.removeEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
            
            // SkinnablePopUpContainer relies on state changes for open and close
            dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_COMPLETE));
        }
        
        override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
            var frameEllipseSize:Number = backgroundCornerRadius * 2;
            
            // account for borderThickness center stroke alignment
            var showBorder:Boolean = !isNaN(borderThickness);
            var borderWeight:Number = showBorder ? borderThickness : 0;
            
//            trace(this.hostComponent.className, frameEllipseSize, showBorder, borderWeight);
            
            // contentBackgroundGraphic already accounts for the arrow position
            // use it's positioning instead of recalculating based on unscaledWidth
            // and unscaledHeight
            var frameX:Number = Math.floor(contentGroup.getLayoutBoundsX() - frameThickness) - (borderWeight / 2);
            var frameY:Number = Math.floor(contentGroup.getLayoutBoundsY() - frameThickness) - (borderWeight / 2);
            var frameWidth:Number = contentGroup.getLayoutBoundsWidth() + (frameThickness * 2) + borderWeight;
            var frameHeight:Number = contentGroup.getLayoutBoundsHeight() + (frameThickness * 2) + borderWeight;
            var titleOffset:Number = 0;
            if (titleDisplay && titleDisplay.text) {
                titleOffset = titleDisplay.getLayoutBoundsHeight() + frameThickness;
                frameY -= titleOffset;
                frameHeight += titleOffset;
            }
            
            var backgroundColor:Number = getStyle("backgroundColor");
            var backgroundAlpha:Number = getStyle("backgroundAlpha");
            
            var bgFill:Graphics = backgroundFill.graphics;
            bgFill.clear();
            
            if (showBorder)
                bgFill.lineStyle(borderThickness, borderColor, 1, true);
            
            if (useBackgroundGradient)
            {
                // top color is brighter if arrowDirection == ArrowDirection.UP
                var backgroundColorTop:Number = ColorUtil.adjustBrightness2(backgroundColor, 
                    BACKGROUND_GRADIENT_BRIGHTNESS_TOP);
                var backgroundColorBottom:Number = ColorUtil.adjustBrightness2(backgroundColor, 
                    BACKGROUND_GRADIENT_BRIGHTNESS_BOTTOM);
                
                // max gradient height = backgroundGradientHeight
                colorMatrix.createGradientBox(unscaledWidth, backgroundGradientHeight,
                    Math.PI / 2, 0, 0);
                
                bgFill.beginGradientFill(GradientType.LINEAR,
                    [backgroundColorTop, backgroundColorBottom],
                    [backgroundAlpha, backgroundAlpha],
                    [0, 255],
                    colorMatrix);
            }
            else
            {
                bgFill.beginFill(backgroundColor, backgroundAlpha);
            }
            
            bgFill.drawRoundRect(frameX, frameY, frameWidth,
                frameHeight, frameEllipseSize, frameEllipseSize);
            bgFill.endFill();
            
            // draw content background styles
            var contentBackgroundAppearance:String = getStyle("contentBackgroundAppearance");
            
            if (contentBackgroundAppearance != ContentBackgroundAppearance.NONE)
            {
                var contentEllipseSize:Number = contentCornerRadius * 2;
                var contentBackgroundAlpha:Number = getStyle("contentBackgroundAlpha");
                var contentWidth:Number = contentGroup.getLayoutBoundsWidth();
                var contentHeight:Number = contentGroup.getLayoutBoundsHeight();
                
                // all appearance values except for "none" use a mask
                if (!contentMask)
                    contentMask = new SpriteVisualElement();
                
                contentGroup.mask = contentMask;
                
                // draw contentMask in contentGroup coordinate space
                var maskGraphics:Graphics = contentMask.graphics;
                maskGraphics.clear();
                maskGraphics.beginFill(0, 1);
                maskGraphics.drawRoundRect(0, 0, contentWidth, contentHeight,
                    contentEllipseSize, contentEllipseSize);
                maskGraphics.endFill();
                
                // reset line style to none
                if (showBorder)
                    bgFill.lineStyle(NaN);
                
                // draw the contentBackgroundColor
                bgFill.beginFill(getStyle("contentBackgroundColor"),
                    contentBackgroundAlpha);
                bgFill.drawRoundRect(contentGroup.getLayoutBoundsX(),
                    contentGroup.getLayoutBoundsY(),
                    contentWidth, contentHeight, contentEllipseSize, contentEllipseSize);
                bgFill.endFill();
                
                if (contentBackgroundGraphic)
                    contentBackgroundGraphic.alpha = contentBackgroundAlpha;
            }
            else // if (contentBackgroundAppearance == CalloutContentBackgroundAppearance.NONE))
            {
                // remove the mask
                if (contentMask)
                {
                    contentGroup.mask = null;
                    contentMask = null;
                }
            }
            
            // draw highlight in the callout when the arrow is hidden
            if (useBackgroundGradient && !isArrowHorizontal && !isArrowVertical)
            {
                // highlight width spans the callout width minus the corner radius
                var highlightWidth:Number = frameWidth - frameEllipseSize;
                var highlightX:Number = frameX + backgroundCornerRadius;
                var highlightOffset:Number = (highlightWeight * 1.5);
                
                // straight line across the top
                bgFill.lineStyle(highlightWeight, 0xFFFFFF, 0.2 * backgroundAlpha);
                bgFill.moveTo(highlightX, highlightOffset);
                bgFill.lineTo(highlightX + highlightWidth, highlightOffset);
            }
        }
    }
}