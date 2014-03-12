package com.beauscott.mobile.skins
{
    import spark.components.ButtonBarButton;
    import spark.skins.mobile.ButtonBarFirstButtonSkin;
    import spark.skins.mobile.ButtonBarSkin;
    import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
    
    [Style(name="firstButtonSkin", inherit="no", type="Class", format="Class")]
    [Style(name="lastButtonSkin", inherit="no", type="Class", format="Class")]
    [Style(name="middleButtonSkin", inherit="no", type="Class", format="Class")]
    public class AlertViewButtonBarSkin extends ButtonBarSkin
    {
        public function AlertViewButtonBarSkin()
        {
            super();
        }
        override protected function createChildren():void
        {
            // Set up the class factories for the buttons
            if (!firstButton && getStyle('firstButtonSkin') is Class)
            {
                firstButton = new ButtonBarButtonClassFactory(ButtonBarButton);
                firstButton.skinClass = getStyle('firstButtonSkin') as Class;
            }
            
            if (!lastButton && getStyle('lastButtonSkin') is Class)
            {
                lastButton = new ButtonBarButtonClassFactory(ButtonBarButton);
                lastButton.skinClass = getStyle('lastButtonSkin') as Class;
            }
            
            if (!middleButton && getStyle('middleButtonSkin') is Class)
            {
                middleButton = new ButtonBarButtonClassFactory(ButtonBarButton);
                middleButton.skinClass = getStyle('middleButtonSkin') as Class;
            }
            super.createChildren();
        }
    }
}