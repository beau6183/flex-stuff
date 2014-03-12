package com.beauscott.mobile.controls
{
    import flash.events.Event;
    
    import mx.core.IDataRenderer;

    public class ExtendedListEvent extends Event
    {
        
        public static const DISCLOSURE_BUTTON_CLICKED:String = "disclosureButtonClicked";
        public static const ACCESSORY_BUTTON_CLICKED:String = "accessoryButtonClicked";
        public static const SWIPED:String = "swiped";
        
        private var _renderer:IDataRenderer;
        public function get renderer():IDataRenderer {
            return _renderer;
        }
        
        private var _relatedObject:Object;
        public function get relatedObject():Object {
            return _relatedObject;
        }
        
        private var _itemIndex:int = -1;
        public function get itemIndex():int {
            return _itemIndex;
        }
        
        private var _itemData:*;
        public function get itemData():* {
            return _itemData;
        }
        
        public function ExtendedListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, itemIndex:int = -1, itemData:* = undefined, renderer:IDataRenderer = null, relatedObject:Object = null):void
        {
            super(type, bubbles, cancelable);
            _relatedObject = relatedObject;
            _renderer = renderer;
            _itemIndex = itemIndex;
            _itemData = itemData
        }
        
        override public function clone():Event {
            return new ExtendedListEvent(type, bubbles, cancelable, itemIndex, itemData, renderer, relatedObject);
        }
        
        override public function toString():String {
            return formatToString('ExtendedListEvent', 'type', 'bubbles', 'cancelable', 'itemIndex', 'renderer', 'relatedObject');
        }
    }
}