package com.beauscott.mobile.assets {
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.utils.getQualifiedSuperclassName;
    
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    import mx.graphics.BitmapScaleMode;
    import mx.styles.ISimpleStyleClient;
    import mx.utils.ObjectUtil;
    
    import spark.components.Image;
    
    [Style(name="assetClass", inherit="no", type="Class")]
    [Style(name="assetURL", inherit="no", type="String")]
    [Style(name="scaleMode", inherit="no", type="String")]
    /**
     *  Horizontal alignment of children in the container.
     *  Possible values are <code>"left"</code>, <code>"center"</code>,
     *  and <code>"right"</code>.
     *  The default value is <code>"left"</code>, but some containers,
     *  such as ButtonBar and ToggleButtonBar,
     *  have different default values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
    
    /**
     *  Vertical alignment of children in the container.
     *  Possible values are <code>"top"</code>, <code>"middle"</code>,
     *  and <code>"bottom"</code>.
     *  The default value is <code>"top"</code>, but some containers,
     *  such as ButtonBar, ControlBar, LinkBar,
     *  and ToggleButtonBar, have different default values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]
    public class AssetLoader extends UIComponent {
        
        protected var asset:DisplayObject;
        private var assetChanged:Boolean = false;
        
        //
        // Asset properties
        //
        
        private var _assetProperties:Object = null;

        [Bindable("assetPropertiesChanged")]
        public function get assetProperties():Object {
            return _assetProperties;
        }

        /**
         * @private
         */
        public function set assetProperties(value:Object):void {
            if (_assetProperties !== value) {
                _assetProperties = value;
                assetChanged = true;
                dispatchEvent(new Event("assetPropertiesChanged"));
                invalidateProperties();
            }
        }

        override public function styleChanged(styleProp:String):void {
            if (!styleProp || styleProp == "assetClass" || styleProp == "assetURL" || styleProp == "assetFile") {
                assetChanged = true;
                invalidateDisplayList();
            }
            super.styleChanged(styleProp);
        }
        
        override protected function commitProperties():void {
            super.commitProperties();
            if (assetChanged) {
                assetChanged = false;
                if (asset) {
                    removeChild(asset);
                    invalidateSize();
                    invalidateDisplayList();
                    asset = null;
                }
                
                var assetClass:Class;
                var assetURL:Object = getStyle("assetURL") as String;
                if (assetURL) {
                    assetClass = Image;
                }
                else {
                    assetClass = getStyle("assetClass") as Class;
                    if (getQualifiedSuperclassName(assetClass) == "mx.core::BitmapAsset") {
                        assetURL = assetClass;
                        assetClass = Image;
                    }
                }
                
                if (assetClass) {
                    asset = DisplayObject(createInFontContext(assetClass));
                    if (asset is ISimpleStyleClient && !(asset is Image)) {
                        ISimpleStyleClient(asset).styleName = this;
                    }
                }
                
                if (asset) {
                    if (assetProperties) {
                        var d:Array = ObjectUtil.getClassInfo(assetProperties).properties;
                        for each(var p:QName in d) {
                            if (p.localName in asset) {
                                try {
                                    asset[p.localName] = d[p.localName];
                                }
                                catch (e:Error) {
                                    // safe guard against read only
                                }
                            }
                        }
                    }
                    
                    if (assetURL && asset is Image) {
                        Image(asset).source = assetURL;
                        Image(asset).scaleMode = BitmapScaleMode.LETTERBOX;
                        Image(asset).setStyle("backgroundAlpha", 0);
                        Image(asset).smooth = true;
                    }
                    
                    addChild(asset);
                    invalidateSize();
                    invalidateDisplayList();
                }
            }
        }
        
        override protected function measure():void {
            super.measure();
            if (asset is IVisualElement) {
                measuredHeight = IVisualElement(asset).getPreferredBoundsHeight();
                measuredWidth = IVisualElement(asset).getPreferredBoundsWidth();
            }
            else if (asset is UIComponent) {
                measuredHeight = UIComponent(asset).getExplicitOrMeasuredHeight();
                measuredWidth = UIComponent(asset).getExplicitOrMeasuredWidth();
            }
            else if (asset) {
                measuredHeight = asset.height;
                measuredWidth = asset.width;
            }
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (asset is IVisualElement) {
                IVisualElement(asset).setLayoutBoundsSize(unscaledWidth, unscaledHeight);
                IVisualElement(asset).setLayoutBoundsPosition(0, 0);
            }
            else if (asset is UIComponent) {
                UIComponent(asset).setActualSize(unscaledWidth, unscaledHeight);
                UIComponent(asset).move(0,0);
            }
            else if (asset) {
                asset.width = unscaledWidth;
                asset.height = unscaledHeight;
                asset.x = asset.y = 0;
            }
        }
    }
}