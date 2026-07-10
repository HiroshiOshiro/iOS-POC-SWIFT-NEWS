import SwiftUI

// NavigationDemoNavigation.screen() 経由でのみ生成する
struct NavigationDemoListView: View {
    // sheetとfullScreenCoverを同じ状態変数で管理する。
    // .sheet(item:)/.fullScreenCover(item:)それぞれに対応するcaseの時だけ
    // 値を渡すBindingを咬ませることで、1つのenumで両方の提示を制御できる。
    @State private var presentedStyle: PresentationStyle?

    // NavigationLinkはタップした瞬間に自動でpushしてしまうため、
    // 非表示のNavigationLinkをisActiveで駆動する形にし、ダミー通信完了後に
    // isActiveをtrueにすることでpushタイミングを制御する。
    @State private var isNavigationLinkActive = false

    // 現在ダミー通信を実行中のボタンがどれか(nilなら実行中なし)。
    // 実行中は対象ボタンにインジケータを出し、他のボタンは連打防止のためdisabledにする。
    @State private var loadingAction: DemoAction?

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        performTransition(.navigationLink)
                    } label: {
                        rowLabel(title: "① NavigationLinkで遷移", icon: "arrow.right.circle", action: .navigationLink)
                    }
                    .disabled(loadingAction != nil)
                } footer: {
                    Text("画面をスタックに積む標準的な遷移。戻るボタン・スワイプバックが自動で使える。")
                }

                Section {
                    Button {
                        performTransition(.sheet)
                    } label: {
                        rowLabel(title: "② sheetで遷移", icon: "arrow.up.square", action: .sheet)
                    }
                    .disabled(loadingAction != nil)
                } footer: {
                    Text("画面下からモーダル表示。下スワイプで閉じられる、軽量なタスク向け。")
                }

                Section {
                    Button {
                        performTransition(.fullScreenCover)
                    } label: {
                        rowLabel(title: "③ fullScreenCoverで遷移", icon: "rectangle.fill", action: .fullScreenCover)
                    }
                    .disabled(loadingAction != nil)
                } footer: {
                    Text("画面全体を覆うモーダル。スワイプで閉じられないため明示的な閉じるボタンが必要。\n\nいずれもボタン押下後、API呼び出しを模した0.5秒の待ちを挟んでから遷移する。")
                }
            }
            .navigationTitle("画面遷移")
            .background(
                // ユーザーが直接タップすることはなく、isNavigationLinkActiveの変化にのみ反応する
                NavigationLink(isActive: $isNavigationLinkActive) {
                    NavigationDemoDestinationView(style: nil)
                } label: {
                    EmptyView()
                }
                .hidden()
            )
        }
        .navigationViewStyle(.stack)
        .sheet(item: binding(for: .sheet)) { style in
            NavigationView {
                NavigationDemoDestinationView(style: style)
            }
        }
        .fullScreenCover(item: binding(for: .fullScreenCover)) { style in
            NavigationView {
                NavigationDemoDestinationView(style: style)
            }
        }
    }

    @ViewBuilder
    private func rowLabel(title: String, icon: String, action: DemoAction) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            if loadingAction == action {
                ProgressView()
            }
        }
    }

    private func performTransition(_ action: DemoAction) {
        loadingAction = action
        Task {
            let success = await simulateAPICall()
            loadingAction = nil
            guard success else { return }
            switch action {
            case .navigationLink:
                isNavigationLinkActive = true
            case .sheet:
                presentedStyle = .sheet
            case .fullScreenCover:
                presentedStyle = .fullScreenCover
            }
        }
    }

    // API呼び出し風のダミー処理。実際のRepository層のNetworkService呼び出しと同様、
    // 0.5秒待ってから結果を返す(このデモでは常に成功する)。
    private func simulateAPICall() async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }

    // presentedStyleが指定のcaseの時だけ値を通すBinding。
    // set側は常にpresentedStyleへ書き戻すので、閉じた(nilになった)ことも正しく反映される。
    private func binding(for style: PresentationStyle) -> Binding<PresentationStyle?> {
        Binding(
            get: { presentedStyle == style ? presentedStyle : nil },
            set: { presentedStyle = $0 }
        )
    }
}

private enum DemoAction {
    case navigationLink
    case sheet
    case fullScreenCover
}
