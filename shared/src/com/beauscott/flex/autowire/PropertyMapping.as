package com.beauscott.flex.autowire
{
    public class PropertyMapping
    {
        [Bindable]
        public var name:String;
        
        [Bindable]
        public var ifaceName:String;
        
        public function PropertyMapping(name:String = null, ifaceName:String = null)
        {
            this.name = name;
            this.ifaceName = ifaceName;
        }
    }
}