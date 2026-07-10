import Foundation

// sheet/fullScreenCoverの提示状態を1つのenumにまとめることで、
// 「両方同時にtrue」のような取り得ない組み合わせを型レベルで防ぐ。
// (真偽値2つのState変数で管理する実装との違いはここ)
enum PresentationStyle: String, Identifiable {
    case sheet
    case fullScreenCover

    var id: String { rawValue }
}
