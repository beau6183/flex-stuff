package com.beauscott.mobile.util
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SoftKeyboardEvent;
    import flash.geom.Rectangle;
    
    import mx.core.FlexGlobals;
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    
    import spark.components.Scroller;
    import spark.components.supportClasses.ListBase;

    [DefaultProperty("target")]
    
    public class TextFormUtil extends EventDispatcher
    {
        private var _target:Scroller;
        private var _targetList:ListBase;

        [Bindable(event="targetChanged")]
        public function get target():Scroller
        {
            return _target;
        }

        public function set target(value:Scroller):void
        {
            if( _target !== value)
            {
                if (_target != null) {
                    _target.removeEventListener(Event.ADDED_TO_STAGE, target_addedToStageHandler);
                    _target.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, softKeyboard_activateHandler);
                    _target.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyboard_deactivateHandler);
                    resetScrollerSize(_targetList ? _targetList : _target, originalFrame);
                    originalFrame = null;
                    stageListenerAdded = false;
                    _targetList = null;
                }
                _target = value;
                
                if (_target != null) {
//                    trace("Scroll target set to ", _target);
                    
                    var p:DisplayObjectContainer = _target.parent;
                    while (p) {
                        if (p is ListBase) {
                            _targetList = ListBase(p);
                            break;
                        }
                        p = p.parent;
                    }
                    saveFrameRect();
                }
                dispatchEvent(new Event("targetChanged"));
            }
        }
        
        
        private var originalFrame:_PositionSave;
        private var stageListenerAdded:Boolean = false;
        private var sizeAdjusted:Boolean = false;
        
        public function TextFormUtil(target:Scroller = null):void {
            super();
            this.target = target;
        }
        
        private function saveFrameRect():void {
            if (_target && _target.parent) {
                _target.removeEventListener(Event.ADDED_TO_STAGE, target_addedToStageHandler);
                if (originalFrame == null) {
                    originalFrame = new _PositionSave();
                    var sc:IVisualElement = _targetList ? _targetList : _target;
                    if (sc.bottom != null && !isNaN(Number(sc.bottom))) {
                        originalFrame.bottom = Number(sc.bottom);
                    }
                    else if (!isNaN(sc.percentHeight)) {
                        originalFrame.percentHeight = sc.percentHeight;
                    }
                    else {
                        originalFrame.explicitHeight = sc.height
                    }
                    _target.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, softKeyboard_activateHandler);
                    _target.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyboard_deactivateHandler);
                }
                if (FlexGlobals.topLevelApplication.softKeyboardIsActive()) {
                    adjustScrollContainerForSoftKeyboard(getStageFocusComponent());  
                }
            }
            else if (_target && !stageListenerAdded) {
                _target.addEventListener(Event.ADDED_TO_STAGE, target_addedToStageHandler);
                stageListenerAdded = true;
            }
        }
        
        private function getStageFocusComponent(hint:Object = null):UIComponent {
            if (hint == null) hint = FlexGlobals.topLevelApplication.stage.focus;
            var control:UIComponent = hint as UIComponent;
            var p:Object = hint;
            while (!control && p && 'parent' in p) {
                p = p.parent;
                control = p as UIComponent;
            }
//            trace("determined target input as: ", control);
            return control;
        }
        
        private function target_addedToStageHandler(event:Event):void {
            saveFrameRect();
        }
        
        private function softKeyboard_activateHandler(event:SoftKeyboardEvent):void {
            adjustScrollContainerForSoftKeyboard(getStageFocusComponent(event.target));
        }
        
        private function softKeyboard_deactivateHandler(event:SoftKeyboardEvent):void {
            adjustScrollContainerForSoftKeyboard(getStageFocusComponent());
        }
        
        private function adjustScrollContainerForSoftKeyboard(control:UIComponent = null):void {
            var sc:UIComponent = _targetList ? _targetList : _target;
            
            if (FlexGlobals.topLevelApplication.softKeyboardIsActive() && !sizeAdjusted) {
                var t:Rectangle = sc.getBounds(FlexGlobals.topLevelApplication as DisplayObject);
                var appFrame:Rectangle = FlexGlobals.topLevelApplication.stage.getBounds(FlexGlobals.topLevelApplication.stage);
                var k:Rectangle = FlexGlobals.topLevelApplication.systemManager.stage.softKeyboardRect;
                appFrame.height -= k.height;
                var proposedHeight:Number = appFrame.height - t.y;
                if (t.y >= appFrame.y && proposedHeight > 0 && ((t.y + t.height) > appFrame.height)) {
                    sc.bottom = NaN;
                    sc.percentHeight = NaN;
                    sc.height = proposedHeight;
                    sizeAdjusted = true;
                }
            }
            else if (!FlexGlobals.topLevelApplication.softKeyboardIsActive() && sizeAdjusted) {
                resetScrollerSize(sc, originalFrame);
            }
            
            if (_target != null && _target.parent != null && 
                control is IVisualElement && target.contains(control)) {
                _target.ensureElementIsVisible(control as IVisualElement);    
            }
        }
        
        private function resetScrollerSize(target:UIComponent, originalFrame:_PositionSave):void {
            if (target && target.parent && originalFrame) {
                sizeAdjusted = false;
                if (originalFrame != null) {
                    if (!isNaN(originalFrame.bottom)) {
                        target.percentHeight = NaN;
                        target.height = NaN;
                        target.bottom = originalFrame.bottom;
                    }
                    else if (!isNaN(originalFrame.percentHeight)) {
                        target.height = NaN;
                        target.bottom = NaN;
                        target.percentHeight = originalFrame.percentHeight;
                    }
                    else {
                        target.percentHeight = NaN;
                        target.bottom = NaN;
                        target.height = originalFrame.explicitHeight;
                    }
                }
            }
        }
    }
}

class _PositionSave {
    public var bottom:Number;
    public var percentHeight:Number;
    public var explicitHeight:Number;
}