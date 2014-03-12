package com.beauscott.mobile {
    import mx.core.mx_internal;
    import mx.managers.SystemManager;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    
    import spark.preloaders.SplashScreen;
    
    use namespace mx_internal;
    
    [ResourceBundle("plugins")]
    
    public class PluginSplashscreen extends SplashScreen {
        
        override mx_internal function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class {
            var xx:IResourceManager = ResourceManager.getInstance();
//            xx.initializeLocaleChain(xx.localeChain);
            var xy:Object = xx.getClass('plugins', 'splashscreen');
            if (xy) {
                var sysManager:SystemManager = this.parent.loaderInfo.content as SystemManager;
                if (sysManager) {
                    var info:Object = sysManager.info();
                    if (info) {
                        info['splashScreenImage'] = xy;
                    }
                }
            }
            return super.getImageClass(aspectRatio, dpi, resolution);
        }
    }
    
}