package com.beauscott.flex.notifications
{
	import mx.utils.ObjectUtil;

	public class Notification
	{
		private var _type:String;
		public function get type():String {
			return _type;
		}
		
		internal var _userObject:Object;
		public function get userObject():Object {
			return _userObject;
		}
		
		internal var stopped:Boolean = false;
		
		public function Notification(type:String, userObject:Object = null)
		{
			_type = type;
			_userObject = userObject;
		}
		
		public function stop():void {
			stopped = true;
		}
        
        internal var sent:Boolean = false;
        public function send():void {
            NotificationCenter.sendNote(this, _userObject);
        }
		
		public function toString():String {
			return ObjectUtil.toString(this, null, ["userObject"]);
		}
	}
}