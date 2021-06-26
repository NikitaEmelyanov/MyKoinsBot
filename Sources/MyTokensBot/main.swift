import Foundation
import TelegramBotSDK

print("Checking if database is up to date")
do {
    try MigrationController.migrate()
} catch {
    print("Error while migrating the database: \(error)")
    exit(1)
}

// Add MY_TOKENS_BOT_TOKEN to environment variables or create a file named 'MY_TOKENS_BOT_TOKEN'
// containing bot's token in app's working dir.
let token = readToken(from: "MY_TOKENS_BOT_TOKEN")

let bot = TelegramBot(token: token)
var routers = [String: Router]()

// Controllers:
let mainController = MainController()
let addController = AddController()

// DB Accesses:
let sessionAccess = SessionAccess()
let categoryAccess = CategoryAccess()
let expenseAccess = ExpenseAccess()

print("Ready to accept commands")

while let update = bot.nextUpdateSync() {
    
    // Properties associated with request context
    var properties = [String: AnyObject]()
    
    // ChatId is needed for choosing a router associated with particular chat
    guard let chatId = update.message?.chat.id ??
        update.callbackQuery?.message?.chat.id else {
            continue
    }
    
    do {
        // Fetch Session object from database. It will be created if missing.
        let session = try sessionAccess.initial(for: chatId)
        
        // Fetching from database is expensive operation. Store the session
        // in properties to avoid fetching it again in handlers
        properties[Properties.session] = session as AnyObject
        
        let router = routers[session.router_name]
        if let router = router {
            try router.process(update: update, properties: properties)
        } else {
            print("Warning: chat \(chatId) has invalid router: \(session.router_name)")
        }
    } catch {
        bot.reportErrorAsync(chatId: chatId,
                             text: "❗ Error while performing the operation.",
                             errorDescription: "Recovered from exception: \(error)")
    }
}

fatalError("Server stopped due to error: \(String(describing: bot.lastError))")
