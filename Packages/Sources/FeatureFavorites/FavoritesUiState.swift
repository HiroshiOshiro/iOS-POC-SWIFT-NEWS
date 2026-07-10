import CoreModel

public enum FavoritesUiState: Equatable {
    case loading
    case empty
    case success([NewsArticle])
}
