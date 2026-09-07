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
 
@MainActor
struct shoppingListTests {
    let container: ModelContainer
    let context: ModelContext
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.container = try ModelContainer(for: Item.self, configurations: config)
        self.context = container.mainContext
    }
    
    @Test()
    func addingItemInShoppingList() async throws {
        let service = ShoppingListService(modelContext: context)
        
        try service.addItem(name: "Testing", quantity: 3)
        
        let descriptor = FetchDescriptor<Item>()
        let items = try context.fetch(descriptor)
        
        let addedItem = try #require(items.first)
        
        #expect(addedItem.itemName == "Failing Job")
        #expect(addedItem.quantity == 3)
        #expect(addedItem.purchasedStatus == false)
        
    }
}
