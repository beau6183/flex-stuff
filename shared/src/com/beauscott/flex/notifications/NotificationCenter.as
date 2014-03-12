package com.beauscott.flex.notifications
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	public class NotificationCenter
	{
		public function NotificationCenter()
		{
			super();
			throw new ArgumentError("NotificationCenter is a static class and cannot be instantiated.");
		}
		
//		protected static var listenersByNoteName:Dictionary = new Dictionary(false);
//		protected static var listenersByCallback:Dictionary = new Dictionary(true);
        protected static var listenersByOwnerAndNoteName:Dictionary = new Dictionary(true);
		
		public static function listen(notificationName:String, thisObj:Object, callback:Function, withObject:Object = null):void {
			
			if (StringUtil.trim(notificationName).length == 0) {
				throw new ArgumentError("notificationName cannot be null or empty"); 
			}
			
			if (callback == null) {
				throw new ArgumentError("callback cannot be null");
			}
            
            if (thisObj == null) {
                throw new ArgumentError("thisObj cannot be null");
            }
			
			var l:__Listener = null;
            
            for each(var arr:ArrayCollection in listenersByOwnerAndNoteName[thisObj]) {
                for each (l in arr) {
                    if (l.noteName == notificationName && l.callback === callback) {
                        Log.getLogger("NotificationCenter").error("Notification {0} already registered for given owner/callback", notificationName);
                        return;
                    }
                }
            }
            
			l = new __Listener();
			l.noteName = notificationName;
			l.callback = callback;
			l.withObject = withObject;
            l.owner = thisObj;
            
            if (listenersByOwnerAndNoteName[thisObj] == null) {
                listenersByOwnerAndNoteName[thisObj] = new Dictionary(true);
            }
            if (listenersByOwnerAndNoteName[thisObj][callback] == null) {
                listenersByOwnerAndNoteName[thisObj][callback] = new ArrayCollection();
            }
            ArrayCollection(listenersByOwnerAndNoteName[thisObj][callback]).addItemAt(l, 0);
		}
		
		public static function stopListening(notificationName:String, thisObj:Object, callback:Function):void {
			var l:__Listener = null;
            
            if (listenersByOwnerAndNoteName[thisObj] && listenersByOwnerAndNoteName[thisObj][callback] != null) {
                for each (l in listenersByOwnerAndNoteName[thisObj][callback]) {
                    if (l.noteName == notificationName) {
                        var idx:int = ArrayCollection(listenersByOwnerAndNoteName[thisObj][callback]).getItemIndex(l);
                        ArrayCollection(listenersByOwnerAndNoteName[thisObj][callback]).removeItemAt(idx);
                        break;
                    }
                }
                if (!ArrayCollection(listenersByOwnerAndNoteName[thisObj][callback]).length) {
                    delete listenersByOwnerAndNoteName[thisObj][callback];
                }
            }
		}
        
        public static function stopListeningForOwner(thisObj:Object):void {
            delete listenersByOwnerAndNoteName[thisObj];
        }
		
		public static function send(notifcationName:String, withObject:Object = null):void {
            var note:Notification = new Notification(notifcationName, withObject);
            sendNote(note, withObject);
        }
        
        internal static function sendNote(note:Notification, withObject:Object = null):void {
            if (note.sent) return;
            note.sent = true;
            var stopped:Boolean = false;
            var returned:* = undefined;
            
            for each (var dict:Dictionary in listenersByOwnerAndNoteName) {
                for each (var arr:ArrayCollection in dict) {
                    for each (var l:__Listener in arr) {
                        if (l.noteName == note.type) {
                            
                            if (withObject === null) {
                                note._userObject = l.withObject;
                            }
                            else {
                                note._userObject = withObject;
                            }
                            
                            if (l.callback.length) {
                                returned = l.callback.apply(l.owner, [note]);
                            }
                            else {
                                returned = l.callback.apply(l.owner);
                            }
                            
                            if (returned !== undefined || note.stopped) {
                                note.stopped = true;
                                stopped = true;
                                break;
                            }
                        }
                    }
                    if (stopped) break;
                }
                if (stopped) break;
            }
		}
	}
}

class __Listener {
	public var noteName:String;
	public var callback:Function;
	public var withObject:Object;
    public var owner:Object;
}