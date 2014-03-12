package com.beauscott.mobile.controls
{
    import com.beauscott.flex.notifications.NotificationCenter;
    
    import flash.events.MouseEvent;
    
    import spark.components.ViewMenuItem;
    
    public class POSViewMenuItem extends ViewMenuItem
    {
        [Bindable("dataChange")]
        public var data:Object;
        
        [Bindable("notificationNameChange")]
        public var notificationName:String;
        
        public function POSViewMenuItem()
        {
            super();
        }
        
        override protected function clickHandler(event:MouseEvent):void {
            super.clickHandler(event);
            if (!event.isDefaultPrevented() && notificationName != null) {
                NotificationCenter.send(notificationName, data);
            }
        }
    }
}