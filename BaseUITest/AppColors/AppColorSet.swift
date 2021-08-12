//
//  AppColorSet.swift
//  ssg
//
//  Created by youngji Yoon on 2021/05/25.
//  Copyright © 2021 emart. All rights reserved.
//

import UIKit

/* 2021. 05. 25. youngji
 🧐 반드시 담당자에게 문의 후 추가 요망 🧐
 😈 문의 없이 개인적인 추가는 불가합니다!!!!!!!!!!!!!!!!👿
 디자인팀에서 정의한 컬러셋
 참고 링크 : https://docs.google.com/spreadsheets/d/1jJunk-C-_NrLgGj89A8jA1EGstbZl-4tjTGTaiFBvNY/edit?usp=sharing
 *********담당자********
 iOS/ AND: Core파트
 UX/디자인팀 - 문경희P

 2021. 07. 06. youngji // 요청자 : 문경희 P - gray 350(0xcfcfcf) 추가
 2021. 07. 20. youngji // 요청자 : 문경희 P - 명칭변경 (ssg_primary -> primary), 컬러 변경 (FF5B59 -> FF3E3E)
                                        - 명칭변경 (ssg_secondary1 -> secondary1)
*/

extension UIColor {
    // ssg(공통)
      static let primary = UIColor(named: "primary") ?? UIColor(hex: 0xFF3E3E) // #FF3E3E
      static let secondary1 = UIColor(named: "secondary1") ?? UIColor(hex: 0x6841FF)  // #6841FF
      static let gray150 = UIColor(named: "gray150") ?? UIColor(hex: 0xF5F5F5)  // #F5F5F5
      static let gray100 = UIColor(named: "gray100") ?? UIColor(hex: 0xFAFAFA)  // #FAFAFA
      static let gray200 = UIColor(named: "gray200") ?? UIColor(hex: 0xF0F0F0)  // #F0F0F0
      static let gray300 = UIColor(named: "gray300") ?? UIColor(hex: 0xE5E5E5)  // #E5E5E5
      static let gray350 = UIColor(named: "gray350") ?? UIColor(hex: 0xCFCFCF)  // #CFCFCF
      static let gray400 = UIColor(named: "gray400") ?? UIColor(hex: 0x969696)  // #969696
      static let gray500 = UIColor(named: "gray500") ?? UIColor(hex: 0x888888)  // #888888
      static let gray600 = UIColor(named: "gray600") ?? UIColor(hex: 0x777777)  // #777777
      static let gray700 = UIColor(named: "gray700") ?? UIColor(hex: 0x666666)  // #666666
      static let gray800 = UIColor(named: "gray800") ?? UIColor(hex: 0x444444)  // #444444
      static let gray900 = UIColor(named: "gray900") ?? UIColor(hex: 0x222222)  // #222222
      static let benefit = UIColor(named: "benefit") ?? UIColor(hex: 0x5D30FF)  // #5D30FF
      static let decrease = UIColor(named: "decrease") ?? UIColor(hex: 0x22009C)  // #22009C
      static let increase = UIColor(named: "increase") ?? UIColor(hex: 0xFF3E3E)  // #FF3E3E
      static let review = UIColor(named: "review") ?? UIColor(hex: 0x014989)  // #014989
      static let black_alpha_3 = UIColor(named: "black_alpha_3") ?? UIColor(hex: 0x000000, alpha: 0.03) // #000000/ alpha - 3%
      static let black_alpha_20 = UIColor(named: "black_alpha_20") ?? UIColor(hex: 0x000000, alpha: 0.2) // #000000/ alpha - 20%
      static let black_alpha_45 = UIColor(named: "black_alpha_45") ?? UIColor(hex: 0x000000, alpha: 0.45) // #000000/ alpha - 45%
      static let black_alpha_60 = UIColor(named: "black_alpha_60") ?? UIColor(hex: 0x000000, alpha: 0.60) // #000000/ alpha - 60%
      static let black_alpha_80 = UIColor(named: "black_alpha_80") ?? UIColor(hex: 0x000000, alpha: 0.80) // #000000/ alpha - 80%
      static let black_alpha_95 = UIColor(named: "black_alpha_95") ?? UIColor(hex: 0x000000, alpha: 0.95) // #000000/ alpha - 95%
      static let white_alpha_80 = UIColor(named: "white_alpha_80") ?? UIColor(hex: 0xffffff, alpha: 0.80) // #ffffff/ alpha - 80%
      static let white_alpha_95 = UIColor(named: "white_alpha_95") ?? UIColor(hex: 0xffffff, alpha: 0.95) // #ffffff/ alpha - 95%

    // 이마트몰
      static let emartmall_primary = UIColor(named: "emartmall_primary") ?? UIColor(hex: 0xFFD040) // #FFD040
      static let emartmall_secondary1 = UIColor(named: "emartmall_secondary1") ?? UIColor(hex: 0xFF6A26) // #FF6A26
      static let emartmall_secondary2 = UIColor(named: "emartmall_secondary2") ?? UIColor(hex: 0x383F45) // #383F45

    // 신세계몰
      static let shinsegaemall_primary = UIColor(named: "shinsegaemall_primary") ?? UIColor(hex: 0xF12E24) // #F12E24

    // 트레이더스
      static let traders_primary = UIColor(named: "traders_primary") ?? UIColor(hex: 0xA6DD27) // #A6DD27
      static let traders_secondary1 = UIColor(named: "traders_secondary1") ?? UIColor(hex: 0x02BD56) // #02BD56

