//
//  PromoCodes.swift
//  QRCodeReader
//
//  Created by Paul Colombier on 12/02/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class PromoCodes: UIViewController, UITableViewDataSource {
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteList(_ sender: Any) {
        let arrayEmpty = [""]
        UserDefaults.standard.set(arrayEmpty, forKey: "CodePromoArray")
        self.ui_tableView.reloadData()
        viewDidLoad()
    }
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var ui_tableView: UITableView!
    
    var loadedCodePromo = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ui_tableView.dataSource = self
        loadedCodePromo = UserDefaults.standard.array(forKey: "CodePromoArray") as? [[String: Any]] ?? []
        
        if loadedCodePromo.isEmpty {
            emptyListLabel.text = "La liste est actuellement vide"
        } else {
            emptyListLabel.text = "Liste de vos codes promos"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedCodePromo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "codePromoCell", for: indexPath)
        
        let promoList = loadedCodePromo[indexPath.row]
        if let titleLabel = cell.textLabel {
            titleLabel.text = promoList["title"] as? String
        }
        if let discountLabel = cell.detailTextLabel {
            discountLabel.text = promoList["discount"] as? String
        }
        
        return cell
    }
}
    /*
    class PromoCodes: UIViewController, UITableViewController {
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var UI_TableViewCodePromo: UITableView!
    
    var loadedCodePromo = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadedCodePromo = UserDefaults.standard.array(forKey: "CodePromoArray") as? [[String: Any]] ?? []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UI_TableViewCodePromo.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UI_TableViewCodePromo.numberOfRows(inSection: loadedCodePromo.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "codePromoCell", for: indexPath)
        
        if let loadedCart = UserDefaults.standard.array(forKey: "CodePromoArray") as? [[String: Any]] {
                let promo = loadedCart[indexPath.row]
                //cell.UI_TitleCell.text = promo["title"] as? String?
                cell.detailTextLabel?.text = promo["discount"] as? String
        }
        return cell
    }*/
    
    /*
    func loadTableView() {
        if let loadedCart = UserDefaults.standard.array(forKey: "CodePromoArray") as? [[String: Any]] {
        //            print(loadedCart)  // [[price: 19.99, qty: 1, name: A], [price: 4.99, qty: 2, name: B]]"
        UI_TableViewCodePromo.numberOfRows(inSection: loadedCart.count)
            for item in loadedCart {
            print(item["name"]  as! String)    // A, B
            //                print(item["price"] as! Double)    // 19.99, 4.99
            //                print(item["qty"]   as! Int)
            //                print(item["image"]   as! Int)  // 1, 2
            UI_TableViewCodePromo.cellForRow(at: IndexPath) {
                let item = loadedCart[indexPath.row]
                cell.textLabel?.text = item["title"] as? String + item["discount"] as? String
                cell.detailTextLabel?.text = item["endDate"] as? String
                cell.idLabel.text = item["id"] as? String
            }
            }
        }
    }*/
