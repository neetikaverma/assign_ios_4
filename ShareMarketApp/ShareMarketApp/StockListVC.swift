//
//  StockListVC.swift
//  ShareMarketApp
//
//  Created by user199585 on 12/06/21.
//

import UIKit

class StockListVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewStocks: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var stocks = [Share]()
    
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        
        tableViewStocks.delegate = self
        tableViewStocks.dataSource = self
        tableViewStocks.tableFooterView = UIView()
    }
}

extension StockListVC: UISearchBarDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        isSearch = true
        Services.shared.fetchShares(query: searchBar.text!) { shares in
            self.stocks = shares
            DispatchQueue.main.async {
                self.tableViewStocks.reloadData()
            }
        }
        return true
    }
}

extension StockListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearch) {
            viewNoData.isHidden = stocks.count > 0
        }
        return isSearch ? stocks.count : DummyModel.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearch ? "Results" : "Recommended"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StockCell
        let data = isSearch ? stocks[indexPath.row] : DummyModel[indexPath.row]
        cell.viewBackground.layer.masksToBounds = false
        cell.viewBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.23
        cell.viewBackground.layer.shadowRadius = 4
        cell.lblTitle.text = data.name + " (" + data.symbol + ")"
        cell.lblSubTitle.text = data.currency + " (" + data.region + ")"
        cell.lblOpen.text = "Open: " + data.marketOpen
        cell.lblClose.text = "Close: " + data.marketClose
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        Services.shared.fetchShareDetail(isFavorite: false, share: isSearch ? stocks[indexPath.row] : DummyModel[indexPath.row]) { quote in
            print(quote)
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockDetailVC") as! StockDetailVC
                vc.quote = quote
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

class StockCell: UITableViewCell {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var lblClose: UILabel!
}
