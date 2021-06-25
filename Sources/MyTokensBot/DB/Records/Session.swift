import Foundation
import TelegramBotSDK
import GRDB

struct Session: Codable, FetchableRecord, PersistableRecord {
    var chat_id: Int64
    var router_name: String
}
