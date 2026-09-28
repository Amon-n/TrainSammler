import SwiftUI

public struct RarityBadgeView: View {
    public let rarity: RarityTier
    public var style: BadgeStyle = .standard
    
    public enum BadgeStyle {
        case minimal
        case standard
        case glowing
    }
    
    public init(rarity: RarityTier, style: BadgeStyle = .standard) {
        self.rarity = rarity
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: rarity.iconName)
                .font(.caption2.weight(.bold))
            Text(rarity.rawValue.uppercased())
                .font(.caption2.weight(.heavy))
                .tracking(0.5)
        }
        .padding(.horizontal, style == .minimal ? 6 : 8)
        .padding(.vertical, style == .minimal ? 2 : 4)
        .foregroundStyle(rarity == .common ? Color.primary : rarity.color)
        .background {
            Capsule()
                .fill(rarity.color.opacity(0.15))
        }
        .overlay {
            Capsule()
                .strokeBorder(rarity.color.opacity(0.4), lineWidth: 1)
        }
        .shadow(color: style == .glowing ? rarity.color.opacity(0.6) : .clear, radius: 8, x: 0, y: 0)
    }
}

#Preview {
    VStack(spacing: 12) {
        RarityBadgeView(rarity: .common)
        RarityBadgeView(rarity: .uncommon)
        RarityBadgeView(rarity: .rare)
        RarityBadgeView(rarity: .legendary, style: .glowing)
    }
    .padding()
}
