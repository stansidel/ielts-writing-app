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
