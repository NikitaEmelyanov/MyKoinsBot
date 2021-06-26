import Foundation
import TelegramBotSDK
import GRDB

struct Session: Codable, FetchableRecord, PersistableRecord {
    var chat_id: Int64?
    var router_name: String
}

extension Session {
    enum Columns {
        static let chat_id = Column(CodingKeys.chat_id)
        static let router_name = Column(CodingKeys.router_name)
    }
}

