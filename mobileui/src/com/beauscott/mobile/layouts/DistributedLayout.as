package com.beauscott.mobile.layouts
{
    import mx.core.ILayoutElement;
    
    import spark.components.supportClasses.GroupBase;
    import spark.layouts.supportClasses.LayoutBase;
    
    public class DistributedLayout extends LayoutBase
    {
        public function DistributedLayout()
        {
            super();
        }
        
        //----------------------------------
        //  gap
        //----------------------------------
        
        private var _gap:int = 0;
        
        [Inspectable(category="General")]
        
        /**
         *  The horizontal space between layout elements.
         * 
         *  Note that the gap is only applied between layout elements, so if there's
         *  just one element, the gap has no effect on the layout.
         * 
         *  @default 0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */    
        public function get gap():int
        {
            return _gap;
        }
        
        /**
         *  @private
         */
        public function set gap(value:int):void
        {
            if (_gap == value) 
                return;
            
            _gap = value;
            
            var g:GroupBase = target;
            if (g)
            {
                g.invalidateSize();
                g.invalidateDisplayList();
            }
        }
        
        /**
         *  @private 
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        override public function measure():void
        {
            super.measure();
            
            var layoutTarget:GroupBase = target;
            if (!layoutTarget)
                return;
            
            var elementCount:int = 0;
            var gap:Number = this.gap;
            
            var width:Number = 0;
            var height:Number = 0;
            
            var count:int = layoutTarget.numElements;
            for (var i:int = 0; i < count; i++)
            {
                var layoutElement:ILayoutElement = layoutTarget.getElementAt(i);
                if (!layoutElement || !layoutElement.includeInLayout)
                    continue;
                
                width += layoutElement.getPreferredBoundsWidth();
                elementCount++;
                height = Math.max(height, layoutElement.getPreferredBoundsHeight());
                
            }
            
            if (elementCount > 1)
                width += gap * (elementCount - 1);
            
            layoutTarget.measuredWidth = width;
            layoutTarget.measuredHeight = height;
        }
        
        override public function updateDisplayList(width:Number, height:Number):void {
            var gap:Number = this.gap;
            super.updateDisplayList(width, height);
            
            var layoutTarget:GroupBase = target;
            if (!layoutTarget)
                return;
            
            
            var count:int = layoutTarget.numElements;
            var elementCount:int = count;
            var layoutElement:ILayoutElement;
            
            
            // Special case: if width is zero, make the gap zero as well
            if (width == 0)
                gap = 0;
            
            // Special case for no elements
            if (elementCount == 0)
            {
                layoutTarget.setContentSize(0, 0);
                return;
            }
            // The content size is always the parent size
            layoutTarget.setContentSize(width, height);
            
            // pass one: determine layout objects
            for (var i:int = 0; i < count; i++)
            {
                layoutElement = layoutTarget.getElementAt(i);
                if (!layoutElement || !layoutElement.includeInLayout)
                {
                    elementCount--;
                    continue;
                }
            }
            
            var elemWidth:Number = (width - ((elementCount - 1) * gap)) / elementCount;
            var posIndex:int = 0;
            
            // pass two: distribute total width evenly among layout elements
            for (i = 0; i < count; i++)
            {
                layoutElement = layoutTarget.getElementAt(i);
                if (!layoutElement || !layoutElement.includeInLayout)
                {
                    continue;
                }
                layoutElement.setLayoutBoundsSize(elemWidth, height);
                layoutElement.setLayoutBoundsPosition(posIndex++ * (elemWidth + gap), 0);
            }
        }
    }
}