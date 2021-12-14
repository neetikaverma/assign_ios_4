//
//  StockDetailVC.swift
//  ShareMarketApp
//
//  Created by user199585 on 12/06/21.
//

import UIKit

class StockDetailVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblLowHigh: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblChangePercent: UILabel!
    @IBOutlet weak var lblLastUpdate: UILabel!
    
    var quote: Quote!
    
    var rightButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        
        rightButtonItem = UIBarButtonItem.init(
            image: quote.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )

        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func setData() {
        lblTitle.text = quote.share.name
        lblSubtitle.text = quote.share.currency + " (" + quote.share.region + ")"
        lblPrice.text = quote.price
        lblLowHigh.text = "Low: " + quote.low + "   High: " + quote.high
        lblChangePercent.text = quote.changePercent
        lblChangePercent.textColor = quote.change.contains("-") ? .red : .green
        lblLastUpdate.text = quote.lastUpdate
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        quote.isFavorite = !quote.isFavorite
        rightButtonItem.image = quote.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        if(quote.isFavorite) {
            CoreDataCrudClient.shared.save(data: quote)
        }
        else {
            CoreDataCrudClient.shared.delete(whereKey: "symbol", value: quote.share.symbol)
        }
    }
    
    @IBAction func btnUpdateDataAction(_ sender: Any) {
        Services.shared.fetchShareDetail(isFavorite: true, share: quote.share) { quote in
            print(quote)
            self.quote = quote
            DispatchQueue.main.async {
                self.setData()
            }
        }
    }
}
