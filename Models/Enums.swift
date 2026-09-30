import Foundation
import SwiftUI

// MARK: - Rarity Tier
public enum RarityTier: String, Codable, CaseIterable, Comparable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case legendary = "Legendary"
    
    public var points: Int {
        switch self {
        case .common: return 100
        case .uncommon: return 250
        case .rare: return 500
        case .legendary: return 1500
        }
    }
    
    public var color: Color {
        switch self {
        case .common: return Color.gray
        case .uncommon: return Color.teal
        case .rare: return Color.indigo
        case .legendary: return Color.orange
        }
    }
    
    public var iconName: String {
        switch self {
        case .common: return "circle.fill"
        case .uncommon: return "shield.fill"
        case .rare: return "sparkles"
        case .legendary: return "crown.fill"
        }
    }
    
    public static func < (lhs: RarityTier, rhs: RarityTier) -> Bool {
        lhs.points < rhs.points
    }
}

// MARK: - Train Category
public enum TrainCategory: String, Codable, CaseIterable {
    case highSpeed = "Fernverkehr (ICE/IC)"
    case regional = "Regionalverkehr"
    case special = "Sonder- & Testzüge"
    
    public var icon: String {
        switch self {
        case .highSpeed: return "tram.fill"
        case .regional: return "tram"
        case .special: return "star.circle.fill"
        }
    }
}
