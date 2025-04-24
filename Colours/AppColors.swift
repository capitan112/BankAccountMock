//
//  AppColors.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct AppColors {
    let textColor: Color
    let background: Color
    let primary: Color
    let secondary: Color

    init(colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            textColor = Color.black
            background = Color(red: 0.949, green: 0.949, blue: 0.969)
            primary = Color.white
            secondary = Color.gray
        case .dark:
            textColor = Color.white
            background = Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255)
            primary = Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255)
            secondary = Color.white
        @unknown default:
            textColor = Color.white
            background = Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255)
            primary = Color.blue
            secondary = Color.gray
        }
    }
}

private struct AppColorsKey: EnvironmentKey {
    static var defaultValue: AppColors {
        let colorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? ColorScheme.dark : ColorScheme.light
        return AppColors(colorScheme: colorScheme)
    }
}

extension EnvironmentValues {
    var appColors: AppColors {
        get { self[AppColorsKey.self] }
        set { self[AppColorsKey.self] = newValue }
    }
}
