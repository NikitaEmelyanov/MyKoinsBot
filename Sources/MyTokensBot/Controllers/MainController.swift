import Foundation
import TelegramBotSDK

class MainController {
    
    init() {
        routers[Commands.main] = Router(bot: bot) { router in
            router[Commands.start] = onStart
            router[Commands.stop] = onStop
            router[Commands.help] = onHelp
            router[Commands.add] = onAdd
        }
    }
    
    public func onStart(context: Context) throws -> Bool {
        try showMainMenu(context: context, text: "Please choose an option.")
        return true
    }
    
    public func onStop(context: Context) -> Bool {
        let replyTo = context.privateChat ? nil : context.message?.messageId
        
        let replyKeyboardRemove = ReplyKeyboardRemove(removeKeyboard: true)
        replyKeyboardRemove.selective = replyTo != nil
        let markup = ReplyMarkup.replyKeyboardRemove(replyKeyboardRemove)
        context.respondAsync("Stopping.",
                             replyToMessageId: replyTo,
                             replyMarkup: markup)
        return true
    }
    
    public func onHelp(context: Context) throws -> Bool {
        let text = "Usage:\n" +
            "/add to show add menu\n" +
            "/stop to stop bot\n" +
            "/help for help\n"
        try showMainMenu(context: context, text: text)
        return true
    }
    
    public func onAdd(context: Context) throws -> Bool {
        guard context.chatId != nil else { return false }
        try context.updateSession(routerName: Commands.add[1])
        return addController.onHelp(context: context)
    }
    
    public func showMainMenu(context: Context, text: String) throws {
        // Use replies in group chats, otherwise bot won't be able to see the text typed by user.
        // In private chats don't clutter the chat with quoted replies.
        let replyTo = context.privateChat ? nil : context.message?.messageId
        
        let keyboardStrings = [
            [ KeyboardButton(text: Commands.add[0]) ],
            [ KeyboardButton(text: Commands.help[0]), KeyboardButton(text: Commands.stop[0]) ]
        ]
        
        let replyKeyboardMarkup = ReplyKeyboardMarkup(keyboard: keyboardStrings)
        replyKeyboardMarkup.resizeKeyboard = true
        replyKeyboardMarkup.selective = replyTo != nil
        replyKeyboardMarkup.oneTimeKeyboard = true
        let markup = ReplyMarkup.replyKeyboardMarkup(replyKeyboardMarkup)
        context.respondAsync(text,
            replyToMessageId: replyTo, // ok to pass nil, it will be ignored
            replyMarkup: markup)
    }
}
