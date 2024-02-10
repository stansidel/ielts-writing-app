//
//  ContentView.swift
//  IELTSWritingApp
//
//  Created by Stan Sidel on 2/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        SessionView(
                            item: item,
                            taskTypes: TaskType.ieltsTypes
                        )
                        .padding(16)
                        .frame(maxHeight: .infinity)
                    } label: {
                        VStack {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            Text(item.taskType.name)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(
                timestamp: Date(),
                taskType: TaskType.defaultIELTSType,
                question: "",
                answer: "",
                startedAt: nil,
                completedAt: nil
            )
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
