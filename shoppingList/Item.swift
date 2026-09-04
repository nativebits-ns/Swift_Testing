//
//  Item.swift
//  shoppingList
//
//  Created by Nachiket Shilwant on 04/09/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
