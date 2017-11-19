//
//  UIColorExtension.swift
//  InteractiveUISample
//
//  Created by 酒井文也 on 2017/11/13.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    //16進数のカラーコードをiOSの設定に変換するメソッド
    //参考：【Swift】Tips: あると便利だったextension達(UIColor編)
    //https://dev.classmethod.jp/smartphone/utilty-extension-uicolor/
    convenience init(code: String) {
        var color: UInt32 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: code.replacingOccurrences(of: "#", with: "")).scanHexInt32(&color) {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >>  8) / 255.0
            b = CGFloat( color & 0x0000FF       ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}