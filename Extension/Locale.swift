import Foundation
import SwiftUI

extension Locale {
    enum SupportedLocale: String {
        // Arabic
        case ar = "ar"
        case ar_AE = "ar-AE" // Arabic (United Arab Emirates)
        case ar_BH = "ar-BH" // Arabic (Bahrain)
        case ar_DZ = "ar-DZ" // Arabic (Algeria)
        case ar_EG = "ar-EG" // Arabic (Egypt)
        case ar_IQ = "ar-IQ" // Arabic (Iraq)
        case ar_JO = "ar-JO" // Arabic (Jordan)
        case ar_KW = "ar-KW" // Arabic (Kuwait)
        case ar_LB = "ar-LB" // Arabic (Lebanon)
        case ar_LY = "ar-LY" // Arabic (Libya)
        case ar_MA = "ar-MA" // Arabic (Morocco)
        case ar_OM = "ar-OM" // Arabic (Oman)
        case ar_QA = "ar-QA" // Arabic (Qatar)
        case ar_SA = "ar-SA" // Arabic (Saudi Arabia)
        case ar_SD = "ar-SD" // Arabic (Sudan)
        case ar_SY = "ar-SY" // Arabic (Syria)
        case ar_TN = "ar-TN" // Arabic (Tunisia)
        case ar_YE = "ar-YE" // Arabic (Yemen)
        
        // English
        case en = "en"
        case en_AU = "en-AU" // English (Australia)
        case en_CA = "en-CA" // English (Canada)
        case en_GB = "en-GB" // English (United Kingdom)
        case en_US = "en-US" // English (United States)
        
        // German
        case de = "de"
        case de_DE = "de-DE" // German (Germany)
        case de_AT = "de-AT" // German (Austria)
        case de_CH = "de-CH" // German (Switzerland)
        
        // Spanish
        case es = "es"
        case es_ES = "es-ES" // Spanish (Spain)
        case es_MX = "es-MX" // Spanish (Mexico)
        
        // French
        case fr = "fr"
        case fr_CA = "fr-CA" // French (Canada)
        case fr_FR = "fr-FR" // French (France)
        
        // Other languages
        case ca_ES = "ca-ES" // Catalan (Spain)
        case cs_CZ = "cs-CZ" // Czech (Czech Republic)
        case da_DK = "da-DK" // Danish (Denmark)
        case el_GR = "el-GR" // Greek (Greece)
        case fi_FI = "fi-FI" // Finnish (Finland)
        case hi_IN = "hi-IN" // Hindi (India)
        case hr_HR = "hr-HR" // Croatian (Croatia)
        case hu_HU = "hu-HU" // Hungarian (Hungary)
        case id_ID = "id-ID" // Indonesian (Indonesia)
        case it_IT = "it-IT" // Italian (Italy)
        case ja_JP = "ja-JP" // Japanese (Japan)
        case ko_KR = "ko-KR" // Korean (South Korea)
        case ms_MY = "ms-MY" // Malay (Malaysia)
        case nb_NO = "nb-NO" // Norwegian Bokmål (Norway)
        case nl_NL = "nl-NL" // Dutch (Netherlands)
        case pl_PL = "pl-PL" // Polish (Poland)
        case pt_BR = "pt-BR" // Portuguese (Brazil)
        case pt_PT = "pt-PT" // Portuguese (Portugal)
        case ro_RO = "ro-RO" // Romanian (Romania)
        case ru_RU = "ru-RU" // Russian (Russia)
        case sk_SK = "sk-SK" // Slovak (Slovakia)
        case sv_SE = "sv-SE" // Swedish (Sweden)
        case th_TH = "th-TH" // Thai (Thailand)
        case tr_TR = "tr-TR" // Turkish (Turkey)
        case uk_UA = "uk-UA" // Ukrainian (Ukraine)
        case vi_VN = "vi-VN" // Vietnamese (Vietnam)
        case zh_CN = "zh-CN" // Chinese (China)
        case zh_HK = "zh-HK" // Chinese (Hong Kong)
        case zh_TW = "zh-TW" // Chinese (Taiwan)
        
       var locale: Locale {
            return Locale(identifier: self.rawValue)
        }
    }
    
    static var bestMatching: Locale {
        if let identifier = Bundle.main.preferredLocalizations.first,
           let supportedLocale = SupportedLocale(rawValue: identifier.lowercased()){
            return Locale(identifier: supportedLocale.rawValue)
        } else {
            return Locale(identifier: SupportedLocale.en_US.rawValue)
        }
    }
    
    static func isRTL(locale: Locale) -> Bool {
        let rtlLocales: [SupportedLocale] = [
            .ar, .ar_AE, .ar_BH, .ar_DZ, .ar_EG, .ar_IQ, .ar_JO, .ar_KW, .ar_LB, .ar_LY,
            .ar_MA, .ar_OM, .ar_QA, .ar_SA, .ar_SD, .ar_SY, .ar_TN, .ar_YE
        ]
        if let supportedLocale = SupportedLocale(rawValue: locale.identifier) {
            return rtlLocales.contains(supportedLocale)
        }
        return false
    }
    
    var layoutDirection: LayoutDirection {
        return Locale.isRTL(locale: self) ? .rightToLeft : .leftToRight
    }
    
    func isMatch(_ supportedLocale: SupportedLocale) -> Bool {
        return Locale.current.identifier.contains(supportedLocale.rawValue)
    }
    
    
}
