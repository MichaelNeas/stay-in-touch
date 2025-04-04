//
//  String.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import Foundation

enum RegexPattern: String {
    case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    case email = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
}

extension String {

    func isValid(regex: RegexPattern) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", regex.rawValue)
        return predicate.evaluate(with: self)
    }

    var onlyDigits: String {
        self.filter(\.isNumber)
    }

    func prepend(_ string: String) -> String {
        string + self
    }
}
