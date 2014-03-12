package com.beauscott.mobile.controls
{
    import mx.core.IVisualElement;
    
    [Event(name="valueCommit", type="mx.events.FlexEvent")]
    
    public interface IAccessorizableInput
    {
        function get inputAccessoryValueField():String;
        function get inputAccessoryCreated():Boolean;
        
        [Bindable("inputAccessoryChange")]
        function get inputAccessory():IVisualElement;
        function set inputAccessory(value:IVisualElement):void;
        
        function showAccessory():void;
        function hideAccessory():void;
    }
}