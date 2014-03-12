package com.beauscott.mobile.controls
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.core.ClassFactory;
    import mx.core.IVisualElement;
    import mx.managers.IFocusManagerContainer;
    
    import spark.components.DataGroup;
    import spark.events.RendererExistenceEvent;
    import spark.layouts.HorizontalAlign;
    import spark.layouts.VerticalLayout;
    import spark.utils.LabelUtil;
    
    //-----------------------------
    // Item Renderer default styles
    //-----------------------------
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
    
    
    [Event(name="sourceDataChange", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [Event(name="editableChanged", type="com.beauscott.mobile.controls.FormListItemRendererEvent")]
    [DefaultProperty("formItems")]
    [Exclude(kind="property", name="dataProvider")]

    public class FormDataGroup extends DataGroup
    {
        /**
         *  @private
         */
        private var editableChanged:Boolean = false;
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
                editableChanged = true;
                dispatchEvent(new FormListItemRendererEvent(FormListItemRendererEvent.EDITABLE_CHANGED, false, false, !value, value));
                invalidateProperties();
            }
        }
        
        
        //----------------------------------
        //  sourceData
        //----------------------------------
        
        private var _sourceData:Object;
        [Inspectable(category="Data")]
        [Bindable(event="sourceDataChange")]
        public function get sourceData():Object
        {
            return _sourceData;
        }
        /**
         *  @private
         */
        public function set sourceData(value:Object):void
        {
            if( _sourceData !== value)
            {
                var event:FormListItemRendererEvent = new FormListItemRendererEvent(FormListItemRendererEvent.SOURCE_DATA_CHANGE);
                event.oldValue = _sourceData;
                event.newValue = value;
                _sourceData = value;
                if (hasEventListener(event.type))
                    dispatchEvent(event);
            }
        }
        
        //----------------------------------
        //  labelField
        //----------------------------------
        
        /**
         *  @private
         */
        private var _labelField:String = "label";
        
        /**
         *  @private
         */
        private var labelFieldOrFunctionChanged:Boolean; 
        
        [Inspectable(category="Data", defaultValue="label")]
        
        /**
         *  The name of the field in the data provider items to display 
         *  as the label. 
         * 
         *  If labelField is set to an empty string (""), no field will 
         *  be considered on the data provider to represent label.
         * 
         *  The <code>labelFunction</code> property overrides this property.
         *
         *  @default "label" 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get labelField():String
        {
            return _labelField;
        }
        
        /**
         *  @private
         */
        public function set labelField(value:String):void
        {
            if (value == _labelField)
                return 
                
                _labelField = value;
            labelFieldOrFunctionChanged = true;
            invalidateProperties();
        }
        
        //----------------------------------
        //  labelFunction
        //----------------------------------
        
        /**
         *  @private
         */
        private var _labelFunction:Function; 
        
        [Inspectable(category="Data")]
        
        /**
         *  A user-supplied function to run on each item to determine its label.  
         *  The <code>labelFunction</code> property overrides 
         *  the <code>labelField</code> property.
         *
         *  <p>You can supply a <code>labelFunction</code> that finds the 
         *  appropriate fields and returns a displayable string. The 
         *  <code>labelFunction</code> is also good for handling formatting and 
         *  localization. </p>
         *
         *  <p>The label function takes a single argument which is the item in 
         *  the data provider and returns a String.</p>
         *  <pre>
         *  myLabelFunction(item:Object):String</pre>
         *
         *  @default null
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get labelFunction():Function
        {
            return _labelFunction;
        }
        
        /**
         *  @private
         */
        public function set labelFunction(value:Function):void
        {
            if (value == _labelFunction)
                return 
                
                _labelFunction = value;
            labelFieldOrFunctionChanged = true;
            invalidateProperties(); 
        }

        //----------------------------------
        //  formItems
        //----------------------------------
        
        [Bindable("dataProviderChanged")]
        public function get formItems():Vector.<FormListItem> {
            if (super.dataProvider != null && super.dataProvider.length) {
                var out:Vector.<FormListItem> = new Vector.<FormListItem>();
                for (var i:int = 0; i < super.dataProvider.length; i++) {
                    var f:FormListItem = super.dataProvider.getItemAt(i) as FormListItem;
                    if (f != null) {
                        out.push(f);
                    }
                }
                if (out.length) return out;
            }
            return null;
        }
        /**
         * @private
         */
        public function set formItems(value:Vector.<FormListItem>):void {
            if (value && value.length) {
                var f:Array = new Array(value.length);
                for (var i:int = 0; i < value.length; i++) {
                    f[i] = value[i];
                }
                super.dataProvider = new ArrayCollection(f);
            }
            else {
                super.dataProvider = null;
            }
        }
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        public function FormDataGroup()
        {
            super();
            this.itemRenderer = new ClassFactory(FormListItemRenderer);
            this.hasFocusableChildren = true;
            addEventListener(RendererExistenceEvent.RENDERER_REMOVE, rendererRemovedHandler, false, int.MAX_VALUE - 100);
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
        
        override protected function commitProperties():void {
            super.commitProperties();
            if (editableChanged) {
                editableChanged = false;
                var iiv:Vector.<int> = getItemIndicesInView();
                for each(var idx:int in iiv) {
                    var fi:FormListItemRenderer = getElementAt(idx) as FormListItemRenderer;
//                    if (fi.formItem && fi.formItem.editable != _editable) {
                        fi.formItem.dispatchEvent(new FormListItemRendererEvent(FormListItemRendererEvent.EDITABLE_CHANGED, false, false, !_editable, editable));
//                    }
                }
            }
        }
        
        /**
         *  Given a data item, return the correct text a renderer
         *  should display while taking the <code>labelField</code> 
         *  and <code>labelFunction</code> properties into account. 
         *
         *  @param item A data item 
         *  
         *  @return String representing the text to display for the 
         *  data item in the  renderer. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        override public function itemToLabel(item:Object):String
        {
            return LabelUtil.itemToLabel(item, labelField, labelFunction);
        }
        
        /**
         *  @inheritDoc
         *  Actually, the last thing this should do is set the sourceData for the item renderer 
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void {
            super.updateRenderer(renderer, itemIndex, data);
            if (renderer is IFormListItemRenderer) {
//                trace ("Renderer added", renderer, itemIndex, data);
                IFormListItemRenderer(renderer).sourceData = sourceData;
                IFormListItemRenderer(renderer).formItems = formItems;
            }
        }
        
        /**
         * @private
         */
        private function rendererRemovedHandler(event:RendererExistenceEvent):void {
//            trace(event);
            // Null source data to prevent extraenous event handling
            if (event.renderer is IFormListItemRenderer) {
                IFormListItemRenderer(event.renderer).sourceData = null;
                IFormListItemRenderer(event.renderer).formItems = null;
            }
        }
    }
}