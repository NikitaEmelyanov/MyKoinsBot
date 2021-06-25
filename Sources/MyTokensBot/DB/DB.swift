import Foundation
import TelegramBotSDK
import GRDB

class DB {
    static let queue: DatabaseQueue = {
        var config = Configuration()
        config.prepareDatabase { db in      // prepareDatabase is now a method
            db.trace { print($0) }
        }
        config.busyMode = .timeout(10) // Wait 10 seconds before throwing SQLITE_BUSY error
        config.defaultTransactionKind = .deferred
        
        do {
            return try DatabaseQueue(path: "db.sqlite", configuration: config)
        } catch {
            fatalError("Unable to open database: \(error)")
        }
    }()
}
