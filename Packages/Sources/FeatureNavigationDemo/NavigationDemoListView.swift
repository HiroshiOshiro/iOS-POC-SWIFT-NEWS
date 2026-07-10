import SwiftUI

// NavigationDemoNavigation.screen() 経由でのみ生成する
struct NavigationDemoListView: View {
    // sheetとfullScreenCoverを同じ状態変数で管理する。
    // .sheet(item:)/.fullScreenCover(item:)それぞれに対応するcaseの時だけ
    // 値を渡すBindingを咬ませることで、1つのenumで両方の提示を制御できる。
    @State private var presentedStyle: PresentationStyle?

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        NavigationDemoDestinationView(style: nil)
                    } label: {
                        Label("① NavigationLinkで遷移", systemImage: "arrow.right.circle")
                    }
                } footer: {
                    Text("画面をスタックに積む標準的な遷移。戻るボタン・スワイプバックが自動で使える。")
                }

                Section {
                    Button {
                        presentedStyle = .sheet
                    } label: {
                        Label("② sheetで遷移", systemImage: "arrow.up.square")
                    }
                } footer: {
                    Text("画面下からモーダル表示。下スワイプで閉じられる、軽量なタスク向け。")
                }

                Section {
                    Button {
                        presentedStyle = .fullScreenCover
                    } label: {
                        Label("③ fullScreenCoverで遷移", systemImage: "rectangle.fill")
                    }
                } footer: {
                    Text("画面全体を覆うモーダル。スワイプで閉じられないため明示的な閉じるボタンが必要。")
                }
            }
            .navigationTitle("画面遷移")
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

    // presentedStyleが指定のcaseの時だけ値を通すBinding。
    // set側は常にpresentedStyleへ書き戻すので、閉じた(nilになった)ことも正しく反映される。
    private func binding(for style: PresentationStyle) -> Binding<PresentationStyle?> {
        Binding(
            get: { presentedStyle == style ? presentedStyle : nil },
            set: { presentedStyle = $0 }
        )
    }
}
