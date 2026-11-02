import Foundation

func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() { fatalError("FAIL: \(message)") }
}
let questions = try StudyContent.load(from: URL(fileURLWithPath: CommandLine.arguments[1]))
check(questions.count == 45, "45 validated questions")
check(Set(questions.map(\.domain)) == Set(StudyDomain.allCases), "all four domains")
for stage in 0..<3 {
    let stageQuestions = questions.filter { $0.stage == stage }
    for targetScore in [0, 10, 11, 15] {
        var run = QuizRun(stage: stage, questions: stageQuestions)
        run.next()
        check(run.questionIndex == 0 && run.answers.isEmpty, "unanswered cannot advance")
        run.answer("invalid")
        check(run.selectedID == nil, "invalid choice cannot answer")
        for index in 0..<15 {
            check(run.choices.count == 3, "exactly three options")
            let id = index < targetScore ? run.question.correctID : run.question.choices.first { $0.id != run.question.correctID }!.id
            run.answer(id)
            run.answer(run.question.correctID)
            check(run.answers.count == index + 1, "cannot count twice")
            check(run.score == min(index + 1, targetScore), "score")
            run.next()
        }
        check(run.isComplete && run.score == targetScore, "stage completed")
        check(run.canAdvance == (targetScore >= 11), "10/11 progression boundary")
        check(run.missed.count == 15 - targetScore, "missed questions")
        let count = run.answers.count
        run.next(); run.answer(run.question.correctID)
        check(run.answers.count == count, "cannot answer after completion")
        let domainTotals = StudyDomain.allCases.map { run.domainScore($0).total }.reduce(0,+)
        check(domainTotals == 15, "domain totals match stage")
        if !run.missed.isEmpty {
            var review = QuizRun(stage: stage, questions: run.missed, isReview: true)
            let originalScore = run.score
            for _ in review.questions {
                review.answer(review.question.correctID)
                review.next()
            }
            check(review.isComplete && review.missed.isEmpty, "review completion")
            check(!review.canAdvance, "review cannot unlock next stage")
            check(run.score == originalScore, "review cannot change original score")
        }
    }
}
var shortReview = QuizRun(stage: 0, questions: [questions[0]], isReview: true)
shortReview.answer(shortReview.question.correctID); shortReview.next()
check(shortReview.isComplete && shortReview.questionIndex == 0, "one-question review safe")
var broken = questions
broken.removeLast()
do { try StudyContent.validate(broken); fatalError("FAIL: malformed bank accepted") }
catch StudyContent.ContentError.invalidBank { }
print("PASS: 45 unique questions, 3 choices, stage boundaries, answer guards, domain scores, isolated review and malformed content")
