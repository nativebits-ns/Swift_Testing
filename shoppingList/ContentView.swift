//
//  ContentView.swift
//  shoppingList
//
//  Created by Nachiket Shilwant on 04/09/26.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var viewModel: ShoppingListViewModel

    init(service: ShoppingListServiceProtocol) {
        _viewModel = State(wrappedValue: ShoppingListViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    TextField("Add item...", text: $viewModel.newItemName)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                    TextField("Qty", text: $viewModel.newItemQuantityText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                    Button("Add", action: viewModel.addItem)
                        .buttonStyle(.borderedProminent)
                        .disabled(!viewModel.isValidInput)
                }
                .padding()
                .background(Color(uiColor: .systemBackground))

                if viewModel.pendingItems.isEmpty {
                    ContentUnavailableView(
                        "List is Empty",
                        systemImage: "cart",
                        description: Text("Add items above to start building your shopping list.")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.pendingItems) { item in
                            HStack {
                                Text(item.itemName)
                                    .fontWeight(.medium)

                                Spacer()

                                HStack(spacing: 12) {
                                    Button(action: { viewModel.decrementQuantity(for: item) }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.borderless)

                                    Text("\(item.quantity)")
                                        .fontWeight(.semibold)
                                        .frame(minWidth: 20)

                                    Button(action: { viewModel.incrementQuantity(for: item) }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.tint)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deletePendingItems)
                    }
                    .listStyle(.insetGrouped)

                    Button(action: viewModel.markAllPendingAsPurchased) {
                        Label("Complete Purchase", systemImage: "cart.fill.badge.checkmark")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.isHistorySheetPresented = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isHistorySheetPresented) {
                PurchaseHistorySheet(viewModel: viewModel)
            }
        }
    }
}

struct PurchaseHistorySheet: View {
    @Bindable var viewModel: ShoppingListViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.purchasedItems.isEmpty {
                    ContentUnavailableView("No History", systemImage: "cart.badge.questionmark", description: Text("Purchased items will show up here."))
                } else {
                    List(viewModel.purchasedItems) { item in
                        HStack {
                            Text(item.itemName)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("Qty: \(item.quantity)")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Purchase History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { viewModel.isHistorySheetPresented = false }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
