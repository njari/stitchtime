import SwiftUI

extension Color {
    /// Initialize a Color from a hex string.
    /// Supports 3 or 6 digit hexadecimal values.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = (
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6: // RGB (24-bit)
            (r, g, b) = (
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1.0
        )
    }
}

struct AppColors {
    static let primary = Color(hex: "cb997e")
    static let secondary = Color(hex: "ddbea9")
    static let tertiary = Color(hex: "ffe8d6")
    static let quaternary = Color(hex: "b7b7a4")
    static let quinary = Color(hex: "a5a58d")
    static let accent = Color(hex: "6b705c")
}
