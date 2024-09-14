//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 14/09/24.
//

import Foundation
import UIKit

extension UIFont {
    public static func allFontNames() -> [String] {
        let familyNames = UIFont.familyNames.sorted()
        return familyNames.flatMap { familyName in
            let fontName = UIFont.fontNames(forFamilyName: familyName)
            return fontName
        }
    }
}


extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            print("Couldn't find font \(fontName)")
            return false
        }

        // NOTE: -
        // Previously we were using `CTFontManagerRegisterGraphicsFont` which takes CTFont.
        // but this was not working in the WidgetKit extension.
        // So as per the this thread,
        // https://developer.apple.com/forums/thread/659332
        // Apple engineer suggested to use `CTFontManagerRegisterFontsForURL`.
        // Here scope like `CTFontManagerScope.persistent` is not supported in this method.
        // `CTFontManagerScope.none` should used for un-registering method only.
        // `CTFontManagerScope.process` works for both App and WidgetKit extension Target.

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        guard success else {
            print(
                """
                Error registering font: \(fontName). Maybe it was already registered.\
                \(error.map { " \($0.takeUnretainedValue().localizedDescription)" } ?? "")
                """
            )
            return false
        }

        return true
    }
    
    public static func registerAppWriteFonts() {
        let success = Self.registerFont(bundle: Bundle.module, fontName: "Playwrite", fontExtension: "ttf")
        print(success)
    }
}

public enum AppFont: CaseIterable {
    case playWrite
    
    var fontName: String {
        switch self { case .playWrite: "Playwrite" }
    }
    
    var fontExtension: String {
        switch self { case .playWrite: ".ttf" }
    }
    
    public enum PlayWriteWeight: String {
        case regular
        case thin
        case extraLight
        case light
        
        var name: String {
            switch self {
            case .regular:
                "PlaywriteCU-Regular"
            case .thin:
                "PlaywriteCU-Regular_Thin"
            case .extraLight:
                "PlaywriteCU-Regular_ExtraLight"
            case .light:
                "PlaywriteCU-Regular_Light"
            }
        }
    }
}

extension UIFont {
    public static func register(_ font: AppFont) -> Bool {
        Self.registerFont(bundle: .module, fontName: font.fontName, fontExtension: font.fontExtension)
    }
    
    public static func registerAll() {
        AppFont.allCases.forEach {
            _ = Self.register($0)
        }
    }
}

import SwiftUI

extension Font {
    public static func playwrite(weight: AppFont.PlayWriteWeight, size: CGFloat) -> Font {
        Font.custom(weight.name, size: size)
    }
}
