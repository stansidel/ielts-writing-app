//
//  SessionView.swift
//  IELTSWritingApp
//
//  Created by Stan Sidel on 2/10/24.
//

import SwiftUI

struct SessionView: View {
    @Bindable var item: Item
    let taskTypes: [TaskType]

    var body: some View {
        WritingView(
            taskTypes: taskTypes,
            item: item
        )
    }
}

#Preview {
    SessionView(
        item: Item(
            timestamp: Date(),
            taskType: TaskType(name: "Name", minWordsCount: 100, expectedTimeInMinutes: 20),
            question: "",
            answer: "",
            startedAt: nil,
            completedAt: nil
        ),
        taskTypes: [
            TaskType(name: "Task type", minWordsCount: 100, expectedTimeInMinutes: 20)
        ]
    )
}