    // 신세계 백화점
      static let department_primary = UIColor(named: "department_primary") ?? UIColor(hex: 0x6A6B6D) // #6A6B6D
      static let department_secondary2 = UIColor(named: "department_secondary2") ?? UIColor(hex: 0x7E8083) // #7E8083
      static let department_secondary3 = UIColor(named: "department_secondary3") ?? UIColor(hex: 0xa59357) // #a59357

    // 새벽배송
      static let earlymorning_primary = UIColor(named: "earlymorning_primary") ?? UIColor(hex: 0xA3B7CD) // #A3B7CD
      static let earlymorning_secondary1 = UIColor(named: "earlymorning_secondary1") ?? UIColor(hex: 0x8097AF) // #8097AF
      static let earlymorning_secondary2 = UIColor(named: "earlymorning_secondary2") ?? UIColor(hex: 0x3FE37E) // #3FE37E
      static let earlymorning_secondary3 = UIColor(named: "earlymorning_secondary3") ?? UIColor(hex: 0xF8E71C) // #F8E71C

    // 까사미아
      static let casamia_primary = UIColor(named: "casamia_primary") ?? UIColor(hex: 0xFFCF02) // #FFCF02
      static let casamia_secondary1 = UIColor(named: "casamia_secondary1") ?? UIColor(hex: 0x3E3935) // #3E3935

    // 스타벅스
      static let starbucks_primary = UIColor(named: "starbucks_primary") ?? UIColor(hex: 0x006241) // #006241
      static let starbucks_secondary1 = UIColor(named: "starbucks_secondary1") ?? UIColor(hex: 0x1e3932) // #1e3932

    // 씨코르
      static let chicor_secondary1 = UIColor(named: "chicor_secondary1") ?? UIColor(hex: 0x000000) // #000000
    // 신세계TV쇼핑
      static let tvshopping_primary = UIColor(named: "tvshopping_primary") ?? UIColor(hex: 0xE2231A) // #E2231A
    // 하우디
      static let howdy_primary = UIColor(named: "howdy_primary") ?? UIColor(hex: 0x000000) // #000000
    // 트립
      static let triip_primary = UIColor(named: "triip_primary") ?? UIColor(hex: 0x328CA8) // #328CA8
    // SI빌리지
      static let sivillage_primary = UIColor(named: "sivillage_primary") ?? UIColor(hex: 0x222222) // #222222
    // 스타필드
      static let starfield_primary = UIColor(named: "starfield_primary") ?? UIColor(hex: 0xB12536) // #B12536
    // 프리미엄아울렛
      static let premiumoutlet_primary = UIColor(named: "premiumoutlet_primary") ?? UIColor(hex: 0xD9117C) // #D9117C

    // 서비스에서 사용 하는 컬러셋
    // 해피바이러스
      static let happyvirus_primary = UIColor(named: "happyvirus_primary") ?? UIColor(hex: 0x59CBEC) // #59CBEC
      static let happyvirus_secondary = UIColor(named: "happyvirus_secondary") ?? UIColor(hex: 0x4A90E2) // #4A90E2

    // 먼데이문
      static let mondaymoon_primary = UIColor(named: "mondaymoon_primary") ?? UIColor(hex: 0x3E584B) // #3E584B
      static let mondaymoon_secondary = UIColor(named: "mondaymoon_secondary") ?? UIColor(hex: 0xB69D81) // #B69D81

    // 쓱톡
      static let ssgtalk_primary = UIColor(named: "ssgtalk_primary") ?? UIColor(hex: 0x6677C0) // #6677C0

    // 선물하기
      static let present_primary = UIColor(named: "present_primary") ?? UIColor(hex: 0x2FD5FF) // #2FD5FF

    // 백화점 식품관
      static let foodmarket_primary = UIColor(named: "foodmarket_primary") ?? UIColor(hex: 0xFF4D1C) // #FF4D1C
      static let foodmarket_secondary1 = UIColor(named: "foodmarket_secondary1") ?? UIColor(hex: 0xF2E9E2) // #F2E9E2
      static let foodmarket_secondary2 = UIColor(named: "foodmarket_secondary2") ?? UIColor(hex: 0xCCC8BC) // #CCC8BC
      static let foodmarket_secondary3 = UIColor(named: "foodmarket_secondary3") ?? UIColor(hex: 0x45483D) // #45483D

    // 뜨레또
      static let trestot_primary = UIColor(named: "trestot_primary") ?? UIColor(hex: 0x03A86C) // #03A86C

    // 우르르
      static let urr_primary = UIColor(named: "urr_primary") ?? UIColor(hex: 0x6252FF) // #6252FF
      static let urr_secondary = UIColor(named: "urr_secondary") ?? UIColor(hex: 0x19C9FF) // #19C9FF

    // 팩토리스토어
      static let factorystore = UIColor(named: "factorystore") ?? UIColor(hex: 0xD80E19) // #D80E19

    // 청소연구소
      static let cleaninglaboratory_primary = UIColor(named: "cleaninglaboratory_primary") ?? UIColor(hex: 0x0EC8DF) // #0EC8DF
      static let cleaninglaboratory_secondary = UIColor(named: "cleaninglaboratory_secondary") ?? UIColor(hex: 0x00BFFE) // #00BFFE

    // SSGPAY
      static let ssgpay_primary = UIColor(named: "ssgpay_primary") ?? UIColor(hex: 0xE24F39) // #E24F39
      static let ssgpay_secondary = UIColor(named: "ssgpay_secondary") ?? UIColor(hex: 0x323743)// #323743
}
