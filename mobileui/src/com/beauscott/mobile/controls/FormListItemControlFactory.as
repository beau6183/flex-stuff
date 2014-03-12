package com.beauscott.mobile.controls
{
    import mx.collections.ArrayCollection;
    import mx.utils.ObjectUtil;
    import mx.validators.EmailValidator;
    import mx.validators.Validator;
    
    import spark.components.TextArea;
    import spark.components.TextInput;
    import spark.components.ToggleSwitch;
    import spark.components.supportClasses.SkinnableTextBase;
    import spark.core.IEditableText;
    import spark.core.ISoftKeyboardHintClient;

    internal class FormListItemControlFactory
    {
        public static var TEXT:Class = TextInput;//StyleableTextField;
        public static var TEXT_AREA:Class = TextArea;
        public static var DATE:Class = DateInput;//StyleableTextField;
        public static var TIME:Class = DateInput;//StyleableTextField;
        public static var DATE_AND_TIME:Class = DateInput;
        public static var CHECKBOX:Class = ToggleSwitch;
        public static var SELECT:Class = OptionInput;//StyleableTextField;
        public static var PASSWORD:Class = TextInput;//StyleableTextField;
        public static var EMAIL:Class = TextInput;//StyleableTextField;
        public static var CURRENCY:Class = CurrencyInput;
        public static var NUMBER:Class = TextInput;//StyleableTextField;
        public static var PHONE:Class = PhoneInput;//StyleableTextField;
        
        public static function getControlInstanceForRenderer(renderer:FormListItemRenderer):Object {
            if (!renderer.formItem) return null;
            var formItem:FormListItem = renderer.formItem;
            var ctrl:Object;
            if (formItem.type != FormListItemType.CUSTOM && formItem.type != FormListItemType.LINK && formItem.control == null) {
                var c:Class = renderer.getStyle(formItem.type + "Renderer") as Class;
                if (!c) {
                    // Decamelize
                    var t:String = formItem.type;
                    t = t.replace(/([A-Z]+)/g, "_$&").toUpperCase();
                    if (t in FormListItemControlFactory)
                        c = FormListItemControlFactory[t];
                }
                if (!c) {
                    return null;
                }
                ctrl = renderer.$createInFontContext(c);
                
                if (ctrl) {
                    
                    if (ctrl is IAccessorizableInput && formItem.inputAccessory) {
                        IAccessorizableInput(ctrl).inputAccessory = formItem.inputAccessory;
                    }
                    
                    if ('id' in ctrl) {
                        ctrl.id = "control";
                    }
                    
                }
            }
            else {
                ctrl = formItem.control;
            }
            
            return ctrl;
        }
        
        public static function setEditable(renderer:FormListItemRenderer, control:Object):void {
            if (control && renderer.formItem) {
                var formItem:FormListItem = renderer.formItem;
                var editable:Boolean = (!(control is IAccessorizableInput) || !(IAccessorizableInput(control).inputAccessory || formItem.inputAccessory)) && renderer.editable;
                
                if ("enabled" in control)
                    control.enabled = formItem.enabled;
                
                if ("editable" in control) {
                    control.editable = editable;
                }
            }
        }
        
        public static function setProperties(renderer:FormListItemRenderer, ctrl:Object):void {
            if (ctrl && renderer.formItem) {
                var formItem:FormListItem = renderer.formItem;
                
                if (ctrl is TextArea) {
                    TextArea(ctrl).heightInLines = renderer.formItem.textAreaHeightInLines;
                }
                
                if (ctrl is IEditableText || ctrl is SkinnableTextBase) {
                    var iet:Object = ctrl;
                    
                    if (formItem.type == FormListItemType.PASSWORD) {
                        iet.displayAsPassword = true;
                    }
                    if (formItem.type == FormListItemType.NUMBER) {
                        iet.restrict = "0-9\-\.";
                    }
                    if (formItem.type == FormListItemType.EMAIL) {
                        iet.restrict = "a-zA-Z0-9@\\-_.";
                    }
                }
                
                if (ctrl is IAccessorizableInput && formItem.inputAccessory) {
                    IAccessorizableInput(ctrl).inputAccessory = formItem.inputAccessory;
                }
                
                if (ctrl is CurrencyInput) {
                    CurrencyInput(ctrl).currencyCode = formItem.currencyCode;
                }
                
                if (ctrl is DateInput) {
                    DateInput(ctrl).displayMode = formItem.type;
                }
                
                if (ctrl is OptionInput) {
                    setOptions(renderer, ctrl as OptionInput);
                }
                
                if (ctrl is ISoftKeyboardHintClient) {
                    var isk:ISoftKeyboardHintClient = ISoftKeyboardHintClient(ctrl);
                    isk.autoCapitalize = formItem.autoCapitalize;
                    isk.autoCorrect = formItem.autoCorrect;
                    isk.returnKeyLabel = formItem.returnKeyLabel;
                    isk.softKeyboardType = formItem.softKeyboardType;
                }
                
                if (ctrl is IEditableText) {
                    var txtControl:IEditableText = IEditableText(ctrl);
                    txtControl.selectable = true;
                    txtControl.multiline = false;
                    txtControl.focusEnabled = true;
                }
                else if (ctrl is SkinnableTextBase) {
                    var stbControl:SkinnableTextBase = SkinnableTextBase(ctrl);
                    stbControl.selectable = true;
                }
                
                if (formItem.additionalProperties) {
                    if (formItem.additionalProperties is String) {
                        var props:Array = String(formItem.additionalProperties).split(";");
                        for each(var prop:String in props) {
                            var px:Array = prop.split(":", 2);
                            if (px[0] in ctrl) {
                                ctrl[px[0]] = px[1];
                            }
                        }
                    }
                    else {
                        for each(var p:QName in ObjectUtil.getClassInfo(formItem.additionalProperties).properties) {
                            if (p.localName in ctrl) {
                                ctrl[p.localName] = formItem.additionalProperties[p.localName];
                            }
                        }
                    }
                }
                
                setEditable(renderer, ctrl);
            }
        }
        
        public static function setOptions(renderer:FormListItemRenderer, control:OptionInput):void {
            if (control && renderer.formItem) {
                var formItem:FormListItem = renderer.formItem;
                var dp:Array;
                if (formItem.options) {
                    dp = [];
                    for each(var opt:FormListItemSelectOption in formItem.options) {
                        dp.push(opt);
                    }
                    control.options = dp;
                }
            }
        }
        
        public static function validatorForRenderer(renderer:FormListItemRenderer):Validator {
            if (!renderer.formItem) return null;
            var formItem:FormListItem = renderer.formItem;
            if (formItem.validator) return formItem.validator;
                
            var v:Validator;
            if (formItem.type == FormListItemType.EMAIL) {
                v = new EmailValidator();
            }
            //TODO more default validators
            
            return v;
        }
    }
}