package com.beauscott.mobile.controls
{
    import com.beauscott.mobile.util.TextFormUtil;
    
    import flash.events.Event;
    
    import mx.core.IVisualElement;
    import mx.utils.BitFlagUtil;
    
    import spark.components.List;
    import spark.events.RendererExistenceEvent;
    import spark.layouts.HorizontalAlign;
    import spark.layouts.VerticalLayout;
    
    [Style(name="textRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="dateRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="timeRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="dateAndTimeRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="checkBoxRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="selectRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="passwordRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="emailRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="currencyRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="numberRenderer", inherit="yes", type="Class", format="Class")]
    [Style(name="phoneRenderer", inherit="yes", type="Class", format="Class")]
    
    [DefaultProperty("formItems")]
    [Exclude(kind="property", name="dataProvider")]
    [Event(name="editableChanged", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    /**
     * Mobile optimized scrolling list implementation of a FormDataGroup form
     */
    public class FormList extends List
    {
        private var dataGroupProperties:Object = {};
        private static const DATA_GROUP_SOURCE_DATA_FLAG:uint = 0 << 0;
        private static const DATA_GROUP_FORM_ITEMS_FLAG:uint = 0 << 1;
        
        private var focusUtil:TextFormUtil;
        
        [Bindable(event="sourceDataChange")]
        public function get sourceData():Object
        {
            return dataGroup is FormDataGroup ? FormDataGroup(dataGroup).sourceData : 
                !dataGroup ? dataGroupProperties.sourceData : null;
        }
        /**
         * @private
         */
        public function set sourceData(value:Object):void
        {
            if (dataGroup is FormDataGroup) {
                FormDataGroup(dataGroup).sourceData = value;
                dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                    DATA_GROUP_SOURCE_DATA_FLAG, true);
            }
            else if (!dataGroup && dataGroupProperties.sourceData !== value) {
                var event:FormListItemRendererEvent = 
                    new FormListItemRendererEvent(FormListItemRendererEvent.SOURCE_DATA_CHANGE);
                event.oldValue = dataGroupProperties.sourceData;
                event.newValue = value;
                dataGroupProperties.sourceData = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        
        [Bindable("dataProviderChanged")]
        public function get formItems():Vector.<FormListItem> {
            return dataGroup is FormDataGroup ? FormDataGroup(dataGroup).formItems : null;
        }
        /**
         * @private
         */
        public function set formItems(value:Vector.<FormListItem>):void {
            if (dataGroup is FormDataGroup) {
                FormDataGroup(dataGroup).formItems = value;
                dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                    DATA_GROUP_FORM_ITEMS_FLAG, true);
            }
            else if (!dataGroup && dataGroupProperties.formItems !== value) {
                dataGroupProperties.formItems = value;
                dispatchEvent(new Event("dataProviderChanged"));
            }
        }
        
        /**
         *  @private
         */
        private var _editable:Boolean = true;
        
        [Bindable("editableChanged")]
        public function get editable():Boolean
        {
            return _editable;
        }
        /**
         *  @private
         */
        public function set editable(value:Boolean):void
        {
            if( _editable !== value)
            {
                _editable = value;
                if (dataGroup is FormDataGroup) {
                    FormDataGroup(dataGroup).editable = _editable;
                }
                else {
                    dispatchEvent(new FormListItemRendererEvent(FormListItemRendererEvent.EDITABLE_CHANGED, false, false, !value, value));    
                }
            }
        }
        
        public function FormList()
        {
            super();
            this.hasFocusableChildren = true;
            addEventListener(RendererExistenceEvent.RENDERER_REMOVE, rendererRemoved);
        }
        
        override protected function createChildren():void {
            super.createChildren();
            var l:VerticalLayout = new VerticalLayout();
            l.paddingLeft = 10;
            l.paddingRight = 10;
            l.paddingTop = 10;
            l.paddingBottom = 10;
            l.horizontalAlign = HorizontalAlign.JUSTIFY;
            l.gap = 0;
            layout = l;
        }
        
        /**
         *  @private
         */
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == dataGroup && dataGroup is FormDataGroup)
            {
                var form:FormDataGroup = dataGroup as FormDataGroup;
                
                var newDataGroupProperties:uint = 0;
                
                if (dataGroupProperties.formItems !== undefined)
                {
                    form.formItems = dataGroupProperties.formItems;
                    newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                        DATA_GROUP_FORM_ITEMS_FLAG, true);
                }
                
                if (dataGroupProperties.sourceData !== undefined)
                {
                    form.sourceData = dataGroupProperties.sourceData;
                    newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                        DATA_GROUP_SOURCE_DATA_FLAG, true);
                }
                
                form.editable = _editable;
                
                
                form.addEventListener(FormListItemRendererEvent.SOURCE_DATA_CHANGE, forwardEvent);
                form.addEventListener(FormListItemRendererEvent.EDITABLE_CHANGED, forwardEvent);
                form.addEventListener("dataProviderChanged", forwardEvent);
                
                dataGroupProperties = newDataGroupProperties;
            }
            
            if (instance == scroller) {
                if (!focusUtil)
                    focusUtil = new TextFormUtil(scroller);
                else
                    focusUtil.target = scroller;
            }
        }
        
        /**
         *  @private
         */
        override protected function partRemoved(partName:String, instance:Object):void
        {        
            super.partRemoved(partName, instance);
            
            if (instance == dataGroup && dataGroup is FormDataGroup)
            {
                var form:FormDataGroup = dataGroup as FormDataGroup;
                
                form.removeEventListener(FormListItemRendererEvent.SOURCE_DATA_CHANGE, forwardEvent);
                form.removeEventListener(FormListItemRendererEvent.EDITABLE_CHANGED, forwardEvent);
                form.removeEventListener("dataProviderChanged", forwardEvent);
                
                var newDataGroupProperties:Object = {};
                
                if (BitFlagUtil.isSet(dataGroupProperties as uint, DATA_GROUP_FORM_ITEMS_FLAG))
                    newDataGroupProperties.formItems = form.formItems;
                
                if (BitFlagUtil.isSet(dataGroupProperties as uint, DATA_GROUP_SOURCE_DATA_FLAG))
                    newDataGroupProperties.sourceData = form.sourceData;
                
                dataGroupProperties = newDataGroupProperties;
            }
            
            if (instance == scroller && focusUtil) {
                focusUtil.target = null;
            }
        }
        
        private function forwardEvent(event:Event):void {
            if (!event.isDefaultPrevented()) {
                var e:Event = event.clone();
                event.stopImmediatePropagation();
                dispatchEvent(e);
            }
        }
        
        override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void {
            super.updateRenderer(renderer, itemIndex, data);
            if (renderer is IFormListItemRenderer) {
//                trace ("Renderer updated", itemIndex, useVirtualLayout);
                IFormListItemRenderer(renderer).sourceData = sourceData;
                IFormListItemRenderer(renderer).formItems = formItems;
            }
        }
        
        /**
         * @private
         */
        override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void {
            super.dataGroup_rendererRemoveHandler(event);
            rendererRemoved(event);
        }
        
        private function rendererRemoved(event:RendererExistenceEvent):void {
            super.dataGroup_rendererRemoveHandler(event);
//            trace("Renderer Removed", event.renderer, useVirtualLayout);
            // Null source data to prevent extraenous event handling
            if (event.renderer is IFormListItemRenderer) {
                IFormListItemRenderer(event.renderer).sourceData = null;
                IFormListItemRenderer(event.renderer).formItems = null;
            }
        }
    }
}