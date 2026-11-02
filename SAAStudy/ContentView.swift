import SwiftUI
import UIKit

private enum Palette {
    static let background = Color(red: 0.045, green: 0.075, blue: 0.12)
    static let card = Color(red: 0.085, green: 0.125, blue: 0.18)
    static let amber = Color(red: 1.0, green: 0.69, blue: 0.29)
    static let mint = Color(red: 0.36, green: 0.87, blue: 0.73)
    static let red = Color(red: 1.0, green: 0.48, blue: 0.43)
    static let muted = Color(red: 0.64, green: 0.70, blue: 0.79)
}

struct ContentView: View {
    @State private var bank: [StudyQuestion] = []
    @State private var loadError: String?
    @State private var run: QuizRun?
    @State private var review: QuizRun?
    @State private var scores: [Int] = []
    @State private var showsAbout = false
    @State private var showsQuit = false
    @State private var transitioning = false
    @StateObject private var ads = InterstitialAds()

    var body: some View {
        Group {
            if loadError != nil { errorPage }
            else if bank.isEmpty { ProgressView("問題を準備中") }
            else if let review {
                if review.isComplete { reviewResult(review) }
                else { quizPage(review) }
            } else if let run {
                if run.isComplete { resultPage(run) }
                else { quizPage(run) }
            } else { homePage }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background.ignoresSafeArea())
        .foregroundStyle(.white)
        .tint(Palette.amber)
        .preferredColorScheme(.dark)
        .task { loadQuestions() }
        .sheet(isPresented: $showsAbout) { AboutView(ads: ads) }
        .confirmationDialog("今回の進み具合をリセットして戻りますか？", isPresented: $showsQuit, titleVisibility: .visible) {
            Button("スタートに戻る", role: .destructive) { reset() }
            Button("続ける", role: .cancel) { }
        }
    }

