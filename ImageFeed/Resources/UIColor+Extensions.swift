//
//  UIColor+Extensions.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 10.04.2023.
//

import UIKit

//test

extension UIColor {
        static var ypBlue: UIColor { UIColor(named: "blue") ?? UIColor.blue }
        static var ypRed: UIColor { UIColor(named: "red") ?? UIColor.red }
        static var ypBlack: UIColor { UIColor(named: "black") ?? UIColor.black}
        static var ypBackground: UIColor { UIColor(named: "background") ?? UIColor.darkGray }
        static var ypGray: UIColor { UIColor(named: "gray") ?? UIColor.gray }
        static var ypWhite: UIColor { UIColor(named: "white") ?? UIColor.white}
        static var ypWhiteAlpha50: UIColor { UIColor(named: "white (alpha 50)") ?? UIColor.white}
     }
