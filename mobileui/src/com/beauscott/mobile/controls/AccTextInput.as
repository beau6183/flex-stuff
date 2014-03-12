package com.beauscott.mobile.controls {
    import com.beauscott.mobile.controls.modals.AccessoryViewModal;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.events.SoftKeyboardEvent;
    
    import mx.core.FlexGlobals;
    import mx.core.IVisualElement;
    import mx.managers.PopUpManager;
    
    import spark.components.TextInput;
    import spark.events.PopUpEvent;
    
    [Event(name="actionButtonClick", type="flash.events.Event")]
    [Event(name="actionButtonClicked", type="flash.events.Event")]
    [Event(name="accessoryClosed", type="flash.events.Event")]
    public class AccTextInput extends TextInput implements IAccessorizableInput {
        
        private var _inputAccessory:IVisualElement;
        private var _inputAccessoryCreated:Boolean = false;
        
        public function get inputAccessoryCreated():Boolean {
            return _inputAccessoryCreated;
        }
        
        public function get inputAccessoryValueField():String {
            return "text";
        }
        
        [Bindable("inputAccessoryChange")]
        public function get inputAccessory():IVisualElement
        {
            return _inputAccessory;
        }
        
        private var _actionButtonLabel:String = "Done";

        [Bindable(event="actionButtonLabelChanged")]
        public function get actionButtonLabel():String {
            return _actionButtonLabel;
        }

        public function set actionButtonLabel(value:String):void {
            if (_actionButtonLabel !== value) {
                _actionButtonLabel = value;
                dispatchEvent(new Event("actionButtonLabelChanged"));
                if (currentAccessoryView) {
                    currentAccessoryView.actionButtonLabel = value;
                }
            }
        }
        
        private var _cancelButtonLabel:String = "Cancel";
        
        [Bindable(event="cancelButtonLabelChanged")]
        public function get cancelButtonLabel():String {
            return _cancelButtonLabel;
        }
        
        public function set cancelButtonLabel(value:String):void {
            if (_cancelButtonLabel !== value) {
                _cancelButtonLabel = value;
                dispatchEvent(new Event("cancelButtonLabelChanged"));
                if (currentAccessoryView) {
                    currentAccessoryView.cancelButtonLabel = value;
                }
            }
        }
        
        private var _cancelButtonVisible:Boolean = true;
        
        [Bindable(event="cancelButtonVisibleChanged")]
        public function get cancelButtonVisible():Boolean {
            return _cancelButtonVisible;
        }
        
        public function set cancelButtonVisible(value:Boolean):void {
            if (_cancelButtonVisible !== value) {
                _cancelButtonVisible = value;
                dispatchEvent(new Event("cancelButtonVisibleChanged"));
                if (currentAccessoryView) {
                    currentAccessoryView.cancelButtonVisible = value;
                }
            }
        }
        
        private var _actionButtonVisible:Boolean = true;
        
        [Bindable(event="actionButtonVisibleChanged")]
        public function get actionButtonVisible():Boolean {
            return _actionButtonVisible;
        }
        
        public function set actionButtonVisible(value:Boolean):void {
            if (_actionButtonVisible !== value) {
                _actionButtonVisible = value;
                dispatchEvent(new Event("actionButtonVisibleChanged"));
                if (currentAccessoryView) {
                    currentAccessoryView.actionButtonVisible = value;
                }
            }
        }

        
        /**
         * @private
         */
        public function set inputAccessory(value:IVisualElement):void
        {
            if (_inputAccessory !== value) {
                _inputAccessory = value;
                dispatchEvent(new Event("inputAccessoryChange"));
            }
        }
        
        private var _disableSoftKeyboard:Boolean = false;

        [Bindable("disableSoftKeyboardChanged")]
        [Bindable("inputAccessoryChange")]
        public function get disableSoftKeyboard():Boolean {
            return _disableSoftKeyboard || !!inputAccessory;
        }

        public function set disableSoftKeyboard(value:Boolean):void {
            _disableSoftKeyboard = value;
            dispatchEvent(new Event("disableSoftKeyboardChanged"));
        }

        
        public function AccTextInput():void {
            super();
            addEventListener(MouseEvent.CLICK, mouseClickHandler);
            addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, softKeyboardActivatingHandler, true, int.MAX_VALUE);
            
            addEventListener(FocusEvent.FOCUS_IN, focusInCaptureHandler, true);
//            addEventListener(FocusEvent.FOCUS_OUT, focusOutCaptureHandler, true);
            
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }
        
        private function addedToStageHandler(event:Event):void {
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        }
        
        private function removedFromStageHandler(event:Event):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
            if (currentAccessoryView) {
                currentAccessoryView.removeEventListener("actionButtonClick", actionButton_clickHandler);
                currentAccessoryView.removeEventListener(PopUpEvent.OPEN, accessoryView_openHandler);
            }
            hideAccessory();
            currentAccessoryView = null;
        }
        
        private var focusInPrevented:Boolean = false;
        
        private function focusInCaptureHandler(event:FocusEvent):void {
//            trace ("AccTextInput focus in capture", event);
            if (inputAccessory && FlexGlobals.topLevelApplication.softKeyboardIsActive()) {
                event.preventDefault();
                focusInPrevented = true;
                addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyboard_deactivateHandler);
                systemManager.stage.focus = null;
            }
        }
        
        private function softKeyboard_deactivateHandler(event:SoftKeyboardEvent):void {
            removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyboard_deactivateHandler);
            if (inputAccessory && focusInPrevented) {
                focusInPrevented = false;
                setFocus();
            }
        }
        
        private function focusOutCaptureHandler(event:FocusEvent):void {
//            trace ("AccTextInput focus out capture", event);
            if (focusInPrevented) {
                event.preventDefault();
                focusInPrevented = false;
            }
            else {
                removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyboard_deactivateHandler);
            }
        }
        
        private function softKeyboardActivatingHandler(event:SoftKeyboardEvent):void {
//            trace ("AccTextInput softKeyboardActivatingHandler capture", event);
            if(disableSoftKeyboard) {
                event.preventDefault();
            }
        }
        
        private function mouseClickHandler(event:MouseEvent):void {
            showAccessory();
        }
        
        override protected function focusInHandler(event:FocusEvent):void {
//            trace ("AccTextInput focus in", event);
            super.focusInHandler(event);
            if (event.target != this) {
                showAccessory();
            }
        }
        
        override protected function focusOutHandler(event:FocusEvent):void {
//            trace ("AccTextInput focus out capture", event);
            super.focusOutHandler(event);
            if (event.target != this) {
                hideAccessory();
            }
        }
        
        private var currentAccessoryView:AccessoryViewModal;
        
        public function showAccessory():void {
            if (!inputAccessory) return;
            if (!currentAccessoryView) {
                currentAccessoryView = new AccessoryViewModal();
                currentAccessoryView.addEventListener("actionButtonClick", actionButton_clickHandler);
                currentAccessoryView.actionButtonLabel = actionButtonLabel;
                currentAccessoryView.actionButtonVisible = actionButtonVisible;
                currentAccessoryView.cancelButtonLabel = cancelButtonLabel;
                currentAccessoryView.cancelButtonVisible = cancelButtonVisible;
                _inputAccessoryCreated = true;
                currentAccessoryView.focusEnabled = false;
                currentAccessoryView.hasFocusableChildren = false;
                currentAccessoryView.inputControl = this;
                currentAccessoryView.addEventListener(PopUpEvent.OPEN, accessoryView_openHandler);
            }
            if (inputAccessory is DisplayObject && !currentAccessoryView.contains(inputAccessory as DisplayObject)) {
                currentAccessoryView.addElement(inputAccessory);
            }
            if (!currentAccessoryView.isOpen) {
                currentAccessoryView.open(DisplayObjectContainer(this.document), false);
            }
        }
        private var actionButtonClicked:Boolean = false;
        private function actionButton_clickHandler(event:Event):void {
            if (!hasEventListener("actionButtonClick") || dispatchEvent(new Event("actionButtonClick", false, true))) {
                actionButtonClicked = true;
                hideAccessory();
            }
        }
        
        private function accessoryView_openHandler(event:PopUpEvent):void {
            event.currentTarget.addEventListener(PopUpEvent.CLOSE, accessoryView_closeHandler);
        }
        
        private function accessoryView_closeHandler(event:PopUpEvent):void {
            event.currentTarget.removeEventListener(PopUpEvent.CLOSE, accessoryView_closeHandler);
            commitAccessoryValue(event.data);
            if (actionButtonClicked && hasEventListener("actionButtonClicked")) {
                actionButtonClicked = false;
                dispatchEvent(new Event("actionButtonClicked"));
            }
            
            if (hasEventListener("accessoryClosed")) {
                dispatchEvent(new Event("accessoryClosed"));
            }
            
        }
        
        protected function commitAccessoryValue(value:*):void {
            
        }
        
        public function hideAccessory():void {
            if (!currentAccessoryView) return;
            if (currentAccessoryView.isOpen) {
                currentAccessoryView.close();
            }
        }
    }
    
}