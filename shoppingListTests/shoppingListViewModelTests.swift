//
//  shoppingListViewModelTests.swift
//  shoppingList
//
//  Created by Nachiket Shilwant on 07/09/26.
//

import Testing
import SwiftData
import Foundation
@testable import shoppingList

extension Tag {
    @Tag static var viewModelInitialState: Self
}

@Suite("Shopping List View Model Tests")
@MainActor
struct shoppingListViewModelTests {
    let container: ModelContainer
    let context: ModelContext
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.container = try ModelContainer(for: Item.self, configurations: config)
        self.context = container.mainContext
    }
    
    @Test(.tags(.viewModelInitialState))
    func initialStateWithEmptyStore() throws {
        let service = ShoppingListService(modelContext: context)
        let viewModel = ShoppingListViewModel(service: service)
        
        #expect(viewModel.newItemName == "")
        #expect(viewModel.newItemQuantityText == "1")
        #expect(viewModel.isHistorySheetPresented == false)
        #expect(viewModel.allItems.isEmpty)
        #expect(viewModel.pendingItems.isEmpty)
        #expect(viewModel.purchasedItems.isEmpty)
        #expect(viewModel.isValidInput == false)
    }
    
    @Test(.tags(.viewModelInitialState))
    func initialStateWithPreexistingItems() throws {
        let service = ShoppingListService(modelContext: context)
        try service.addItem(name: "Milk", quantity: 2, purchaseStatus: false)
        try service.addItem(name: "Bread", quantity: 1, purchaseStatus: true)
        
        let viewModel = ShoppingListViewModel(service: service)
        
        #expect(viewModel.allItems.count == 2)
        #expect(viewModel.pendingItems.count == 1)
        #expect(viewModel.pendingItems.first?.itemName == "Milk")
        #expect(viewModel.purchasedItems.count == 1)
        #expect(viewModel.purchasedItems.first?.itemName == "Bread")
    }
}
