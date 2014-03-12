package com.beauscott.mobile.controls
{
    import com.beauscott.flex.notifications.NotificationCenter;
    
    import flash.events.Event;
    import flash.utils.getQualifiedSuperclassName;
    
    import mx.core.IVisualElement;
    import mx.graphics.BitmapScaleMode;
    import mx.styles.ISimpleStyleClient;
    
    import spark.components.Image;
    import spark.components.View;
    
    [Style(name="background", inherit="no", type="Class")]

    public class ExtendedView extends View implements IViewMenuTitle
    {
        private var _backLabel:String;
        private var _explicitBackLabel:String;
        [Bindable("backLabelChanged")]
        public function get backLabel():String {
            return _explicitBackLabel ? _explicitBackLabel : _backLabel;
        }
        /**
         * @private
         */
        public function set backLabel(value:String):void {
            if (_explicitBackLabel !== value && _backLabel !== value) {
                _explicitBackLabel = value;
                if (hasEventListener("backLabelChanged"))
                    dispatchEvent(new Event("backLabelChanged"));
            }
        }

        internal function setBackLabel(value:String):void {
            if (_backLabel != value) {
                _backLabel = value;
                if (hasEventListener("backLabelChanged"))
                    dispatchEvent(new Event("backLabelChanged"));
            }
        }

        public function ExtendedView()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
        }

        private function _addedToStageHandler(event:Event):void {
            addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
            addedToStage();
        }
        
        protected function addedToStage():void {
            
        }

        private function _removedFromStageHandler(event:Event):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
            NotificationCenter.stopListeningForOwner(this);
            removedFromStage();
        }
        
        protected function removedFromStage():void {
            
        }

        public function goBack():void {
            if (this.navigator) {
                navigator.backKeyUpHandler();
            }
        }

        //
        // IViewMenuTitle
        //
        private var _viewMenuTitle:String;
        [Bindable("viewMenuTitleChanged")]
        public function get viewMenuTitle():String {
            return _viewMenuTitle;
        }
        /**
         * @private
         */
        public function set viewMenuTitle(value:String):void {
            if (value !== _viewMenuTitle) {
                _viewMenuTitle = value;
                dispatchEvent(new Event("viewMenuTitleChanged"));
            }
        }
        
        private var _viewMenuRole:String;
        [Bindable("viewMenuRoleChanged")]
        public function get viewMenuRole():String {
            return _viewMenuRole;
        }
        /**
         * @private
         */
        public function set viewMenuRole(value:String):void {
            if (value !== _viewMenuRole) {
                _viewMenuRole = value;
                dispatchEvent(new Event("viewMenuRoleChanged"));
            }
        }
        
        private var backgroundChanged:Boolean = false;
        private var viewBackground:IVisualElement;
        
        override public function styleChanged(styleProp:String):void {
            super.styleChanged(styleProp);
            if (!styleProp || styleProp == "background") {
                backgroundChanged = true;
                invalidateProperties();
                invalidateDisplayList();
            }
        }
        
        override protected function commitProperties():void {
            super.commitProperties();
            if (backgroundChanged) {
                backgroundChanged = false;
                if (viewBackground) {
                    removeElement(viewBackground);
                    viewBackground = null;
                }
                var bgclass:Class = getStyle("background") as Class;
                if (bgclass) {
                    var bg:IVisualElement;
                    if (getQualifiedSuperclassName(bgclass) == "mx.core::BitmapAsset") {
                        var img:Image = new Image();
                        img.scaleMode = BitmapScaleMode.STRETCH;
                        img.smooth = true;
                        img.source = getStyle("background");
                        bg = img;
                    }
                    else {
                        bg = new bgclass() as IVisualElement;
                    }
                    if (bg) {
                        bg.includeInLayout = false;
                        if ("id" in bg) bg['id'] = "viewBackground";
                        if (bg is ISimpleStyleClient && !(bg is Image)) bg['styleName'] = this;
                        addElementAt(bg, 0);
                        viewBackground = bg;
                    }
                }
            }
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            if (viewBackground) {
                viewBackground.setLayoutBoundsPosition(0,0);
                viewBackground.setLayoutBoundsSize(unscaledWidth,unscaledHeight);                
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
    }
}