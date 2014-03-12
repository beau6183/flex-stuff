package com.beauscott.mobile.skins
{
    import flash.display.DisplayObject;
    import flash.utils.getQualifiedClassName;
    
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    
    import spark.components.ViewMenu;
    import spark.components.ViewNavigator;
    import spark.components.ViewNavigatorApplication;
    import spark.skins.mobile.supportClasses.MobileSkin;
    
    /**
     *  The ActionScript-based skin used for ViewNavigatorApplication.  This
     *  skin contains a single ViewNavigator that spans the entire
     *  content area of the application.
     * 
     * @see spark.components.ViewNavigatorApplication
     * 
     *  @langversion 3.0
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public class ViewNavigatorApplicationSkin extends MobileSkin
    {
        
        private var currentBackground:Class;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        public function ViewNavigatorApplicationSkin()
        {
            super();
            
            viewMenu = new ClassFactory(ViewMenu);
        }
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * The navigator for the application.
         *  
         *  @langversion 3.0
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        public var navigator:ViewNavigator;
        
        protected var background:DisplayObject;
        
        
        /**
         *  Creates an action menu from this factory when the menu button is pressed 
         */ 
        public var viewMenu:IFactory;
        
        //--------------------------------------------------------------------------
        //
        //  Overridden Properties
        //
        //--------------------------------------------------------------------------
        /** 
         *  @copy spark.skins.spark.ApplicationSkin#hostComponent
         */
        public var hostComponent:ViewNavigatorApplication;
        
        //--------------------------------------------------------------------------
        //
        // Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        override protected function createChildren():void
        {
            var vmc:Class = getStyle('viewMenuClass') as Class;
            if (vmc != null) {
                viewMenu = new ClassFactory(vmc);
            }
            
            navigator = new ViewNavigator();
            navigator.id = "navigator";
            
            addChild(navigator);
        }
        
        /**
         *  @private 
         */ 
        override protected function measure():void
        {        
            super.measure();
            
            measuredWidth = navigator.getPreferredBoundsWidth();
            measuredHeight = navigator.getPreferredBoundsHeight();
        }
        
        /**
         *  @private
         */
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            navigator.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
            navigator.setLayoutBoundsPosition(0, 0);
            
            var c:Class = getStyle("backgroundImage") as Class;
            if (c != currentBackground) {
                if (c != null) {
                    var cn:String = getQualifiedClassName(c);
                    if (background != null) {
                        var bc:String = getQualifiedClassName(background);
                        if (bc != cn) {
                            removeChild(background);
                            background = null;
                        }
                    }
                    if (background == null) {
                        background = new c() as DisplayObject;
                        addChildAt(background, 0);
                    }
                }
                if (background != null) {
                    background.width = unscaledWidth;
                    background.height = unscaledHeight;
                    background.x = background.y = 0;
                }
                currentBackground = c;
            }
        }
    }
}