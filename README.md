# AWSSTUDY(SAA)

SAA-C03（AWS Certified Solutions Architect – Associate）の設計判断を学ぶ、日本語のiPhone用3択クイズ。

## 遊び方

スタート → 3択で回答 → 全選択肢の理由・設計のポイント → 次の問題 → 結果。

- 3ステージ×15問、全45問のオリジナル問題
- 安全性14問、可用性12問、性能10問、コスト9問
- 問題と選択肢を毎回シャッフル
- 各ステージ11問以上で次へ。10問以下は「やり直す」から同じステージに再挑戦
- 間違えた問題だけの復習、復習後も元のスコアを維持
- 分野ごとの正解数を表示
- 回答前から「次へ」の領域を確保し、回答前は無効化
- 学習自体はオフライン対応。公式資料・広告には通信が必要
- ログイン・永続保存なし。進み具合はプロセス終了でリセット

公式試験の問題数・選択肢数・採点を再現する模試ではありません。11/15はゲーム内の進行条件で、AWS試験の合否やスケールドスコアに対応しません。本アプリはAWSによる提供・承認を受けたものではありません。

## 起動

`SAAStudy.xcodeproj` をXcodeで開き、`SAAStudy` スキームとiPhoneシミュレーターを選んで実行。iOS 17以降、iPhone縦画面に対応。

実機では自分のApple Developer Teamを選び、Bundle IDの登録と署名設定を確認してください。

- Bundle ID：`com.fumiaki.awsstudysaa`
- バージョン：1.0 / ビルド1
- 表示名：AWSSTUDY(SAA)

## 出題内容

[公式試験ガイド](https://docs.aws.amazon.com/aws-certification/latest/solutions-architect-associate-03.html)の4分野を参考にしています。各問題の`sourceURL`からサービスの公式資料を参照できます。

問題は `SAAStudy/Questions.json`。正解だけでなく、すべての選択肢に理由を記述しています。2026-11-02に公式資料の本文と設計条件を照合しました。確認内容は [CONTENT_REVIEW.md](CONTENT_REVIEW.md) を参照してください。サービスの変更に合わせて見直してください。45問ですべての試験範囲を網羅するものではありません。

## 広告と配信準備

Google Mobile Ads SDK 13.9.0とUMPをSwift Package Managerで導入。結果画面から移動するときに広告を表示し、読み込めない場合は直ちに進みます。復習中・出題中に全画面広告は出しません。

**DebugはGoogleのテスト広告ID、Releaseは本人提供のAWSSTUDY(SAA)専用AdMobアプリ／インタースティシャルIDです。バナー広告ユニットは使用しません。AWSCLISTUDYの本番広告ユニットを流用していません。**

初回リリースはPublisher first-party IDを無効化し、PPT disabledと各リクエストのnpa=1で非パーソナライズ扱い、広告コンテンツ上限Gを設定しています。SDKの診断・不正防止等のデータ処理は残るため、配布前にAdMobの同意メッセージ、地域設定、App Privacy、実機挙動を照合してください。

本番IDを設定した場合は、スタート画面でUMPの同意情報を取得してから広告を読み込みます。出題画面で同意フォームを開始しません。必要な場合、「学習とプライバシー」から広告設定を変更できます。

`PRIVACY.md` は公開用ポリシー原稿です。公開先URLの設定、広告を含むApp Privacy・年齢制限の申告（広告あり）、app-ads.txt、App Store Connectの新アプリ登録が必要です。App Storeへのアップロード・審査提出はまだ行っていません。

## テスト

```sh
swiftc SAAStudy/StudyModel.swift Tests/main.swift -o /tmp/saastudy-tests
/tmp/saastudy-tests SAAStudy/Questions.json
```

45問の構造、3択と正解の一意性、未回答／二重回答防止、10/11の境界、分野別成績、復習と元スコアの分離、不正データを検証します。


XcodeのTest（⌘U）または次のコマンドでUIテストを実行できます。

```sh
xcodebuild test -project SAAStudy.xcodeproj -scheme SAAStudy \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' CODE_SIGNING_ALLOWED=NO
```

UIテストは実際の画面で回答・採点・10/11問の分岐・再挑戦・誤答復習と再復習・全3ステージの完了・終了確認を操作します。選択肢の回答前後の座標も検証します。テスト実行時だけDebugの起動引数`-ui-testing-no-ads`で広告の読込を抑止し、広告未読込でも画面遷移できることを確認します。通常のDebug起動はテスト広告ID、Releaseは専用の本番IDでAdMobを使用します。

アイコンは提供されたクラウド／チェック画像に「SAA」を追加。制作プロンプトは [Design/icon-prompt.md](Design/icon-prompt.md) に記録しています。

申請準備の原稿・提出画像・本人操作手順と未完了項目は [Submission/README.md](Submission/README.md) にまとめています。完成版の申請キットではありません。

本番サイトを公開済み：[紹介](https://givetex.org/apps/awstady-saa/)／[サポート](https://givetex.org/apps/awstady-saa/support/)／[プライバシー](https://givetex.org/apps/awstady-saa/privacy/)。2026-11-03にHTTP200と表示を確認しました。
