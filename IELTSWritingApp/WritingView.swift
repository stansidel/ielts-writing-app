//
//  WritingView.swift
//  IELTSWritingApp
//
//  Created by Stan Sidel on 2/10/24.
//

import SwiftUI

protocol WordsCounter {
    func getWordsCount(in text: String) -> Int
}

struct IELTSWordsCounter: WordsCounter {
    func getWordsCount(in text: String) -> Int {
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { $0.contains(/[\d\w]+/) }

        return words.count
    }
}

protocol TimeFormatter {
    func formatTime(time: TimeInterval) -> String
}

struct IELTSTimeFormatter: TimeFormatter {
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct WritingView: View {
    let taskTypes: [TaskType]
    @Bindable var item: Item
    @State private var showingStartAlert = false
    @State private var showingCompleteAlert = false

    let wordsCounter: WordsCounter = IELTSWordsCounter()
    let timeFormatter: TimeFormatter = IELTSTimeFormatter()

    private var hasStarted: Bool { item.startedAt != nil }
    private var hasCompleted: Bool { item.completedAt != nil }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TaskQuestionView(
                    question: $item.question,
                    taskType: $item.taskType,
                    isEditable: !hasStarted,
                    taskTypes: taskTypes
                )
                Button("Start") {
                    showingStartAlert = true
                }
                .disabled(hasStarted)
                .alert(
                    Text("Are you sure?"),
                    isPresented: $showingStartAlert,
                    presenting: Text("Are you sure you want to reset the timer?")
                ) { details in
                    Button(role: .destructive) {
                        $item.startedAt.wrappedValue = Date()
                    } label: {
                        Text("Yes")
                    }
                }
                Spacer()
            }
            VStack(alignment: .leading) {
                InputFieldView(
                    text: $item.answer,
                    stats: formattedStats,
                    isEditable: hasStarted && !hasCompleted
                )
                Spacer()
                HStack {
                    WordCountView(
                        currentWordsCount: wordsCounter.getWordsCount(in: item.answer),
                        minWordsCount: item.taskType.minWordsCount
                    )
                    Spacer()
                    if let startTime = item.startedAt {
                        TimerView(
                            startTime: startTime,
                            endTime: item.completedAt,
                            maxTime:  TimeInterval(item.taskType.expectedTimeInMinutes * 60)
                        )
                    }
                }
                .padding(8)
                HStack {
                    Spacer()
                    Button("Finish") {
                        showingCompleteAlert = true
                    }
                    .disabled(hasCompleted || !hasStarted)
                    .alert(
                        Text("Are you sure?"),
                        isPresented: $showingCompleteAlert,
                        presenting: Text("Are you sure you want to complete writing?")
                    ) { details in
                        Button(role: .destructive) {
                            $item.completedAt.wrappedValue = Date()
                        } label: {
                            Text("Yes")
                        }
                    }
                }
                .padding(8)
            }
            .frame(maxHeight: .infinity)
        }
    }

    private var formattedStats: String {
        let wordsCount = wordsCounter.getWordsCount(in: item.answer)
        var text = "(\(wordsCount) words"
        if let startedAt = item.startedAt, let completedAt = item.completedAt {
            let timeSpent = completedAt.timeIntervalSince(startedAt)
            let formattedTimeSpent = timeFormatter.formatTime(time: timeSpent)
            text += " in \(formattedTimeSpent)"
        }
        text += ")"

        return text
    }
}

struct TaskQuestionView: View {
    @Binding var question: String
    @Binding var taskType: TaskType
    let isEditable: Bool
    let taskTypes: [TaskType]

    var body: some View {
        VStack {
            Picker("Task type:", selection: $taskType) {
                ForEach(taskTypes, id: \.self) {
                    Text($0.name)
                }
            }
            .disabled(!isEditable)
            Text("Question:")
            TextEditor(
                text: isEditable ? $question : .constant(question)
            )
        }
    }
}

struct InputFieldView: View {
    @Binding var text: String
    let stats: String
    let isEditable: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your answer:")
            TextEditor(text: isEditable ? $text : .constant(answerWithStats))
            .autocorrectionDisabled()
        }
    }

    private var answerWithStats: String {
        "\(text)\n\n\(stats)"
    }
}

struct TimerView: View {
    let startTime: Date
    let endTime: Date?
    let maxTime: TimeInterval

    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()

    var body: some View {
        if let timeSpent = timeSpent {
            Text("Time spent: \(formatTime(time: timeSpent))")
        } else {
            Text("Time left: \(formatTime(time: timeLeft))")
                .onReceive(timer) { _ in
                    now = Date()
                }
        }
    }

    private var timeLeft: TimeInterval {
        maxTime - now.timeIntervalSince(startTime)
    }

    private var timeSpent: TimeInterval? {
        guard let endTime else { return nil }

        return endTime.timeIntervalSince(startTime)
    }

    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct WordCountView: View {
    let currentWordsCount: Int
    let minWordsCount: Int

    var body: some View {
        Text("Words: \(currentWordsCount) of \(minWordsCount)")
    }
}

#Preview("Initial") {
    WritingView(
        taskTypes: [
            TaskType(name: "Task type", minWordsCount: 100, expectedTimeInMinutes: 20)
        ],
        item: Item(
            timestamp: Date(),
            taskType: TaskType(name: "Task type", minWordsCount: 100, expectedTimeInMinutes: 20),
            question: "",
            answer: "",
            startedAt: nil,
            completedAt: nil
        )
    )
}

#Preview("Started") {
    WritingView(
        taskTypes: [
            TaskType(name: "Task type", minWordsCount: 100, expectedTimeInMinutes: 20)
        ],
        item: Item(
            timestamp: Date(),
            taskType: TaskType(name: "Task type", minWordsCount: 100, expectedTimeInMinutes: 20),
            question: "Write something.",
            answer: "",
            startedAt: Date() - 12,
            completedAt: nil
        )
    )
}

#Preview("Completed") {
    WritingView(
        taskTypes: [
            TaskType(name: "Task type", minWordsCount: 100, expectedTimeInMinutes: 20)
        ],
        item: Item(
            timestamp: Date(),
            taskType: TaskType(name: "Task type", minWordsCount: 100, expectedTimeInMinutes: 20),
            question: "Write something.",
            answer: "My sample answer.",
            startedAt: Date() - 5 * 60 - 12,
            completedAt: Date() - 1
        )
    )
}
