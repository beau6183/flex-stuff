package com.beauscott.mobile.skins
{
    import com.beauscott.mobile.controls.FormDataGroup;
    import com.beauscott.mobile.controls.FormListItemRenderer;
    
    import mx.core.ClassFactory;
    
    import spark.layouts.HorizontalAlign;
    import spark.layouts.VerticalLayout;
    import spark.skins.mobile.ListSkin;
    
    public class FormListSkin extends ListSkin
    {
        public function FormListSkin()
        {
            super();
        }
        
        override protected function createChildren():void {
            if (!dataGroup)
            {
                // Create data group layout
                var layout:VerticalLayout = new VerticalLayout();
                layout.requestedMinRowCount = 5;
                layout.horizontalAlign = HorizontalAlign.JUSTIFY;
                layout.gap = 0;
                layout.variableRowHeight = true;
                
                // Create data group
                dataGroup = new FormDataGroup();
                dataGroup.layout = layout;
                if (!dataGroup.itemRenderer)
                    dataGroup.itemRenderer = new ClassFactory(FormListItemRenderer);
            }
            super.createChildren();
        }
    }
}