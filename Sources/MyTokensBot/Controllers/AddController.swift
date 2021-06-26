import Foundation
import TelegramBotSDK

class AddController {
    private let wrongUsageMessage = "Wrong usage: please review help"

    init() {
        routers[Commands.add[1]] = Router(bot: bot) { router in
            router[Commands.help] = onHelp
            router[Commands.cancel] = onCancel
            router.unmatched = onAdd
        }
    }
    
    public func onHelp(context: Context) -> Bool {
        let text = "Usage:\n" +
            "'categoryName' 'amount' - create new category or add to existing one and add amount\n\n" +
            "transport 100\n" +
            "tech stuff 45000\n\n" +
            "/cancel to cancel\n"
        
        let keyboardStrings = [
            [ KeyboardButton(text: Commands.help[0]), KeyboardButton(text: Commands.cancel[0]) ],
        ]
        let replyKeyboardMarkup = ReplyKeyboardMarkup(keyboard: keyboardStrings)
        
        if context.privateChat {
            let markup = ReplyMarkup.replyKeyboardMarkup(replyKeyboardMarkup)
            context.respondAsync(text, replyMarkup: markup)
        } else {
            let replyTo = context.message?.messageId
            replyKeyboardMarkup.selective = replyTo != nil
            let markup = ReplyMarkup.replyKeyboardMarkup(replyKeyboardMarkup)
            context.respondAsync(text,
                replyToMessageId: replyTo,
                replyMarkup: markup)
        }
        return true
    }
    
    public func onCancel(context: Context) throws -> Bool {
        try mainController.showMainMenu(context: context, text: "Cancelled")
        try context.updateSession(routerName: Commands.main)
        return true
    }
    
    public func onAdd(context: Context) throws -> Bool {
        guard let chatId = context.chatId else { return false }
        
        let words = context.args.scanWords()
        guard words.count > 1 else {
            context.respondAsync(self.wrongUsageMessage)
            return false
        }
        
        let numWords = words.filter { word in
            return Int64.init(word) != nil
        }
        
        guard numWords.count == 1 else {
            context.respondAsync(self.wrongUsageMessage)
            return false
        }
        
        guard let last = words.last, let amount = Int64.init(last) else {
            context.respondAsync(self.wrongUsageMessage)
            return false
        }
        
        let categoryName = words.dropLast().joined()
        var category = try categoryAccess.getByName(name: categoryName)
        
        var resultText = ""
        if (category == nil) {
            category = try categoryAccess.insert(category: Category(category_id: nil, name: categoryName))
            resultText += "New \(categoryName) category created\n"
        }
        
        guard let categoryId = category!.category_id else {
            throw CustomError.runtimeError("category_id is not provided")
        }
        
        let expense = Expense(cost_id: nil, chat_id: chatId, category_id: categoryId, amount: amount)
        _ = try expenseAccess.insert(expense: expense)
        resultText += "Added \(amount) for \(categoryName) category\n"
        
        context.respondAsync(resultText)
        
        return true
    }
}
