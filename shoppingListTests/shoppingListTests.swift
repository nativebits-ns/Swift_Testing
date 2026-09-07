//
//  shoppingListTests.swift
//  shoppingListTests
//
//  Created by Nachiket Shilwant on 04/09/26.
//

import Testing
import SwiftData
import Foundation
@testable import shoppingList

extension Tag {
    @Tag static var itemCreation: Self
    @Tag static var itemValidation: Self
    @Tag static var itemDeletion: Self
}

@Suite("Shopping List Service Tests")
@MainActor
struct shoppingListTests {
    let container: ModelContainer
    let context: ModelContext
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.container = try ModelContainer(for: Item.self, configurations: config)
        self.context = container.mainContext
    }
    
    @Test(.tags(.itemCreation))
    func addingItemInShoppingList() async throws {
        let service = ShoppingListService(modelContext: context)
        
        try service.addItem(name: "Testing", quantity: 3)
        
        let descriptor = FetchDescriptor<Item>()
        let items = try context.fetch(descriptor)
        
        let addedItem = try #require(items.first)
        
        #expect(addedItem.itemName == "Testing")
        #expect(addedItem.quantity == 3)
        #expect(addedItem.purchasedStatus == false)
        
    }
    
    @Test(.tags(.itemValidation))
    func addingEmptyNameItemInShoppingList() async throws {
        let service = ShoppingListService(modelContext: context)
        
        #expect(throws: Error.self) {
            try service.addItem(name: "", quantity: 5)
        }
    }
    
    @Test(
        .tags(.itemCreation),
        arguments: [("test1", 1, true),("test2", 2, false),("test3", 3, true),("test4", 4, false)]
    )
    func addingMultipleItemInShoppingList(
        name: String,
        quantity: Int,
        purchase: Bool
    ) async throws {
        let service = ShoppingListService(modelContext: context)
        
        try service.addItem(name: name, quantity: quantity, purchaseStatus: purchase)
        
        let descriptor = FetchDescriptor<Item>()
        let items = try context.fetch(descriptor)
        
        
        let addedItem = try #require(items.first)
        
        #expect(addedItem.itemName == name)
        #expect(addedItem.quantity == quantity)
        #expect(addedItem.purchasedStatus == purchase)
    }
    
    @Test(.tags(.itemDeletion))
    func deletingItemInShoppingList() throws {
        let service = ShoppingListService(modelContext: context)
        try service.addItem(name: "Testing", quantity: 3)
        
        let descriptor = FetchDescriptor<Item>()
        let items = try context.fetch(descriptor)
        
        let itemToDelete = try #require(items.first)
        
        try service.deleteItem(itemToDelete)
        
        let itemsAfterDelete = try context.fetch(FetchDescriptor<Item>())
        #expect(itemsAfterDelete.isEmpty)
    }
    
    @Test(.tags(.itemValidation))
    func markingItemsAsPurchased() async throws {
        let service = ShoppingListService(modelContext: context)
        try service.addItem(name: "Testing", quantity: 3)
        
        let descriptor = FetchDescriptor<Item>()
        let items = try context.fetch(descriptor)
        
        let itemToUpdate = try #require(items.first)
        
        itemToUpdate.purchasedStatus = true
        
        let itemAfterUpdate = try context.fetch(FetchDescriptor<Item>())
        #expect(itemAfterUpdate.first?.purchasedStatus == true)
        
    }
}
