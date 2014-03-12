package com.beauscott.mobile.controls
{
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.StageOrientationEvent;
    
    import mx.core.FlexGlobals;
    import mx.utils.StringUtil;
    
    import spark.components.Group;
    import spark.components.Label;
    import spark.components.Scroller;
    import spark.components.ViewMenu;
    import spark.components.ViewMenuItem;
    import spark.layouts.HorizontalAlign;
    import spark.layouts.VerticalLayout;
    
    [Style(name="contentBackgroundAppearance", type="String", enumeration="inset,flat,none", inherit="no")]
    public class ActionSheetViewMenu extends ViewMenu
    {
        [SkinPart(required="false")]
        public var titleDisplay:Label;
        
        private var _title:String = "";
        private var titleChanged:Boolean = false;

        [Bindable(event="titleChanged")]
        public function get title():String
        {
            return _title;
        }

        public function set title(value:String):void
        {
            value = StringUtil.trim(value);
            if( _title !== value)
            {
                _title = value;
                if (titleDisplay) {
                    titleDisplay.text = value;
                }
                else {
                    titleChanged = true;
                    invalidateProperties();
                }
                dispatchEvent(new Event("titleChanged"));
                invalidateSkinState();
                invalidateDisplayList();
                invalidateSize();
//                if (isOpen) {
//                    validateNow();
//                }
            }
        }
        
        //
        // Scroller support
        //
        
        protected var scroller:Scroller;
        protected var scrollerGroup:Group;
        protected var regularElements:Array = [];
        protected var destructiveButtons:Array = [];
        protected var cancelButtons:Array = [];

        public function ActionSheetViewMenu()
        {
            super();
        }
        
        override protected function createChildren():void {
            super.createChildren();
            var l:VerticalLayout = new VerticalLayout();
            l.horizontalAlign = HorizontalAlign.JUSTIFY;
            l.variableRowHeight = true;
            l.gap = 0;
            layout = l;
            
            scroller = new Scroller();
            scroller.scrollSnappingMode = "none";
            scroller.minHeight = 0;
            scroller.percentHeight = 100;
            l = new VerticalLayout();
            l.variableRowHeight = false;
            l.horizontalAlign = HorizontalAlign.JUSTIFY;
            l.gap = 0;
            scrollerGroup = new Group();
            scrollerGroup.minHeight = 0;
            scrollerGroup.layout = l;
            
            scroller.viewport = scrollerGroup;
            addElement(scroller);
        }
        
        override protected function commitProperties():void {
            super.commitProperties();
            if (titleChanged) {
                titleChanged = false;
                if (titleDisplay) {
                    titleDisplay.text = title;
                }
            }
            if (itemsChanged) {
                itemsChanged = false;
                var vmi:ViewMenuItem;
                var i:int = 0;
                for each(vmi in destructiveButtons) {
                    addElementAt(vmi, i++);
                }
                for each(vmi in regularElements) {
                    if (scrollerGroup) {
                        scrollerGroup.addElement(vmi);
                    }
                    else {
                        addElementAt(vmi, i++);
                    }
                }
                if (scrollerGroup) {
                    i = getElementIndex(scroller) + 1;
                }
                for each(vmi in cancelButtons) {
                    addElementAt(vmi, i++);
                }
                invalidateDisplayList();
            }
        }
        
        override public function set caretIndex(value:int):void {
            // do nothing
        }
        
        override protected function keyDownHandler(event:KeyboardEvent):void {
            // do nothing
        }
        
        private var itemsChanged:Boolean = false;
        private var _items:Vector.<ViewMenuItem>;
        
        override public function set items(value:Vector.<ViewMenuItem>):void {
            var itemsSizeChanged:Boolean = false;
            if (value && !value.length) {
                value = null;
            }
            if (value != _items) {
                itemsSizeChanged = !_items || !value || (_items.length != value.length);
                _items = value;
                regularElements.length = 0;
                var vmi:ViewMenuItem;
                for each(vmi in destructiveButtons) {
                    if (vmi.parent == this) {
                        removeElement(vmi);
                    }
                }
                destructiveButtons.length = 0;
                cancelButtons.length = 0;
                for each(vmi in cancelButtons) {
                    if (vmi.parent == this) {
                        removeElement(vmi);
                    }
                }
                if (scrollerGroup) scrollerGroup.removeAllElements();
                if (value) {
                    for (var i:int = 0; i < value.length; i++) {
                        vmi = value[i];
                        if (vmi.styleName == "cancelButton") {
                            cancelButtons.push(vmi);
                        }
                        else if (vmi.styleName == "destructiveButton") {
                            destructiveButtons.push(vmi);
                        }
                        else {
                            regularElements.push(vmi);
                        }
                    }
                }
                if (regularElements.length || destructiveButtons.length || cancelButtons.length) {
                    itemsChanged = true;
                    invalidateProperties();
                }
                if (itemsSizeChanged) {
                    invalidateSize();
                }
            }
        }
    }
}