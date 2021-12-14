
import Foundation

class Services {
    
    static var shared = Services()
    private let apiKey = "M367IP8BGAFFQLZG"
    
    public  func fetchShares(query: String, completion:@escaping([Share]) -> ()) {
         let currenciesURL = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(query)&apikey=\(apiKey)")
        URLSession.shared.dataTask(with: currenciesURL!) { (data, request, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return } //no data
            
            do{
                let rootDic = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let shares = rootDic?.value(forKey: "bestMatches") as? [[String:Any]]
                if(shares != nil) {
                    var sharesData = [Share]()
                    print(shares)
                    for sh in shares! {
                        sharesData.append(Share(response: sh))
                    }
                    completion(sharesData)
                }
                else {
                    
                }
            }catch{
                print(error)
            }
        }.resume()
    }
    
    public  func fetchShareDetail(isFavorite: Bool, share: Share, completion:@escaping(Quote) -> ()) {
        let currenciesURL = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(share.symbol)&apikey=\(apiKey)")
        URLSession.shared.dataTask(with: currenciesURL!) { (data, request, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return } //no data
            
            do{
                let rootDic = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let quote = rootDic?.value(forKey: "Global Quote") as? [String:Any]
                if(quote != nil) {
                    completion(Quote(isFavorite: isFavorite, share: share, response: quote!))
                }
                else {
                    
                }
            }catch{
                print(error)
            }
        }.resume()
    }
}

