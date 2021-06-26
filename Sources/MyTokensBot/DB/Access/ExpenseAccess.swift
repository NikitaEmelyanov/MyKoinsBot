import Foundation
import TelegramBotSDK
import GRDB

class ExpenseAccess {
    public func insert(expense: Expense) throws -> Expense {
        try DB.queue.write { db in
            try expense.insert(db)
        }
        return expense
    }
}
