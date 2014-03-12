package com.beauscott.flex.autowire
{
    [DefaultProperty("impl")]
    public class ClassMapping
    {
        [Bindable]
        public var iface:Object;
        
        [Bindable]
        public var impl:Object;
        
        [Bindable]
		[ArrayElementType("com.beauscott.flex.autowire.PropertyMapping")]
        public var properties:Array = [];
        
        internal var initialized:Boolean = false;
        
        public function ClassMapping(ifaceName:Object = null, impl:Object = null)
        {
            this.iface = ifaceName;
            this.impl = impl; 
        }
    }
}