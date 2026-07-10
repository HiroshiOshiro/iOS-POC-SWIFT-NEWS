import SwiftUI

// NavigationLink / sheet / fullScreenCover のいずれで開いたかによって
// 説明文とdismissボタンの有無を出し分ける、共通の遷移先画面。
struct NavigationDemoDestinationView: View {
    let style: PresentationStyle?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: iconName)
                .font(.system(size: 48))
                .foregroundColor(.accentColor)

            Text(title)
                .font(.title2.bold())

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // NavigationLinkで積んだ画面は標準の戻るボタンがあるので不要。
            // sheet/fullScreenCoverはモーダルなので明示的な閉じるボタンを用意する。
            if style != nil {
                Button("閉じる") { dismiss() }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
            }

            Spacer()
        }
        .padding(.top, 48)
        .navigationTitle(style == nil ? "詳細画面" : "")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var iconName: String {
        switch style {
        case .none: return "arrow.right.circle"
        case .sheet: return "arrow.up.square"
        case .fullScreenCover: return "rectangle.fill"
        }
    }

    private var title: String {
        switch style {
        case .none: return "① NavigationLinkで開いた画面"
        case .sheet: return "② sheetで開いた画面"
        case .fullScreenCover: return "③ fullScreenCoverで開いた画面"
        }
    }

    private var description: String {
        switch style {
        case .none:
            return "NavigationViewのスタックにpushされました。\n左上の戻るボタンやスワイプバックで前の画面に戻れます。"
        case .sheet:
            return "画面下からモーダルとして表示されています。\n下にスワイプするか「閉じる」ボタンで閉じられます。"
        case .fullScreenCover:
            return "画面全体を覆うモーダルです。\nスワイプでは閉じられないため、明示的な「閉じる」ボタンが必須です。"
        }
    }
}
