# iOS-POC-SWIFT-NEWS

iOS 15+ / Swift / SwiftUI / Clean Architecture + MVVM のPOCアプリ。

## 構成

- **News タブ**: Hacker News API から記事一覧を取得、お気に入り登録
- **お気に入り タブ**: Core Data に保存したお気に入り記事の一覧・詳細
- **Setting タブ**: メールアドレス/パスワードでのログイン(モックAPI)、ログイン成功後のユーザー情報表示

## 技術要素

- Clean Architecture (Domain / Data / Presentation) + MVVM
- Swift Concurrency（async/await, `@MainActor`）
- Network: Hacker News API (`https://hacker-news.firebaseio.com`)
- ログインAPI送信処理は `URLRequest`/`URLSession` を実装した上で `URLProtocol` によりモック化
- ローカルDB: Core Data（お気に入り記事の永続化）
- AppStorage: ログインセッションの永続化

## セットアップ

```sh
xcodegen generate
open iOS-POC-SWIFT-NEWS.xcodeproj
```
