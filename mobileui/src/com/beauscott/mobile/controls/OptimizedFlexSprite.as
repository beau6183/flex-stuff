package com.beauscott.mobile.controls
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import mx.core.EventPriority;
    import mx.core.FlexGlobals;
    import mx.core.FlexSprite;
    import mx.core.IMXMLObject;
    import mx.events.ResizeEvent;
    
    import spark.core.SpriteVisualElement;
    
    [Event(name="resize", type="mx.events.ResizeEvent")]
    
    public class OptimizedFlexSprite extends SpriteVisualElement
    {
        
        //
        // Overrides
        //

        override public function set width(value:Number):void {
            var event:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE, false, false, super.width, height);
            super.width = value;
            if (hasEventListener(ResizeEvent.RESIZE))
                dispatchEvent(event);
            invalidateDisplayList();
        }
        
        override public function set height(value:Number):void {
            var event:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE, false, false, width, super.height);
            super.height = value;
            if (hasEventListener(ResizeEvent.RESIZE))
                dispatchEvent(event);
            invalidateDisplayList();
        }
        
        public function OptimizedFlexSprite()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, int.MAX_VALUE);
        }
        
        private var propertiesInvalidatedFlag:Boolean = false;
        private var displayListInvalidatedFlag:Boolean = false;
        
        private function addedToStageHandler(event:Event):void {
            if (event.type == Event.REMOVED_FROM_STAGE) {
                removeEventListener(Event.REMOVED_FROM_STAGE, addedToStageHandler);
                addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, int.MAX_VALUE);
            }
            
            else if (event.type == Event.ADDED_TO_STAGE) {
                removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
                addEventListener(Event.REMOVED_FROM_STAGE, addedToStageHandler, false, int.MAX_VALUE);
                invalidateProperties();
                invalidateDisplayList();
            }
            
            else if (propertiesInvalidatedFlag && event.type == Event.ENTER_FRAME) {
                stage.removeEventListener(Event.ENTER_FRAME, addedToStageHandler);
                validateProperties();
            }
            
            else if (displayListInvalidatedFlag && event.type == Event.RENDER) {
                stage.removeEventListener(Event.RENDER, addedToStageHandler);
                validateDisplayList();
            }
        }
        
        public function invalidateProperties():void {
            if (stage && !propertiesInvalidatedFlag) {
                propertiesInvalidatedFlag = true;
                stage.addEventListener(Event.ENTER_FRAME, addedToStageHandler);
                stage.invalidate();
            }
        }
        
        public function invalidateDisplayList():void {
            if (stage && !displayListInvalidatedFlag) {
                displayListInvalidatedFlag = true;
                stage.addEventListener(Event.RENDER, addedToStageHandler);
                stage.invalidate();
            }
        }
        
        public function validateNow():void {
            validateProperties();
            validateDisplayList();
        }
        
        private function validateProperties():void {
            if (propertiesInvalidatedFlag) {
                commitProperties();
                propertiesInvalidatedFlag = false;
            }
        }
        
        private function validateDisplayList():void {
            if (displayListInvalidatedFlag) {
                updateDisplayList(width * scaleX, height * scaleY);
                displayListInvalidatedFlag = false;
            }
        }
        
        protected function commitProperties():void {
            
        }
        
        protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            
        }
    }
}