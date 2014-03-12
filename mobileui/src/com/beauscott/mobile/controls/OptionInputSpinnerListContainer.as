package com.beauscott.mobile.controls
{
    import flash.events.Event;
    
    import mx.collections.IList;
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    import mx.events.FlexEvent;
    
    import spark.components.SpinnerList;
    import spark.components.SpinnerListContainer;
    import spark.components.SpinnerListItemRenderer;
    import spark.events.IndexChangeEvent;
    import spark.layouts.HorizontalAlign;
    
    public class OptionInputSpinnerListContainer extends SpinnerListContainer {
        
        private var defaultItemRenderer:IFactory = new ClassFactory(SpinnerListItemRenderer);
        private var _itemRenderer:IFactory = defaultItemRenderer;
        private var rendererChanged:Boolean = false;

        public function get itemRenderer():IFactory
        {
            return _itemRenderer;
        }

        public function set itemRenderer(value:IFactory):void
        {
            if (!value) value = defaultItemRenderer
            if (value != _itemRenderer) {
                _itemRenderer = value;
                rendererChanged = true;
                invalidateProperties();
            }
        }

        
        private var spinnerChanged:Boolean = false;
        
        private var _spinner:SpinnerList;
        
        public function get spinner():SpinnerList
        {
            return _spinner;
        }
        
        public function set spinner(value:SpinnerList):void
        {
            if (value !== _spinner) {
                if (_spinner && _spinner.parent == this) {
                    _spinner.removeEventListener(IndexChangeEvent.CHANGE, spinner_changeHandler);
                    _spinner.removeEventListener(FlexEvent.VALUE_COMMIT, spinner_changeHandler);
                    removeElement(_spinner);
                }
                _spinner = value;
                spinnerChanged = true;
                invalidateProperties();
            }
        }
        
        /**
         * @private
         */
        private var _selectedItem:*;
        
        [Bindable("change")]
        [Bindable("valueCommit")]
        [NonCommittingChangeEvent("change")]
        /**
         * selected item
         */
        public function get selectedItem():* {
            return _selectedItem;
        }
        /**
         * @private
         */
        public function set selectedItem(value:*):void {
            if (_selectedItem !== value) {
                _selectedItem = value;
                if (value && dataProvider) {
                    _selectedIndex = dataProvider.getItemIndex(_selectedItem);
                }
                else {
                    _selectedIndex = -1;
                }
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                invalidateProperties();
            }
        }
        
        /**
         * @private
         */
        private var _selectedIndex:int = -1;
        
        [Bindable("change")]
        [Bindable("valueCommit")]
        [NonCommittingChangeEvent("change")]
        /**
         * selected index
         */
        public function get selectedIndex():int {
            return _selectedIndex;
        }
        /**
         * @private
         */
        public function set selectedIndex(value:int):void {
            if (dataProvider && (value >= dataProvider.length || value < -1)) {
                value = -1;
            }
            if (_selectedIndex !== value) {
                _selectedIndex = value;
                if (_selectedIndex > -1 && dataProvider) {
                    _selectedItem = dataProvider.getItemAt(_selectedIndex);
                }
                else if (_selectedIndex == -1) {
                    _selectedItem = null;
                }
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                invalidateProperties();
            }
        }
        
        /**
         * @private 
         */
        private var _dataProvider:IList;
        private var dataChanged:Boolean = false;
        
        [Bindable(event="dataChange")]
        public function get dataProvider():IList
        {
            return _dataProvider;
        }
        
        /**
         * @private 
         */
        public function set dataProvider(value:IList):void
        {
            if( _dataProvider !== value)
            {
                _dataProvider = value;
                if (_dataProvider && _selectedItem) {
                    var idx:int = _dataProvider.getItemIndex(_selectedItem);
                    if (idx > -1) {
                        _selectedIndex = idx;
                    }
                }
                dataChanged = true;
                dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
                invalidateProperties();
            }
        }
        
        /**
         * @private 
         */
        private var labelFieldOrFunctionChanged:Boolean = false;
        
        /**
         * @private 
         */
        private var _labelField:String;
        
        public function get labelField():String
        {
            return _labelField;
        }
        /**
         * @private 
         */
        public function set labelField(value:String):void
        {
            if( _labelField !== value)
            {
                _labelField = value;
                labelFieldOrFunctionChanged = true;
                invalidateProperties();
            }
        }
        
        
        /**
         * @private 
         */
        private var _labelFunction:Function;
        
        public function get labelFunction():Function
        {
            return _labelFunction;
        }
        /**
         * @private 
         */
        public function set labelFunction(value:Function):void
        {
            if( _labelFunction !== value)
            {
                _labelFunction = value;
                labelFieldOrFunctionChanged = true;
                invalidateProperties();
            }
        }
        
        
        /**
         * @private 
         */
        private var _wrapElements:Boolean;

        [Bindable(event="wrapElementsChange")]
        public function get wrapElements():Boolean
        {
            return _wrapElements;
        }
        
        /**
         * @private 
         */
        public function set wrapElements(value:Boolean):void
        {
            if (_wrapElements !== value) {
                _wrapElements = value;
                dispatchEvent(new Event("wrapElementsChange"));
                invalidateProperties();
            }
        }
        
        
        public function OptionInputSpinnerListContainer(spinner:SpinnerList = null):void {
            super();
            this.spinner = spinner;
        }
        
        override protected function createChildren():void {
            super.createChildren();
            if (!_spinner) {
                var s:SpinnerList = new SpinnerList();
                s.width = NaN;
                s.percentWidth = 100;
                spinner = s;
            }
        }
        
        override protected function commitProperties():void {
            setStyle('horizontalAlign', HorizontalAlign.CENTER);
            
            if (_spinner) {
                _spinner.removeEventListener(IndexChangeEvent.CHANGE, spinner_changeHandler);
                _spinner.removeEventListener(FlexEvent.VALUE_COMMIT, spinner_changeHandler);
            }
            
            if (dataChanged) {
                if (_spinner) {
                    _spinner.dataProvider = dataProvider;
                }
                dataChanged = false;
            }
            
            if (labelFieldOrFunctionChanged) {
                if (_spinner) {
                    _spinner.labelField = labelField;
                    _spinner.labelFunction = labelFunction;
                }
                labelFieldOrFunctionChanged = false;
            }
            
            if (spinnerChanged) {
                if (_spinner && _spinner.parent != this) {
                    addElement(_spinner);
                }
                rendererChanged = true;
                spinnerChanged = false;
            }
            
            if (_spinner) {
                if (rendererChanged && _itemRenderer != _spinner.itemRenderer) {
                    _spinner.itemRenderer = _itemRenderer;
                }
                rendererChanged = false;
                _spinner.selectedIndex = _selectedIndex;
                _spinner.wrapElements = _wrapElements;
                _spinner.addEventListener(IndexChangeEvent.CHANGE, spinner_changeHandler);
                _spinner.addEventListener(FlexEvent.VALUE_COMMIT, spinner_changeHandler);
            }
            super.commitProperties();
        }
        
        private function spinner_changeHandler(event:Event):void {
            _selectedItem = spinner.selectedItem;
            _selectedIndex = spinner.selectedIndex;
            dispatchEvent(event);
        }
    }
}