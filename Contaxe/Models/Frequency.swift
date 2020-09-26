//
//  Frequency.swift
//  Contaxe
//
//  Created by Michael Neas on 9/26/20.
//

import Foundation

enum Frequency: String, CaseIterable, Identifiable, CustomStringConvertible {
    case daily
    case weekly
    case monthly
    
    var description: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }

    var id: String { self.rawValue }
}
