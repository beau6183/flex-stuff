package com.beauscott.mobile {
    
    import com.beauscott.flex.beauscott;
    import com.beauscott.mobile.controls.ActionSheetViewMenu;
    import com.beauscott.mobile.controls.IViewMenuTitle;
    import com.beauscott.mobile.spark.components.ViewNavigatorApplication;
    
    import flash.desktop.NativeApplication;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.system.Capabilities;
    
    import mx.core.DPIClassification;
    import mx.core.FlexGlobals;
    import mx.core.mx_internal;
    import mx.managers.SystemManager;
    
    import spark.components.ViewMenu;
    
    use namespace mx_internal;
    
    use namespace beauscott;
    
    [Style(name="backgroundImage", inherit="no", type="Class", format="File")]
    [Style(name="viewMenuClass", inherit="no", type="Class", format="Class")]
    [Style(name="modalTransparency", inherit="yes", type="Number", format="Number")]
    [Style(name="modalTransparencyColor", inherit="yes", type="uint", format="Color")]
    
    public class MobileViewNavigatorApplicationBase extends ViewNavigatorApplication {
        
        
        private static var _fullScreenSet:Boolean = false;
        private static var _fullScreen:Boolean = false;
        public function get fullScreen():Boolean {
            if (!_fullScreenSet) {
                _fullScreenSet = true;
                _fullScreen = false;
                var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
                var ns:Namespace = xml.namespace();
                var fs:XMLList = xml..ns::fullScreen;
                if (fs && fs.length() > 0) {
                    _fullScreen = fs[0].toString() == "true";
                }
            }
            return _fullScreen;
        }
        
        private static var _version:String;
        public function get version():String {
            if (_version == null) {
                var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
                var ns:Namespace = xml.namespace();
                _version = xml.ns::versionNumber.toString();
            }
            return _version;
        }
        
        private static var _versionLabel:String;
        public function get versionLabel():String {
            if (_versionLabel == null) {
                var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
                var ns:Namespace = xml.namespace();
                _versionLabel = xml.ns::versionLabel.toString();
            }
            return _versionLabel;
        }
        
        private static var _applicationName:String;
        public function get applicationName():String {
            if (_applicationName == null) {
                var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
                var ns:Namespace = xml.namespace();
                _applicationName = xml.ns::filename.toString();
            }
            return _applicationName;
        }
        
//        [Bindable("resize")]
        override public function get applicationDPI():Number {
            return super.applicationDPI;
        }
        
//        [Bindable("resize")]
        public function get nativeDPI():Number {
            return Capabilities.screenDPI;
        }
        
//        [Bindable("resize")]
        override public function get runtimeDPI():Number {
            return super.runtimeDPI;
        }
        
//        [Bindable("resize")]
        public function get dpiScale():Number {
            return runtimeDPI / FlexGlobals.topLevelApplication.applicationDPI;
        }
        
//        [Bindable("resize")]
        public function get dpiBaseScale():Number {
            return applicationDPI / DPIClassification.DPI_160;
        }
        
//        [Bindable("resize")]
        public function get dpiNativeScale():Number {
            return nativeDPI / DPIClassification.DPI_160;
        }
        
//        [Bindable("resize")]
        /**
         * @private
         * Return the density scaling factor for the application
         */
        public function get scaleFactor():Number
        {
            if (systemManager is SystemManager)
                return SystemManager(systemManager).densityScale;
            
            return 1;
        }
        
        private static var _isTablet:Boolean = false;
        private static var _isTabletSet:Boolean = false;
        [Bindable("addedToStage")]
        public function get isTablet():Boolean {
            if (!_isTabletSet && systemManager && systemManager.stage) {
                var screenSize:Point = new Point();
                screenSize.x = Math.max(systemManager.stage.stageWidth, systemManager.stage.stageHeight);
                screenSize.y = Math.min(systemManager.stage.stageWidth, systemManager.stage.stageHeight);
                if (Capabilities.os.toLowerCase().indexOf('windows') > -1 || Capabilities.os.toLowerCase().indexOf('mac os') > -1) {
                    // Desktop, use screen size instead;
                    if (systemManager.stage.nativeWindow && (systemManager.stage.nativeWindow.maximizable || systemManager.stage.nativeWindow.resizable)) {
                        screenSize.x = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
                        screenSize.y = Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
                    }
                        // in the debug simulator... adjust the screen res for virtual device status bar;
                        // Simulator subtracts 38px from top edge for non-fullscreen apps
                    else if (Capabilities.isDebugger && !fullScreen) {
                        if (screenSize.y == systemManager.stage.stageHeight) { // portrait
                            screenSize.y += 38; 
                        }
                        else {
                            screenSize.x += 38;
                        }
                    }
                }
                    // Mobile, adjust full screen res potiential
                else if (!fullScreen) {
                    //                    trace ("Adjusting for status bar");
                    var capSize:Point = new Point();
                    capSize.x = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
                    capSize.y = Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
                    if (capSize.x > screenSize.x) {
                        //                        trace ("Adjusted screen width calc for status bar", (capSize.x - screenSize.x), "px");
                        screenSize.x += (capSize.x - screenSize.x);
                    }
                    if (capSize.y > screenSize.y) {
                        //                        trace ("Adjusted screen height calc for status bar", (capSize.y - screenSize.y), "px");
                        screenSize.y += (capSize.y - screenSize.y);
                    }
                }
                var diag:Number = Math.round(Math.round(100 * (screenSize.length / nativeDPI)) / 10) / 10;
                _isTablet = diag >= 5 || Math.max(screenSize.x, screenSize.y) >= 1024;
                _isTabletSet = true;
                trace("Client Info: os =", Capabilities.os, "CPU =", Capabilities.cpuArchitecture);
                trace("DPI: runtime =", runtimeDPI, ", application =", applicationDPI, ", native =", nativeDPI);
                trace("Scale factors: base =", dpiBaseScale, ", Pixel Density =", scaleFactor, "native =", dpiNativeScale);
                trace("Determined screen diagonal =", diag.toFixed(1) + '" @', nativeDPI,
                    "dpi (", screenSize.x, 'x', screenSize.y, '); Device is', _isTablet ? "Tablet" : "Phone");
            }
            return _isTablet;
        }
        
        /**
         * @private
         */ 
        protected function get currentViewMenuTitle():String {
            if (activeView is IViewMenuTitle) {
                return IViewMenuTitle(activeView).viewMenuTitle;
            }
            return null;
        }
        
        public function MobileViewNavigatorApplicationBase():void {
            super();
        }
        
        /**
         *  @private
         *  Attaches a mouseShield to prevent interaction with the rest of the 
         *  application while the menu is open
         */ 
        override mx_internal function attachMouseShield():void
        {
            if (skin)
            {
                mouseShield = new Sprite();
                
                var g:Graphics = mouseShield.graphics;
                var msa:Number = 0.3;
                if (getStyle('modalTransparency') !== undefined && !isNaN(getStyle('modalTransparency'))) {
                    msa = getStyle('modalTransparency');
                }
                var msc:uint = 0;
                if (getStyle('modalTransparencyColor') !== undefined) {
                    msc = getStyle('modalTransparencyColor');
                }
                g.beginFill(msc,msa);
                g.drawRect(0,0,getLayoutBoundsWidth(), getLayoutBoundsHeight());
                g.endFill();
                
                skin.addChild(mouseShield);
            }
        }
        
        /**
         * @private
         */ 
        override protected function updateViewMenuPosition():void {
            var vm:ViewMenu = getCurrentViewMenu();
            
            if (vm) {
                
                if (vm is ActionSheetViewMenu) {
                    ActionSheetViewMenu(vm).title = currentViewMenuTitle;
                }
                
                var vmm:Point = new Point(vm.getLayoutBoundsWidth(), vm.getLayoutBoundsHeight());
                var s:Point = new Point(systemManager.stage.stageWidth, systemManager.stage.stageHeight);
                
                if (isTablet) {
                    vm.maxHeight = s.y;
                    var w:Number = Math.min(s.x, s.y) * 0.8; 
                    vm.width = w;
                    vm.validateNow();
                    vm.setLayoutBoundsPosition((s.x - w) / 2, (s.y - vm.getLayoutBoundsHeight()) / 2, false);
                }
                else {
                    var h:Number = Math.min(vmm.y, s.y);
                    vm.width = s.x;
                    vm.setActualSize(s.x, h);
                    vm.validateNow();
                    vm.move(0, s.y - vm.getLayoutBoundsHeight());
                }
            }
        }
        
        override protected function getViewMenuPreferredHeight():Number {
            var vm:ViewMenu = getCurrentViewMenu();
            if (vm) {
                return NaN; 
            }
            return super.getViewMenuPreferredHeight();
        }
        
        override protected function getViewMenuPreferredWidth():Number {
            if (isTablet) {
                var fullWidth:Number = getLayoutBoundsWidth();
                if (fullWidth > getLayoutBoundsHeight()) { //landscape
                    fullWidth = fullWidth * 0.6;
                }
                else {
                    fullWidth = fullWidth * 0.8;
                }
                return fullWidth; 
            }
            else {
                return super.getViewMenuPreferredWidth();
            }
        }
        
    }
    
}