import Foundation

enum Frequency: String, CaseIterable, Identifiable, CustomStringConvertible {
    case daily
    case weekly

    var description: String {
        switch self {
        case .daily: "Daily"
        case .weekly: "Weekly"
        }
    }

    var id: String { rawValue }
}
