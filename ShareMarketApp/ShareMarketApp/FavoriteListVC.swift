//
//  StockListVC.swift
//  ShareMarketApp
//
//  Created by user199585 on 12/06/21.
//

import UIKit

class FavoriteListVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewStocks: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var stocks = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableViewStocks.delegate = self
        tableViewStocks.dataSource = self
        tableViewStocks.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CoreDataCrudClient.shared.fetch { data in
            self.stocks = data
            DispatchQueue.main.async {
                self.tableViewStocks.reloadData()
            }
        }
    }
}

extension FavoriteListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewNoData.isHidden = stocks.count > 0
        return stocks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StockCell
        cell.viewBackground.layer.masksToBounds = false
        cell.viewBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.23
        cell.viewBackground.layer.shadowRadius = 4
        cell.lblTitle.text = stocks[indexPath.row].share.name + " (" + stocks[indexPath.row].share.symbol + ")"
        cell.lblSubTitle.text = stocks[indexPath.row].share.currency + " (" + stocks[indexPath.row].share.region + ")"
        cell.lblOpen.text = "Open: " + stocks[indexPath.row].share.marketOpen
        cell.lblClose.text = "Close: " + stocks[indexPath.row].share.marketClose
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockDetailVC") as! StockDetailVC
        vc.quote = stocks[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
