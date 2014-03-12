package com.beauscott.mobile.skins
{
    import mx.core.IVisualElement;
    
    import spark.components.SpinnerListContainer;
    import spark.layouts.HorizontalAlign;
    import spark.layouts.HorizontalLayout;
    import spark.skins.mobile.DateSpinnerSkin;
    
    public class AccDateSpinnerSkin extends DateSpinnerSkin
    {
        public function AccDateSpinnerSkin()
        {
            super();
        }
        
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void {
            // Always set the SpinnerListContainer to its measured width, regardless of our size
            var containerWidth:Number = unscaledWidth;//SpinnerListContainer(listContainer).getPreferredBoundsWidth();
            var containerHeight:Number = unscaledHeight;
            var hl:HorizontalLayout = SpinnerListContainer(listContainer).layout as HorizontalLayout;
            if (hl)
                hl.horizontalAlign = HorizontalAlign.CENTER;
            
            setElementSize(listContainer, containerWidth, containerHeight);
            // if width is greater than necessary, center the component
            setElementPosition(listContainer, 0, 0);
        }
    }
}