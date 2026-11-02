# SAA STUDY

SAA-C03（AWS Certified Solutions Architect – Associate）の設計判断を学ぶ、日本語のiPhone用3択クイズ。

## 遊び方

スタート → 3択で回答 → 全選択肢の理由・設計のポイント → 次の問題 → 結果。

- 3ステージ×15問、全45問のオリジナル問題
- 安全性14問、可用性12問、性能10問、コスト9問
- 問題と選択肢を毎回シャッフル
- 各ステージ11問以上で次へ。10問以下は同じステージに再挑戦
- 間違えた問題だけの復習、復習後も元のスコアを維持
- 分野ごとの正解数を表示
- 回答前から「次へ」の領域を確保し、回答前は無効化
- 学習自体はオフライン対応。公式資料・広告には通信が必要
- ログイン・永続保存なし。進み具合はプロセス終了でリセット

公式試験の問題数・選択肢数・採点を再現する模試ではありません。11/15はゲーム内の進行条件で、AWS試験の合否やスケールドスコアに対応しません。本アプリはAWSによる提供・承認を受けたものではありません。

## 起動

`SAAStudy.xcodeproj` をXcodeで開き、`SAAStudy` スキームとiPhoneシミュレーターを選んで実行。iOS 17以降、iPhone縦画面に対応。

実機では自分のApple Developer Teamを選び、Bundle IDの登録と署名設定を確認してください。

- Bundle ID：`com.benkei.saastudy`
- バージョン：1.0 / ビルド1
- 表示名：SAA STUDY

## 出題内容

[公式試験ガイド](https://docs.aws.amazon.com/aws-certification/latest/solutions-architect-associate-03.html)の4分野を参考にしています。各問題の`sourceURL`からサービスの公式資料を参照できます。

問題は `SAAStudy/Questions.json`。正解だけでなく、すべての選択肢に理由を記述しています。サービスの変更に合わせて見直してください。45問ですべての試験範囲を網羅するものではありません。

## 広告と配信準備

Google Mobile Ads SDK 13.9.0とUMPをSwift Package Managerで導入。結果画面から移動するときに広告を表示し、読み込めない場合は直ちに進みます。復習中・出題中に全画面広告は出しません。

**Debug・ReleaseともGoogleのテスト広告IDです。本番配信前に、このアプリ専用のAdMobアプリ／広告ユニットを作り、Releaseの `ADMOB_APP_ID` と `ADMOB_INTERSTITIAL_UNIT_ID` を置き換えてください。AWSCLISTUDYの本番IDは使用していません。**

本番IDを設定した場合は、UMPで同意情報を取得してから広告を読み込みます。必要な場合、「学習とプライバシー」から広告設定を変更できます。

`PRIVACY.md` は公開用ポリシー原稿です。公開先URLの設定、広告を含むApp Privacy・年齢制限の申告（広告あり）、app-ads.txt、App Store Connectの新アプリ登録が必要です。App Storeへのアップロード・審査提出はまだ行っていません。

## テスト

```sh
swiftc SAAStudy/StudyModel.swift Tests/main.swift -o /tmp/saastudy-tests
/tmp/saastudy-tests SAAStudy/Questions.json
```

45問の構造、3択と正解の一意性、未回答／二重回答防止、10/11の境界、分野別成績、復習と元スコアの分離、不正データを検証します。
