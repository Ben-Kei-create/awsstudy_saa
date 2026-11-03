import Foundation

enum StudyDomain: String, Codable, CaseIterable {
    case security, resilience, performance, cost
    var title: String {
        switch self {
        case .security: return "安全な設計"
        case .resilience: return "高可用な設計"
        case .performance: return "高性能な設計"
        case .cost: return "コスト最適化"
        }
    }
    var symbol: String {
        switch self {
        case .security: return "lock.shield"
        case .resilience: return "arrow.triangle.branch"
        case .performance: return "bolt"
        case .cost: return "chart.line.downtrend.xyaxis"
        }
    }
}

struct StudyChoice: Codable, Identifiable, Equatable {
    let id: String
    let text: String
    let reason: String
}

struct StudyQuestion: Codable, Identifiable, Equatable {
    let id: String
    let stage: Int
    let domain: StudyDomain
    let prompt: String
    let choices: [StudyChoice]
    let correctID: String
    let takeaway: String
    let sourceURL: String
    var correctChoice: StudyChoice { choices.first { $0.id == correctID }! }
}

enum StudyContent {
    static let stageTitles = ["設計の基礎", "構成を選ぶ", "実践シナリオ"]
    static let stageSubtitles = ["要件から、サービスを見極める。", "つながりと負荷を、設計する。", "制約の中で、最適な一手を選ぶ。"]
    static func load(from url: URL) throws -> [StudyQuestion] {
        let questions = try JSONDecoder().decode([StudyQuestion].self, from: Data(contentsOf: url))
        try validate(questions)
        return questions
    }
    static func validate(_ questions: [StudyQuestion]) throws {
        guard questions.count == 45,
              Set(questions.map(\.id)).count == 45,
              Set(questions.map(\.prompt)).count == 45,
              (0..<3).allSatisfy({ stage in questions.filter { $0.stage == stage }.count == 15 }),
              questions.allSatisfy({ question in
                  question.choices.count == 3 && Set(question.choices.map(\.id)).count == 3 &&
                  Set(question.choices.map(\.text)).count == 3 &&
                  question.choices.contains { $0.id == question.correctID } &&
                  !question.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                  !question.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                  !question.takeaway.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                  question.choices.allSatisfy { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !$0.reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } &&
                  URL(string: question.sourceURL)?.scheme == "https" &&
                  URL(string: question.sourceURL)?.host == "docs.aws.amazon.com"
              }) else { throw ContentError.invalidBank }
    }
    enum ContentError: Error { case invalidBank }
}

struct StudyAnswer {
    let question: StudyQuestion
    let selectedID: String
    var isCorrect: Bool { selectedID == question.correctID }
}

struct QuizRun {
    let stage: Int
    let questions: [StudyQuestion]
    let isReview: Bool
    private(set) var questionIndex = 0
    private(set) var choices: [StudyChoice] = []
    private(set) var answers: [StudyAnswer] = []
    private(set) var selectedID: String?
    private(set) var isComplete = false

    init(stage: Int, questions: [StudyQuestion], isReview: Bool = false) {
        precondition(!questions.isEmpty)
        self.stage = stage
        self.questions = questions.shuffled()
        self.isReview = isReview
        choices = self.questions[0].choices.shuffled()
    }
    var question: StudyQuestion { questions[questionIndex] }
    var score: Int { answers.filter(\.isCorrect).count }
    var missed: [StudyQuestion] { answers.filter { !$0.isCorrect }.map(\.question) }
    // This is a learning-game progression threshold, not an AWS exam score.
    var canAdvance: Bool { isComplete && !isReview && score >= 11 }
    var progress: Double { Double(questionIndex + (selectedID == nil ? 0 : 1)) / Double(questions.count) }
    var isLast: Bool { questionIndex == questions.count - 1 }

    mutating func answer(_ id: String) {
        guard !isComplete, selectedID == nil, choices.contains(where: { $0.id == id }) else { return }
        selectedID = id
        answers.append(StudyAnswer(question: question, selectedID: id))
    }
    mutating func next() {
        guard selectedID != nil, !isComplete else { return }
        if isLast { isComplete = true }
        else {
            questionIndex += 1
            selectedID = nil
            choices = question.choices.shuffled()
        }
    }
    func domainScore(_ domain: StudyDomain) -> (correct: Int, total: Int) {
        let relevant = answers.filter { $0.question.domain == domain }
        return (relevant.filter(\.isCorrect).count, relevant.count)
    }
}
