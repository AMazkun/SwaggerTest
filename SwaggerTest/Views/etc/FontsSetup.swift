//
//  FontsSetup.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

let rawHeight : CGFloat = 56
let inpHeight : CGFloat = 24

let backgroundGray = Color(red: 0.973, green: 0.973, blue: 0.973)
enum FontSetting {
    case Heading1
    case Body1
    case Body2
    case Body3
    
    var size: CGFloat {
        switch self {
        case .Heading1: return 20
        case .Body1: return 16
        case .Body2: return 18
        case .Body3: return 14
        }
    }
    
    var linespacing: CGFloat {
        switch self {
        case .Heading1: return 4
        case .Body1: return 5
        case .Body2: return 6
        case .Body3: return 6
        }
    }
}

struct CustomFontModifier: ViewModifier {
    var type: FontSetting

    func body(content: Content) -> some View {
        content
            .font(.custom("NunitoSans-Regular", size: type.size))
            .lineSpacing(type.linespacing)
    }
}

extension View {
    func nunitoSansFont(_ type: FontSetting) -> some View {
        self.modifier(CustomFontModifier(type: type))
    }
}
