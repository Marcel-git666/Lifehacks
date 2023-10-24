//
//  Extensions.swift
//  Lifehacks
//
//  Created by Marcel Mravec on 16.10.2023.
//

import SwiftUI

extension Text {
    init(viewCount: Int) {
        self.init("Viewed \(viewCount.formatted()) times")

    }

    init(date: Date, prefix: String = "Asked on") {
        self.init(prefix + " " + date.formatted(date: .long, time: .omitted))
    }
}

extension View {
    func style(color: Color, isFilled: Bool = true, isRounded: Bool = true) -> some View {
        modifier(Style(color: color, isFilled: isFilled, isRounded: isRounded))
    }
}

extension View {
    func visible(_ isVisible: Bool) -> some View {
        opacity(isVisible ? 1.0 : 0.0)
    }
}
