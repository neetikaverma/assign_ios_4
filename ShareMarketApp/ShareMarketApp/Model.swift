import Foundation
import CoreData

struct Share {
    var symbol: String
    var name: String
    var type: String
    var region: String
    var marketOpen: String
    var marketClose: String
    var timezone: String
    var currency: String
    var matchScore: String
    
    init(response: [String: Any]) {
        symbol = "\(response["1. symbol"] ?? "NA")"
        name = "\(response["2. name"] ?? "NA")"
        type = "\(response["3. type"] ?? "NA")"
        region = "\(response["4. region"] ?? "NA")"
        marketOpen = "\(response["5. marketOpen"] ?? "NA")"
        marketClose = "\(response["6. marketClose"] ?? "NA")"
        timezone = "\(response["7. timezone"] ?? "NA")"
        currency = "\(response["8. currency"] ?? "NA")"
        matchScore = "\(response["9. matchScore"] ?? "NA")"
    }
    
    init(response: NSManagedObject, isLocal: Bool) {
        symbol = "\(response.value(forKey: "symbol") ?? "NA")"
        name = "\(response.value(forKey: "name") ?? "NA")"
        type = "\(response.value(forKey: "type") ?? "NA")"
        region = "\(response.value(forKey: "region") ?? "NA")"
        marketOpen = "\(response.value(forKey: "marketOpen") ?? "NA")"
        marketClose = "\(response.value(forKey: "marketClose") ?? "NA")"
        timezone = "\(response.value(forKey: "timezone") ?? "NA")"
        currency = "\(response.value(forKey: "currency") ?? "NA")"
        matchScore = "\(response.value(forKey: "matchScore") ?? "NA")"
    }
}


struct Quote {
    var share: Share
    var open: String
    var high: String
    var low: String
    var price: String
    var volume: String
    var previousClose: String
    var change: String
    var changePercent: String
    var isFavorite: Bool
    var lastUpdate: String
    
    init(isFavorite: Bool, share: Share, response: [String: Any]) {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy - h:mm:ss a"
        
        self.share = share
        open = "\(response["02. open"] ?? "NA")"
        high = "\(response["03. high"] ?? "NA")"
        low = "\(response["04. low"] ?? "NA")"
        price = "\(response["05. price"] ?? "NA")"
        volume = "\(response["06. volume"] ?? "NA")"
        previousClose = "\(response["08. previous close"] ?? "NA")"
        change = "\(response["09. change"] ?? "NA")"
        changePercent = "\(response["10. change percent"] ?? "NA")"
        lastUpdate = dayTimePeriodFormatter.string(from: Date())
        self.isFavorite = isFavorite
    }
    
    init(share: Share, response: NSManagedObject, isLocal: Bool) {
        self.share = share
        open = "\(response.value(forKey: "open") ?? "NA")"
        high = "\(response.value(forKey: "high") ?? "NA")"
        low = "\(response.value(forKey: "low") ?? "NA")"
        price = "\(response.value(forKey: "price") ?? "NA")"
        volume = "\(response.value(forKey: "volume") ?? "NA")"
        previousClose = "\(response.value(forKey: "previousClose") ?? "NA")"
        change = "\(response.value(forKey: "change") ?? "NA")"
        changePercent = "\(response.value(forKey: "changePercent") ?? "NA")"
        lastUpdate = "\(response.value(forKey: "lastUpdate") ?? "NA")"
        self.isFavorite = (response.value(forKey: "changePercent") as? Bool) ?? true
    }
}
