//
//  Constants .swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import Foundation


struct Constants {
//    static let APP_ID = "63d2a114"
//    static let AUTH_KEY =  "23ad28ea302b7d5e22cdf116992eeed5"
//    static let API_KEY = "8fe2a412-13fb-444c-a9bc-7b306b9ccdfb"
    static let API_KEY = Bundle.main.infoDictionary?["WORD_API_KEY"] as? String
    
//    static let Tokens = ["{b}", "{bc}", "{inf}", "{it}", "{ldquo}", "{p_br}", "{rdquo}", "{sc}", "{sup}", "{gloss}, {parahw}", "{qword}","{wi}","{dx}","{dx_def}","{dx_ety}","{ma}","{a_link}","{d_link}","{dxt}","{et_link}","{i_link}","{mat}", ""]
    
    
    
}
