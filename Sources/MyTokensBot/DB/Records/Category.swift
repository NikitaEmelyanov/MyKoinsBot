import Foundation
import TelegramBotSDK
import GRDB

class Category: Record {
    var category_id: Int64?
    var name: String
    
    init(category_id: Int64?, name: String) {
        self.category_id = category_id
        self.name = name
        super.init()
    }
    
    /// The table name
    override class var databaseTableName: String { "category" }
    
    /// The table columns
    enum Columns: String, ColumnExpression {
        case category_id, name
    }
    
    required init(row: Row) {
        category_id = row[Columns.category_id]
        name = row[Columns.name]
        super.init(row: row)
    }
    
    /// The values persisted in the database
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.category_id] = category_id
        container[Columns.name] = name
    }
    
    /// Update auto-incremented id upon successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        category_id = rowID
    }
}
