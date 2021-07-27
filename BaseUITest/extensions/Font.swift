//
//  Font.swift
//  BaseUITest
//
//  Created by pkh on 2021/07/27.
//

import UIKit

// Font
enum FontName: String {
    case APPLE_SD_MEDIUM = "AppleSDGothicNeo-Medium"
    case APPLE_SD_REGULAR = "AppleSDGothicNeo-Regular"
    case APPLE_SD_BOLD = "AppleSDGothicNeo-Bold"
    case APPLE_SD_THIN = "AppleSDGothicNeo-Thin"
    case APPLE_SD_LIGHT = "AppleSDGothicNeo-Light"
    case APPLE_SD_SEMIBOLD = "AppleSDGothicNeo-SemiBold"
    case APPLE_SD_ULTRA_LIGHT = "AppleSDGothicNeo-UltraLight"

    case HELVETICA_NEUE_MEDIUM = "HelveticaNeue-Medium"
    case HELVETICA_NEUE_BOLD = "HelveticaNeue-Bold"

    case ROBOTO_MEDIUM = "Roboto-Medium"
    case ROBOTO_REGULAR = "Roboto-Regular"
    case ROBOTO_BOLD = "Roboto-Bold"

    case AVENIR_BOOK = "Avenir-Book"
    case AVENIR_LIGHT = "Avenir-Light"
    case AVENIR_MEDIUM = "Avenir-Medium"
    case AVENIR_HEAVY = "Avenir-Heavy"
    case AVENIR_NEXT_BOLD = "AvenirNextCondensed-Bold"
    case AVENIR_ROMAN = "Avenir-Roman"
    case AVENIR_NEXT_MEDIUM = "AvenirNext-Medium"
    case AVENIR_NEXT_DEMIBOLD = "AvenirNext-DemiBold"
    case AVENIR_NEXT_ULTRA_LIGHT = "AvenirNext-UltraLight"
    case AVENIR_NEXT_REGULAR = "AvenirNext-Regular"

    case FUTURA_MEDIUM = "Futura-Medium"
    case GEORGIA = "Georgia"

    case SSGOTHAM_BLACK = "ssgotham-black"
    case SSGOTHAM_MEDIUM = "ssgotham-Medium"

    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
