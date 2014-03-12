package com.beauscott.mobile.assets
{
    import com.beauscott.mobile.controls.OptimizedFlexSprite;
    
    import flash.events.Event;
    
    
    public class FormViewBackgroundShape extends OptimizedFlexSprite
    {
        private var _backgroundColor:uint = 0xD5D5D5;

        [Bindable(event="backgroundColorChange")]
        public function get backgroundColor():uint
        {
            return _backgroundColor;
        }

        public function set backgroundColor(value:uint):void
        {
            if( _backgroundColor !== value)
            {
                _backgroundColor = value;
                dispatchEvent(new Event("backgroundColorChange"));
                invalidateDisplayList();
            }
        }

        
        private var _stripeColor:uint = 0xDADADA;
        
        [Bindable(event="stripeColorChange")]
        public function get stripeColor():uint
        {
            return _stripeColor;
        }

        public function set stripeColor(value:uint):void
        {
            if( _stripeColor !== value)
            {
                _stripeColor = value;
                dispatchEvent(new Event("stripeColorChange"));
                invalidateDisplayList();
            }
        }
        
        private var _stripeWidth:Number = 2;

        [Bindable(event="stripeWidthChange")]
        public function get stripeWidth():Number
        {
            return _stripeWidth;
        }

        public function set stripeWidth(value:Number):void
        {
            if( _stripeWidth !== value)
            {
                _stripeWidth = value;
                dispatchEvent(new Event("stripeWidthChange"));
                invalidateDisplayList();
            }
        }

        
        private var _stripeSpacing:Number = 10;

        [Bindable(event="stripeSpacingChange")]
        public function get stripeSpacing():Number
        {
            return _stripeSpacing;
        }

        public function set stripeSpacing(value:Number):void
        {
            if( _stripeSpacing !== value)
            {
                _stripeSpacing = value;
                dispatchEvent(new Event("stripeSpacingChange"));
                invalidateDisplayList();
            }
        }


        public function FormViewBackgroundShape()
        {
            super();
            this.cacheAsBitmap = true;
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            graphics.clear();
            graphics.moveTo(0,0);
            graphics.beginFill(backgroundColor);
            graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
            graphics.endFill();
            
            for (var i:Number = 0; i < unscaledWidth; i += (stripeSpacing)) {
                graphics.moveTo(i,0);
                graphics.beginFill(stripeColor);
                graphics.drawRect(i, 0, stripeWidth, unscaledHeight);
                graphics.endFill();
            }
        }
    }
}