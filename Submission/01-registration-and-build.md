# App ID登録とビルドの準備（本人操作用・未登録）

2026-11-03。完成版の申請キットではありません。管理画面は操作していません。

## ビルド種別

**iOS App → Release Archive → App Store Connect配布**。XcodeのSchemeは `SAAStudy`、Archive ActionはRelease。対象はiPhoneのみ、iOS 17以降、縦画面です。SimulatorやDebugのビルドは提出対象になりません。

| 項目 | 確認した値 |
| --- | --- |
| ソース | `/Applications/AWSCLIapp/SAAStudy` |
| プロジェクト | `SAAStudy.xcodeproj` |
| Scheme / Target | `SAAStudy` |
| 表示名 | `AWSSTUDY(SAA)` |
| Bundle ID | `com.fumiaki.awsstudysaa` |
| Team設定 | `7R927F3U4V`（本人のDeveloperアカウントで一致を確認） |
| 署名方式 | Automatically manage signing / Automatic |
| バージョン / ビルド | `1.0` / `1` |
| Archive | 未実行。今回承認されていないため実行していません |
| アップロード・ビルド選択 | 未実施。本人操作 |

## 1. Register an App ID

Apple DeveloperのCertificates, Identifiers & Profiles → Identifiers → ＋ → App IDs → App。

- Description：`AWSSTUDY SAA`
- Bundle ID：Explicit
- Bundle IDの入力値：`com.fumiaki.awsstudysaa`
- Capabilities：このアプリのために追加で有効化するものはありません。Push Notifications、Sign in with Apple、App Groups、iCloud、Game Centerなどを選択しません。
- Explicit App IDでIn-App Purchaseがデフォルト表示されても、実装に課金機能があることは意味しません。本アプリにはStoreKit商品・購読はありません。
- 最後に登録情報とTeamを確認し、本人がRegisterを実行してください。

## 2. App Store Connectのアプリレコード

App Store Connectのアカウント登録済み、対象アプリのApp ID／アプリレコードは未登録として扱っています。

- Platform：iOS
- Name：`AWSSTUDY(SAA)`（名称の空きは管理画面で確認）
- Primary language：Japanese
- Bundle ID：上で登録した `com.fumiaki.awsstudysaa`
- SKU：`awsstudysaa-ios-001`（本人指定値）
- User Access：既存ユーザーのアクセスを変更しません。新規アプリ作成時の画面で本人が対象を確認してください。

## 3. 配布用署名とArchive

App ID登録後、Xcodeでプロジェクトを開き、SAAStudyターゲットのSigning & CapabilitiesでTeam・Bundle IDを照合します。自動署名が配布用証明書とプロファイルを取得できることを本人が確認してください。

実機での主要操作を確認後、実機向けの一般的な宛先（Any iOS Device / Generic iOS Device相当）を選んでProduct → Archive。OrganizerでApp Store Connect向けの配布を選択します。証明書・プロファイル作成、Archive、検証、アップロード、ビルド選択、審査送信は今回未実施です。

自動公開は本人決定済みです。審査通過後に自動で公開する設定なので、審査送信前に公開可能な状態かを確認してください。

## 確認資料

- [Register an App ID](https://developer.apple.com/help/account/identifiers/register-an-app-id)
- [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
- [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/)

確認日：2026-11-03。
