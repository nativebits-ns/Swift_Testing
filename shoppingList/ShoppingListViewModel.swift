//
//  ShoppingListViewModel.swift
//  shoppingList
//
//  Created by Nachiket Shilwant on 04/09/26.
//


import Foundation
import Observation

@Observable
final class ShoppingListViewModel {
    private let service: ShoppingListServiceProtocol

    var newItemName: String = ""
    var newItemQuantityText: String = "1"
    var isHistorySheetPresented: Bool = false
    
    private(set) var allItems: [Item] = []
    
    var pendingItems: [Item] {
        allItems.filter { !$0.purchasedStatus }
    }
    
    var purchasedItems: [Item] {
        allItems.filter { $0.purchasedStatus }
    }
    
    var isValidInput: Bool {
        let trimmed = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let qty = Int(newItemQuantityText), qty > 0 else {
            return false
        }
        return true
    }

    init(service: ShoppingListServiceProtocol) {
        self.service = service
        loadItems()
    }

    func loadItems() {
        do {
            allItems = try service.fetchItems()
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func addItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let quantity = Int(newItemQuantityText), quantity > 0, !trimmedName.isEmpty else {
            return
        }

        do {
            try service.addItem(name: trimmedName, quantity: quantity, purchaseStatus: false)
            newItemName = ""
            newItemQuantityText = "1"
            loadItems()
        } catch {
            print("Failed to add item: \(error)")
        }
    }

    func incrementQuantity(for item: Item) {
        item.quantity += 1
        saveChanges(for: item)
    }

    func decrementQuantity(for item: Item) {
        if item.quantity > 1 {
            item.quantity -= 1
            saveChanges(for: item)
        } else {
            deleteItem(item)
        }
    }

    func deleteItem(_ item: Item) {
        do {
            try service.deleteItem(item)
            loadItems()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }

    func deletePendingItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { pendingItems[$0] }
        for item in itemsToDelete {
            try? service.deleteItem(item)
        }
        loadItems()
    }

    func markAllPendingAsPurchased() {
        do {
            try service.markAllAsPurchased(items: pendingItems)
            loadItems()
        } catch {
            print("Failed to update status: \(error)")
        }
    }

    private func saveChanges(for item: Item) {
        do {
            try service.updateItem(item)
            loadItems()
        } catch {
            print("Failed to update item: \(error)")
        }
    }
}
