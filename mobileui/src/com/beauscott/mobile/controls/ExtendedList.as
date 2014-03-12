package com.beauscott.mobile.controls
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    import flash.ui.Multitouch;
    import flash.ui.MultitouchInputMode;
    
    import mx.core.EventPriority;
    import mx.core.IVisualElement;
    
    import spark.components.List;
    
    [Style(name="alternatingItemAlphas", type="Array", arrayType="Number", format="Number", inherit="yes", theme="spark, mobile")]
    
    [Event(name="accessoryButtonClicked", type="com.beauscott.mobile.controls.ExtendedListEvent")]
    [Event(name="disclosureButtonClicked", type="com.beauscott.mobile.controls.ExtendedListEvent")]
    [Event(name="swiped", type="com.beauscott.mobile.controls.ExtendedListEvent")]
    
    public class ExtendedList extends List
    {
        public function ExtendedList()
        {
            super();
        }
        
        private var _swipeEnabled:Boolean = false;

        [Bindable(event="swipeEnabledChanged")]
        public function get swipeEnabled():Boolean
        {
            return _swipeEnabled;
        }

        /**
         * @private
         */
        public function set swipeEnabled(value:Boolean):void
        {
            if( _swipeEnabled !== value)
            {
                _swipeEnabled = value;
                dispatchEvent(new Event("swipeEnabledChanged"));
                if (_swipeEnabled) {
                    Multitouch.inputMode = MultitouchInputMode.GESTURE;
                }
            }
        }

        
        public function rendererForIndex(index:int, ensureVisible:Boolean = true):IVisualElement {
            if (this.dataGroup) {
                if (ensureVisible)
                    ensureIndexIsVisible(index);
                return dataGroup.getElementAt(index);
            }
            return null;
        }
        
        override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void {
            super.updateRenderer(renderer, itemIndex, data);
            if (renderer is IEventDispatcher) {
                renderer.addEventListener(ExtendedListEvent.ACCESSORY_BUTTON_CLICKED, accessoryButtonClickedHandler, false, EventPriority.DEFAULT, true);
                renderer.addEventListener(ExtendedListEvent.DISCLOSURE_BUTTON_CLICKED, disclosureButtonClickedHandler, false, EventPriority.DEFAULT, true);
            }
            if (renderer is ExtendedItemRenderer) {
                ExtendedItemRenderer(renderer).enableSwiping(swipeEnabled);
                if (swipeEnabled) {
                    renderer.addEventListener(ExtendedListEvent.SWIPED, itemSwipedHandler, false, EventPriority.DEFAULT, true);
                }
                else {
                    renderer.removeEventListener(ExtendedListEvent.SWIPED, itemSwipedHandler);
                }
            }
        }
        
        protected function itemSwipedHandler(event:ExtendedListEvent):void {
            if (!event.isDefaultPrevented() && hasEventListener(event.type)) {
                //                trace(this.className, "item swiped", event);
                var e:ExtendedListEvent = new ExtendedListEvent(event.type, false, false, event.itemIndex, event.itemData, event.renderer, event.relatedObject);
                dispatchEvent(e);
            }
        }
        
        protected function disclosureButtonClickedHandler(event:ExtendedListEvent):void {
            if (!event.isDefaultPrevented() && hasEventListener(event.type)) {
//                trace(this.className, "disclosure button clicked", event);
                var e:ExtendedListEvent = new ExtendedListEvent(event.type, false, false, event.itemIndex, event.itemData, event.renderer, event.relatedObject);
                if (!dispatchEvent(e)) {
                    event.preventDefault();
                }
            }
            else {
                event.preventDefault();
            }
        }
        
        protected function accessoryButtonClickedHandler(event:ExtendedListEvent):void {
            if (!event.isDefaultPrevented() && hasEventListener(event.type)) {
//                trace(this.className, "accessory button clicked", event);
                var e:ExtendedListEvent = new ExtendedListEvent(event.type, false, false, event.itemIndex, event.itemData, event.renderer, event.relatedObject);
                if (!dispatchEvent(e)) {
                    event.preventDefault();
                }
            }
            else {
                event.preventDefault();
            }
        }
    }
}