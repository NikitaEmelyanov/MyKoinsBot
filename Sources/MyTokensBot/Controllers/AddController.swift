import Foundation
import TelegramBotSDK

class AddController {

    init() {
        routers[Commands.add[1]] = Router(bot: bot) { router in
            router[Commands.help] = onHelp
            router[Commands.cancel] = onCancel
            router.unmatched = onAdd
        }
    }
    
    func onHelp(context: Context) -> Bool {
        let text = "Usage:\n" +
            "'categoryName' 'amount' - create new category or add to existing one and add amount\n\n" +
            "transport 100\n" +
            "tech stuff 45000\n\n" +
            "/cancel to cancel\n"
        
        
        let keyboardStrings = [
            [ KeyboardButton(text: Commands.cancel[0]) ],
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
    
    func onCancel(context: Context) throws -> Bool {
        try mainController.showMainMenu(context: context, text: "Cancelled")
        try context.updateSession(routerName: Commands.main)
        return true
    }
    
    func onAdd(context: Context) throws -> Bool {
        guard context.chatId != nil else { return false }
        let name = context.args.scanRestOfString()
        guard name != Commands.add[0] else { return false } // Button pressed twice in a row
        // todo: create logic for expenses here
        try context.updateSession(routerName: Commands.main)
        try mainController.showMainMenu(context: context, text: "Added")
        
        return true
    }
}
