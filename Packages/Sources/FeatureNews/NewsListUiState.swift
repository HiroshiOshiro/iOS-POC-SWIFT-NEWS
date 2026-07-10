import CoreModel

// NiAのForYouUiState(sealed interface)に相当。loading中にarticlesが古い値を
// 持ったままになる、といった取り得ない組み合わせを型で防ぐ。
public enum NewsListUiState: Equatable {
    case loading
    case success([NewsArticle])
    case failure(String)
}
