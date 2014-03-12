package com.beauscott.mobile.controls
{
    import spark.components.IItemRenderer;

    [Event(name="sourceDataChange", type="com.beauscott.mobile.controls.FormDataGroupEvent")]
    public interface IFormListItemRenderer extends IItemRenderer
    {
        [Bindable("sourceDataChange")]
        function get sourceData():Object;
        function set sourceData(value:Object):void;
        
        function set formItems(value:Vector.<FormListItem>):void;
        
        [Bindable("editableChanged")]
        function get editable():Boolean;
        
//        function get value():Object;
    }
}