import XCTest

final class StudyFlowTests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing-no-ads"]
        app.launch()
        XCTAssertTrue(app.buttons["start"].waitForExistence(timeout: 10))
    }

    private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Exercise real shuffled questions, disabled actions, stable answer frames and scoring.
    private func finishRun(count: Int, correctCount: Int, captureFirst: Bool = false) {
        for index in 0..<count {
            let next = app.buttons["next"]
            XCTAssertTrue(next.waitForExistence(timeout: 5))
            XCTAssertFalse(next.isEnabled)
            let choices = ["a", "b", "c"].map { app.buttons["choice-" + $0] }
            XCTAssertTrue(choices.allSatisfy { $0.exists && $0.isHittable })
            let frames = choices.map(\.frame)
            if captureFirst && index == 0 { capture("02-question") }
            // All original bank questions currently use a as their keyed answer; UI order shuffles.
            app.buttons[index < correctCount ? "choice-a" : "choice-b"].tap()
            XCTAssertTrue(next.isEnabled)
            XCTAssertTrue(app.staticTexts["設計のポイント"].isHittable)
            for (choice, frame) in zip(choices, frames) {
                XCTAssertFalse(choice.isEnabled)
                XCTAssertEqual(choice.frame.minY, frame.minY, accuracy: 1)
                XCTAssertEqual(choice.frame.height, frame.height, accuracy: 1)
            }
            if captureFirst && index == 0 { capture("03-answer") }
            next.tap()
        }
    }

    func testStageProgressionAndIsolatedReview() {
        capture("01-start")
        app.buttons["start"].tap()
        finishRun(count: 15, correctCount: 10, captureFirst: true)
        XCTAssertEqual(app.staticTexts["stageScore"].label, "10")
        XCTAssertTrue(app.buttons["やり直す"].exists)
        XCTAssertFalse(app.buttons["次のステージへ"].exists)
        capture("04-result")
        app.buttons["review"].tap()
        finishRun(count: 5, correctCount: 4)
        XCTAssertTrue(app.staticTexts["5問中 4問正解"].exists)
        app.buttons["残り1問をもう一度"].tap()
        finishRun(count: 1, correctCount: 1)
        app.buttons["returnToResult"].tap()
        XCTAssertEqual(app.staticTexts["stageScore"].label, "10")
        app.buttons["やり直す"].tap() // An unloaded ad must not block this transition.
        finishRun(count: 15, correctCount: 11)
        XCTAssertEqual(app.staticTexts["stageScore"].label, "11")
        app.buttons["次のステージへ"].tap()
        finishRun(count: 15, correctCount: 11)
        app.buttons["次のステージへ"].tap()
        finishRun(count: 15, correctCount: 15)
        XCTAssertTrue(app.staticTexts["3ステージ完了 · 合計 37 / 45"].exists)
        XCTAssertFalse(app.buttons["review"].exists)
        app.buttons["スタートに戻る"].tap()
        XCTAssertTrue(app.buttons["start"].exists)
    }

    func testFirstStageLayoutAndFeedback() {
        capture("compact-01-start")
        app.buttons["start"].tap()
        finishRun(count: 15, correctCount: 15, captureFirst: true)
        XCTAssertEqual(app.staticTexts["stageScore"].label, "15")
        XCTAssertFalse(app.buttons["review"].exists)
    }

    func testQuitAndAbout() {
        app.buttons["学習とプライバシーについて"].tap()
        XCTAssertTrue(app.navigationBars["学習とプライバシー"].waitForExistence(timeout: 3))
        app.buttons["閉じる"].tap()
        app.buttons["start"].tap()
        app.buttons["学習を終了する"].tap()
        app.buttons["続ける"].tap()
        XCTAssertTrue(app.buttons["next"].exists)
        app.buttons["学習を終了する"].tap()
        app.buttons["スタートに戻る"].tap()
        XCTAssertTrue(app.buttons["start"].exists)
    }
}
