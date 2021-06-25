import Foundation
import TelegramBotSDK
import GRDB

class SessionAccess {
    public func initial(for chatId: Int64) throws -> Session {
        let session: Session = try DB.queue.inDatabase { db in
            var session = try Session.fetchOne(db, key: chatId)
            if session == nil {
                session = Session(chat_id: chatId, router_name: Commands.main)
                try session?.insert(db)
            }
            return session!
        }
        return session
    }
    
    public func update(session: Session) throws -> Session {
        try DB.queue.inDatabase { db in
            try session.update(db)
        }
        return session
    }
}
