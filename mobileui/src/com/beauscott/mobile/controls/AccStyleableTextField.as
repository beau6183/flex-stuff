package com.beauscott.mobile.controls
{
    import com.beauscott.mobile.controls.modals.AccessoryViewModal;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.core.FlexGlobals;
    import mx.core.IVisualElement;
    
    import spark.components.supportClasses.StyleableTextField;
    import spark.events.PopUpEvent;
    import spark.events.TextOperationEvent;
    
    public class AccStyleableTextField extends StyleableTextField implements IAccessorizableInput
    {
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
        
        public function AccStyleableTextField()
        {
            super();
            editable = false;
            selectable = true;
            addEventListener(MouseEvent.CLICK, clickHandler);
        }
        
        private function clickHandler(event:MouseEvent):void {
            if (!event.isDefaultPrevented()) {
                showAccessory();
            }
        }
        
        private var currentAccessoryView:AccessoryViewModal;
        
        public function showAccessory():void {
            if (!inputAccessory) return;
            if (!currentAccessoryView) {
                currentAccessoryView = new AccessoryViewModal();
                currentAccessoryView.inputControl = this;
                currentAccessoryView.addEventListener(PopUpEvent.CLOSE, accessoryView_closeHandler);
            }
            if (!currentAccessoryView.isOpen) {
                if (!currentAccessoryView.contains(inputAccessory as DisplayObject)) {
                    currentAccessoryView.addElement(inputAccessory);
                }
                _inputAccessoryCreated = true;
                currentAccessoryView.open(FlexGlobals.topLevelApplication as DisplayObjectContainer, true);
            }
        }
        
        private function accessoryView_closeHandler(event:PopUpEvent):void {
            if (event.commit && dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGING))) {
                commitAccessoryValue(event.data);
                dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            }
        }
        
        protected function commitAccessoryValue(value:*):void {
            this.text = value;
        }
        
        public function hideAccessory():void {
            if (!currentAccessoryView) return;
            if (currentAccessoryView.isOpen) {
                currentAccessoryView.close();
            }
        }
        
        // Mock delayed validation;
        private var invalidatedFlag:Boolean = false;
        public function invalidateProperties():void {
            if (!invalidatedFlag) {
                invalidatedFlag = true;
                FlexGlobals.topLevelApplication.callLater(validateProperties);
            }
        }
        private function validateProperties():void {
            if (invalidatedFlag) {
                commitProperties();
                invalidatedFlag = false;
            }
        }
        protected function commitProperties():void {
            
        }
    }
}