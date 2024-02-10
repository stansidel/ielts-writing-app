//
//  TaskType.swift
//  IELTSWritingApp
//
//  Created by Stan Sidel on 2/10/24.
//

import Foundation

struct TaskType: Hashable, Codable {
    let name: String
    let minWordsCount: Int
    let expectedTimeInMinutes: Int
}

extension TaskType {

    static let ieltsTypes: [TaskType] = [
        TaskType(name: "IELTS General Task 1", minWordsCount: 150, expectedTimeInMinutes: 20),
        TaskType(name: "IELTS General Task 2", minWordsCount: 250, expectedTimeInMinutes: 40),
        TaskType(name: "IELTS Academic Task 1", minWordsCount: 150, expectedTimeInMinutes: 20),
        TaskType(name: "IELTS Academic Task 2", minWordsCount: 250, expectedTimeInMinutes: 40)
    ]

    static let defaultIELTSType: TaskType = ieltsTypes.first!
}
