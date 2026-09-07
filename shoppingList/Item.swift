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
    var id: UUID
    var timestamp: Date
    var itemName: String
    var quantity: Int
    var purchasedStatus: Bool
    
    init(id: UUID = UUID(), itemName: String, quantity: Int = 1, purchasedStatus: Bool = false) {
        self.id = id
        self.timestamp = Date()
        self.itemName = itemName
        self.quantity = quantity
        self.purchasedStatus = purchasedStatus
    }
}
