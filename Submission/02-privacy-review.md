# プライバシー申告の調査・候補（未確定）

2026-11-03。App Store Connectの実画面、広告管理画面、配布ArchiveのPrivacy Reportとの照合前です。以下をそのまま確定申告として扱わないでください。

## 実装と方針

- 本人決定：初回は興味・関心の独自収集なし、ATTなし。将来の追加時に実装・公開ポリシー・App Privacyを改める。
- アプリ独自のサーバー・アカウント・保存DB・独自解析SDK・StoreKit・購読・位置情報権限なし。
- 回答・正誤・分野別成績・復習対象はプロセス内だけ。ネットワークへ送信せず、終了時に消える。これらはAppleの「収集」と区別。
- 通信はAdMob/UMP、利用者が開くAWS公式資料・Googleポリシー・サポート。アプリが学習回答を広告のキーワード等に渡す実装なし。
- `ATTrackingManager`、`NSUserTrackingUsageDescription`、IDFAを直接取得するコードなし。ただしATTがないことだけでSDKのトラッキングがないと結論しない。
- 承認済み設定：Publisher first-party ID無効、Publisher Privacy Personalization Stateをdisabled、広告コンテンツ上限G。IDFAなしでもその他の端末識別子をSDKが扱い得る。
- Google Mobile Ads 13.9.0 / UMP 3.1.0。追加のメディエーションSDKはPackage.resolvedにない。AdMob管理画面の配信元・任意機能は未確認。

## 版に対応した証拠

`evidence/sdk-privacy-manifests.json` は署名なしReleaseアプリに実際に同梱された2 SDKのマニフェストを転記したもの。公式の一般的なデータ開示資料は確認時点で13.12.0を対象としているため、13.9.0の実態にそのまま置換せず、同梱版の情報と併用しています。SDK更新は今回行っていません。

アプリ独自コードでRequired Reason APIの直接利用は見つかりませんでした。SDKには必要なマニフェストが同梱されています。アプリ独自のPrivacyInfo.xcprivacyを機械的に追加せず、Archive後のPrivacy Reportと警告を確認して必要性を判断します。

- GMA：SystemBootTime `35F9.1`、UserDefaults `CA92.1`、DiskSpace `E174.1`
- UMP：UserDefaults `CA92.1`

## データ収集の回答候補

「アプリまたは第三者パートナーによるデータ収集」は **はい**。運営者が成績を収集しないことは、広告SDKを含むアプリ全体の無収集を意味しません。

表の用途と関連付けは同梱SDKマニフェストの和集合。管理画面の任意設定や実際の非パーソナライズ構成、配布Privacy Reportを照合して最終確定します。無効化によって減った収集を根拠なくゼロとは表現しません。

| データタイプ | SDK | 用途候補（すべて照合） | ユーザーに関連付け | トラッキング |
| --- | --- | --- | --- | --- |
| おおよその位置情報 | GMA・UMP | 第三者広告／デベロッパの広告またはマーケティング／解析／Appの機能 | あり（GMA） | SDK宣言はなし。最終構成の確認対象 |
| デバイスID | GMA | 第三者広告／デベロッパの広告またはマーケティング／解析 | あり | **同梱SDKはtrue**。ATTを要求しない今回構成とSDKの適用条件を照合するまで確定しない |
| 製品の操作 | GMA・UMP | 第三者広告／デベロッパの広告またはマーケティング／解析／Appの機能 | あり（GMA） | SDK宣言はなし。最終構成の確認対象 |
| 広告データ | GMA | 第三者広告／デベロッパの広告またはマーケティング／解析 | あり | SDK宣言はなし。最終構成の確認対象 |
| クラッシュデータ | GMA | 解析 | なし | SDK宣言はなし |
| パフォーマンスデータ | GMA・UMP | 第三者広告／デベロッパの広告またはマーケティング／解析／Appの機能 | なし | SDK宣言はなし |
| その他の診断データ | GMA | 第三者広告／デベロッパの広告またはマーケティング／解析 | なし | SDK宣言はなし |

デベロッパの広告・マーケティングはSDK宣言上の用途です。運営者が独自キャンペーンを実装しているという意味ではありません。最終申告時はGoogleのバージョン別開示と広告設定に対応する用途を照合します。App Functionalityに不正防止・同意処理が含まれることにも注意します。

