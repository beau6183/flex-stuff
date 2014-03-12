package com.beauscott.mobile.controls
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    import flash.events.TransformGestureEvent;
    import flash.ui.Multitouch;
    import flash.ui.MultitouchInputMode;
    
    import mx.core.mx_internal;
    import mx.events.SandboxMouseEvent;
    
    import spark.components.ResizeMode;
    import spark.components.supportClasses.ItemRenderer;
    
    use namespace mx_internal;
    
    [Style(name="alternatingItemAlphas", type="Array", arrayType="Number", format="Number", inherit="yes", theme="spark, mobile")]
    [Style(name="overrideItemColor", type="uint", format="color")]
    [Style(name="overrideItemAlpha", type="Number", format="Number")]
    
    [Event(name="accessoryButtonClicked", type="com.beauscott.mobile.controls.ExtendedListEvent")]
    [Event(name="disclosureButtonClicked", type="com.beauscott.mobile.controls.ExtendedListEvent")]
    [Event(name="swiped", type="com.beauscott.mobile.controls.ExtendedListEvent")]
    
    public class ExtendedItemRenderer extends ItemRenderer
    {
        private var _swipeEnabled:Boolean = false;
        private var _listSwipeEnabled:Boolean = false;
        public function set swipeEnabled(value:Boolean):void {
            _swipeEnabled = value;
        }
        /**
         * @private
         */
        public function get swipeEnabled():Boolean {
            return _swipeEnabled && _listSwipeEnabled;
        }
        internal function enableSwiping(enable:Boolean = true):void {
            if (enable != _listSwipeEnabled) {
                _listSwipeEnabled = enable;
            }
        }
        
        private var _accessoryButton:IEventDispatcher;
        [Bindable("accessoryButtonChanged")]
        public function get accessoryButton():IEventDispatcher {
            return _accessoryButton;
        }
        /**
         * @private
         */
        public function set accessoryButton(value:IEventDispatcher):void {
            if (_accessoryButton !== value) {
                if (_accessoryButton) {
                    _accessoryButton.removeEventListener(MouseEvent.MOUSE_DOWN, accessoryButton_clickHandler, false);
                }
                _accessoryButton = value;
                if (_accessoryButton) {
                    _accessoryButton.addEventListener(MouseEvent.MOUSE_DOWN, accessoryButton_clickHandler, false, int.MAX_VALUE);
                }
            }
        }
        
        protected function accessoryButton_clickHandler(event:MouseEvent):void {
            if (dispatchEvent(new ExtendedListEvent(ExtendedListEvent.ACCESSORY_BUTTON_CLICKED, false, true, itemIndex, this.data, this, accessoryButton))) {
                event.preventDefault();
                event.stopImmediatePropagation();
                event.stopPropagation();
            }
        }
        
        private var _disclosureButton:IEventDispatcher;
        [Bindable("disclosureButtonChanged")]
        public function get disclosureButton():IEventDispatcher {
            return _disclosureButton;
        }
        /**
         * @private
         */
        public function set disclosureButton(value:IEventDispatcher):void {
            if (_disclosureButton !== value) {
                if (_disclosureButton) {
                    _disclosureButton.removeEventListener(MouseEvent.MOUSE_DOWN, disclosureButton_clickHandler, false);
                }
                _disclosureButton = value;
                if (_disclosureButton) {
                    _disclosureButton.addEventListener(MouseEvent.MOUSE_DOWN, disclosureButton_clickHandler, false, int.MAX_VALUE);
                }
            }
        }
        
        protected function disclosureButton_clickHandler(event:MouseEvent):void {
            if (dispatchEvent(new ExtendedListEvent(ExtendedListEvent.DISCLOSURE_BUTTON_CLICKED, false, true, itemIndex, this.data, this, accessoryButton))) {
                event.preventDefault();
                event.stopImmediatePropagation();
                event.stopPropagation();
            }
        }
        
        public function ExtendedItemRenderer()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }
        
        private var mouseIsDown:Boolean = false;
        
        private function addedToStageHandler(event:Event):void {
            mouseIsDown = false;
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
            stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, stage_swipeHandler, true);
            
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler, false, 0, true);
            systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler, false, 0, true);
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler_noRollOverOpenDelay, false, 0, true);
        }
        
        private function removedFromStageHandler(event:Event):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
            stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, stage_swipeHandler, true);
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler);
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler_noRollOverOpenDelay);
            
        }
        
        private function stage_swipeHandler(event:TransformGestureEvent):void {
            if (swipeEnabled) {
                if (!event.isDefaultPrevented() && event.target is DisplayObject && contains(DisplayObject(event.target)) &&
                        dispatchEvent(new ExtendedListEvent(ExtendedListEvent.SWIPED, false, true, itemIndex, this.data, this, event.target))) {
                    if (hasState(currentState + "Swiped")) {
                        setCurrentState(currentState + "Swiped");
                    }
                    else if (hasState("swiped")) {
                        setCurrentState("swiped");
                    }
                    event.preventDefault();
                    return;
                }
                else {
                    resetSwipeState();
                }
            }
        }
        
        /**
         *  @private
         *  Called when the systemManager receives a mouseDown event. This closes
         *  the dropDown if the target is outside of the dropDown.
         */
        private function systemManager_mouseDownHandler(event:Event):void
        {
            if (mouseIsDown)
            {
                mouseIsDown = false;
                return;
            }
            
            if (swipeEnabled && !(event.target == this || this.contains(DisplayObject(event.target))))
            {
                resetSwipeState();
            }
        }
        
        private function resetSwipeState():void {
            if (currentState.toLowerCase().indexOf("swiped") > -1) {
                var s:String = currentState.replace(/swiped/i, "");
                if (hasState(s)) {
                    setCurrentState(s);
                }
                else {
                    setCurrentState("");
                }
            }
        }
        
        private function systemManager_mouseUpHandler_noRollOverOpenDelay(event:Event):void
        {
            // stop here if mouse was down from being down on the open button
            if (mouseIsDown)
            {
                mouseIsDown = false;
                return;
            }
        }
        
        override mx_internal function drawBackground():void {
            if (!autoDrawBackground) {
                super.drawBackground();
                return;
            }
            
            // TODO (rfrishbe): Would be good to remove this duplicate code with the 
            // super.drawBackground() version
            var w:Number = (resizeMode == ResizeMode.SCALE) ? measuredWidth : unscaledWidth;
            var h:Number = (resizeMode == ResizeMode.SCALE) ? measuredHeight : unscaledHeight;
            
            if (isNaN(w) || isNaN(h))
                return;
            
            graphics.clear();
            
            var backgroundColor:uint;
            var backgroundAlpha:Number = 1;
            var alphaSet:Boolean = false;
            var drawBackground:Boolean = true;
            var downColor:* = getStyle("downColor");
            
            if (down && downColor !== undefined)
                backgroundColor = downColor;
            else if (selected)
                backgroundColor = getStyle("selectionColor");
            else if (hovered)
                backgroundColor = getStyle("rollOverColor");
            else
            {
                var $overrideColor:* = getStyle('overrideItemColor');
                if ($overrideColor !== undefined && $overrideColor is uint) {
                    backgroundColor = uint($overrideColor);
                    var $overrideAlpha:* = getStyle('overrideItemAlpha');
                    if ($overrideAlpha !== undefined && !isNaN($overrideAlpha)) {
                        alphaSet = true;
                        backgroundAlpha = Number($overrideAlpha);
                    }
                }
                else {
                
                    var alternatingColors:Array;
                    var alternatingColorsStyle:Object = getStyle("alternatingItemColors");
                    
                    if (alternatingColorsStyle)
                        alternatingColors = (alternatingColorsStyle is Array) ? (alternatingColorsStyle as Array) : [alternatingColorsStyle];
                    
                    if (alternatingColors && alternatingColors.length > 0)
                    {
                        // translate these colors into uints
                        styleManager.getColorNames(alternatingColors);
                        
                        backgroundColor = alternatingColors[itemIndex % alternatingColors.length];
                    }            
                    else
                    {
                        // don't draw background if it is the contentBackgroundColor. The
                        // list skin handles the background drawing for us.
                        drawBackground = false;
                    }
                }
            }
            
            if (!selected && !alphaSet) {
                var alternatingAlphas:Array;
                var alternatingAlphasStyle:Object = getStyle("alternatingItemAlphas");
                
                if (alternatingAlphasStyle)
                    alternatingAlphas = (alternatingAlphasStyle is Array) ? (alternatingAlphasStyle as Array) : [alternatingAlphasStyle];
                
                if (alternatingAlphas && alternatingAlphas.length > 0)
                {
                    backgroundAlpha = Math.max(Math.min(1, alternatingAlphas[itemIndex % alternatingAlphas.length]), 0);
                }
            }
            
            graphics.beginFill(backgroundColor, backgroundAlpha);
            
            if (showsCaret)
            {
                graphics.lineStyle(1, getStyle("selectionColor"));
                graphics.drawRect(0.5, 0.5, w-1, h-1);
            }
            else 
            {
                graphics.lineStyle();
                graphics.drawRect(0, 0, w, h);
            }
            
            graphics.endFill();
        }
    }
}