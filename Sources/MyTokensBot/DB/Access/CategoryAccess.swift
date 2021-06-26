import Foundation
import TelegramBotSDK
import GRDB

class CategoryAccess {
    public func insert(category: Category) throws -> Category {
        try DB.queue.write { db in
            try category.insert(db)
        }
        return category
    }
    
    public func getByName(name: String) throws -> Category? {
        try DB.queue.read { db in
            return try Category
                .filter(Category.Columns.name == name)
                .fetchOne(db)
        }
    }
}
