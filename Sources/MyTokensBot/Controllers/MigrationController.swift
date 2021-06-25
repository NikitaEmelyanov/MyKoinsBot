import Foundation
import GRDB

class MigrationController {
    static var migrator = DatabaseMigrator()
    
    static func migrate() throws {
        // Migrations run in order, once and only once. When a user upgrades the application, only non-applied migrations are run.
        
        // v1.0 database
        migrator.registerMigration("createTables") { db in
            try db.execute(sql:
                """
                CREATE TABLE session (
                    chat_id INTEGER PRIMARY KEY,
                    router_name TEXT NOT NULL
                );
                CREATE TABLE category (
                    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL
                );
                CREATE TABLE expense (
                    cost_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    chat_id INTEGER,
                    category_id INTEGER,
                    amount INTEGER NOT NULL,
                    FOREIGN KEY(category_id) REFERENCES category(category_id) ON DELETE CASCADE,
                    FOREIGN KEY(chat_id) REFERENCES session(chat_id) ON DELETE CASCADE
                );
                CREATE INDEX expense_by_chat_idx ON expense (chat_id, cost_id);
                """
            )
        }
        
        // Migrations for future versions will be inserted here:
        //
        // // v2.0 database
        
        try migrator.migrate(DB.queue)
    }
}
