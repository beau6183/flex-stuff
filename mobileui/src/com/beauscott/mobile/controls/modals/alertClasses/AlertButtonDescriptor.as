package com.beauscott.mobile.controls.modals.alertClasses
{
	import flash.events.EventDispatcher;

	public class AlertButtonDescriptor extends EventDispatcher
	{
		[Bindable("labelChanged")]
		public var label:String;
		
		[Bindable("flagChanged")]
		public var flag:uint = 0;
        
        [Bindable]
        public var styleName:Object;
		
		public function AlertButtonDescriptor(label:String, flag:uint):void {
			super();
			this.label = label;
			this.flag = flag;
		}
	}
}