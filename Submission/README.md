# AWSSTUDY(SAA) 申請準備（未完了）

2026-11-03。完成版のApp Store申請キットは、必須条件が整うまで出力しません。Apple／AdMob管理画面の操作、Archive、アップロード、審査送信は行っていません。

## 決定事項

- 名前：AWSSTUDY(SAA)。Bundle IDは本人指定の `com.fumiaki.awsstudysaa` に更新。
- iOS App／iPhoneのみ／iOS17以降。提出用はRelease Archive → App Store Connect。
- 無料・アプリ内課金なし、全世界配信、審査承認後に自動公開。
- 初回は興味・関心の独自収集なし・ATTなし。トレーダー。
- 元アイコンは使用・改変権限あり。SAA文字入りを使用。
- Releaseの専用AdMobアプリID：`ca-app-pub-4859622277330192~4404081101`
- ReleaseのインタースティシャルID：`ca-app-pub-4859622277330192/7934638717`
- DebugはGoogleのテストIDを維持。提供されたバナーIDは実装に使用しない。
- 承認済みの広告設定：Publisher first-party ID無効、PPT disabled、広告リクエストにnpa=1、広告コンテンツ上限G。

## 作成済み

| 成果物 | 保存先 |
| --- | --- |
| App ID登録とビルド種別、本人操作手順 | [01-registration-and-build.md](01-registration-and-build.md) |
| SDK・全データ分類・申告候補と未確認条件 | [02-privacy-review.md](02-privacy-review.md) |
| 年齢制限・権利・暗号化・配信・アクセシビリティ等の候補 | [03-store-form-candidates.md](03-store-form-candidates.md) |
| 管理画面と実機の確認項目 | [04-device-checklist.md](04-device-checklist.md) |
| 説明文・サブタイトル・キーワード・審査メモ等 | `drafts/` |
| 上限と実測値 | [metadata-counts.json](metadata-counts.json) |
| 今回の6.1・6.3インチ枠用6枚（JPEG・1206×2622・透過なし） | `screenshots/iphone-6.3/` |
| 画像の検証情報 | [screenshots/manifest.json](screenshots/manifest.json) |
| Releaseの実際の識別情報 | [evidence/release-build-info.json](evidence/release-build-info.json) |
| 同梱SDKのマニフェスト | [evidence/sdk-privacy-manifests.json](evidence/sdk-privacy-manifests.json) |
| 公式資料と確認日 | [official-sources.md](official-sources.md) |
| 承認を受けて適用済みのアプリ内リンク変更 | [evidence/applied-published-site-links.patch](evidence/applied-published-site-links.patch) |
| 本人指定の審査連絡先（ローカル・Git対象外） | `private/review-contact.json` |

## GiveTex

作業場所：`/Applications/GiveTeX`、ブランチ `codex/saa-study-pages`。

- [PR #16](https://github.com/Ben-Kei-create/GiveTeX/pull/16)（2026-11-03に承認を受けてマージ・公開済み）
- [Vercelプレビュー](https://give-te-x-git-codex-saa-study-pages-ben-kei-creates-projects.vercel.app/apps/awstady-saa/)（Vercel認証が必要）
- トップ／サポート／プライバシーの静的HTMLと実画面6枚のWeb縮小版を作成。
- 1440px・390px幅で表示確認、画像読込成功、ページ全体の横はみ出しなし。各内部リンク・画像属性・サイトマップXMLを検証。
- 提出用の元画像はサイトへ追加せず、幅480pxのJPEGと256pxのアイコンのみ使用。
- VercelのCI成功を確認。プレビューの接続権限はなかったため、本番公開後に1440px・390px幅で本文・画像・リンクを直接検証しました。保護設定は変更していません。
- 本番URLは `/apps/awstady-saa/`、`support/`、`privacy/`。2026-11-03に3ページのHTTP200とAWSSTUDY(SAA)の本文を確認済み。
- `https://givetex.org/app-ads.txt` はwwwホストへのリダイレクト後にHTTP200。`pub-4859622277330192` の行と一致。AdMob管理画面での確認完了は別途必要。

## 確認状況と残る完了条件

| 残件 | 必要な対応・完了条件 |
| --- | --- |
| App ID／アプリレコード | 本人が登録し、Bundle ID・Team・名前を照合 |
| サイトの公開 | **完了**。2026-11-03に公開承認を受けてPR #16をマージ。3ページの本番HTTP200・本文・画像を確認 |
| アプリ内ポリシーURL | **完了**。公開後リンクを適用し、2サイズのUIテストで情報画面のリンク表示を確認 |
| 広告・同意・プライバシー | AdMobの地域別設定／配信元／app-ads確認状態、必要な同意画面、実機挙動、ArchiveのPrivacy ReportとApp Privacyの全分岐を照合 |
| 対応端末と実機 | 本人が実機で主要フロー・広告を確認。iOS17の最小OS環境は未検証 |
| 署名・Archive・提出ビルド | 本人が配布用署名・Archive・アップロードを実施し、処理済みビルドを確認 |
| 実際の必須設問 | 本人の画面で年齢・権利・暗号化・地域条件・DSA・契約等を照合。画面を確認していない項目を確定扱いにしない |

本人の配信方針に関する追加質問は現時点でありません。残るのは上記の承認・管理画面操作・実機確認です。契約・税務・公開連絡先などの個人情報は本人が管理画面へ直接入力します。

任意の動画、ヘッダ・検索結果用アセット、課金商品、イベントなどを未作成だからという理由で必須の不足には含めません。利用しない初回構成の候補として整理しています。
