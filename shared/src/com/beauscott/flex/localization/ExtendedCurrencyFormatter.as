package com.beauscott.flex.localization
{
    import spark.formatters.CurrencyFormatter;

    public class ExtendedCurrencyFormatter extends CurrencyFormatter
    {

        [Bindable("change")]
        override public function set currencyISOCode(value:String):void {
            if (value != super.currencyISOCode) {
                if (value != null) {
                    var c:Currency = Currency.getCurrencyByISOCode(value);
                    if (c != null) {
                        currencySymbol = c.symbol;
                    }
                }
                super.currencyISOCode = value;
            }
        }

        public function ExtendedCurrencyFormatter()
        {
            super();
        }
    }
}