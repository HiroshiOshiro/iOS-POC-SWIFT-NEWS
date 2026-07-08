import SwiftUI

// アプリ全体で共通のお気に入りトグルボタン(designsystemの最小単位のatom)
public struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    public init(isFavorite: Bool, action: @escaping () -> Void) {
        self.isFavorite = isFavorite
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundColor(isFavorite ? .yellow : .gray)
        }
        .buttonStyle(.plain)
    }
}
