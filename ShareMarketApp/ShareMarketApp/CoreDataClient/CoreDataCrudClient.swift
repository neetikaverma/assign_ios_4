import UIKit
import CoreData

class CoreDataCrudClient: NSObject {
    
    static let shared = CoreDataCrudClient()
    
    //Save Stock data to local
    func save(data: Quote)
    {
        //        DispatchQueue.main.async()
        //        {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        let entity = NSEntityDescription.entity(forEntityName: "Stocks", in: appDelegate.context)
        let newData = NSManagedObject(entity: entity!, insertInto: appDelegate.context)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy - h:mm:ss a"
        
        newData.setValue(data.share.symbol, forKey: "symbol")
        newData.setValue(data.share.name, forKey: "name")
        newData.setValue(data.share.type, forKey: "type")
        newData.setValue(data.share.region, forKey: "region")
        newData.setValue(data.share.marketOpen, forKey: "marketOpen")
        newData.setValue(data.share.marketClose, forKey: "marketClose")
        newData.setValue(data.share.timezone, forKey: "timezone")
        newData.setValue(data.share.currency, forKey: "currency")
        newData.setValue(data.share.matchScore, forKey: "matchScore")
        newData.setValue(data.open, forKey: "open")
        newData.setValue(data.high, forKey: "high")
        newData.setValue(data.low, forKey: "low")
        newData.setValue(data.price, forKey: "price")
        newData.setValue(data.volume, forKey: "volume")
        newData.setValue(data.previousClose, forKey: "previousClose")
        newData.setValue(data.change, forKey: "change")
        newData.setValue(data.changePercent, forKey: "changePercent")
        newData.setValue(data.isFavorite, forKey: "isFavorite")
        newData.setValue(dayTimePeriodFormatter.string(from: Date()), forKey: "lastUpdate")
        
        do {
            try appDelegate.context.save()
        } catch {
            print("Failed saving")
        }
        //        }
    }
    
    //Update Stock data to local
    func update(data: Quote, whereKey: String, value: String)
    {
        DispatchQueue.main.async()
        {
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stocks")
            
            request.returnsObjectsAsFaults = false
            do {
                let result = try appDelegate.context.fetch(request)
                
                for newData in result as! [NSManagedObject] {
                    
                    if(value == "\(newData.value(forKey: whereKey) ?? "")")
                    {
                        let dayTimePeriodFormatter = DateFormatter()
                        dayTimePeriodFormatter.timeZone = TimeZone.current
                        dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy - h:mm:ss a"
                        
                        newData.setValue(data.share.symbol, forKey: "symbol")
                        newData.setValue(data.share.name, forKey: "name")
                        newData.setValue(data.share.type, forKey: "type")
                        newData.setValue(data.share.region, forKey: "region")
                        newData.setValue(data.share.marketOpen, forKey: "marketOpen")
                        newData.setValue(data.share.marketClose, forKey: "marketClose")
                        newData.setValue(data.share.timezone, forKey: "timezone")
                        newData.setValue(data.share.currency, forKey: "currency")
                        newData.setValue(data.share.matchScore, forKey: "matchScore")
                        newData.setValue(data.open, forKey: "open")
                        newData.setValue(data.high, forKey: "high")
                        newData.setValue(data.low, forKey: "low")
                        newData.setValue(data.price, forKey: "price")
                        newData.setValue(data.volume, forKey: "volume")
                        newData.setValue(data.previousClose, forKey: "previousClose")
                        newData.setValue(data.change, forKey: "change")
                        newData.setValue(data.changePercent, forKey: "changePercent")
                        newData.setValue(data.isFavorite, forKey: "isFavorite")
                        newData.setValue(dayTimePeriodFormatter.string(from: Date()), forKey: "lastUpdate")
                    }
                }
            } catch {
                print("Failed")
            }
            
            do {
                try appDelegate.context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    //fetch Stock data to local
    func fetch(completion: (_ data: [Quote])->())
    {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stocks")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try appDelegate.context.fetch(request)
            var quotesData = [Quote]()
            for data in result as! [NSManagedObject] {
                let share = Share(response: data, isLocal: true)
                quotesData.append(Quote(share: share, response: data, isLocal: true))
            }
            completion(quotesData)
        } catch {
            print("Failed")
        }
    }
    
    
    //Delete Stock data from local
    func delete(whereKey: String, value: String)
    {
        DispatchQueue.main.async()
        {
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stocks")
            let predicate = NSPredicate(format: "\(whereKey) == %@", value as CVarArg)
            request.predicate = predicate
            let result = try? appDelegate.context.fetch(request)
            let resultData = result as! [NSManagedObject]
            
            for object in resultData {
                appDelegate.context.delete(object)
            }
            
            do {
                try appDelegate.context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
}
