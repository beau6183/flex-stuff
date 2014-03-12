package com.beauscott.flex.util
{
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import mx.collections.ArrayCollection;
    import mx.collections.ListCollectionView;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;


    /**
     * Data conversion and comparison utilities
     */
    public class DataUtils
    {

        /**
         * This method determines if two data objects contain the same
         * information.  This is used to determine equivalency since there
         * is not operator overloading in actionscript.  It utilizes
         * introspection to examine all fields and their equivalency.
         *
         * @param sourceObj    The first object to compare
         * @param pickObj      The second object to compare
         * @return true if equal, false if not.
         */
        public static function dataObjectsEqual(sourceObj:Object, pickObj:Object):Boolean
        {
            return ObjectUtil.compare(sourceObj, pickObj) == 0;
        }

        /**
         * Copies data from one ArrayCollection to another, by reference.
         * @param source The source object
         * @param dest The object to be filled in
         * @return Filled copy
         */
        public static function copyArrayCollection(source:ListCollectionView, dest:ListCollectionView = null):ListCollectionView
        {
            if (source == null)
                return null;

            if (source != dest)
            {
                if (dest == null)
                {
                    // TODO Make this an equal type to source if not specified
                    dest = new ArrayCollection();
                }
                else
                {
                    dest.removeAll();
                }
                dest.addAll(source);
            }
            return dest;
        }

        /**
         * This method allows for getting a copy of an array collection that
         * creates new objects for every element in the collection, rather than
         * reusing the object contained in the collection.  Useful for data
         * providers and such.
         *
         * @param source    The source for the copy
         * @param dest      The array collection to copy the clone into
         * @return Filled clone
         */
        public static function cloneArrayCollection(source:ListCollectionView, dest:ListCollectionView = null):ListCollectionView
        {
            if (source == null)
                return null;

            if (source != dest)
            {
                var copy:ListCollectionView = ListCollectionView(ObjectUtil.copy(source));
                if (dest != null)
                {
                    dest.removeAll();
                    dest.addAll(copy)
                }
                else
                {
                    dest = copy;
                }
            }
            return dest;
        }

        /**
         * Creates a new instance of the object given as source. No values are copied.
         * @param source Object of which's type will be created as the new instance.
         *               If a class is passed in, a new instance of the class will be created.
         * @return a new instance of the same type as the source object
         */
        public static function getNewObjectInstance(source:Object):*
        {
            if (source == null)
                return null;
            if (source is Class)
            {
                return new(source as Class);
            }
            else
            {
                return new(getDefinitionByName(getQualifiedClassName(source))as Class);
            }
        }

        /**
         * Creates and returns a clone of the passesd-in object.
         *
         * @param source The Object to clone
         * @return the new cloned object
         */
        public static function getCloneOfObject(source:Object):Object
        {
            if (source == null)
                return null;
            return ObjectUtil.copy(source);
        }

        /**
         * Copies the contents of one object to anther object of the same type. Useful when reusing object instances.
         * @param sourceObj
         * @param destObj
         * @return true if the copy operation was successful, false otherwise
         */
        public static function copyObject(sourceObj:Object, destObj:Object):void
        {
            var copy:Object = getCloneOfObject(sourceObj);
            internalCopy(copy, destObj, sourceObj);
        }

        private static function internalCopy(sourceObj:Object, destObj:Object, original:Object):void
        {
            var srcObjDesc:Object = ObjectUtil.getClassInfo(sourceObj, null, {includeReadOnly: false});
            var destObjDesc:Object = ObjectUtil.getClassInfo(destObj);

            // if different class types, they are not equal
            if ((destObjDesc["name"] != "null") && (srcObjDesc["name"] != destObjDesc["name"]))
                return;

            for each(var attrDesc:Object in srcObjDesc["properties"])
            {
                var fieldName:String;
                if (attrDesc is QName)
                    fieldName = attrDesc.localName;
                else
                    fieldName = String(attrDesc);

                // If it is a simple type, we can do a straight compare
                if (destObj[fieldName] == null || ObjectUtil.isSimple(sourceObj[fieldName]))
                {
                    destObj[fieldName] = sourceObj[fieldName];
                }
                else if (sourceObj[fieldName] == null)
                {
                    destObj[fieldName] = null;
                }
                else
                {
                    // if it is another object, recurse and introspect there
                    var property:String;

                    // When dealing with dynamic objects (Object or Dictionary), we want to be sure that
                    // the destination's object doesn't keep old values, so lets clear them out
                    if (sourceObj[fieldName] is Dictionary || getQualifiedClassName(sourceObj[fieldName]) == "Object")
                    {
                        for(property in destObj[fieldName])
                        {
                            if (!sourceObj[fieldName].hasOwnProperty(property))
                            {
                                delete destObj[fieldName][property];
                            }
                        }
                        internalCopy(destObj[fieldName], sourceObj[fieldName], original[fieldName]);
                    }

                    //
                    // Handle array collections differently since
                    // they have functions and we want all the elements as
                    // is in the collection
                    //
                    else if (sourceObj[fieldName]is ListCollectionView)
                    {
                        // Using copy as we've already made a copy, no need to duplicate work
                        copyArrayCollection(sourceObj[fieldName], destObj[fieldName]);
                    }
                    else if (!(sourceObj is Function))
                    {
                        internalCopy(sourceObj[fieldName], destObj[fieldName], original[fieldName]);
                    }
                }
            }
        }

        /**
         * Returns an array filled with the Class's public properties for
         * easy enumeration access.
         *
         * @param object the Object whose properties we are trying to copy
         * @return an Array of properties extracted from the passed-in object
         */
        public static function getObjectEnumeration(object:Object):Array
        {
            var enum:Array = new Array();
            var classInfo:Object = ObjectUtil.getClassInfo(object);
            for each(var qn:QName in classInfo.properties)
            {
                enum.push(object[qn.localName]);
            }
            return enum;
        }

        /**
         * Returns an array filled with the names of the objects member variables
         *
         * @param object the Object whose property names we are trying to copy
         * @return an Array of property names extracted from the passed-in object
         */
        public static function getMemberVariableNames(object:Object, writeableOnly:Boolean = false):Array
        {
            var enum:Array = new Array();

            var desc:XML = describeType(object);
            var accessors:XMLList = desc..variable.@name;
            if (writeableOnly)
            {
                accessors += desc..accessor.(@access == 'readwrite').@name;
            }
            else
            {
                accessors += desc..accessor.@name;
            }

            for each(var accessor:String in accessors)
            {
                enum.push(accessor);
            }

            return enum;
        }

        /**
         * Checks whether the passed-in value is "logically" empty.  null
         * values are always empty.  Empty strings are empty.
         *
         * @param val the value to check
         * @return true if the value is empty, false otherwise
         */
        public static function isEmpty(val:*):Boolean
        {
            if (val == null)
                return true;
            if (ObjectUtil.isSimple(val))
            {
                if (val is String)
                {
                    return mx.utils.StringUtil.trim(val).length == 0;
                }
                else if (val is Boolean)
                {
                    return false;
                }
                else
                {
                    return isNaN(val)
                }
            }
            return false;
        }

        public static function mergeObjects(source:Object, dest:Object):Object
        {
            if (source == null)
                return null;
            var vars:Array = getMemberVariableNames(dest, true);
            for each(var v:String in vars)
            {
                if (source.hasOwnProperty(v))
                {
                    dest[v] = source[v];
                }
            }
            return dest;
        }

    }
}
