package com.beauscott.mobile.controls
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TouchEvent;
    import flash.geom.Point;
    import flash.utils.ByteArray;
    
    import mx.core.UIComponent;
    import mx.graphics.codec.PNGEncoder;
    
    [Style(name="backgroundColor", inherit="no", type="uint", format="Color")]
    [Style(name="backgroundAlpha", inherit="no", type="Number", format="Number")]
    
    [Style(name="lineColor", inherit="no", type="uint", format="Color")]
    [Style(name="lineAlpha", inherit="no", type="Number", format="Number")]
    [Style(name="lineThickness", inherit="no", type="Number", format="Number")]
    
    public class SignatureCaptureComponent extends UIComponent
    {
        protected var points:Vector.<Point> = new Vector.<Point>();
        protected var canvas:Sprite = new Sprite();
        
        protected var styleDidChange:Boolean = false;
        protected var _lineThickness:Number = 2;
        protected var _lineColor:uint = 0x000000;
        protected var _lineAlpha:Number = 1.0;
        protected var _backgroundColor:uint = 0xFFFFFF;
        protected var _backgroundAlpha:Number = 1.0;
        
        public function get bitmapData():BitmapData {
            if (hasData) {
                var bm:BitmapData = new BitmapData(unscaledWidth, unscaledHeight, true);
                bm.draw(canvas);
                return bm;
            }
            return null;
        }
        
        public function get pngData():ByteArray {
            if (hasData) {
                var png:PNGEncoder = new PNGEncoder();
                return png.encode(bitmapData);
            }
            return null;
        }
        
        [Bindable("change")]
        public function get hasData():Boolean {
            return points.length > 0;
        }
        
        public function SignatureCaptureComponent()
        {
            super();
            addEventListener(MouseEvent.MOUSE_DOWN, touchBeginHandler);
            addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
        }
        
        override protected function createChildren():void {
            super.createChildren();
            addChild(canvas);
        }
        
        override public function styleChanged(styleProp:String):void {
            if (styleProp in ["backgroundAlpha", "backgroundColor", "lineThickness", "lineColor", "lineAlpha"] || styleProp == null) {
                styleDidChange = true;
                invalidateProperties();
                invalidateDisplayList();
            }
            super.styleChanged(styleProp);
        }
        
        override protected function commitProperties():void {
            super.commitProperties();
            if (styleDidChange) {
                _backgroundAlpha = Math.min(1, Math.abs(getStyle("backgroundAlpha")));
                _backgroundColor = getStyle("backgroundColor");
                _lineThickness = getStyle("lineThickness");
                _lineColor = getStyle("lineColor");
                _lineAlpha = Math.min(1, Math.abs(getStyle("lineAlpha")));
            }
        }
        
        private var oldUnscaledHeight:Number = 0;
        private var oldUnscaledWidth:Number = 0;
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (oldUnscaledHeight != unscaledHeight || oldUnscaledWidth != unscaledWidth || styleDidChange) {
                redrawAllPoints();

                canvas.x = 0; 
                canvas.y = 0;
                canvas.width = unscaledWidth;
                canvas.height = unscaledHeight;
                
                graphics.clear();
                graphics.moveTo(0,0);
                
                graphics.beginFill(_backgroundColor, _backgroundAlpha);
                graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
                graphics.endFill();
                
                                
                oldUnscaledHeight = unscaledHeight;
                oldUnscaledWidth = unscaledWidth;
                styleDidChange = false;
            }
        }
        
        public function clear(dispatchChangeEvent:Boolean = true):void {
            if (canvas) {
                var changed:Boolean = false;
                if (points.length > 0) changed = dispatchChangeEvent && true;
                points.length = 0;
                canvas.graphics.clear();
                // 100% transparent, just need something in graphics to size the component
                canvas.graphics.beginFill(_backgroundColor, 0);
                canvas.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
                canvas.graphics.endFill();
                
                if (changed) {
                    dispatchEvent(new Event(Event.CHANGE));
                }
            }
        }
        
        public function redrawAllPoints():void {
            var pts:Vector.<Point> = points.slice();
            clear(false);
            points = pts;
            
            if (points.length == 0) return;
            var p:Point;
            
            // If size has changed, redraw lines with adjusted/scaled points
            var sy:Number = unscaledHeight / oldUnscaledHeight;
            var sx:Number = unscaledWidth / oldUnscaledWidth;
            if (isNaN(sx)) sx = 1;
            if (isNaN(sy)) sy = 1;
            
//            trace("Rescaling points by", sx, sy, oldUnscaledWidth, unscaledWidth, oldUnscaledHeight, unscaledHeight);
            
            var move:Boolean = true;
            for (var i:uint = 0; i < points.length; i++) {
                var lastPoint:Point = i > 0 ? points[i - 1] : null;
                p = points[i];
                if (p != null) {
                    p.x *= sx;
                    p.y *= sy;
                    if (move) {
                        canvas.graphics.moveTo(p.x, p.y);
                        move = false;
                    }
                    else {
                        canvas.graphics.lineStyle(_lineThickness, _lineColor, _lineAlpha, true, "normal");
                        canvas.graphics.lineTo(p.x, p.y);
                    }
                }
                else {
                    move = true;
                }
            }
            
            if (sx != 1 || sy != 1 || styleDidChange) {
                dispatchEvent(new Event(Event.CHANGE));
            }
        }
        
        private function drawNextSegment(p:Point):void {
            var lastPoint:Point = points.length > 0 ? points[points.length - 1] : null;
            if (lastPoint != null && p != null) {
                canvas.graphics.moveTo(lastPoint.x, lastPoint.y);
                canvas.graphics.lineStyle(_lineThickness, _lineColor, _lineAlpha, true, "normal");
                canvas.graphics.lineTo(p.x, p.y);
            }
            else if (p != null) {
                canvas.graphics.moveTo(p.x, p.y);
            }
//            else {
//                trace ("Pen up");
//            }
            points.push(p);
            dispatchEvent(new Event(Event.CHANGE));
        }
        
        private var touching:Boolean = false;
        
        private function touchBeginHandler(event:Event):void {
            if (!touching) {
                touching = true;
                removeEventListener(MouseEvent.MOUSE_DOWN, touchBeginHandler);
                removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
                
                if (event is MouseEvent) {
                    addEventListener(MouseEvent.MOUSE_MOVE, touchMoveHandler);
                    addEventListener(MouseEvent.MOUSE_UP, touchEndHandler);
                }
                else {
                    addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
                    addEventListener(TouchEvent.TOUCH_END, touchEndHandler);    
                }
            }
        }
        
        private function touchMoveHandler(event:Event):void {
            if (!touching) return;
            var p:Point;
            if (event is MouseEvent) {
                var e:MouseEvent = MouseEvent(event);
                if (e.buttonDown) {
                    p = new Point(e.localX, e.localY);
                }
                else {
                    touchEndHandler(event);
                }
            }
            else if (event is TouchEvent) {
                var t:TouchEvent = TouchEvent(event);
                p = new Point(t.localX, t.localY);
            }
            if (p != null) {
                var g:Point = localToGlobal(p);
                if (hitTestPoint(g.x, g.y)) {
                    drawNextSegment(p);    
                }
                else {
//                    trace ("out of bounds");
                    if (points.length > 0 && points[points.length - 1] != null) {
                        drawNextSegment(null); // pen up marker
                    }
                }
            }
        }
        
        private function touchEndHandler(event:Event):void {
            if (touching) {
                drawNextSegment(null); //mark pen up
                removeEventListener(MouseEvent.MOUSE_MOVE, touchMoveHandler);
                removeEventListener(MouseEvent.MOUSE_UP, touchEndHandler);
                removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
                removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);    
                
                addEventListener(MouseEvent.MOUSE_DOWN, touchBeginHandler);
                addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
                touching = false;
            }
        }
    }
}