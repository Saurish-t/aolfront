import SwiftUI

struct AppTheme {
    static let primary = Color(hex: "6C5CE7")       // Rich purple
    static let secondary = Color(hex: "00CEC9")     // Teal
    static let accent = Color(hex: "FD79A8")        // Pink
    
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primary, primary.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [accent, Color(hex: "FF7675")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let welcomeGradient = LinearGradient(
        gradient: Gradient(colors: [primary, Color(hex: "5758BB")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static func cardBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "2D3436").opacity(0.7) : Color.white
    }
    
    static let primaryButtonStyle = ButtonStyle(
        background: primary,
        foreground: .white,
        pressedBackground: primary.opacity(0.8)
    )
    
    static let secondaryButtonStyle = ButtonStyle(
        background: secondary,
        foreground: .white,
        pressedBackground: secondary.opacity(0.8)
    )
    
    static let accentButtonStyle = ButtonStyle(
        background: accent,
        foreground: .white,
        pressedBackground: accent.opacity(0.8)
    )
    
    static func textPrimary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white : Color(hex: "2D3436")
    }
    
    static func textSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color(hex: "636E72")
    }
    
    struct ButtonStyle {
        let background: Color
        let foreground: Color
        let pressedBackground: Color
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                configuration.isPressed ? 
                    AppTheme.primary.opacity(0.8) : 
                    AppTheme.primary
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: AppTheme.primary.opacity(0.3), radius: 5, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                configuration.isPressed ? 
                    AppTheme.secondary.opacity(0.8) : 
                    AppTheme.secondary
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: AppTheme.secondary.opacity(0.3), radius: 5, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct AccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                configuration.isPressed ? 
                    AppTheme.accent.opacity(0.8) : 
                    AppTheme.accent
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: AppTheme.accent.opacity(0.3), radius: 5, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    var color: Color = AppTheme.primary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .foregroundColor(color)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 2)
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct MemoryCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.cardBackground(colorScheme))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func memoryCardStyle() -> some View {
        self.modifier(MemoryCardStyle())
    }
}
