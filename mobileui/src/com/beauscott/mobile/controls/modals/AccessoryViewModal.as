package com.beauscott.mobile.controls.modals
{
    import com.beauscott.mobile.controls.IAccessorizableInput;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.StageOrientationEvent;
    
    import mx.core.FlexGlobals;
    import mx.core.IVisualElement;
    import mx.events.FlexMouseEvent;
    import mx.events.ResizeEvent;
    import mx.events.SandboxMouseEvent;
    
    import spark.components.ActionBar;
    import spark.components.Button;
    import spark.components.SkinnablePopUpContainer;

    /**
     *  Normal and landscape state.
     *  
     *  @langversion 3.0
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    [SkinState("normalAndLandscape")]
    
    /**
     *  Closed and landscape state.
     *  
     *  @langversion 3.0
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    [SkinState("closedAndLandscape")]
    
    /**
     *  Disabled and landscape state.
     *  
     *  @langversion 3.0
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    [SkinState("disabledAndLandscape")]
    
    [Event(name="actionButtonClick", type="flash.events.Event")]
    [Event(name="cancelButtonClick", type="flash.events.Event")]
    
    public class AccessoryViewModal extends SkinnablePopUpContainer
    {
        // Skin parts
        [SkinPart(required="false")]
        public var actionButton:Button;
        [SkinPart(required="false")]
        public var cancelButton:Button;
        
        // Skin parts
        [SkinPart(required="false")]
        public var actionBar:ActionBar;
        
        // Tracks whether the mouse is down on the ViewMenu. If so, prevent keyboard
        private var isMouseDown:Boolean = false;
        
        public var inputControl:IVisualElement;
        
        [Bindable("titleChanged")]
        public var title:String;
        
        [Bindable("actionButtonLabelChanged")]
        public var actionButtonLabel:String = "Done";
        
        [Bindable("actionButtonVisibleChanged")]
        public var actionButtonVisible:Boolean = true;
        
        [Bindable("cancelButtonLabelChanged")]
        public var cancelButtonLabel:String = "Cancel";
        
        [Bindable("cancelButtonVisibleChanged")]
        public var cancelButtonVisible:Boolean = true;
        
        /**
         *  @private
         */   
        override protected function getCurrentSkinState():String
        {
            var skinState:String = super.getCurrentSkinState();
            if (FlexGlobals.topLevelApplication.aspectRatio == "portrait")
                return super.getCurrentSkinState();
            else
                return skinState + "AndLandscape";                
        }
        
        public function AccessoryViewModal()
        {
            super();
            focusEnabled = false;
            hasFocusableChildren = false;
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }
        
        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);
            
            if (instance == actionButton) {
                actionButton.addEventListener(MouseEvent.CLICK, actionButton_clickHandler, false, 0, true);
            }
            else if (instance == cancelButton) {
                cancelButton.addEventListener(MouseEvent.CLICK, cancelButton_clickHandler, false, 0, true);
            }
        }
        
        protected function actionButton_clickHandler(event:MouseEvent):void {
            if (hasEventListener("actionButtonClick")) {
                dispatchEvent(new Event("actionButtonClick"));
            }
            else {
                close(true);
            }
        }
        
        protected function cancelButton_clickHandler(event:MouseEvent):void {
            if (hasEventListener("cancelButtonClick")) {
                dispatchEvent(new Event("cancelButtonClick"));
            }
            else {
                close(false);
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event Handlers
        //
        //--------------------------------------------------------------------------
        
        private function addedToStageHandler(event:Event):void
        {
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
            systemManager.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
        }
        
        private function removedFromStageHandler(event:Event):void
        {
//            trace("Stage focus2", stage.focus);
            removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
            systemManager.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
        }
        
        override public function setFocus():void {
            // do nothing
        }
        
        private function orientationChangeHandler(event:StageOrientationEvent):void
        {
            invalidateSkinState();
        }
        
        private function mouseDownHandler(event:MouseEvent):void
        {
            isMouseDown = true;
            
            // Listen for mouse up anywhere
            systemManager.getSandboxRoot().addEventListener(
                MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true /* useCapture */);
            
            systemManager.getSandboxRoot().addEventListener(
                SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
        }
        
        private function systemManager_mouseUpHandler(event:Event):void
        {
            systemManager.getSandboxRoot().removeEventListener(
                MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true /* useCapture */);
            
            systemManager.getSandboxRoot().removeEventListener(
                SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
            
            isMouseDown = false;
        }
        
        override public function updatePopUpPosition():void {
            // Size the menu as big as the app
            width = FlexGlobals.topLevelApplication.getLayoutBoundsWidth();
            height = FlexGlobals.topLevelApplication.getLayoutBoundsHeight();
            
//            addEventListener(MouseEvent.CLICK, viewMenu_clickHandler);
            addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseDownOutsideHandler);
//            addEventListener(PopUpEvent.CLOSE, viewMenuClose_handler);
//            addEventListener(PopUpEvent.OPEN, viewMenuOpen_handler);
            addEventListener(ResizeEvent.RESIZE, resizeHandler);
        }
        
        private function mouseDownOutsideHandler(event:FlexMouseEvent):void {
            if (isOpen) {
                var doClose:Boolean = true;
                if (event.target is DisplayObject) {
                    var t:DisplayObject = DisplayObject(event.target);
                    doClose = !(t == this || contains(t) || 
                        (inputControl && inputControl != t && (!(inputControl is DisplayObjectContainer) || DisplayObjectContainer(inputControl).contains(t))))
                }
                if (doClose)
                    close();
            }
        }
        
        
        private function resizeHandler(event:ResizeEvent):void
        {
            // Size the menu as big as the app
            width = FlexGlobals.topLevelApplication.getLayoutBoundsWidth();
            height = FlexGlobals.topLevelApplication.getLayoutBoundsHeight();
            invalidateSkinState();
        }
        
        override public function close(commit:Boolean=false, data:*=null):void {
//            trace("Stage focus", systemManager ? systemManager.stage.focus : "dunno");
            if (data === null && inputControl is IAccessorizableInput) {
                var input:IAccessorizableInput = IAccessorizableInput(inputControl);
                if (input.inputAccessoryCreated) {
                    var field:String = input.inputAccessoryValueField;
                    if (field in input.inputAccessory) {
                        data = input.inputAccessory[field];
                    }
                }
            }
            super.close(commit, data);
        }
    }
}