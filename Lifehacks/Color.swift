//
//  Color.swift
//  Lifehacks
//
//  Created by Marcel Mravec on 25.09.2023.
//

import SwiftUI

extension Color {
    static var blazeOrange: Color { .init("Blaze Orange") }
    static var electricViolet: Color { .init("Electric Violet") }
    static var pizazz: Color { .init("Pizazz") }
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.accentColor
            Color.pizazz
            Color.electricViolet
            Color.blazeOrange
        }
    }
}