    private var homePage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                HStack {
                    Text("CLOUD ARCHITECTURE").font(.caption.weight(.bold)).tracking(2)
                    Spacer()
                    Button { showsAbout = true } label: {
                        Image(systemName: "info.circle").font(.title3).padding(10)
                    }
                    .accessibilityLabel("学習とプライバシーについて")
                }
                .foregroundStyle(Palette.muted)
                Image("BrandMark")
                    .resizable().scaledToFit().frame(width: 88, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 12) {
                    Text("SAA STUDY")
                        .font(.system(size: 43, weight: .heavy, design: .rounded))
                        .tracking(-1.5).minimumScaleFactor(0.65).lineLimit(1)
                    HStack(spacing: 8) {
                        Text("SAA-C03").font(.subheadline.monospaced().weight(.bold)).foregroundStyle(Palette.amber)
                        Text("Solutions Architect · Associate").font(.caption).foregroundStyle(Palette.muted)
                    }
                    Text("その構成を選ぶ、\n理由がわかる。")
                        .font(.system(size: 29, weight: .semibold))
                        .lineSpacing(5).padding(.top, 12)
                    Text("3択で考える、クラウドの設計。")
                        .font(.subheadline).foregroundStyle(Palette.muted)
                }
                HStack(spacing: 0) {
                    homeMetric("3", "ステージ")
                    Rectangle().fill(.white.opacity(0.12)).frame(width: 1, height: 32)
                    homeMetric("45", "オリジナル問題")
                    Rectangle().fill(.white.opacity(0.12)).frame(width: 1, height: 32)
                    homeMetric("4", "学習分野")
                }
                .padding(.vertical, 20)
                .background(Palette.card, in: RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(0..<3) { stage in
                        HStack(spacing: 14) {
                            Text(String(format: "%02d", stage + 1))
                                .font(.caption.monospaced().weight(.bold)).foregroundStyle(Palette.amber)
                            Text(StudyContent.stageTitles[stage]).font(.subheadline.weight(.medium))
                            Spacer()
                            Text("15問").font(.caption).foregroundStyle(Palette.muted)
                        }
                    }
                }
                Text("答え合わせの後は、選択肢ごとの理由を確認。\n間違えた問題だけを、もう一度。")
                    .font(.footnote).foregroundStyle(Palette.muted).lineSpacing(4)
            }
            .padding(24)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 12) {
                PrimaryAction(title: "はじめる", symbol: "arrow.right") { start(stage: 0) }
                Text("3択の学習用問題です。公式試験の出題形式とは異なります。")
                    .font(.caption2).foregroundStyle(Palette.muted).multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24).padding(.top, 16).padding(.bottom, 12)
            .frame(maxWidth: 560).frame(maxWidth: .infinity)
            .background(Palette.background)
        }
    }

    private func homeMetric(_ value: String, _ label: String) -> some View {
        VStack(spacing: 5) {
            Text(value).font(.title2.monospacedDigit().bold())
            Text(label).font(.caption2).foregroundStyle(Palette.muted)
        }.frame(maxWidth: .infinity)
    }

    private func quizPage(_ active: QuizRun) -> some View {
        VStack(spacing: 0) {
            quizHeader(active)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        Color.clear.frame(height: 0).id("questionTop")
                        domainBadge(active.question.domain)
                        Text(active.question.prompt)
                            .font(.system(size: 24, weight: .semibold))
                            .lineSpacing(5).fixedSize(horizontal: false, vertical: true)
                            .accessibilityAddTraits(.isHeader)
                        if active.selectedID != nil { explanation(active) }
                    }
                    .padding(.horizontal, 24).padding(.bottom, 20)
                    .frame(maxWidth: 560, alignment: .leading)
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: active.question.id) { _, _ in proxy.scrollTo("questionTop", anchor: .top) }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { choicesPanel(active) }
        .task { await ads.prepare() }
    }

    private func quizHeader(_ active: QuizRun) -> some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(active.isReview ? "REVIEW" : "STAGE \(String(format: "%02d", active.stage + 1))")
                        .font(.caption2.monospaced().bold()).tracking(1.5).foregroundStyle(Palette.amber)
                    Text(active.isReview ? "間違えた問題" : StudyContent.stageTitles[active.stage])
                        .font(.subheadline.weight(.semibold))
                }
                Spacer()
                Text("\(active.questionIndex + 1) / \(active.questions.count)")
                    .font(.subheadline.monospacedDigit()).foregroundStyle(Palette.muted)
                Button { showsQuit = true } label: {
                    Image(systemName: "xmark").font(.subheadline.weight(.semibold)).padding(12)
                }
                .accessibilityLabel("学習を終了する")
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.10))
                    Capsule().fill(Palette.amber).frame(width: max(0, geometry.size.width * active.progress))
                }
            }
            .frame(height: 4)
            .accessibilityLabel("進み具合")
            .accessibilityValue("\(Int(active.progress * 100))パーセント")
        }
        .padding(24).padding(.bottom, 2)
        .frame(maxWidth: 560).frame(maxWidth: .infinity)
    }

    private func domainBadge(_ domain: StudyDomain) -> some View {
        Label(domain.title, systemImage: domain.symbol)
            .font(.caption.weight(.semibold)).foregroundStyle(Palette.mint)
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(Palette.mint.opacity(0.10), in: Capsule())
    }

    private func choicesPanel(_ active: QuizRun) -> some View {
        VStack(spacing: 10) {
            ForEach(Array(active.choices.enumerated()), id: \.element.id) { index, choice in
                choiceButton(choice, index: index, active: active)
            }
            PrimaryAction(
                title: active.isLast ? (active.isReview ? "復習の結果を見る" : "結果を見る") : "次の問題",
                symbol: "arrow.right",
                enabled: active.selectedID != nil
            ) { nextQuestion() }
            .padding(.top, 3)
        }
        .padding(.horizontal, 24).padding(.top, 14).padding(.bottom, 12)
        .frame(maxWidth: 560).frame(maxWidth: .infinity)
        .background(Palette.background)
    }

    private func choiceButton(_ choice: StudyChoice, index: Int, active: QuizRun) -> some View {
        let answered = active.selectedID != nil
        let correct = answered && choice.id == active.question.correctID
        let wrong = answered && choice.id == active.selectedID && !correct
        let border = correct ? Palette.mint : wrong ? Palette.red : Color.white.opacity(0.14)
        return Button { answer(choice.id) } label: {
            HStack(alignment: .center, spacing: 12) {
                Text(["A", "B", "C"][index])
                    .font(.caption.monospaced().bold())
                    .foregroundStyle(correct ? Palette.mint : Palette.muted)
                    .frame(width: 25, height: 28)
                    .background(.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 7))
                Text(choice.text)
                    .font(.system(size: 15, weight: .medium))
                    .lineSpacing(2).fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(correct ? Palette.mint : Palette.red)
                    .opacity(correct || wrong ? 1 : 0).accessibilityHidden(true)
            }
            .padding(.horizontal, 14).padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 60)
            .foregroundStyle(answered && !correct && !wrong ? Palette.muted : .white)
            .background(correct ? Palette.mint.opacity(0.08) : Palette.card, in: RoundedRectangle(cornerRadius: 16))
            .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(border, lineWidth: correct || wrong ? 1.5 : 1) }
            .contentShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(AnswerButtonStyle()).disabled(answered)
        .accessibilityLabel(choice.text + (correct ? "、正解" : wrong ? "、選んだ回答、不正解" : ""))
    }

    private func explanation(_ active: QuizRun) -> some View {
        let correct = active.selectedID == active.question.correctID
        return VStack(alignment: .leading, spacing: 18) {
            Label(correct ? "正解" : "もう一歩", systemImage: correct ? "checkmark.circle.fill" : "arrow.counterclockwise.circle.fill")
                .font(.headline).foregroundStyle(correct ? Palette.mint : Palette.amber)
            VStack(alignment: .leading, spacing: 7) {
                Text("設計のポイント").font(.caption.weight(.bold)).foregroundStyle(Palette.amber)
                Text(active.question.takeaway).font(.subheadline.weight(.semibold)).lineSpacing(4)
            }
            ForEach(active.question.choices) { choice in
                VStack(alignment: .leading, spacing: 7) {
                    HStack(alignment: .top, spacing: 7) {
                        Image(systemName: choice.id == active.question.correctID ? "checkmark" : "minus")
                            .foregroundStyle(choice.id == active.question.correctID ? Palette.mint : Palette.muted)
                        Text(choice.text).font(.footnote.weight(.semibold))
                    }
                    Text(choice.reason).font(.footnote).foregroundStyle(Palette.muted).lineSpacing(4)
                }
            }
            if let url = URL(string: active.question.sourceURL) {
                Link(destination: url) {
                    Label("AWS公式資料で確認", systemImage: "arrow.up.right.square").font(.footnote.weight(.medium))
                }
            }
            Text("解説を確認したら、下のボタンで次へ。")
                .font(.caption2).foregroundStyle(Palette.muted)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Palette.card, in: RoundedRectangle(cornerRadius: 18))
    }

    private func resultPage(_ completed: QuizRun) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("STAGE \(String(format: "%02d", completed.stage + 1))  /  RESULT")
                    .font(.caption.monospaced().bold()).tracking(1.5).foregroundStyle(Palette.amber)
                Text(completed.canAdvance ? "ステージクリア" : "もう一度、設計しよう。")
                    .font(.largeTitle.bold()).accessibilityAddTraits(.isHeader)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("\(completed.score)")
                        .font(.system(size: 84, weight: .bold, design: .rounded)).foregroundStyle(Palette.amber)
                    Text("/ 15 問正解").font(.headline).foregroundStyle(Palette.muted)
                }
                Text(StudyContent.stageTitles[completed.stage])
                    .font(.title3.weight(.semibold))
                if completed.stage == 2 && completed.canAdvance {
                    Label("3ステージ完了 · 合計 \(scores.reduce(0, +) + completed.score) / 45", systemImage: "flag.checkered")
                        .font(.headline).foregroundStyle(Palette.mint)
                }
                domainResults(completed)
                Text("11問以上で次のステージへ。\nこれは学習ゲームの目安で、AWS試験の合否判定ではありません。")
                    .font(.caption).foregroundStyle(Palette.muted).lineSpacing(4)
            }
            .padding(24).frame(maxWidth: 560, alignment: .leading).frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 12) {
                if !completed.missed.isEmpty {
                    Button { startReview(completed) } label: {
                        Label("間違えた\(completed.missed.count)問を復習", systemImage: "arrow.counterclockwise")
                            .font(.subheadline.weight(.semibold)).frame(maxWidth: .infinity).padding(16)
                            .foregroundStyle(Palette.mint)
                            .background(Palette.mint.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain).disabled(transitioning)
                }
                if completed.canAdvance {
                    PrimaryAction(title: completed.stage == 2 ? "スタートに戻る" : "次のステージへ", symbol: "arrow.right", enabled: !transitioning) {
                        leaveResult {
                            if completed.stage == 2 { reset() }
                            else { scores.append(completed.score); start(stage: completed.stage + 1) }
                        }
                    }
                } else {
                    PrimaryAction(title: "同じステージに再挑戦", symbol: "arrow.clockwise", enabled: !transitioning) {
                        leaveResult { start(stage: completed.stage) }
                    }
                }
                if !(completed.stage == 2 && completed.canAdvance) {
                    Button("スタートに戻る") { leaveResult { reset() } }
                        .font(.footnote).foregroundStyle(Palette.muted).padding(5).disabled(transitioning)
                }
            }
            .padding(24).frame(maxWidth: 560).frame(maxWidth: .infinity).background(Palette.background)
        }
    }

    private func domainResults(_ completed: QuizRun) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("分野別のふりかえり").font(.subheadline.weight(.semibold))
            ForEach(StudyDomain.allCases, id: \.self) { domain in
                let score = completed.domainScore(domain)
                if score.total > 0 {
                    VStack(spacing: 9) {
                        HStack {
                            Label(domain.title, systemImage: domain.symbol).font(.footnote)
                            Spacer()
                            Text("\(score.correct) / \(score.total)").font(.footnote.monospacedDigit()).foregroundStyle(Palette.muted)
                        }
                        ProgressView(value: Double(score.correct), total: Double(score.total)).tint(Palette.mint)
                    }
                }
            }
        }
        .padding(20).background(Palette.card, in: RoundedRectangle(cornerRadius: 20))
    }

    private func reviewResult(_ completed: QuizRun) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "arrow.counterclockwise.circle.fill").font(.system(size: 56)).foregroundStyle(Palette.mint)
            Text("復習、おつかれさま。") .font(.title.bold())
            Text("\(completed.questions.count)問中 \(completed.score)問正解")
                .font(.title2.monospacedDigit().weight(.semibold))
            Text("ステージの成績は変わりません。\n理由を覚えて、次の挑戦へ。")
                .font(.subheadline).foregroundStyle(Palette.muted).multilineTextAlignment(.center)
            PrimaryAction(title: "ステージの結果へ", symbol: "arrow.right") { review = nil }
            if !completed.missed.isEmpty {
                Button("残り\(completed.missed.count)問をもう一度") {
                    review = QuizRun(stage: completed.stage, questions: completed.missed, isReview: true)
                }.font(.subheadline).padding(12)
            }
        }
        .padding(24).frame(maxWidth: 560)
    }

    private var errorPage: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle").font(.largeTitle).foregroundStyle(Palette.amber)
            Text("問題を読み込めませんでした").font(.headline)
            Text("アプリを再起動するか、サポートへお問い合わせください。")
                .font(.subheadline).foregroundStyle(Palette.muted).multilineTextAlignment(.center)
            Button("再読み込み") { loadQuestions() }
        }.padding(24)
    }

    private func loadQuestions() {
        guard bank.isEmpty else { return }
        do {
            guard let url = Bundle.main.url(forResource: "Questions", withExtension: "json") else {
                throw StudyContent.ContentError.invalidBank
            }
            bank = try StudyContent.load(from: url)
            loadError = nil
        } catch { loadError = error.localizedDescription }
    }
    private func start(stage: Int) {
        review = nil
        run = QuizRun(stage: stage, questions: bank.filter { $0.stage == stage })
    }
    private func reset() { review = nil; run = nil; scores = [] }
    private func startReview(_ completed: QuizRun) {
        guard !completed.missed.isEmpty else { return }
        review = QuizRun(stage: completed.stage, questions: completed.missed, isReview: true)
    }
    private func answer(_ id: String) {
        if review != nil { review?.answer(id) }
        else { run?.answer(id) }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    private func nextQuestion() {
        if review != nil { review?.next() }
        else { run?.next() }
    }
    private func leaveResult(_ action: @escaping () -> Void) {
        guard !transitioning else { return }
        transitioning = true
        ads.show { action(); transitioning = false }
    }
}

