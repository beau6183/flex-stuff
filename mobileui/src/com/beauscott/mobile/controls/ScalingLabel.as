package com.beauscott.mobile.controls
{
    import spark.components.supportClasses.SkinnableTextBase;
    import spark.components.supportClasses.StyleableTextField;
    
    [Style(name="minFontSize", inherit="no", type="Number")]
    
    public class ScalingLabel extends SkinnableTextBase
    {
        public function ScalingLabel()
        {
            super();
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (textDisplay is StyleableTextField) {
                var minFontSize:Number = getStyle('minFontSize') === undefined || isNaN(getStyle('minFontSize')) ? 0 : getStyle('minFontSize');
                var stf:StyleableTextField = StyleableTextField(textDisplay);
                var bfs:Number = getStyle('fontSize');
                do {
                    textDisplay.text = text;
                    stf.setStyle('fontSize', bfs);
                    stf.commitStyles();
                    stf.truncateToFit();
                } while (textDisplay.isTruncated && --bfs >= minFontSize);
            }
        }
    }
}