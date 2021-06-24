import Foundation
import TelegramBotSDK

class MainController {
    let bot: TelegramBot
    var startedInChatId = Set<Int64>()
    
    var calculated: Int64 = 0
    
    init(bot: TelegramBot) {
        self.bot = bot
    }
    
    public func start(context: Context) -> Bool {
        guard let chatId = context.chatId else { return false }
            
        guard !started(in: chatId) else {
            context.respondAsync("@\(bot.username) already started.")
            return true
        }
        startedInChatId.insert(chatId)
            
        var startText: String
        if !context.privateChat {
            startText = "Public chat for @\(bot.username) started.\n\n"
        } else {
            startText = "Private chat for @\(bot.username) started.\n\n"
        }
        
        startText += "Use /help to see availiable commands.\n"
        startText += "To stop, type /stop.\n"
        startText += "Available commands:\n\n" +
        "/plus - simple calculation\n" +
        "Stay tuned!"
            
        context.respondAsync(startText)
        return true
    }
    
    public func stop(context: Context) -> Bool {
        guard let chatId = context.chatId else { return false }

        guard started(in: chatId) else {
            context.respondAsync("@\(bot.username) already stopped.")
            return true
        }
        
        startedInChatId.remove(chatId)
        
        context.respondSync("@\(bot.username) stopped. To restart, type /start")
        return true
    }
    
    public func help(context: Context) -> Bool {
        guard let from = context.message?.from else { return false }
        let helpText = "What can this bot do?\n\n" +
            "This is @MyCoins bot. Helps you manage your costs and spendings. " +
            "If you want to use it in group chat, simply open the bot's profile " +
            "and use the 'Add to group' button.\n\n" +
            "Send /start to use bot.\n" +
            "Tell the bot to /stop when you're done.\n\n" +
            "Available commands:\n" +
            "/plus - simple calculation" +
            "Stay tuned!"
        
        context.respondAsync("Hi, " + from.firstName + "!\n" + helpText)
        return true
    }
    
    public func plus(context: Context) -> Bool {
        guard let chatId = context.chatId else { return false }
        guard started(in: chatId) else { return false }
        
        guard let numValue = context.args.scanInt64() else {
            context.respondAsync("Please, provide some number as argument")
            return true
        }
        
        let result = self.calculated.addingReportingOverflow(numValue)
        guard !result.overflow, INT64_MAX != result.partialValue else {
            context.respondAsync("Too big number. Please, use a smaller one")
            return true
        }
        self.calculated = result.partialValue
        
        if (self.calculated == 300) {
            context.respondAsync("You know wnat it means")
        }
        
        context.respondAsync("Calculated: " + String(self.calculated))
        
        return true;
    }
    
    private func started(in chatId: Int64) -> Bool {
        return startedInChatId.contains(chatId)
    }
}
