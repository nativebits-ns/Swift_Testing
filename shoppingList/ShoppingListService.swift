//
//  Untitled.swift
//  shoppingList
//
//  Created by Nachiket Shilwant on 04/09/26.
//

import Foundation
import SwiftData

protocol ShoppingListServiceProtocol {
    func fetchItems() throws -> [Item]
    func addItem(name: String, quantity: Int, purchaseStatus: Bool) throws
    func updateItem(_ item: Item) throws
    func deleteItem(_ item: Item) throws
    func markAllAsPurchased(items: [Item]) throws
}

final class ShoppingListService: ShoppingListServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchItems() throws -> [Item] {
        let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }
    
    func addItem(name: String, quantity: Int, purchaseStatus: Bool = false) throws {
        if name.isEmpty {
            throw CocoaError(.fileWriteUnknown, userInfo: [NSLocalizedDescriptionKey: "Can't add this item"])
        }
        let newItem = Item(itemName: name, quantity: quantity, purchasedStatus: purchaseStatus)
        modelContext.insert(newItem)
        try modelContext.save()
    }
    
    func updateItem(_ item: Item) throws {
        try modelContext.save()
    }
    
    func deleteItem(_ item: Item) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func markAllAsPurchased(items: [Item]) throws {
        for item in items {
            item.purchasedStatus = true
        }
        try modelContext.save()
    }
}

