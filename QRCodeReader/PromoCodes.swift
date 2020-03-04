//
//  PromoCodes.swift
//  QRCodeReader
//
//  Created by Paul Colombier on 12/02/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class PromoCodes: UIViewController, UITableViewDataSource {
    
    //Navigation
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    //Nettoyage liste QrCode
    @IBAction func deleteList(_ sender: Any) {
        let arrayEmpty = [""]
        UserDefaults.standard.set(arrayEmpty, forKey: "CodePromoArray")
        checkList()
        self.ui_tableView.reloadData()
    }
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var ui_tableView: UITableView!
    
    var loadedCodePromo = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui_tableView.dataSource = self
        checkList()
    }
    
    func checkList() {
        loadedCodePromo = UserDefaults.standard.array(forKey: "CodePromoArray") as? [[String: String]] ?? []
        
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
        let cell : PromoCodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "codePromoCell", for: indexPath) as! PromoCodeTableViewCell
        
        guard let titleLabel = cell.ui_titleLabel,
            let discountLabel = cell.ui_discountLabel,
            let endDateLabel = cell.ui_endDateLabel
            else {
                return cell
        }
        
        let promoList = loadedCodePromo[indexPath.row]
        
        //Cellule Title
        titleLabel.text = promoList["title"]
        
        //Cellule Promotion
        discountLabel.text = promoList["discount"]
        
        //Cellule Date
        endDateLabel.text = promoList["endDate"]

        //Check la date
        let dateString = promoList["endDate"] ?? "01/01/1970"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateFromString = dateFormatter.date(from: dateString)
        let now = Date()
        //Si date expirée
        if dateFromString! < now {
            titleLabel.textColor = UIColor.lightGray
            discountLabel.textColor = UIColor.lightGray
            endDateLabel.textColor = UIColor.lightGray
            endDateLabel.text = "Expiré"
            //Si date est celle du jour
        } else if dateFromString == now {
            titleLabel.textColor = UIColor.orange
            discountLabel.textColor = UIColor.orange
            endDateLabel.textColor = UIColor.orange
        }
        
        return cell
    }
}