## 現在選択しない候補（下位項目）

| 分類 | 下位項目・判断 |
| --- | --- |
| 連絡先情報 | 氏名／メールアドレス／電話番号／住所／その他の連絡先情報：アプリから収集しない |
| 健康とフィットネス | 健康／フィットネス：収集しない |
| 財務情報 | 支払い情報／信用情報／その他の財務情報：収集しない |
| 位置情報 | 正確な位置情報：収集しない。おおよその位置情報は上記SDK分を申告候補に含める |
| 機密情報 | 人種・信条・生体情報等：収集しない |
| 連絡先 | アドレス帳等：収集しない |
| ユーザコンテンツ | メールまたはテキストメッセージ／写真またはビデオ／オーディオ／ゲームプレイコンテンツ／その他のユーザコンテンツ：アプリから送信しない。カスタマーサポートは下記の別途確認対象 |
| 閲覧履歴 | 独自の閲覧履歴収集なし。広告SDKや外部リンク先の処理を無収集と断定しない |
| 検索履歴 | アプリに検索機能なし |
| ID | ユーザIDは独自に発行しない。デバイスIDは上記SDK分を申告候補に含める |
| 購入 | 購入履歴を収集しない。課金実装なし |
| 使用状況 | その他の使用状況データは独自収集なし。製品の操作・広告データは上記を参照 |
| 周囲 | 環境スキャン：利用なし |
| 身体 | 手／頭：利用なし |
| その他 | その他のデータタイプ：独自収集なし。SDK任意機能を有効にする場合は再確認 |

メールサポートでは返信先と相談内容を受け取ります。外部メールでの任意問い合わせという経路を確認し、Appleの任意開示の全条件を確認するまで、メールアドレス／カスタマーサポートを自動的に省略可能とは断定しません。公開サイトのポリシーには問い合わせ情報の取り扱いを明記済みです。

## 公開ポリシーと選択URL

- 公開ポリシー：`https://givetex.org/apps/awstady-saa/privacy/`（本番HTTP200・本文確認済み）
- 公開サポート：`https://givetex.org/apps/awstady-saa/support/`（本番HTTP200・本文確認済み）
- Privacy Choices URLは任意。専用のデータ管理ページはないため初回は未設定候補。必要なUMPプライバシー設定はアプリの情報画面に表示される構成。

## 管理画面と実機の残件

AdMobの欧州規制・米国州法等のPrivacy & messaging設定、UMPの同意と再選択、未同意・エラー時挙動、実機の広告とIDFA非取得・必要な通信、実際の配布Privacy Report、Apple画面の全データ分岐を照合してください。非パーソナライズ広告も同意管理やデータ申告が不要になるわけではありません。

## 公式根拠（2026-11-03確認）

- [Apple App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/)
- [Apple User Privacy and Data Use](https://developer.apple.com/app-store/user-privacy-and-data-use/)
- [Google App store data disclosure](https://developers.google.com/admob/ios/privacy/data-disclosure)
- [Google Privacy strategies](https://developers.google.com/admob/ios/privacy/strategies)
- [Publisher personalization state](https://developers.google.com/admob/ios/api/reference/Enums/GADPublisherPrivacyPersonalizationState.html)
- [Google personalized and non-personalized ads](https://support.google.com/admob/answer/7676680)


## 2026-11-03 公開時の追加確認

公開URLは確定。アプリ内ポリシーリンクとサポートリンクは適用済みです。すべての広告リクエストに `npa=1` を追加し、PPT disabled・Publisher first-party ID無効と併用します。

GoogleのPPT公式資料は、PPTだけでは第三者による広告配信・追跡が許される場合があると明示しています。NPAはGoogle需要に対する制限を強めますが、非Google需要・RTB等には管理画面の追加条件があるため、「ATT未要求」「NPA指定」だけを根拠にトラッキングの質問を確定しません。同梱13.9.0のデバイスIDに対するTracking=trueとの適用関係について、利用中の広告配信構成に対応した確認が残っています。

この確認を行わず「トラッキングなし」と断定することも、単に保守的にTracking=trueへチェックしてATTなしのまま提出することも行いません。

公式根拠：[Google Publisher Privacy Treatment API](https://support.google.com/admob/answer/14323214)、[Apple App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/)。確認日2026-11-03。
