import Foundation
import TelegramBotSDK

extension Context {
    var session: Session { return properties[Properties.session] as! Session }
    
    public func updateSession(routerName: String) throws {
        var session = self.session;
        session.router_name = routerName
        properties[Properties.session] = try sessionAccess.update(session: session) as AnyObject?
    }
}
