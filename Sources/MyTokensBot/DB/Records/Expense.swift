import Foundation
import TelegramBotSDK
import GRDB

struct Expense: Codable, FetchableRecord, PersistableRecord {
    var cost_id: Int64?
    var chat_id: Int64
    var category_id: Int64
    var amount: Int64
}

extension Expense {
    enum Columns {
        static let cost_id = Column(CodingKeys.cost_id)
        static let chat_id = Column(CodingKeys.chat_id)
        static let category_id = Column(CodingKeys.category_id)
        static let amount = Column(CodingKeys.amount)
    }
}
