# 確認した公式資料

確認日：2026-11-03（日本時間）。本人のApp Store Connect／AdMob画面の確認を代替するものではありません。

| 資料 | URL | 用途 |
| --- | --- | --- |
| Apple Register an App ID | https://developer.apple.com/help/account/identifiers/register-an-app-id | Explicit IDとCapabilities |
| Apple Add a new app | https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app/ | アプリレコード |
| Apple App information | https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/ | 名前・サブタイトル・SKU・地域書類 |
| Apple Platform version information | https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/ | 原稿上限・キーワード100バイト・公開方式・審査メモ |
| Apple Screenshot specifications | https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/ | 6.3インチ1206×2622／6.9インチ1320×2868、1〜10枚、透過不可。今回の実画面も照合 |
| Apple Creative assets specifications | https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications/ | 任意のヘッダ・検索結果素材と通常スクリーンショットの区別 |
| Apple Age ratings values and definitions | https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/ | 全設問候補と地域別算定 |
| Apple Set an app age rating | https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating | 設問による算定 |
| Apple App Privacy Details | https://developer.apple.com/app-store/app-privacy-details/ | 収集・関連付け・トラッキング・全データ分類 |
| Apple User Privacy and Data Use | https://developer.apple.com/app-store/user-privacy-and-data-use/ | ATTと第三者SDK |
| Apple Accessibility Nutrition Labels | https://developer.apple.com/help/app-store-connect/manage-app-accessibility/overview-of-accessibility-nutrition-labels/ | 実評価による申告、任意申告 |
| Apple Complying with Encryption Export Regulations | https://developer.apple.com/documentation/Security/complying-with-encryption-export-regulations | OSの暗号化と書類免除 |
| Apple Overview of export compliance | https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance | 提出ビルドでの確認 |
| Apple DSA trader requirements | https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements/ | 本人のトレーダー連絡先検証 |
| Apple China mainland compliance | https://developer.apple.com/help/app-store-connect/manage-compliance-information/view-china-mainland-compliance-information | 地域ごとの適用条件 |
| Apple Digital Goods and Services questionnaire | https://developer.apple.com/help/app-store-connect/manage-app-information/complete-the-digital-goods-and-services-questionnaire | 出現した場合の本人確認 |
| Apple Regulated Medical Device Status | https://developer.apple.com/help/app-store-connect/manage-app-information/declare-regulated-medical-device-status | 医療機器非該当候補 |
| Google App store data disclosure | https://developers.google.com/admob/ios/privacy/data-disclosure | 公式開示。現行資料は13.12.0に更新されており13.9.0マニフェストと併用 |
| Google Privacy strategies | https://developers.google.com/admob/ios/privacy/strategies | ATT・Publisher first-party ID無効化 |
| Google Publisher personalization state | https://developers.google.com/admob/ios/api/reference/Enums/GADPublisherPrivacyPersonalizationState.html | 非パーソナライズ設定 |
| Google Personalized and non-personalized ads | https://support.google.com/admob/answer/7676680 | 非パーソナライズでも残る処理 |
| Google Release notes | https://developers.google.com/admob/ios/rel-notes | 同梱13.9.0と現行資料の版差 |
| Google Set up app-ads.txt | https://support.google.com/admob/answer/9363762 | 開発者サイトと公開ストアの関連付け |

SDKの実際の情報は `evidence/sdk-privacy-manifests.json`、署名なしReleaseの識別子は `evidence/release-build-info.json` に記録しています。
