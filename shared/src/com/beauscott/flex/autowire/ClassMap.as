package com.beauscott.flex.autowire
{
    import com.beauscott.flex.beauscott;

    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import mx.core.IMXMLObject;
    import mx.core.Singleton;
    import mx.logging.Log;
    import mx.managers.ISystemManager;
    import mx.utils.ObjectUtil;

	use namespace beauscott;

	[DefaultProperty("mappings")]

    public class ClassMap implements IMXMLObject
    {
        [Bindable]
        public var id:String;

        [Bindable]
        public var document:Object;

        public static const INJECT:String = "Inject";

        [ArrayElementType("com.beauscott.flex.autowire.ClassMapping")]
        public var mappings:Array = [];

        private static var ifaceToImpl:Object = {};

        private var isInitialized:Boolean = false;

        public function ClassMap()
        {
            super();
        }

        public function init(sm:ISystemManager):void {
            if (!isInitialized) {
                isInitialized = true;
                for each (var cm:ClassMapping in mappings) {
                    var iface:String = getInterfaceName(cm.iface);
                    if ((cm.impl as Class) != null) {
                        Singleton.registerClass(iface, cm.impl as Class);
                    }
                    else {
                        registerImplementation(iface, cm.impl);
                    }
                    ifaceToImpl[iface] = cm;
                }
            }
        }

        public static function getInterfaceName(obj:Object):String {
            var out:String = null;
            if (obj is String) {
				out = obj as String;
				try {
					var c:Class = getDefinitionByName(out) as Class;
					if (c != null) {
						out = getQualifiedClassName(c);
					}
				}
				catch (e:Error) {
					out = obj as String;
				}
            }
            else if (obj !== null && !ObjectUtil.isSimple(obj)) {
                out = getQualifiedClassName(obj);
            }
            return out;
        }

        public static function get(i:Object):* {
            return getImpl(i); //TODO support factory methods for non singletons
        }

        public static function getImpl(i:Object):* {
            var iface:String = getInterfaceName(i);
            var out:* = Singleton.getClass(iface);
            if (out != null) {
                out = Singleton.getInstance(iface);
            }
            else {
                out = getImplementation(iface);
            }
            var cm:ClassMapping = ifaceToImpl[iface] as ClassMapping;
            if (out == null || cm == null) {
                return null;
            }
            if (!cm.initialized) {
                cm.initialized = true;
                assignDependencies(out);
                for each(var pm:PropertyMapping in cm.properties) {
                    out[pm.name] = getImpl(pm.ifaceName);
                }
            }
            return out;
        }

		private static var implementations:Dictionary = new Dictionary(false);

		private static function getImplementation(interfaceName:String):* {
//			var sm:ISystemManager = Application.application.systemManager;
//			// forward compat with flex 4
//			if (Object(sm).hasOwnProperty('getImplementation')) {
//				return sm['getImplementation'](interfaceName);
//			}
			return implementations[interfaceName];
		}

		private static function registerImplementation(interfaceName:String, impl:Object):void {
//			var sm:ISystemManager = Application.application.systemManager;
//			// forward compat with flex 4
//			if (Object(sm).hasOwnProperty('registerImplementation')) {
//				sm['registerImplementation'](interfaceName, impl);
//			}
//			else {
				if (interfaceName in implementations) {
					throw new ArgumentError(interfaceName + " already registered");
				}
				implementations[interfaceName] = impl;
//			}
		}

        public static function assignDependencies(target:Object):void {
            var desc:XML = describeType(target);
            var deps:XMLList = desc.variable.metadata.(@name == INJECT)
                + desc.accessor.(@access.toString().indexOf('write') > -1).metadata.(@name == INJECT);
            for each(var m:XML in deps) {
                var v:XML = m.parent()[0];
                var varName:String = v.@name;
                var iName:String = m.arg.@value;
				if (!iName || iName.length == 0) {
					iName = v.@type.toString();
				}
				if (iName == null || iName.length == 0) {
					Log.getLogger(getQualifiedClassName(ClassMap).replace('::', '.')).warn("Could not assign dependency to {0}", varName);
					continue;
				}

                var impl:Object = getImpl(iName);
                target[varName] = impl;
            }
        }

        //IMXMLObject
        public function initialized(document:Object, id:String):void {
            this.id = id;
            this.document = document;
        }
    }
}