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
        self.ui_tableView.reloadData()
        viewDidLoad()
    }
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var ui_tableView: UITableView!
    
    var loadedCodePromo = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ui_tableView.dataSource = self
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
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "codePromoCell", for: indexPath)
        
        let promoList = loadedCodePromo[indexPath.row]
        //Cellule Title
        if let titleLabel = cell.textLabel {
            titleLabel.text = promoList["title"]
            //Cellule Promotion
            if let discountLabel = cell.detailTextLabel {
                discountLabel.text = promoList["discount"]
                //Check la date
                let dateString = promoList["endDate"]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateFromString = dateFormatter.date(from: dateString!)
                let now = Date()
                //Si date périmé
                if dateFromString! < now {
                    titleLabel.textColor = UIColor.lightGray
                    discountLabel.textColor = UIColor.lightGray
                    discountLabel.text = "Expiré"
                //Si date est celle du jour
                } else if dateFromString == now {
                    titleLabel.textColor = UIColor.orange
                    discountLabel.textColor = UIColor.orange
                }
            }
        }
        return cell
    }
}
