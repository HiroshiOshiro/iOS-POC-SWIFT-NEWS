import CoreData

// SPMパッケージ内ではXcodeのCore Data自動クラス生成が使えないため手書きで定義する。
@objc(FavoriteArticleEntity)
public final class FavoriteArticleEntity: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var urlString: String?
    @NSManaged public var author: String?
    @NSManaged public var score: Int32
    @NSManaged public var time: Date?
    @NSManaged public var commentCount: Int32
    @NSManaged public var savedAt: Date?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteArticleEntity> {
        NSFetchRequest<FavoriteArticleEntity>(entityName: "FavoriteArticleEntity")
    }
}
