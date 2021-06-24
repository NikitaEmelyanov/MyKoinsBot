import Foundation
import TelegramBotSDK

let token = readToken(from: "MY_TOKENS_BOT_TOKEN")
let bot = TelegramBot(token: token)
let router = Router(bot: bot)
let controller = MainController(bot: bot)

router["start"] = controller.start
router["stop"] = controller.stop
router["help"] = controller.help
router["plus"] = controller.plus

print("Ready to accept commands")
while let update = bot.nextUpdateSync() {
    print("--- update: \(update)")
    
    try router.process(update: update)
}

fatalError("Server stopped due to error: \(String(describing: bot.lastError))")
