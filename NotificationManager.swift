// Notification manager takes care of deregistering observer objects
// Usage via member variable, e.g. in a base `UIViewController` class:
//   private let notificationManager = NotificationManager()

// From http://moreindirection.blogspot.it/2014/08/nsnotificationcenter-swift-and-blocks.html

class NotificationManager {
    private var observerTokens: [AnyObject] = []
    
    deinit {
        deregisterAll()
    }
    
    func deregisterAll() {
        for token in observerTokens {
            NSNotificationCenter.defaultCenter().removeObserver(token)
        }
        
        observerTokens = []
    }
    
    func registerObserver(name: String!, forObject object: AnyObject! = nil, block: (NSNotification! -> Void)) {
        let newToken = NSNotificationCenter.defaultCenter().addObserverForName(name, object: object, queue: nil, usingBlock: block)
        
        observerTokens.append(newToken)
    }
}
