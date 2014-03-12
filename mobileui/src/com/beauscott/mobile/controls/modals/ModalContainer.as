package com.beauscott.mobile.controls.modals
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Screen;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.StageOrientationEvent;
    import flash.ui.Keyboard;

    import mx.core.IVisualElement;
    import mx.core.IVisualElementContainer;
    import mx.core.UIComponent;
    import mx.managers.IFocusManagerComponent;
    import mx.managers.PopUpManager;

    import spark.components.Group;
    import spark.components.SkinnablePopUpContainer;
    import spark.events.PopUpEvent;

    [Style(name="marginTop", inherit="no", type="Number")]

    [Event(name="closing", type="flash.events.Event")]

    public class ModalContainer extends SkinnablePopUpContainer implements IFocusManagerComponent
    {
        [Bindable("titleChanged")]
        public var title:String;

        [SkinPart(required="false")]
        public var controlBar:IVisualElementContainer;

        private var controlBarContentChanged:Boolean = false;
        private var _controlBarContent:Array;

        [ArrayElementType("mx.core.IVisualElement")]
        [Bindable("controlBarContentChanged")]
        public function get controlBarContent():Array {
            return _controlBarContent;
        }
        /**
         * @private
         */
        public function set controlBarContent(value:Array):void {
            _controlBarContent = value;
            controlBarContentChanged = true;
            dispatchEvent(new Event("controlBarContentChanged"));
            invalidateProperties();
        }

        public function ModalContainer()
        {
            super();
            minWidth = Math.min(500, Screen.mainScreen.bounds.width);
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }

        private function addedToStageHandler(event:Event):void
        {
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
            systemManager.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
            systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler, true, int.MAX_VALUE, false);
        }

        private function removedFromStageHandler(event:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
            systemManager.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
            systemManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler, true);
        }

        private function orientationChangeHandler(event:StageOrientationEvent):void
        {
            invalidateSkinState();
            updatePopUpPosition();
        }

        override protected function commitProperties():void {
            if (controlBarContentChanged && controlBar) {
                controlBarContentChanged = false;
                controlBar.removeAllElements();
                for each(var elem:IVisualElement in controlBarContent) {
                    controlBar.addElement(elem);
                }
                UIComponent(controlBar).visible = !!controlBar.numElements;
                UIComponent(controlBar).includeInLayout = !!controlBar.numElements;
            }
            super.commitProperties();
        }

        override public function open(owner:DisplayObjectContainer, modal:Boolean=true):void {
            super.open(owner, modal);

        }

        protected function stage_keyDownHandler(event:KeyboardEvent):void {
            if (!event.isDefaultPrevented() && (event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.ESCAPE)) {
                event.preventDefault();
                event.stopImmediatePropagation();
                close();
            }
        }

        override public function updatePopUpPosition():void {
            PopUpManager.bringToFront(this);
            var marginTop:Number = getStyle("marginTop") === undefined || isNaN(getStyle('marginTop')) ? 0 : getStyle('marginTop');
            validateNow();
            this.setLayoutBoundsPosition((systemManager.stage.stageWidth - this.getLayoutBoundsWidth()) / 2, marginTop);
        }

        /**
         * function(commit:Boolean = false, data:*=null, target:ModalContainer):Boolean // true = proceed with close, false = cancel close
         */
        public var closingHandler:Function;
        public var callbackTarget:Object = null;

        protected function closing(commit:Boolean, data:*):Boolean {
            if (closingHandler != null) {
                var args:Array = [commit, data, this];
                args.length = closingHandler.length;
                return closingHandler.apply(callbackTarget, args);
            }
            return true;
        }

        override public function close(commit:Boolean=false, data:*=null):void {
            if (closing(commit, data) &&
                (!hasEventListener(Event.CLOSING) || dispatchEvent(new Event(Event.CLOSING, false, true)))) {
                super.close(commit, data);
            }
        }

        public static function show(clazz:Class, parent:DisplayObjectContainer, title:String = null, closeHandler:Function = null, closingHandler:Function = null):ModalContainer {
            var alert:ModalContainer = new clazz();
            if (closeHandler != null) {
                alert.addEventListener(PopUpEvent.CLOSE, closeHandler, false, 0, true);
            }
            alert.closingHandler = closingHandler;
            alert.title = title;
            alert.open(parent, true);
            alert.setFocus();
            return alert;
        }
    }
}