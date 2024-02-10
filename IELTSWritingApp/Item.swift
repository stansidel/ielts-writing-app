//
//  Item.swift
//  IELTSWritingApp
//
//  Created by Stan Sidel on 2/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date = Date()
    var taskType: TaskType = TaskType.defaultIELTSType
    var question: String = ""
    var answer: String = ""
    var startedAt: Date?
    var completedAt: Date?

    init(
        timestamp: Date,
        taskType: TaskType,
        question: String,
        answer: String,
        startedAt: Date?,
        completedAt: Date?
    ) {
        self.timestamp = timestamp
        self.taskType = taskType
        self.question = question
        self.answer = answer
        self.startedAt = startedAt
        self.completedAt = completedAt
    }
}
