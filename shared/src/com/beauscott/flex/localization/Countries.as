package com.beauscott.flex.localization
{
    import flash.utils.describeType;
    
    import mx.utils.ObjectUtil;

    public class Countries
    {
        public static const AD:String = "ANDORRA";
        public static const AE:String = "UNITED ARAB EMIRATES";
        public static const AF:String = "AFGHANISTAN";
        public static const AG:String = "ANTIGUA AND BARBUDA";
        public static const AI:String = "ANGUILLA";
        public static const AL:String = "ALBANIA";
        public static const AM:String = "ARMENIA";
        public static const AN:String = "NETHERLANDS ANTILLES";
        public static const AO:String = "ANGOLA";
        public static const AR:String = "ARGENTINA";
        public static const AS:String = "AMERICAN SAMOA";
        public static const AT:String = "AUSTRIA";
        public static const AU:String = "AUSTRALIA";
        public static const AW:String = "ARUBA";
        public static const AZ:String = "AZERBAIJAN";
        public static const BA:String = "BOSNIA AND HERZEGOVINA";
        public static const BB:String = "BARBADOS";
        public static const BD:String = "BANGLADESH";
        public static const BE:String = "BELGIUM";
        public static const BF:String = "BURKINA FASO";
        public static const BG:String = "BULGARIA";
        public static const BH:String = "BAHRAIN";
        public static const BI:String = "BURUNDI";
        public static const BJ:String = "BENIN";
        public static const BM:String = "BERMUDA";
        public static const BN:String = "BRUNEI DARUSSALAM";
        public static const BO:String = "BOLIVIA, PLURINATIONAL STATE OF";
        public static const BR:String = "BRAZIL";
        public static const BS:String = "BAHAMAS";
        public static const BT:String = "BHUTAN";
        public static const BW:String = "BOTSWANA";
        public static const BY:String = "BELARUS";
        public static const BZ:String = "BELIZE";
        public static const CA:String = "CANADA";
        public static const CD:String = "CONGO, THE DEMOCRATIC REPUBLIC OF THE";
        public static const CF:String = "CENTRAL AFRICAN REPUBLIC";
        public static const CG:String = "CONGO";
        public static const CH:String = "SWITZERLAND";
        public static const CI:String = "C?TE D'IVOIRE";
        public static const CK:String = "COOK ISLANDS";
        public static const CL:String = "CHILE";
        public static const CM:String = "CAMEROON";
        public static const CN:String = "CHINA";
        public static const CO:String = "COLOMBIA";
        public static const CR:String = "COSTA RICA";
        public static const CU:String = "CUBA";
        public static const CV:String = "CAPE VERDE";
        public static const CY:String = "CYPRUS";
        public static const CZ:String = "CZECH REPUBLIC";
        public static const DE:String = "GERMANY";
        public static const DJ:String = "DJIBOUTI";
        public static const DK:String = "DENMARK";
        public static const DM:String = "DOMINICA";
        public static const DO:String = "DOMINICAN REPUBLIC";
        public static const DZ:String = "ALGERIA";
        public static const EC:String = "ECUADOR";
        public static const EE:String = "ESTONIA";
        public static const EG:String = "EGYPT";
        public static const ER:String = "ERITREA";
        public static const ES:String = "SPAIN";
        public static const ET:String = "ETHIOPIA";
        public static const FI:String = "FINLAND";
        public static const FJ:String = "FIJI";
        public static const FK:String = "FALKLAND ISLANDS (MALVINAS)";
        public static const FM:String = "MICRONESIA, FEDERATED STATES OF";
        public static const FO:String = "FAROE ISLANDS";
        public static const FR:String = "FRANCE";
        public static const GA:String = "GABON";
        public static const GB:String = "UNITED KINGDOM";
        public static const GD:String = "GRENADA";
        public static const GE:String = "GEORGIA";
        public static const GF:String = "FRENCH GUIANA";
        public static const GH:String = "GHANA";
        public static const GI:String = "GIBRALTAR";
        public static const GL:String = "GREENLAND";
        public static const GM:String = "GAMBIA";
        public static const GN:String = "GUINEA";
        public static const GP:String = "GUADELOUPE";
        public static const GQ:String = "EQUATORIAL GUINEA";
        public static const GR:String = "GREECE";
        public static const GT:String = "GUATEMALA";
        public static const GU:String = "GUAM";
        public static const GW:String = "GUINEA-BISSAU";
        public static const GY:String = "GUYANA";
        public static const HK:String = "HONG KONG";
        public static const HN:String = "HONDURAS";
        public static const HR:String = "CROATIA";
        public static const HT:String = "HAITI";
        public static const HU:String = "HUNGARY";
        public static const ID:String = "INDONESIA";
        public static const IE:String = "IRELAND";
        public static const IL:String = "ISRAEL";
        public static const IN:String = "INDIA";
        public static const IQ:String = "IRAQ";
        public static const IR:String = "IRAN, ISLAMIC REPUBLIC OF";
        public static const IS:String = "ICELAND";
        public static const IT:String = "ITALY";
        public static const JM:String = "JAMAICA";
        public static const JO:String = "JORDAN";
        public static const JP:String = "JAPAN";
        public static const KE:String = "KENYA";
        public static const KG:String = "KYRGYZSTAN";
        public static const KH:String = "CAMBODIA";
        public static const KI:String = "KIRIBATI";
        public static const KM:String = "COMOROS";
        public static const KN:String = "SAINT KITTS AND NEVIS";
        public static const KP:String = "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF";
        public static const KR:String = "KOREA, REPUBLIC OF";
        public static const KW:String = "KUWAIT";
        public static const KY:String = "CAYMAN ISLANDS";
        public static const KZ:String = "KAZAKHSTAN";
        public static const LA:String = "LAO PEOPLE'S DEMOCRATIC REPUBLIC";
        public static const LB:String = "LEBANON";
        public static const LC:String = "SAINT LUCIA";
        public static const LI:String = "LIECHTENSTEIN";
        public static const LK:String = "SRI LANKA";
        public static const LR:String = "LIBERIA";
        public static const LS:String = "LESOTHO";
        public static const LT:String = "LITHUANIA";
        public static const LU:String = "LUXEMBOURG";
        public static const LV:String = "LATVIA";
        public static const LY:String = "LIBYAN ARAB JAMAHIRIYA";
        public static const MA:String = "MOROCCO";
        public static const MC:String = "MONACO";
        public static const MD:String = "MOLDOVA, REPUBLIC OF";
        public static const ME:String = "MONTENEGRO";
        public static const MG:String = "MADAGASCAR";
        public static const MH:String = "MARSHALL ISLANDS";
        public static const MK:String = "MACEDONIA";
        public static const ML:String = "MALI";
        public static const MM:String = "MYANMAR";
        public static const MN:String = "MONGOLIA";
        public static const MO:String = "MACAO";
        public static const MP:String = "NORTHERN MARIANA ISLANDS";
        public static const MQ:String = "MARTINIQUE";
        public static const MR:String = "MAURITANIA";
        public static const MS:String = "MONTSERRAT";
        public static const MT:String = "MALTA";
        public static const MU:String = "MAURITIUS";
        public static const MV:String = "MALDIVES";
        public static const MW:String = "MALAWI";
        public static const MX:String = "MEXICO";
        public static const MY:String = "MALAYSIA";
        public static const MZ:String = "MOZAMBIQUE";
        public static const NA:String = "NAMIBIA";
        public static const NC:String = "NEW CALEDONIA";
        public static const NE:String = "NIGER";
        public static const NG:String = "NIGERIA";
        public static const NI:String = "NICARAGUA";
        public static const NL:String = "NETHERLANDS";
        public static const NO:String = "NORWAY";
        public static const NP:String = "NEPAL";
        public static const NR:String = "NAURU";
        public static const NU:String = "NIUE";
        public static const NZ:String = "NEW ZEALAND";
        public static const OM:String = "OMAN";
        public static const PA:String = "PANAMA";
        public static const PE:String = "PERU";
        public static const PF:String = "FRENCH POLYNESIA";
        public static const PG:String = "PAPUA NEW GUINEA";
        public static const PH:String = "PHILIPPINES";
        public static const PK:String = "PAKISTAN";
        public static const PL:String = "POLAND";
        public static const PM:String = "SAINT PIERRE AND MIQUELON";
        public static const PR:String = "PUERTO RICO";
        public static const PT:String = "PORTUGAL";
        public static const PW:String = "PALAU";
        public static const PY:String = "PARAGUAY";
        public static const QA:String = "QATAR";
        public static const RO:String = "ROMANIA";
        public static const RS:String = "SERBIA";
        public static const RU:String = "RUSSIAN FEDERATION";
        public static const RW:String = "RWANDA";
        public static const SA:String = "SAUDI ARABIA";
        public static const SB:String = "SOLOMON ISLANDS";
        public static const SC:String = "SEYCHELLES";
        public static const SD:String = "SUDAN";
        public static const SE:String = "SWEDEN";
        public static const SG:String = "SINGAPORE";
        public static const SH:String = "SAINT HELENA";
        public static const SI:String = "SLOVENIA";
        public static const SK:String = "SLOVAKIA";
        public static const SL:String = "SIERRA LEONE";
        public static const SM:String = "SAN MARINO";
        public static const SN:String = "SENEGAL";
        public static const SO:String = "SOMALIA";
        public static const SR:String = "SURINAME";
        public static const ST:String = "SAO TOME AND PRINCIPE";
        public static const SV:String = "EL SALVADOR";
        public static const SY:String = "SYRIAN ARAB REPUBLIC";
        public static const SZ:String = "SWAZILAND";
        public static const TC:String = "TURKS AND CAICOS ISLANDS";
        public static const TD:String = "CHAD";
        public static const TG:String = "TOGO";
        public static const TH:String = "THAILAND";
        public static const TJ:String = "TAJIKISTAN";
        public static const TK:String = "TOKELAU";
        public static const TL:String = "TIMOR-LESTE";
        public static const TM:String = "TURKMENISTAN";
        public static const TN:String = "TUNISIA";
        public static const TO:String = "TONGA";
        public static const TR:String = "TURKEY";
        public static const TT:String = "TRINIDAD AND TOBAGO";
        public static const TV:String = "TUVALU";
        public static const TW:String = "TAIWAN, PROVINCE OF CHINA";
        public static const TZ:String = "TANZANIA, UNITED REPUBLIC OF";
        public static const UA:String = "UKRAINE";
        public static const UG:String = "UGANDA";
        public static const UM:String = "UNITED STATES MINOR OUTLYING ISLANDS";
        public static const US:String = "UNITED STATES";
        public static const UY:String = "URUGUAY";
        public static const UZ:String = "UZBEKISTAN";
        public static const VC:String = "SAINT VINCENT AND THE GRENADINES";
        public static const VE:String = "VENEZUELA, BOLIVARIAN REPUBLIC OF";
        public static const VG:String = "VIRGIN ISLANDS, BRITISH";
        public static const VI:String = "VIRGIN ISLANDS, U.S.";
        public static const VN:String = "VIET NAM";
        public static const VU:String = "VANUATU";
        public static const WF:String = "WALLIS AND FUTUNA";
        public static const WS:String = "SAMOA";
        public static const YE:String = "YEMEN";
        public static const YT:String = "MAYOTTE";
        public static const ZA:String = "SOUTH AFRICA";
        public static const ZM:String = "ZAMBIA";
        public static const ZW:String = "ZIMBABWE";
        
        [ArrayElementType("com.beauscott.flex.localization.Country")]
        private static var _allCountries:Array;
        [ArrayElementType("com.beauscott.flex.localization.Country")]
        public static function get allCountries():Array {
            if (!_allCountries) {
                _allCountries = [];
                var desc:XMLList = describeType(Countries)..constant;
                for each(var entry:XML in desc) {
                    var c:Country = new Country(entry.@name, Countries[entry.@name.toString()]);
                    _allCountries.push(c);
                }
                _allCountries.sort(function(a:Country, b:Country):int {
                    return ObjectUtil.stringCompare(a.name, b.name, true);
                });
            }
            return _allCountries;
        }
    }
}