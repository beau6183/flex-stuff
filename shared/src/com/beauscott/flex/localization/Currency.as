package com.beauscott.flex.localization
{
    import flash.utils.Dictionary;

    [Bindable]
    public class Currency
    {
        private var _symbol:String;
        public function get symbol():String
        {
            return _symbol;
        }

        private var _name:String;
        public function get name():String
        {
            return _name;
        }

        private var _code:String;
        public function get code():String
        {
            return _code;
        }

        public function get htmlCode():String {
            var out:String = "";
            for (var i:uint = 0; i < _symbol.length; i++) {
                out += "&#" + _symbol.charCodeAt(i).toString(8);
            }
            return out;
        }

        private var _fractionalDigits:uint;
        public function get fractionalDigits():uint {
            return _fractionalDigits;
        }

        public function Currency():void
        {
        }

        internal function setup(code:String, name:String, symbol:String, fractionalDigits:uint = 2):Currency {
            if (currenciesByCode[code] == null) {
                _code = code;
                _name = name;
                _symbol = symbol;
                _fractionalDigits = fractionalDigits;
                currenciesByCode[code] = this;
            }
            return currenciesByCode[code];
        }

        internal static function construct(code:String, name:String, symbol:String):Currency {
            if (currenciesByCode[code] == null) {
                return new Currency().setup(code, name, symbol);
            }
            else {
                return currenciesByCode[code];
            }
        }

        private static var currenciesByCode:Dictionary = new Dictionary();

        public static function getCurrencyByISOCode(code:String):Currency {
            return currenciesByCode[code];
        }

        // Currency Symbols
        public static const SYM_AFGHANI:String = String.fromCharCode(0x060B);
        public static const SYM_BAHT:String = String.fromCharCode(0x0E3F);
        public static const SYM_CEDI:String = String.fromCharCode(0x20B5);
        public static const SYM_CENT:String = String.fromCharCode(0x00A2);
        public static const SYM_COLON:String = String.fromCharCode(0x20A1);
        public static const SYM_CRUZEIRO:String = String.fromCharCode(0x20A2);
        public static const SYM_DEFAULT:String = String.fromCharCode(0x00A4);
        public static const SYM_DENAR:String = "ден";
        public static const SYM_DINAR_IRAQI:String = "د.ع";
        public static const SYM_DOLLAR:String = String.fromCharCode(0x0024);
        public static const SYM_DONG:String = String.fromCharCode(0x20AB);
        public static const SYM_DRACHMA:String = String.fromCharCode(0x20AF);
        public static const SYM_DRAM:String = "D"; //String.fromCharCode(0x058F);
        public static const SYM_EURO:String = String.fromCharCode(0x20AC);
        public static const SYM_FLORIN:String = String.fromCharCode(0x0192);
        public static const SYM_FRANC:String = String.fromCharCode(0x20A3);
        public static const SYM_GUARANI:String = String.fromCharCode(0x20B2);
        public static const SYM_HRYVNIA:String = String.fromCharCode(0x20B4);
        public static const SYM_KIP:String = String.fromCharCode(0x20AD);
        public static const SYM_KORUNA:String = "Kč";
        public static const SYM_LARI:String = "ლ";
        public static const SYM_LEV:String = "лв";
        public static const SYM_LIRA:String = String.fromCharCode(0x20A4);
        public static const SYM_M:String = String.fromCharCode(0x2133);
        public static const SYM_MILL:String = String.fromCharCode(0x20A5);
        public static const SYM_NAIRA:String = String.fromCharCode(0x20A6);
        public static const SYM_PESO:String = String.fromCharCode(0x20B1);
        public static const SYM_PESTA:String = String.fromCharCode(0x20A7);
        public static const SYM_POUND:String = String.fromCharCode(0x00A3);
        public static const SYM_RIAL:String = String.fromCharCode(0xFDFC);
        public static const SYM_RIEL:String = String.fromCharCode(0x17DB);
        public static const SYM_RUPEE_BENGALI:String = String.fromCharCode(0x09F3);
        public static const SYM_RUPEE_GUJARATI:String = String.fromCharCode(0x0AF1);
        public static const SYM_RUPEE_INDIA:String = String.fromCharCode(0x20B9);
        public static const SYM_RUPEE_TAMIL:String = String.fromCharCode(0x0BF9);
        public static const SYM_RUPEE:String = String.fromCharCode(0x20A8);
        public static const SYM_SHEQEL:String = String.fromCharCode(0x20AA);
        public static const SYM_TAKA:String = String.fromCharCode(0x2547);
        public static const SYM_TENGE:String = String.fromCharCode(0x20B8);
        public static const SYM_TUGRIK:String = String.fromCharCode(0x20AE);
        public static const SYM_WON:String = String.fromCharCode(0x20A9);
        public static const SYM_YEN_CHAR:String = String.fromCharCode(0x5186);
        public static const SYM_YEN:String = String.fromCharCode(0x00A5);
        public static const SYM_ZLOTY:String = "zł";



        // Currencies by ISO-4487 code
        public static var AED:Currency = Currency.construct("AED", "United Arab Emirates dirham", "Dhs.");
        public static var AFN:Currency = Currency.construct("AFN", "Afghan afghani", SYM_AFGHANI);
        public static var ALL:Currency = Currency.construct("ALL", "Albanian lek", "L");
        public static var AMD:Currency = Currency.construct("AMD", "Armenian dram", SYM_DRAM);
        public static var ANG:Currency = Currency.construct("ANG", "Netherlands Antillean guilder", SYM_FLORIN);
        public static var AOA:Currency = Currency.construct("AOA", "Angolan kwanza", "Kz");
        public static var ARS:Currency = Currency.construct("ARS", "Argentine peso", SYM_PESO);
        public static var AUD:Currency = Currency.construct("AUD", "Australian dollar", SYM_DOLLAR);
        public static var AWG:Currency = Currency.construct("AWG", "Aruban florin", SYM_FLORIN);
        public static var AZN:Currency = Currency.construct("AZN", "Azerbaijani manat", "m");
        public static var BBD:Currency = Currency.construct("BBD", "Barbados dollar", SYM_DOLLAR);
        public static var BDT:Currency = Currency.construct("BDT", "Bangladeshi taka", SYM_TAKA);
        public static var BGN:Currency = Currency.construct("BGN", "Bulgarian lev", SYM_LEV);
        public static var BHD:Currency = Currency.construct("BHD", "Bahraini dinar", "BD");
        public static var BIF:Currency = Currency.construct("BIF", "Burundian franc", "Fbu");
        public static var BMD:Currency = Currency.construct("BMD", "Bermudian dollar", SYM_DOLLAR);
        public static var BND:Currency = Currency.construct("BND", "Brunei dollar", SYM_DOLLAR);
        public static var BOB:Currency = Currency.construct("BOB", "Boliviano", "BS.");
        public static var BRL:Currency = Currency.construct("BRL", "Brazilian real", "R$");
        public static var BSD:Currency = Currency.construct("BSD", "Bahamian dollar", SYM_DOLLAR);
        public static var BTN:Currency = Currency.construct("BTN", "Bhutanese ngultrum", "Nu.");
        public static var BWP:Currency = Currency.construct("BWP", "Botswana pula", "P");
        public static var BYR:Currency = Currency.construct("BYR", "Belarusian ruble", "Br");
        public static var BZD:Currency = Currency.construct("BZD", "Belize dollar", SYM_DOLLAR);
        public static var CAD:Currency = Currency.construct("CAD", "Canadian dollar", SYM_DOLLAR);
        public static var CDF:Currency = Currency.construct("CDF", "Congolese franc", SYM_FRANC);
        public static var CHF:Currency = Currency.construct("CHF", "Swiss franc", SYM_FRANC);
        public static var CLP:Currency = Currency.construct("CLP", "Chilean peso", SYM_DOLLAR);
        public static var CNY:Currency = Currency.construct("CNY", "Chinese yuan", SYM_YEN);
        public static var COP:Currency = Currency.construct("COP", "Colombian peso", SYM_DOLLAR);
        public static var CRC:Currency = Currency.construct("CRC", "Costa Rican colon", SYM_COLON);
        public static var CUP:Currency = Currency.construct("CUP", "Cuban peso", SYM_DOLLAR);
        public static var CVE:Currency = Currency.construct("CVE", "Cape Verde escudo", "Esc");
        public static var CZK:Currency = Currency.construct("CZK", "Czech koruna", SYM_KORUNA);
        public static var DJF:Currency = Currency.construct("DJF", "Djiboutian franc", SYM_FRANC);
        public static var DKK:Currency = Currency.construct("DKK", "Danish krone", "kr");
        public static var DOP:Currency = Currency.construct("DOP", "Dominican peso", SYM_DOLLAR);
        public static var DZD:Currency = Currency.construct("DZD", "Algerian dinar", "BD");
        public static var EGP:Currency = Currency.construct("EGP", "Egyptian pound", "DA");
        public static var ERN:Currency = Currency.construct("ERN", "Eritrean nakfa", "Nfk");
        public static var ETB:Currency = Currency.construct("ETB", "Ethiopian birr", "Br");
        public static var EUR:Currency = Currency.construct("EUR", "Euro", SYM_EURO);
        public static var FJD:Currency = Currency.construct("FJD", "Fiji dollar", SYM_DOLLAR);
        public static var FKP:Currency = Currency.construct("FKP", "Falkland Islands pound", SYM_POUND);
        public static var GBP:Currency = Currency.construct("GBP", "Pound sterling", SYM_POUND);
        public static var GEL:Currency = Currency.construct("GEL", "Georgian lari", SYM_LARI);
        public static var GHS:Currency = Currency.construct("GHS", "Ghanaian cedi", SYM_CEDI);
        public static var GIP:Currency = Currency.construct("GIP", "Gibraltar pound", SYM_POUND);
        public static var GMD:Currency = Currency.construct("GMD", "Gambian dalasi", "D");
        public static var GNF:Currency = Currency.construct("GNF", "Guinean franc", SYM_FRANC);
        public static var GTQ:Currency = Currency.construct("GTQ", "Guatemalan quetzal", "Q");
        public static var GYD:Currency = Currency.construct("GYD", "Guyanese dollar", SYM_DOLLAR);
        public static var HKD:Currency = Currency.construct("HKD", "Hong Kong dollar", SYM_DOLLAR);
        public static var HNL:Currency = Currency.construct("HNL", "Honduran lempira", "L");
        public static var HRK:Currency = Currency.construct("HRK", "Croatian kuna", "kn");
        public static var HTG:Currency = Currency.construct("HTG", "Haitian gourde", "G");
        public static var HUF:Currency = Currency.construct("HUF", "Hungarian forint", "Ft");
        public static var IDR:Currency = Currency.construct("IDR", "Indonesian rupiah", "Rp");
        public static var ILS:Currency = Currency.construct("ILS", "Israeli new sheqel", SYM_SHEQEL);
        public static var INR:Currency = Currency.construct("INR", "Indian rupee", SYM_RUPEE);
        public static var IQD:Currency = Currency.construct("IQD", "Iraqi dinar", SYM_DINAR_IRAQI);
        public static var IRR:Currency = Currency.construct("IRR", "Iranian rial", SYM_RIAL);
        public static var ISK:Currency = Currency.construct("ISK", "Icelandic króna", "kr");
        public static var JMD:Currency = Currency.construct("JMD", "Jamaican dollar", SYM_DOLLAR);
        public static var JOD:Currency = Currency.construct("JOD", "Jordanian dinar", "JD");
        public static var JPY:Currency = Currency.construct("JPY", "Japanese yen", SYM_YEN);
        public static var KES:Currency = Currency.construct("KES", "Kenyan shilling", "Ksh");
        public static var KHR:Currency = Currency.construct("KHR", "Cambodian riel", SYM_RIEL);
        public static var KMF:Currency = Currency.construct("KMF", "Comoro franc", SYM_FRANC);
        public static var KPW:Currency = Currency.construct("KPW", "North Korean won", SYM_WON);
        public static var KRW:Currency = Currency.construct("KRW", "South Korean won", SYM_WON);
        public static var KWD:Currency = Currency.construct("KWD", "Kuwaiti dinar", "K.D.");
        public static var KYD:Currency = Currency.construct("KYD", "Cayman Islands dollar", SYM_DOLLAR);
        public static var KZT:Currency = Currency.construct("KZT", "Kazakhstani tenge", SYM_TENGE);
        public static var LAK:Currency = Currency.construct("LAK", "Lao kip", SYM_KIP);
        public static var LBP:Currency = Currency.construct("LBP", "Lebanese pound", SYM_POUND);
        public static var LKR:Currency = Currency.construct("LKR", "Sri Lanka rupee", SYM_RUPEE);
        public static var LRD:Currency = Currency.construct("LRD", "Liberian dollar", SYM_DOLLAR);
        public static var LSL:Currency = Currency.construct("LSL", "Lesotho loti", "M" );
        public static var LTL:Currency = Currency.construct("LTL", "Lithuanian litas", "Lt");
        public static var LVL:Currency = Currency.construct("LVL", "Latvian lats", "Ls");
        public static var LYD:Currency = Currency.construct("LYD", "Libyan dinar", SYM_DINAR_IRAQI);
        public static var MGA:Currency = Currency.construct("MGA", "Malagasy ariary", "Ar");
        public static var MKD:Currency = Currency.construct("MKD", "Macedonian denar", "DEN");
        public static var MMK:Currency = Currency.construct("MMK", "Myanma kyat", "K");
        public static var MNT:Currency = Currency.construct("MNT", "Mongolian tugrik", SYM_TUGRIK);
        public static var MOP:Currency = Currency.construct("MOP", "Macanese pataca", SYM_DOLLAR);
        public static var MRO:Currency = Currency.construct("MRO", "Mauritanian ouguiya", "UM");
        public static var MUR:Currency = Currency.construct("MUR", "Mauritian rupee", SYM_RUPEE);
        public static var MVR:Currency = Currency.construct("MVR", "Maldivian rufiyaa", "Rf.");
        public static var MWK:Currency = Currency.construct("MWK", "Malawian kwacha", "MK");
        public static var MXN:Currency = Currency.construct("MXN", "Mexican peso", SYM_DOLLAR);
        public static var MYR:Currency = Currency.construct("MYR", "Malaysian ringgit", "RM");
        public static var MZN:Currency = Currency.construct("MZN", "Mozambican metical", "MT");
        public static var NAD:Currency = Currency.construct("NAD", "Namibian dollar", SYM_DOLLAR);
        public static var NGN:Currency = Currency.construct("NGN", "Nigerian naira", SYM_NAIRA);
        public static var NIO:Currency = Currency.construct("NIO", "Nicaraguan córdoba", SYM_DOLLAR);
        public static var NOK:Currency = Currency.construct("NOK", "Norwegian krone", "kr");
        public static var NPR:Currency = Currency.construct("NPR", "Nepalese rupee", SYM_RUPEE);
        public static var NZD:Currency = Currency.construct("NZD", "New Zealand dollar", SYM_DOLLAR);
        public static var OMR:Currency = Currency.construct("OMR", "Omani rial", SYM_RIAL);
        public static var PAB:Currency = Currency.construct("PAB", "Panamanian balboa", "B/.");
        public static var PEN:Currency = Currency.construct("PEN", "Peruvian nuevo sol", "S/.");
        public static var PGK:Currency = Currency.construct("PGK", "Papua New Guinean kina", "K");
        public static var PHP:Currency = Currency.construct("PHP", "Philippine peso", SYM_PESO);
        public static var PKR:Currency = Currency.construct("PKR", "Pakistani rupee", SYM_RUPEE);
        public static var PLN:Currency = Currency.construct("PLN", "Polish złoty", SYM_ZLOTY);
        public static var PYG:Currency = Currency.construct("PYG", "Paraguayan guaraní", SYM_GUARANI);
        public static var QAR:Currency = Currency.construct("QAR", "Qatari rial", SYM_RIAL);
        public static var RON:Currency = Currency.construct("RON", "Romanian new leu", "RON");
        public static var RSD:Currency = Currency.construct("RSD", "Serbian dinar", SYM_DOLLAR);
        public static var RUB:Currency = Currency.construct("RUB", "Russian rouble", "руб.");
        public static var RWF:Currency = Currency.construct("RWF", "Rwandan franc", SYM_FRANC);
        public static var SAR:Currency = Currency.construct("SAR", "Saudi riyal", "SR");
        public static var SBD:Currency = Currency.construct("SBD", "Solomon Islands dollar", SYM_DOLLAR);
        public static var SCR:Currency = Currency.construct("SCR", "Seychelles rupee", SYM_RUPEE);
        public static var SDG:Currency = Currency.construct("SDG", "Sudanese pound", SYM_POUND);
        public static var SEK:Currency = Currency.construct("SEK", "Swedish krona/kronor", "kr");
        public static var SGD:Currency = Currency.construct("SGD", "Singapore dollar", SYM_DOLLAR);
        public static var SHP:Currency = Currency.construct("SHP", "Saint Helena pound", SYM_POUND);
        public static var SLL:Currency = Currency.construct("SLL", "Sierra Leonean leone", "Le");
        public static var SOS:Currency = Currency.construct("SOS", "Somali shilling", "Sh.So.");
        public static var SRD:Currency = Currency.construct("SRD", "Surinamese dollar", SYM_DOLLAR);
        public static var SSP:Currency = Currency.construct("SSP", "South Sudanese pound", SYM_POUND);
        public static var STD:Currency = Currency.construct("STD", "São Tomé and Príncipe dobra", "Db");
        public static var SYP:Currency = Currency.construct("SYP", "Syrian pound", SYM_POUND);
        public static var SZL:Currency = Currency.construct("SZL", "Swazi lilangeni", "E");
        public static var THB:Currency = Currency.construct("THB", "Thai baht", SYM_BAHT);
        public static var TMT:Currency = Currency.construct("TMT", "Turkmenistani manat", "M" );
        public static var TND:Currency = Currency.construct("TND", "Tunisian dinar", "DT");
        public static var TOP:Currency = Currency.construct("TOP", "Tongan paʻanga", SYM_DOLLAR);
        public static var TRY:Currency = Currency.construct("TRY", "Turkish lira", "L");
        public static var TTD:Currency = Currency.construct("TTD", "Trinidad and Tobago dollar", SYM_DOLLAR);
        public static var TWD:Currency = Currency.construct("TWD", "New Taiwan dollar", SYM_DOLLAR);
        public static var TZS:Currency = Currency.construct("TZS", "Tanzanian shilling", "Tsh");
        public static var UAH:Currency = Currency.construct("UAH", "Ukrainian hryvnia", SYM_HRYVNIA);
        public static var UGX:Currency = Currency.construct("UGX", "Ugandan shilling", "Ush");
        public static var USD:Currency = Currency.construct("USD", "United States dollar", SYM_DOLLAR);
        public static var UYU:Currency = Currency.construct("UYU", "Uruguayan peso", SYM_DOLLAR);
        public static var VEF:Currency = Currency.construct("VEF", "Venezuelan bolívar fuerte", "BS.");
        public static var VND:Currency = Currency.construct("VND", "Vietnamese đồng", SYM_DONG);
        public static var VUV:Currency = Currency.construct("VUV", "Vanuatu vatu", "VT");
        public static var YER:Currency = Currency.construct("YER", "Yemeni rial", SYM_RIAL);
        public static var ZAR:Currency = Currency.construct("ZAR", "South African rand", "R");
        public static var ZMK:Currency = Currency.construct("ZMK", "Zambian kwacha", "ZK");
        public static var ZWL:Currency = Currency.construct("ZWL", "Zimbabwe dollar", SYM_DOLLAR);





    }
}