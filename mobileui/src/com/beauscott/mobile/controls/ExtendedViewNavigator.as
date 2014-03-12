package com.beauscott.mobile.controls
{
    import spark.components.View;
    import spark.components.ViewNavigator;
    import spark.transitions.ViewTransitionBase;
    
    public class ExtendedViewNavigator extends ViewNavigator
    {
        public static const DEFAULT_BACK_LABEL:String = "Back";
        
        public function getBackLabel():String {
            if (backLabels.length && backLabels[backLabels.length - 1]) {
                return backLabels[backLabels.length - 1];
            }
            return DEFAULT_BACK_LABEL;
        }
        
        protected var backLabels:Array = [];
        
        public function ExtendedViewNavigator()
        {
            super();
        }
        
        override public function popAll(transition:ViewTransitionBase=null):void {
            backLabels.length = 0;
            super.popAll(transition);
        }
        
        override public function popToFirstView(transition:ViewTransitionBase=null):void {
            backLabels.length = 0;
            super.popToFirstView(transition);
        }
        
        override public function pushView(viewClass:Class, data:Object=null, context:Object=null, transition:ViewTransitionBase=null):void {
            if (activeView) {
                backLabels.push(activeView.title);
            }
            super.pushView(viewClass, data, context, transition);
        }
        
        override public function popView(transition:ViewTransitionBase=null):void {
            if (backLabels.length) {
                backLabels.pop();
            }
            super.popView(transition);
        }
        
        public function popToViewIndex(idx:int):void {
            if (idx >= length) idx = length - 1;
        }
        
        public function popToFistInstanceOfView(viewClass:Class, transition:ViewTransitionBase=null):void {
            
        }
        
        public function popToLastInstanceOfView(viewClass:Class, transition:ViewTransitionBase=null):void {
            
        }
        
        override public function loadViewData(value:Object):void {
            super.loadViewData(value);
        }
        
        override public function updateControlsForView(view:View):void {
            super.updateControlsForView(view);
            if (view is ExtendedView) {
                ExtendedView(view).setBackLabel(getBackLabel());
            }
        }
    }
}