private struct AnswerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.opacity(configuration.isPressed ? 0.86 : 1)
    }
}

private struct PrimaryAction: View {
    let title: String
    var symbol = "arrow.right"
    var enabled = true
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title).font(.system(size: 16, weight: .bold))
                Spacer(minLength: 8)
                Image(systemName: symbol).font(.headline)
            }
            .padding(.horizontal, 20).padding(.vertical, 18)
            .frame(maxWidth: .infinity, minHeight: 56)
            .foregroundStyle(enabled ? Palette.background : Palette.muted)
            .background(enabled ? Palette.amber : Palette.card, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain).disabled(!enabled)
    }
}

private struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var ads: InterstitialAds
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    section("このアプリについて", "SAA-C03の公式出題範囲を参考にした、非公式の学習用3択クイズです。問題はオリジナルで、公式試験問題ではありません。公式試験の問題数・選択肢数・採点方式を再現するものではなく、合格を保証しません。Amazon Web Servicesによる提供・承認は受けていません。")
                    section("学習の進め方", "各ステージ15問。11問以上正解すると次へ進めます。復習では間違えた問題だけを出題し、元のステージ成績は変更しません。問題順と選択肢は毎回シャッフルされます。")
                    Link("SAA-C03 公式試験ガイド", destination: URL(string: "https://docs.aws.amazon.com/aws-certification/latest/solutions-architect-associate-03.html")!)
                    section("学習データとプライバシー", "回答と成績はアプリの実行中だけ端末内で扱い、運営者のサーバーへ送信しません。永続保存やアカウント登録はありません。アプリを終了すると進み具合はリセットされます。")
                    section("広告", "Google AdMobを利用します。結果画面から次のステージ・再挑戦・スタート画面へ移動するときに全画面広告を表示する場合があります。読み込みに失敗した場合は待たずに進めます。広告SDKはIPアドレス、端末識別子、広告の表示・操作情報、診断や性能情報などを扱う場合があります。IPアドレスからおおよその地域を推定する場合があります。")
                    Text("必要な地域では同意画面を表示します。本アプリはトラッキング許可を要求しません。")
                        .font(.subheadline).foregroundStyle(.secondary)
                    Link("Googleのプライバシーポリシー", destination: URL(string: "https://policies.google.com/privacy?hl=ja")!)
                    if ads.privacyOptionsRequired {
                        Button("広告のプライバシー設定") { Task { await ads.showPrivacyOptions() } }
                    }
                    Link("サポート", destination: URL(string: "https://github.com/Ben-Kei-create/awsstudy_saa/issues")!)
                    Text("公開の問い合わせには個人情報を書き込まないでください。")
                        .font(.caption).foregroundStyle(.secondary)
                }.padding(24)
            }
            .navigationTitle("学習とプライバシー")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("閉じる") { dismiss() } } }
        }
        .preferredColorScheme(.dark)
    }
    private func section(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(.headline)
            Text(body).font(.subheadline).foregroundStyle(.secondary).lineSpacing(4)
        }
    }
}

#Preview { ContentView() }
